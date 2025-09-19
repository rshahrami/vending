#include "common.h"
#include <string.h>
#include <delay.h>
#include <mega64a.h>
#include <glcd.h>

#define glcd_pixel(x, y, color) glcd_setpixel(x, y)
#define read_flash_byte(p) (*(p))

// --- ����� ����� AT ---
void send_at_command(char *command)
{
    printf("%s\r\n", command);
}

// --- �ǘ ���� ���� USART0 ---
void uart_flush0(void)
{
    unsigned char dummy;

    // �ǘ ���� ������ ��ʝ������
    while (UCSR0A & (1<<RXC0)) {
        dummy = UDR0;
    }
//
//    // �ǘ ���� ���� ���������
//    rx_wr_index0 = rx_rd_index0 = 0;
//    rx_counter0 = 0;
//    rx_buffer_overflow0 = 0;
}


void uart_buffer_reset(void) {
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    rx_buffer_overflow0 = 0;
}


//unsigned char read_serial_timeout_simple(char* buffer, int buffer_size, unsigned long timeout_ms) {
//    int i = 0;
//    unsigned long elapsed = 0;
//
//    // ���� ���� �� ��� �흘���
//    memset(buffer, 0, buffer_size);
//
//    // ������� ������ �� ��� ���� � delay
//    while (elapsed < timeout_ms && i < buffer_size - 1) {
//        // ǐ� ������ �� UART ���� ����
//        while (rx_counter0 > 0 && i < buffer_size - 1) {
//            char c = getchar();  // ������ � ���ǘ�� �� UART
//            buffer[i++] = c;
//            buffer[i] = '\0';
//
//            // ����� ���� ��� GLCD
//            glcd_outtextxy(0, 0, buffer);
//        }
//        delay_ms(1);
//        elapsed++;
//    }
//
//    return (i > 0); // 1 ǐ� ����� � ���ǘ�� ������ ��� ����
//}



// ������ ���� ���� ��� ���
unsigned char read_until_keyword_keep_all(char* buffer, int buffer_size, unsigned long timeout_ms, const char* keyword) {
    int i = 0;
    unsigned long elapsed = 0;
    int found = 0;
    int keyword_len = strlen(keyword);

    memset(buffer, 0, buffer_size);

    while (elapsed < timeout_ms && i < buffer_size - 1) {
        while (rx_counter0 > 0 && i < buffer_size - 1) {
            char c = getchar();
            buffer[i++] = c;
            buffer[i] = '\0';

            // ����� ���� keyword
            if (!found && i >= keyword_len) {
                if (strstr(buffer, keyword) != NULL) {
                    found = 1;
                    elapsed = 0;   // ���� ���� ����� ? ����� ���� ����� ���� �� ����
                }
            }
        }

        if (found && elapsed > 100) {  
            // ���� 100ms ��� �� ���� ���ϡ ����� ���
            break;
        }

        delay_ms(1);
        elapsed++;
    }

    return (i > 0);
}

//// ���� ������ ������ ���� �������
//int extract_value_after_keyword(const char* input, const char* keyword, char* out_value, int out_size) {
//    const char* p = strstr(input, keyword);
//    int i = 0;
//    if (p) {
//        p += strlen(keyword);  // ��� ��� �� �����ǎ�
//        while (*p == ' ' || *p == '\t') p++;  // �� ���� �������
//
//        // ��� ���� ����� �� ����� ��ǘ���� (, �� �Ӂ�� �� CRLF)
//        while (*p && *p != ',' && *p != '\r' && *p != '\n' && *p != ' ' && i < out_size - 1) {
//            out_value[i++] = *p++;
//        }
//        out_value[i] = '\0';
//        return 1;  // ����
//    }
//    return 0;  // ���� ���
//}


