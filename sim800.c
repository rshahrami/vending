#include "common.h"
#include <glcd.h>
#include <delay.h>
#include <string.h>

#define BUFFER_SIZE 512

char buffer[BUFFER_SIZE];

void sim800_restart(void)
{
    // ��� ���� ���� UART �� ��� �흘���
    // (�� �� ���� ���� ������)
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    rx_buffer_overflow0 = 0;
    send_at_command("AT+CSQ\r\n");

    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
        glcd_outtextxy(0, 0, buffer);  // ���� �� ����� "+CSQ: 11,0" � "OK" �ǁ ���    
        delay_ms(500);
    }
//    send_at_command("AT+CSQ\r\n");  // ����� ���� ��� ���
//    read_serial_timeout_simple(buffer, BUFFER_SIZE, 5000); // ������ �� 5 �����
//
//    delay_ms(500);
//
//    send_at_command("AT+CREG?\r\n"); // ����� ���
//    read_serial_timeout_simple(buffer, BUFFER_SIZE, 5000); // ������ �� 5 ����� 
//    delay_ms(500);
}
