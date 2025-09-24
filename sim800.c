#include <stdlib.h>
#include <stdint.h>
#include <glcd.h>
#include <delay.h>
#include <string.h>
#include "common.h"
#include "sim800.h"

//#define BUFFER_SIZE 512
#define MAX_RETRY   3   // ��ǘ�� ����� ����



//char value[16];

char at_command[30];
char sim_number[15];

//char buffer[BUFFER_SIZE];
uint8_t attempts = 0;



void sim800_restart(void) {
    glcd_clear();
    glcd_outtextxy(0, 0, "Restarting SIM800...");

    // --- 1) ���� HTTP (ǐ� ���� ���) ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+HTTPTERM");
        // ǐ� OK �� ERROR ��ϡ ��� ����� ������ (ǐ� HTTP ���� ���� ERROR �����)
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 1000, "ERROR")) break;
        glcd_outtextxy(0, 10, "Waiting HTTPTERM...");
        delay_ms(50);
    }

    // --- 2) ���� SAPBR (bearer) ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+SAPBR=0,1");   // close bearer
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting SAPBR=0,1...");
        delay_ms(50);
    }

    // --- 3) �� �� �� SAPBR ���� ��� (������� ��� ����) ---
    {
        int ok = 0;
        while (!ok) {
            uart_buffer_reset();
            send_at_command("AT+SAPBR=2,1"); // query
            if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "SAPBR")) {
                // ������ ����� ����� ��� +SAPBR: 1,3,"0.0.0.0" �� +SAPBR: 1,0,"0.0.0.0"
                // ǐ� IP 0.0.0.0 �� status != 1 ���� ���� ���� ���
                if (strstr(buffer, "0.0.0.0") || strstr(buffer, ",0,") || strstr(buffer, ",3,")) {
                    ok = 1; // �� ��� ���� �� �� ���� ��� connected ���
                    break;
                }
            }
            // ǐ� �� ����� ����� �� ���� Connected ��� ����� � ������ ���� ��
            glcd_outtextxy(0, 10, "Checking SAPBR closed...");
            delay_ms(100);
        }
    }

    // --- 4) detach �� GPRS ---
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+CGATT=0");     // detach
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting CGATT=0...");
        delay_ms(50);
    }

    // --- 5) ���� ���� ��������� (CFUN=1,1) � Ӂ� ��� �� �ǎ�� ���� ����� ---
    // ��� ����� ��� ��� ���� ����� ��Ϻ �� �� ����� � Ӂ� �� ����� �� �ǎ�� �� AT ���� ��� ��� ��.
    while (1) {
        uart_buffer_reset();
        send_at_command("AT+CFUN=1,1");
        // ��� ��� OK ��Ґ��� �� �� �� �� ���� ��� �� ��� ���ʡ ����� ���� ���� �ǎ�� ������.
        // ����� ǐ� OK ��� �� �� ���� �� Ӂ� ����� "AT" ���� ����.
        read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK"); // (����� ǐ� �����)
        // ǘ��� ����� �� �� ������� �� AT ���� ���
        glcd_outtextxy(0, 10, "Rebooting, wait for AT...");
        while (1) {
            uart_buffer_reset();
            send_at_command("AT");
            if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
                // �ǎ�� ���� ���� � ����� ���
                goto after_reboot;
            }
            // ǐ� ������ �� ����� ����� ���� ����� � delay �������� �����
            delay_ms(50);
        }
    }
after_reboot:

    // --- 6) ����� ���� Echo ---
    while (1) {
        uart_buffer_reset();
        send_at_command("ATE0");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
        glcd_outtextxy(0, 10, "Waiting ATE0...");
        delay_ms(50);
    }

    // --- 7) ��� ����� �ǎ�� ---
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
    // --- ����� ����� ��㝘��� ---
    uart_buffer_reset();
    send_at_command("AT+CPIN?");
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CPIN")) {
//        glcd_outtextxy(0, 0, buffer); 
//        delay_ms(5000); 
        if (extract_field_after_keyword(buffer, "+CPIN:", 0, value, sizeof(value))) {
            glcd_outtextxy(0, 16, value);  // ��� READY �� PIN
        }   
        delay_ms(100);
    } 
    

    // --- ����� ����� �Ș� �� ���� ����� --- 
    glcd_clear();
    do { 
        //glcd_clear();
        uart_buffer_reset();
        send_at_command("AT+CREG?");
        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "CREG")) {
//            glcd_outtextxy(0, 10, buffer);  // ����� ����� �Ș� 
   
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

    return 1;  // ������
}



