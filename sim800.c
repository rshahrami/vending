#include <stdlib.h>
#include <stdint.h>
#include <glcd.h>
#include <delay.h>
#include <string.h>
#include "common.h"
#include "sim800.h"

//#define BUFFER_SIZE 512
#define MAX_RETRY   3   // Õœ«òÀ—  ⁄œ«œ  ·«‘



//char value[16];

char at_command[30];
char sim_number[15];

//char buffer[BUFFER_SIZE];
uint8_t attempts = 0;



void sim800_restart(void) {
    glcd_clear();
    glcd_outtextxy(0, 0, "Restarting SIM800...");

    // --- 1) »” ‰ HTTP («ê— ›⁄«· «” ) ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+HTTPTERM");
        // «ê— OK Ì« ERROR ¬„œ° œÌê— «œ«„Â „ÌùœÂÌ„ («ê— HTTP »” Â ‰»Êœ ERROR „Ìù¬Ìœ)
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 1000, "ERROR")) break;
        glcd_outtextxy(0, 10, "Waiting HTTPTERM...");
        delay_ms(50);
    }

    // --- 2) »” ‰ SAPBR (bearer) ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+SAPBR=0,1");   // close bearer
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting SAPBR=0,1...");
        delay_ms(50);
    }

    // --- 3) çò ò‰ òÂ SAPBR »” Â ‘œÂ («Œ Ì«—Ì «„« „›Ìœ) ---
    {
        int ok = 0;
        while (!ok) {
            uart_buffer_reset();
            send_at_command("AT+SAPBR=2,1"); // query
            if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "SAPBR")) {
                // «‰ Ÿ«— œ«—Ì„ ›Ì·œÌ „À· +SAPBR: 1,3,"0.0.0.0" Ì« +SAPBR: 1,0,"0.0.0.0"
                // «ê— IP 0.0.0.0 Ì« status != 1 »«‘Â Ì⁄‰Ì »” Â «” 
                if (strstr(buffer, "0.0.0.0") || strstr(buffer, ",0,") || strstr(buffer, ",3,")) {
                    ok = 1; // œ— ⁄„· »” Â Ì« œ— Õ«·  €Ì— connected «” 
                    break;
                }
            }
            // «ê— ÂÌç Å«”ŒÌ ‰ÌÊ„œ Ì« Â‰Ê“ Connected «”  „‰ Ÿ— Ê œÊ»«—Â  ·«‘ ò‰
            glcd_outtextxy(0, 10, "Checking SAPBR closed...");
            delay_ms(100);
        }
    }

    // --- 4) detach «“ GPRS ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+CGATT=0");     // detach
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting CGATT=0...");
        delay_ms(50);
    }

    // --- 5) —Ì”  ò«„· ‰—„ù«›“«—Ì (CFUN=1,1) Ê ”Å” ’»—  « „«éÊ· »«·« »Ì«Ìœ ---
    // «Ì‰ œ” Ê— „„ò‰ «”  »«⁄À —Ì»Ê  ‘Êœ∫ ¬‰ —« »›—”  Ê ”Å”  « “„«‰Ì òÂ „«éÊ· »Â AT Å«”Œ œÂœ ’»— ò‰.
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+CFUN=1,1");
        // „„ò‰ «”  OK »«“ê—œœ Ì« ‰Â∫ œ— Â— ’Ê—  »⁄œ «“ “œ‰ —Ì” ° „‰ Ÿ— »«·« ¬„œ‰ „«éÊ· „Ìù‘ÊÌ„.
        // «» œ« «ê— OK ¬„œ «“ ¬‰ ⁄»Ê— ò‰° ”Å” „‰ Ÿ— "AT" Å«”Œ œÂÌ„.
        read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK"); // (»ÌùŒÿ— «ê— ‰Ì«Ìœ)
        // «ò‰Ê‰ „‰ Ÿ— ‘Ê  « „œ«Ê„« »Â AT Å«”Œ œÂœ
        glcd_outtextxy(0, 10, "Rebooting, wait for AT...");
        while (1) {
            uart_buffer_reset();
            send_at_command("AT");
            if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
                // „«éÊ· »«·« ¬„œÂ Ê ¬„«œÂ «” 
                goto after_reboot;
            }
            // «ê— ŒÊ«” Ì „Ì  Ê«‰Ì «Ì‰Ã« ÅÌ«„ Ê÷⁄Ì  Ê delay ÿÊ·«‰Ìù — »–«—Ì
            delay_ms(50);
        }
    }