int extract_field_after_keyword(const char* input, const char* keyword, int field_index, char* out_value, int out_size)
{
    int current_field = 0;
    int i = 0;
    const char* p = strstr(input, keyword);
    
    if (!p) return 0; // �����ǎ� ���� ���

    p += strlen(keyword);      // ��� ��� �� �����ǎ�

    // �� ���� ������� � �ȝ�� ��� �� ����� ����
    while (*p == ' ' || *p == '\t') p++;

    while (*p && current_field <= field_index)
    {
        if (current_field == field_index)
        {
            // ��� ���� ����� ���� �� ���ǡ CR, LF �� space
            while (*p && *p != ',' && *p != '\r' && *p != '\n' && i < out_size - 1)
            {
                out_value[i++] = *p++;
            }
            out_value[i] = '\0';
            return 1; // ����
        }

        // ���� �� ����� ���� � �� ���� �������� �����
        while (*p && *p != ',') p++;
        if (*p == ',') p++;  // �� ���� ����
        while (*p == ' ' || *p == '\t') p++; // �� ���� ����� ��� �� ����
        current_field++;
    }

    return 0; // ���� ������� ���� ���
}


//
//int extract_field_after_keyword(const char* input, const char* keyword, int field_index, char* out_value, int out_size)
//{
//    int current_field = 0;
//    int i = 0;
//    const char* p = strstr(input, keyword);
//    
//    if (!p) return 0; // �����ǎ� ���� ���
//
//    p += strlen(keyword);      // ��� ��� �� �����ǎ�
//    while (*p == ' ' || *p == '\t') p++; // �� ���� �������
//
//    while (*p && current_field <= field_index)
//    {
//        if (current_field == field_index)
//        {
//            // ��� ���� ����� ���� �� ���� �� CRLF �� �Ӂ��
//            while (*p && *p != ',' && *p != '\r' && *p != '\n' && i < out_size - 1)
//            {
//                out_value[i++] = *p++;
//            }
//            out_value[i] = '\0';
//            return 1; // ����
//        }
//
//        // ���� �� ����� ����
//        while (*p && *p != ',') p++;
//        if (*p == ',') p++; // �� ���� ����
//        current_field++;
//    }
//
//    return 0; // ���� ������� ���� ���
//}



//unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, const char* end_pattern) {
//    int i = 0;
//    unsigned int elapsed = 0;
//
//    memset(buffer, 0, buffer_size);
//
//    while (elapsed < (unsigned)timeout_ms) {
//        while (rx_counter0 > 0 && i < buffer_size - 1) {
//            buffer[i++] = getchar();
//        }
//
//        // ����� ���� ����� ����
//        if (end_pattern != NULL && strstr(buffer, end_pattern)) {
//            buffer[i] = '\0';
//            return 1;
//        }
//
//        if (i >= buffer_size - 1) {
//            buffer[i] = '\0';
//            return 1;
//        }
//
//        delay_ms(1);
//        elapsed++;
//    }
//
//    buffer[i] = '\0';
//    return (i > 0);
//}


//// --- ������ ���� ����� �� timeout ---
//unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, const char* expected_response) {
//    int i = 0;
//    unsigned int elapsed = 0;
//
//    // ?C? ??I? EC?? ?C?E?
//    memset(buffer, 0, buffer_size);
//
//    while (elapsed < (unsigned)timeout_ms) {
//        // ?? EC?? E?C? EC?E??C? I? I?E?? ????? UART ?C EI?C??I
//        while (rx_counter0 > 0 && i < buffer_size - 1) {
//            buffer[i++] = getchar();  // getchar C? ????? EC?? ???A?I
//        }
//        // C?? C?EUC??C? ?C I?I??? ??I E???I??
//        if (strstr(buffer, expected_response)) {
//            return 1;
//        }
//        delay_ms(1);
//        elapsed++;
//    }
//    // ?? C? ?C?C? EC???C?E ?? ??EC? I??? ?? ???????
//    return (strstr(buffer, expected_response) != NULL);
//}


