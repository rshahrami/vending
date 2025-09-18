#include "common.h"
#include <stdlib.h>
#include <glcd.h>
#include <delay.h>
#include <string.h>

#define BUFFER_SIZE 512
#define MAX_RETRY   3   // Õœ«òÀ—  ⁄œ«œ  ·«‘



char value[16];
char at_command[30];

char buffer[BUFFER_SIZE];



//unsigned char sim800_basic_init(void) {
//    uart_buffer_reset();
//
//    send_at_command("ATE0");   // Œ«„Ê‘ ò—œ‰ Echo
//    delay_ms(100);
//
//    uart_buffer_reset();
//    send_at_command("AT");     // »——”Ì ¬„«œÂ »Êœ‰ „«éÊ·
//    if (!read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
//        glcd_outtextxy(0, 10, "SIM800 not responding!");
//        return 0; // Failure
//    }
//    glcd_outtextxy(0, 0, buffer);
//    delay_ms(100);
//
//    return 1; // Success
//}


void sim800_restart(void) {

    glcd_clear();
    glcd_outtextxy(0, 0, "Restarting SIM800...");

    // --- —Ì”  »«›— UART ---
    uart_buffer_reset(); 
    
    send_at_command("AT+SAPBR=2,1"); 
    delay_ms(100);


    send_at_command("AT+CGATT=0"); 
    delay_ms(100);
    
    
    send_at_command("AT+CGATT=1"); 
    delay_ms(100);

    // --- ‰—„ù«›“«— —Ì”  „«éÊ· («Œ Ì«—Ì) ---                      // “„«‰ »—«Ì —Ìù«” «— 

    send_at_command("AT+CRESET");
    delay_ms(500);

    send_at_command("AT+CFUN=0");  // —Ìù«” «—  „«éÊ·
    delay_ms(500);                       // “„«‰ »—«Ì —Ìù«” «— 
    
  
    send_at_command("AT+CFUN=1");  // —Ìù«” «—  „«éÊ·
    delay_ms(500);                       // “„«‰ »—«Ì —Ìù«” «— 


//    send_at_command("AT+CFUN=1,1");  // —Ìù«” «—  „«éÊ·
//    delay_ms(2000); 

    // --- Œ«„Ê‘ ò—œ‰ Echo ---
    uart_buffer_reset();
    send_at_command("ATE0");
    delay_ms(100);

    // --- »——”Ì ¬„«œÂ »Êœ‰ „«éÊ· ---
    uart_buffer_reset();
    send_at_command("AT");
    if (!read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
        glcd_outtextxy(0, 10, "SIM800 not responding!");
        return;  // ‘ò”  œ— —«Âù«‰œ«“Ì
    }
    
}


unsigned char check_sim(void) {
    int stat;
    char *comma;
    
    glcd_clear();
    // --- »——”Ì Ê÷⁄Ì  ”Ì„ùò«—  ---
    uart_buffer_reset();
    send_at_command("AT+CPIN?");
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CPIN")) {
        glcd_outtextxy(0, 0, buffer); 
        delay_ms(1000); 
//        if (extract_field_after_keyword(buffer, "+CPIN:", value, sizeof(value))) {
//            glcd_outtextxy(0, 16, value);  // ›ﬁÿ READY Ì« PIN
//        }   
//        delay_ms(1000);
    } 
    
//    uart_buffer_reset();
//    send_at_command("AT+CREG?");
//    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "+CREG")) { 
//        glcd_outtextxy(0, 0, buffer); 
//        if (extract_value_after_keyword(buffer, "+CREG:", value, sizeof(value))) {
//            glcd_outtextxy(0, 16, value);  // ›ﬁÿ READY Ì« PIN
//        }   
//    } 

    // --- »——”Ì Ê÷⁄Ì  ‘»òÂ  « “„«‰ « ’«· ---
    do { 
        glcd_clear();
        uart_buffer_reset();
        send_at_command("AT+CREG?");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "CREG")) {
//            glcd_outtextxy(0, 10, buffer);  // ‰„«Ì‘ Ê÷⁄Ì  ‘»òÂ 
            
            
            if (extract_field_after_keyword(buffer, "+CREG:", 1, value, sizeof(value))) { 
                glcd_outtextxy(0, 10, value); 
                delay_ms(1000);
                stat = atoi(value);
                if (stat == 1) break;
            }
        }
        glcd_outtextxy(0, 15, "Waiting for network...");
        
    } while (1);

    glcd_outtextxy(0, 20, "Network OK!");
    delay_ms(500);

    return 1;  // „Ê›ﬁÌ 

}



