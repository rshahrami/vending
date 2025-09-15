#include "common.h"
#include <glcd.h>
#include <delay.h>
#include <string.h>

#define BUFFER_SIZE 512

char buffer[BUFFER_SIZE];

void sim800_restart(void)
{
    // ›ﬁÿ Ìò»«— »«›— UART —« ’›— „Ìùò‰Ì„
    // (‰Â œ— œ«Œ· Õ·ﬁÂ ŒÊ«‰œ‰)
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    rx_buffer_overflow0 = 0;
    send_at_command("AT+CSQ\r\n");

    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
        glcd_outtextxy(0, 0, buffer);  // »«Ìœ ò· Œ—ÊÃÌ "+CSQ: 11,0" Ê "OK" ç«Å ‘Êœ    
        delay_ms(500);
    }
//    send_at_command("AT+CSQ\r\n");  // œ” Ê— ”«œÂ ç‰œ ŒÿÌ
//    read_serial_timeout_simple(buffer, BUFFER_SIZE, 5000); // ŒÊ«‰œ‰  « 5 À«‰ÌÂ
//
//    delay_ms(500);
//
//    send_at_command("AT+CREG?\r\n"); // œ” Ê— œÊ„
//    read_serial_timeout_simple(buffer, BUFFER_SIZE, 5000); // ŒÊ«‰œ‰  « 5 À«‰ÌÂ 
//    delay_ms(500);
}