unsigned char check_signal_quality(void) {
    
    uart_buffer_reset();
    send_at_command("AT+CSQ");

    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
//        glcd_clear();
//        glcd_outtextxy(0, 0, buffer);  

        if (extract_field_after_keyword(buffer, "+CSQ:", 0, value, sizeof(value))) {
//            int csq = atoi(value);  // ����� ���� �� ���
            glcd_clear();
            glcd_outtextxy(0, 16, value);  // ����� ����� ����� 
            delay_ms(500);
            //stat = atoi(value);
            if (atoi(value) < 5) {
                // ����� ���� => ���� �� ����
                return 0;
            } else {
                return 1;
            }
        }
    }
    return 0; // ǐ� ����� ����� ������
}



unsigned char check_signal_with_restart() {
    int i;
    for (i = 0; i < MAX_RETRY; i++) {
        if (check_signal_quality()) {
            // ����� ���� �� ���� ���� ��
            return 1;
        }
        // ǐ� ����� ����:
        sim800_restart();   // �������� �ǎ�� 
        check_sim();
    }
    // ǐ� ����� ���� ���� ��� �� 3 ��� �� ����� ���� ���
    // ������ �ǐ Ȑ��� �� ���� ��� ���
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

    // ����� SMS
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
        glcd_outtextxy(0, 0, buffer);  // ���� �� ����� "+CSQ: 11,0" � "OK" �ǁ ���   
        delay_ms(100);
    }
    
    glcd_clear();
    glcd_outtextxy(0, 0, "Fetching IP...");

    while (attempts < 3) {
        uart_buffer_reset();
        send_at_command("AT+SAPBR=2,1");

        if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "SAPBR")) {
            // ������� status (���� ��� ��� �� +SAPBR:)
            if (extract_field_after_keyword(buffer, "+SAPBR:", 1, value, sizeof(value))) {
                if (atoi(value) == 1) { 
                    // ǐ� status=1 ��ϡ ���� ��� ���� IP �� ���� ���
                    if (extract_field_after_keyword(buffer, "+SAPBR:", 2, value, sizeof(value))) {
                        glcd_clear();
                        glcd_outtextxy(0, 0, value);
                        delay_ms(300);
                        return 1; // ����
                    }
                }
            }
        }

        // ǐ� �� ����� ���� ���� ���� �����
        attempts++;
        delay_ms(100);
    }

    // ��� �� 3 ��� ���� ������
    glcd_clear();
    glcd_outtextxy(0, 0, "No IP");
    return 0; // ������
}


void gprs_keep_alive(void) {
//    glcd_clear();
//    glcd_outtextxy(0, 0, "Checking Internet...");  

    uart_buffer_reset();
    send_at_command("AT+HTTPTERM");
    delay_ms(100);

    // --- ���� HTTP ---
    uart_buffer_reset();
    send_at_command("AT+HTTPINIT");
    delay_ms(100);

    // --- ������ ����� GPRS ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"CID\",1");
    delay_ms(100);

    // --- ����� URL ---
    uart_buffer_reset();
    send_at_command("AT+HTTPPARA=\"URL\",\"http://www.google.com\"");
    delay_ms(100);

    // --- ����� ������� GET ---
    uart_buffer_reset();
    send_at_command("AT+HTTPACTION=0"); // 0=GET
    delay_ms(100); // ��� ���� ���� HTTP

    // --- ����� ���� ---
    uart_buffer_reset();
    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "HTTPACTION")) {
        // ���� �����: +HTTPACTION:0,200,1256
        // ���� ��� ��� �� +HTTPACTION: ���� �� ����� HTTP ���
        if (extract_field_after_keyword(buffer, "+HTTPACTION", 1, value, sizeof(value))) {
//            status = atoi(value);  // ����� ���� �� ���
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

    

    // --- ����� HTTP ---
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
//            // ǐ� ���� �ϡ �� ���� ���� ���
//            break;
//        } else {
//            // ǐ� ������ ���
//            glcd_clear();
//            glcd_outtextxy(0, 0, "GPRS Init Failed!");
//            delay_ms(100);  // ��� ��� ���
//            // � ������ ���� ʘ��� ����
//        }
//
//}