unsigned char check_signal_quality(void) {
    
    uart_buffer_reset();
    send_at_command("AT+CSQ");

    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
        glcd_clear();
        glcd_outtextxy(0, 0, buffer);  

        if (extract_field_after_keyword(buffer, "+CSQ:", 0, value, sizeof(value))) {
//            int csq = atoi(value);  //  »œÌ· —‘ Â »Â ⁄œœ
//            glcd_outtextxy(0, 16, value);  // ‰„«Ì‘ „ﬁœ«— ”Ìê‰«· 
//            delay_ms(200);
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
    delay_ms(500);

    send_at_command("AT+CSCLK=0");
    delay_ms(200);

    //  ‰ŸÌ„ SMS
    send_at_command("AT+CMGF=1");
    delay_ms(200);

    send_at_command("AT+CNMI=2,2,0,0,0");
    delay_ms(200);

    send_at_command("AT+CMGDA=\"DEL ALL\"");
    delay_ms(300);

    glcd_outtextxy(0, 10, "SMS Ready.");
    delay_ms(300);

    return 1;
}



unsigned char init_GPRS(void)
{
    glcd_clear();
    glcd_outtextxy(0, 0, "Connecting to GPRS...");

    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(150);

    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
    send_at_command(at_command);
    delay_ms(150);
    
    uart_buffer_reset();
    
    send_at_command("AT+SAPBR=1,1");
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 10000, "OK")) {
        glcd_outtextxy(0, 0, buffer);  // »«Ìœ ò· Œ—ÊÃÌ "+CSQ: 11,0" Ê "OK" ç«Å ‘Êœ   
        delay_ms(500);
    }
    
    glcd_clear();
    glcd_outtextxy(0, 0, "Fetching IP...");
    
    uart_buffer_reset();
    
    send_at_command("AT+SAPBR=2,1"); // Request IP 
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "SAPBR")) {
        if (extract_field_after_keyword(buffer, "+SAPBR:", 2, value, sizeof(value))) { 
        }
    }
    glcd_outtextxy(0, 0, buffer);  // »«Ìœ ò· Œ—ÊÃÌ "+CSQ: 11,0" Ê "OK" ç«Å ‘Êœ 
    delay_ms(500);



if (extract_field_after_keyword(buffer, "+CREG:", 1, value, sizeof(value))) {

    // If we reach here, it means getting the IP address failed
    return 1; // Failure
}


void gprs_keep_alive(void) {
    glcd_clear();
    glcd_outtextxy(0, 0, "Checking Internet...");

    // --- ‘—Ê⁄ HTTP ---
    uart_buffer_reset();
    send_at_command("AT+HTTPINIT");
    delay_ms(200);

    // --- «‰ Œ«» ò«‰ò‘‰ GPRS ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"CID\",1");
    delay_ms(200);

    // ---  ‰ŸÌ„ URL ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"URL\",\"http://www.google.com\"");
    delay_ms(200);

    // --- «—”«· œ—ŒÊ«”  GET ---
    uart_buffer_reset();
    send_at_command("AT+HTTPACTION=0"); // 0=GET
    delay_ms(200); // ’»— »—«Ì Å«”Œ HTTP

    // --- »——”Ì Å«”Œ ---
    uart_buffer_reset();
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 10000, "HTTPACTION:")) {
        // „À«· Œ—ÊÃÌ: +HTTPACTION:0,200,1256
        int status = 0;
        char *p = strchr(buffer, ',');  // «Ê·Ì‰ ò«„«
        if (p) {
            status = atoi(p + 1);      // ⁄œœ »⁄œ «“ «Ê·Ì‰ ò«„« = òœ Ê÷⁄Ì  HTTP
        }

        if (status == 200) {
            glcd_outtextxy(0, 16, "Internet OK");
        } else {
            glcd_outtextxy(0, 16, "Internet Failed");
        }
    } else {
        glcd_outtextxy(0, 16, "No response!");
    }

    delay_ms(500);

    // --- Å«Ì«‰ HTTP ---
    uart_buffer_reset();
    send_at_command("AT+HTTPTERM");
    delay_ms(100);
}