after_reboot:

    // --- 6) Œ«„Ê‘ ò—œ‰ Echo ---
    while (1) {
        uart_buffer_reset();
        send_at_command("ATE0");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting ATE0...");
        delay_ms(50);
    }

    // --- 7)  ”  ‰Â«ÌÌ „«éÊ· ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
        glcd_outtextxy(0, 10, "Final AT check...");
        delay_ms(50);
    }

    glcd_outtextxy(0, 20, "Restart Done!");
}


unsigned char check_sim(void) {
    int stat;
    char *comma;
    
    glcd_clear();
    // --- »——”Ì Ê÷⁄Ì  ”Ì„ùò«—  ---
    uart_buffer_reset();
    send_at_command("AT+CPIN?");
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CPIN")) {
//        glcd_outtextxy(0, 0, buffer); 
//        delay_ms(5000); 
        if (extract_field_after_keyword(buffer, "+CPIN:", 0, value, sizeof(value))) {
            glcd_outtextxy(0, 16, value);  // ›ﬁÿ READY Ì« PIN
        }   
        delay_ms(100);
    } 
    

    // --- »——”Ì Ê÷⁄Ì  ‘»òÂ  « “„«‰ « ’«· --- 
    glcd_clear();
    do { 
        //glcd_clear();
        uart_buffer_reset();
        send_at_command("AT+CREG?");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "CREG")) {
//            glcd_outtextxy(0, 10, buffer);  // ‰„«Ì‘ Ê÷⁄Ì  ‘»òÂ 
   
            if (extract_field_after_keyword(buffer, "+CREG:", 1, value, sizeof(value))) { 
//                glcd_outtextxy(0, 10, value); 
//                delay_ms(100);
//                stat = atoi(value);
                if (atoi(value) == 1) break;
            }
        }
        glcd_outtextxy(0, 15, "Waiting for network...");
        
    } while (1);
    
    glcd_clear();
    glcd_outtextxy(0, 20, "Network OK!");
    delay_ms(50);

    return 1;  // „Ê›ﬁÌ 
}



unsigned char check_signal_quality(void) {
    
    uart_buffer_reset();
    send_at_command("AT+CSQ");

    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
//        glcd_clear();
//        glcd_outtextxy(0, 0, buffer);  

        if (extract_field_after_keyword(buffer, "+CSQ:", 0, value, sizeof(value))) {
//            int csq = atoi(value);  //  »œÌ· —‘ Â »Â ⁄œœ
            glcd_clear();
            glcd_outtextxy(0, 16, value);  // ‰„«Ì‘ „ﬁœ«— ”Ìê‰«· 
            delay_ms(500);
            //stat = atoi(value);
            if (atoi(value) < 5) {
                // ”Ìê‰«· ÷⁄Ì› => ‰Ì«“ »Â —Ì” 
                return 0;
            } else {
                return 1;
            }
        }
    }
    return 0; // «ê— «’·« Å«”ŒÌ ‰ê—› Ì„
}



unsigned char check_signal_with_restart() {
    int i;
    for (i = 0; i < MAX_RETRY; i++) {
        if (check_signal_quality()) {
            // ”Ìê‰«· ŒÊ»Â° «“ Õ·ﬁÂ Œ«—Ã ‘Ê
            return 1;
        }
        // «ê— ”Ìê‰«· ‰»Êœ:
        sim800_restart();   // —Ìù«” «—  „«éÊ· 
        check_sim();
    }
    // «ê— «Ì‰Ã« —”Ìœ Ì⁄‰Ì »⁄œ «“ 3 »«— Â„ ”Ìê‰«· œ—”  ‰‘œ
    // „Ì Ê‰Ì ·«ê »êÌ—Ì Ì« Â‰œ· Œÿ« ò‰Ì
    printf("No signal after %d retries!\n", MAX_RETRY);
}



unsigned char init_sms(void)
{
    glcd_clear();
    glcd_outtextxy(0, 0, "Setting SMS Mode...");        
    
    send_at_command("AT+CFUN=1");
    delay_ms(50);

    send_at_command("AT+CSCLK=0");
    delay_ms(50);

    //  ‰ŸÌ„ SMS
    send_at_command("AT+CMGF=1");
    delay_ms(50);

    send_at_command("AT+CNMI=2,2,0,0,0");
    delay_ms(50);

    send_at_command("AT+CMGDA=\"DEL ALL\"");
    delay_ms(50);

    glcd_outtextxy(0, 10, "SMS Ready.");
    delay_ms(50);

    return 1;
}



unsigned char init_GPRS(void)
{
    
    glcd_clear();
    glcd_outtextxy(0, 0, "Connecting to GPRS...");

    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(100);

    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
    send_at_command(at_command);
    delay_ms(100);
    
    uart_buffer_reset();
    
    send_at_command("AT+SAPBR=1,1");
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "OK")) {
        glcd_outtextxy(0, 0, buffer);  // »«Ìœ ò· Œ—ÊÃÌ "+CSQ: 11,0" Ê "OK" ç«Å ‘Êœ   
        delay_ms(100);
    }
    
    glcd_clear();
    glcd_outtextxy(0, 0, "Fetching IP...");

    while (attempts < 3) {
        uart_buffer_reset();
        send_at_command("AT+SAPBR=2,1");

        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "SAPBR")) {
            // «” Œ—«Ã status (›Ì·œ œÊ„ »⁄œ «“ +SAPBR:)
            if (extract_field_after_keyword(buffer, "+SAPBR:", 1, value, sizeof(value))) {
                if (atoi(value) == 1) { 
                    // «ê— status=1 »Êœ° ›Ì·œ ”Ê„ Â„Ê‰ IP —Ê ‰‘Ê‰ »œÂ
                    if (extract_field_after_keyword(buffer, "+SAPBR:", 2, value, sizeof(value))) {
                        glcd_clear();
                        glcd_outtextxy(0, 0, value);
                        delay_ms(300);
                        return 1; // „Ê›ﬁ
                    }
                }
            }
        }

        // «ê— »Â «Ì‰Ã« —”Ìœ Ì⁄‰Ì „Ê›ﬁ ‰»ÊœÂ
        attempts++;
        delay_ms(100);
    }

    // »⁄œ «“ 3 »«—  ·«‘ ‰«„Ê›ﬁ
    glcd_clear();
    glcd_outtextxy(0, 0, "No IP");
    return 0; // ‰«„Ê›ﬁ
}


void gprs_keep_alive(void) {
//    glcd_clear();
//    glcd_outtextxy(0, 0, "Checking Internet...");  

    uart_buffer_reset();
    send_at_command("AT+HTTPTERM");
    delay_ms(100);

    // --- ‘—Ê⁄ HTTP ---
    uart_buffer_reset();
    send_at_command("AT+HTTPINIT");
    delay_ms(100);

    // --- «‰ Œ«» ò«‰ò‘‰ GPRS ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"CID\",1");
    delay_ms(100);

    // ---  ‰ŸÌ„ URL ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"URL\",\"http://www.google.com\"");
    delay_ms(100);

    // --- «—”«· œ—ŒÊ«”  GET ---
    uart_buffer_reset();
    send_at_command("AT+HTTPACTION=0"); // 0=GET
    delay_ms(100); // ’»— »—«Ì Å«”Œ HTTP

    // --- »——”Ì Å«”Œ ---
    uart_buffer_reset();
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "HTTPACTION")) {
        // „À«· Œ—ÊÃÌ: +HTTPACTION:0,200,1256
        // ›Ì·œ œÊ„ »⁄œ «“ +HTTPACTION: Â„«‰ òœ Ê÷⁄Ì  HTTP «” 
        if (extract_field_after_keyword(buffer, "+HTTPACTION", 1, value, sizeof(value))) {
//            status = atoi(value);  //  »œÌ· —‘ Â »Â ⁄œœ
            glcd_outtextxy(0, 16, value);
            delay_ms(100);
//
//            if (atoi(value) == 200) {
//                glcd_outtextxy(0, 16, "Internet OK");
//            } else {
//                glcd_outtextxy(0, 16, "Internet Failed");
//            }
        } 
//        else {
//            glcd_outtextxy(0, 16, "Parsing Error!");
//        }
    } 
//    else {
//        glcd_outtextxy(0, 16, "No response!");
//    }

    

    // --- Å«Ì«‰ HTTP ---
    uart_buffer_reset();
    send_at_command("AT+HTTPTERM");
    delay_ms(100);
}


//
//void full_check(void){
//
//        sim800_restart();
//        check_sim();
//        check_signal_with_restart();
//        init_sms();
//
//        if (init_GPRS()) {
//            // «ê— „Ê›ﬁ ‘œ° «“ Õ·ﬁÂ Œ«—Ã »‘Â
//            break;
//        } else {
//            // «ê— ‰«„Ê›ﬁ »Êœ
//            glcd_clear();
//            glcd_outtextxy(0, 0, "GPRS Init Failed!");
//            delay_ms(100);  // ò„Ì ’»— ò‰Â
//            // Ê œÊ»«—Â Õ·ﬁÂ  ò—«— „Ì‘Â
//        }
//
//}
