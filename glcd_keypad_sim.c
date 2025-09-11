#include <mega64a.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h> // E?C? C?E?CI? C? ECE? atoi
#include <delay.h>

#include "bitmaps.h"

typedef unsigned char uint8_t;
typedef unsigned int  uint16_t;
typedef signed char   int8_t;

#define MOTOR_DDR DDRE
#define MOTOR_PORT PORTE
#define MOTOR_PIN_1 2
#define MOTOR_PIN_2 3
#define MOTOR_PIN_3 4

// --- E???? ?????C? ????I ---
#define KEYPAD_PORT PORTC
#define KEYPAD_DDR DDRC
#define KEYPAD_PIN PINC
#define COL1_PIN 0
#define COL2_PIN 1
#define COL3_PIN 2
#define ROW1_PIN 7
#define ROW2_PIN 5
#define ROW3_PIN 6
#define ROW4_PIN 4

#define APN "mcinet" // APN C??CE?? I?I ?C ?C?I ???I


#define glcd_pixel(x, y, color) glcd_setpixel(x, y)
#define read_flash_byte(p) (*(p))

#define HTTP_TIMEOUT_MS 5000


char ip_address_buffer[16];

volatile bit sms_received = 0;

char header_buffer[100];
char content_buffer[100];
int header_index = 0;
int content_index = 0;


#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 100
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
    char status,data;
    status=UCSR0A;
    data=UDR0;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {
        rx_buffer0[rx_wr_index0++]=data;
        #if RX_BUFFER_SIZE0 == 256
        // special case for receiver buffer size=256
        if (++rx_counter0 == 0) rx_buffer_overflow0=1;
        #else
        if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
        if (++rx_counter0 == RX_BUFFER_SIZE0)
            {
            rx_counter0=0;
            rx_buffer_overflow0=1;
            }
        #endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
    char data;
    while (rx_counter0==0);
    data=rx_buffer0[rx_rd_index0++];
    #if RX_BUFFER_SIZE0 != 256
    if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
    #endif
    #asm("cli")
    --rx_counter0;
    #asm("sei")
    return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


void draw_bitmap(uint8_t x, uint8_t y, __flash unsigned char* bmp, uint8_t width, uint8_t height)
{
    uint16_t byte_index;
    uint8_t page;
    uint8_t col;
    uint8_t bit_pos;
    uint8_t data;
    uint8_t pages;

    byte_index = 0;
    pages = height / 8;

    for (page = 0; page < pages; page++) {
        for (col = 0; col < width; col++) {
            data = read_flash_byte(&bmp[byte_index++]);
            for (bit_pos = 0; bit_pos < 8; bit_pos++) {
                if (data & (1 << bit_pos)) {
                    glcd_pixel(x + col, y + (page * 8) + bit_pos, 1);
                }
            }
        }
    }
}

void send_at_command(char *command)
{
    printf("%s\r\n", command);
}

void uart_flush0(void)
{
    unsigned char dummy;
    //  « Êﬁ Ì çÌ“Ì  ÊÌ »«›— Â” ° »ŒÊ‰ Ê œÊ— »‰œ«“
    while (UCSR0A & (1<<RXC0)) {
        dummy = UDR0;
    }
}


unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, const char* expected_response) {
    int i = 0;
    unsigned int elapsed = 0;

    // ?C? ??I? EC?? ?C?E?
    memset(buffer, 0, buffer_size);

    while (elapsed < (unsigned)timeout_ms) {
        // ?? EC?? E?C? EC?E??C? I? I?E?? ????? UART ?C EI?C??I
        while (rx_counter0 > 0 && i < buffer_size - 1) {
            buffer[i++] = getchar();  // getchar C? ????? EC?? ???A?I
        }
        // C?? C?EUC??C? ?C I?I??? ??I E???I??
        if (strstr(buffer, expected_response)) {
            return 1;
        }
        delay_ms(1);
        elapsed++;
    }
    // ?? C? ?C?C? EC???C?E ?? ??EC? I??? ?? ???????
    return (strstr(buffer, expected_response) != NULL);
}

void sim800_restart(void)
{
    char buffer[128];

    // Â— çÌ  ÊÌ »«›— Â”  Œ«·Ì ò‰
    uart_flush0();

    // œ” Ê— —Ìù«” «—  ‰—„ù«›“«—Ì
    send_at_command("AT+CFUN=1,1");

    // ’»— »—«Ì Å«”Œ OK (Õœ«òÀ— 2 À«‰ÌÂ)
    if (!read_serial_response(buffer, sizeof(buffer), 2000, "OK")) {
        // «ê— OK ‰ê—› Ì„ „Ì‘Â  ’„Ì„ ê—›  œÊ»«—Â  ·«‘ ò‰Ì„
        // Ì« ò·« return ò‰Ì„
    }

    // ’»— »—«Ì ÅÌ«„ RDY (Õœ«òÀ— 10 À«‰ÌÂ)
    while (!read_serial_response(buffer, sizeof(buffer), 10000, "RDY")) {
        //  « Êﬁ Ì RDY ‰Ì«œ Â„Ì‰Ã« „Ìù„Ê‰Â
    }

    // „Ìù Ê‰Ì„ »—«Ì «ÿ„Ì‰«‰ »Ì‘ — ’»— ò‰Ì„  « SIM ¬„«œÂ »‘Â
    // „À·: +CPIN: READY Ê SMS READY
    while (!read_serial_response(buffer, sizeof(buffer), 10000, "+CPIN: READY"));
    while (!read_serial_response(buffer, sizeof(buffer), 10000, "SMS READY"));
}



unsigned char send_json_post(const char* base_url, const char* phone_number) {
    // C??C? ?EU???C (C89)
    char cmd[256];
    char response[256];
    char full_url[256];
    char *action_ptr;
    int method = 0, status_code = 0, data_len = 0;

    // ??C?O ??C? ??? GLCD
    glcd_clear();
    draw_bitmap(0, 0, lotfan_montazer_bemanid, 128, 64);

    // 0) ??O ??I? EC?? UART
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    rx_buffer_overflow0 = 0;

    // 1) Initialize HTTP service
    send_at_command("AT+HTTPINIT");
    if (!read_serial_response(response, sizeof(response), 2000, "OK")) {
        // C?? I??E ?C? ???I? terminate ? I???
        send_at_command("AT+HTTPTERM");
        read_serial_response(response, sizeof(response), 1000, "OK");
        return 0;
    }

    // 2) Set CID to bearer profile 1
    send_at_command("AT+HTTPPARA=\"CID\",1");
    if (!read_serial_response(response, sizeof(response), 1000, "OK")) {
        send_at_command("AT+HTTPTERM");
        read_serial_response(response, sizeof(response), 1000, "OK");
        return 0;
    }

    // 3) Build the full URL with query parameter
    sprintf(full_url, "%s?phone_number=%s", base_url, phone_number);

    // 4) Set the target URL
    sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", full_url);
    send_at_command(cmd);
    if (!read_serial_response(response, sizeof(response), 2000, "OK")) {
        send_at_command("AT+HTTPTERM");
        read_serial_response(response, sizeof(response), 1000, "OK");
        return 0;
    }

    // 5) Start POST action
    // ??O EC?? ?E? C? HTTPACTION
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    send_at_command("AT+HTTPACTION=1");
    if (!read_serial_response(response, sizeof(response), HTTP_TIMEOUT_MS, "+HTTPACTION:")) {
        glcd_clear();
        glcd_outtextxy(0, 0, "No Action Resp");
        delay_ms(500);
        // terminate ? I???
        send_at_command("AT+HTTPTERM");
        read_serial_response(response, sizeof(response), 1000, "OK");
        return 0;
    }

    // 6) Parse status code from response
    action_ptr = strstr(response, "+HTTPACTION:");
    if (action_ptr == NULL ||
        sscanf(action_ptr, "+HTTPACTION: %d,%d,%d", &method, &status_code, &data_len) != 3) {
        send_at_command("AT+HTTPTERM");
        read_serial_response(response, sizeof(response), 1000, "OK");
        return 0;
    }

    // 7) Read server response if needed
    send_at_command("AT+HTTPREAD");
    // ??O EC?? ?E? C? HTTPREAD
    rx_wr_index0 = rx_rd_index0 = 0;
    rx_counter0 = 0;
    read_serial_response(response, sizeof(response), 3000, "OK");

    // 8) Terminate HTTP service
    send_at_command("AT+HTTPTERM");
    read_serial_response(response, sizeof(response), 1000, "OK");

    // 9) ?E???
    return (status_code == 200) ? 1 : 0;
}






char get_key(void)
{
    unsigned char row, col;
    const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
    const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};

    const char key_map[4][3] = {
        {'1', '2', '3'},
        {'4', '5', '6'},
        {'7', '8', '9'},
        {'*', '0', '#'}
    };

    for (col = 0; col < 3; col++)
    {
        KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);
        KEYPAD_PORT &= ~(1 << column_pins[col]);

        for (row = 0; row < 4; row++)
        {
            if (!(KEYPAD_PIN & (1 << row_pins[row])))
            {
                delay_ms(10);

                if (!(KEYPAD_PIN & (1 << row_pins[row])))
                {
                    while (!(KEYPAD_PIN & (1 << row_pins[row])));
                    return key_map[row][col];
                }
            }
        }
    }

    // C?? ??? ???I? ?O?I? ?OI? E?I? ??IC? ??? (NULL) ?C E???IC?
    return 0;
}



void activate_motor(int product_id)
{
    unsigned char motor_pin;
    char motor_msg[20]; 
    int timeout = 1000;

    switch (product_id)
    {
        case 1: motor_pin = MOTOR_PIN_1; break;
        case 2: motor_pin = MOTOR_PIN_2; break;
        case 3: motor_pin = MOTOR_PIN_3; break;
        default: return;
    }

    sprintf(motor_msg, "MOTOR %d ON!", product_id);
    glcd_clear();
    glcd_outtextxy(10, 20, motor_msg);
    MOTOR_PORT |= (1 << motor_pin);
    
    while (!(PIND & (1 << PIND1)) && timeout > 0)
    {
        delay_ms(1);
        timeout--;
    }
 
    MOTOR_PORT &= ~(1 << motor_pin);


    // draw_bitmap(0, 0, mahsol_ra_bardarid, 128, 64);
    // delay_ms(300);
}


unsigned char init_sms(void)
{
    glcd_clear();
    glcd_outtextxy(0, 0, "Setting SMS Mode...");
    send_at_command("AT+CMGF=1");
    delay_ms(1000);

    send_at_command("AT+CNMI=2,2,0,0,0");
    delay_ms(1000);

    send_at_command("AT+CMGDA=\"DEL ALL\"");
    delay_ms(2000);


    // C????C? C? ??C? E?I? ?C?? ?C??? ? U????C? E?I? sleep
    send_at_command("AT+CFUN=1");    // ??C???C?? ?C?? ?C???
    delay_ms(1000);
    send_at_command("AT+CSCLK=0");   // U????C???C?? ?C?E sleep
    delay_ms(1000);

    glcd_outtextxy(0, 10, "SMS Ready.");
    delay_ms(2000);
    return 1;
}


void handle_sms(void)
{
    const char* server_url = "http://193.5.44.191/home/post/";
    int product_id = 0;
    int timeout_counter = 0;
    char key_pressed;
    char *tok, phone[32];
    tok = strtok(header_buffer, "\"");      // ?IC ??I? +CMT:
    tok = strtok(NULL, "\"");               // C???EC? O?C?? ICI? ??E?O?
    if (tok) strcpy(phone, tok);
    else    strcpy(phone, "unknown");

    glcd_clear();
    glcd_outtextxy(0,0,"SMS from:");
    glcd_outtextxy(0,10,phone);
    glcd_outtextxy(0,20,content_buffer);
    delay_ms(2000);

//////////////////////////////////////////////////////////////////////////////////////////////


    if (content_buffer == '1' || content_buffer == '2' || content_buffer == '3')
    {

        if (send_json_post(server_url, phone))
        {
            glcd_clear();                            
            
            draw_bitmap(0, 0, adad_ra_vared_namaeid, 128, 64);
            draw_bitmap(0, 32, square, 128, 32); 
            glcd_outtextxy(64, 42, content_buffer);

            key_pressed = 0;
            for (timeout_counter = 0; timeout_counter < 200; timeout_counter++)
            {
                key_pressed = get_key();
                if (key_pressed != 0) break;
                delay_ms(10);
            }

            if (key_pressed == 0)
            {
                glcd_clear();
                glcd_outtextxy(10, 25, "Timeout! Try again.");
                delay_ms(200);
            }
            else
            {

                if (key_pressed == content_buffer)
                {
                    glcd_clear(); 
                    product_id = content_buffer[0] - '0';
                    activate_motor(product_id);
                }
                else
                {
                    glcd_clear();
//                                    glcd_outtextxy(5, 25, "Error in entry!");
                    draw_bitmap(0, 0, shomare_soton_dorost_vared_nashode, 128, 32);
                    delay_ms(300);
                }
            }
        }
        else
        {
            glcd_clear();
//                        glcd_outtextxy(0, 25, "You are not authorized!");
            draw_bitmap(0, 0, tedad_bish_az_had, 128, 64);
            delay_ms(300);
        }
    }

    else
    {
        glcd_clear();
        draw_bitmap(0, 0, shomare_dorost_payamak_nashode, 128, 64);
        delay_ms(300);
    }






////////////////////////////////////////////////////////////////////////////////////////////


    sms_received = 0;  // A?CI? E?C? ??C? E?I?
}


void process_uart_data(void)
{
    static uint8_t phase = 0;   // 0=I?C?I? ?I?? 1=I?C?I? ??E?C
    static uint8_t h_idx = 0;
    static uint8_t c_idx = 0;
    char d;

    while (rx_counter0 > 0 && !sms_received) {
        d = getchar();

        if (phase == 0) {
            // -- I?C?I? ?I? EC '\n' --
            if (d == '\n') {
                header_buffer[h_idx] = '\0';
                // ??? C?? ?I? ?C??? SMS ECOI? E??? ??CU I?C?I? ??E?C
                if (strstr(header_buffer, "+CMT:") != NULL) {
                    phase = 1;
                    c_idx = 0;  // A?CI? E?C? ?? ??I? content_buffer
                }
                // ???O? h_idx ?C ???E ?? EC I??? E?I? C? C?? ?? O??I
                h_idx = 0;
            }
            else if (d != '\r') {
                // ?I???? ?C?C?E? I? header_buffer
                if (h_idx < sizeof(header_buffer) - 1)
                    header_buffer[h_idx++] = d;
            }
        }
        else {
            // -- I?C?I? ??E?C EC '\n' --
            if (d == '\n') {
                content_buffer[c_idx] = '\0';
                sms_received = 1;    // ?? SMS ?C?? I??C?E OI
                phase = 0;           // E?C? ??C? E?I? I?EC?? E??????I?? E? ?C? 0
                h_idx = 0;           // C??I????C ?C ?? ?C? ???????
                c_idx = 0;
            }
            else if (d != '\r') {
                if (c_idx < sizeof(content_buffer) - 1)
                    content_buffer[c_idx++] = d;
            }
        }
    }
}



unsigned char init_GPRS(void) {
    char at_command[50];
    char response[100]; // Local buffer for the response

    glcd_clear();
    glcd_outtextxy(0, 0, "Connecting to GPRS...");

    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(150);

    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
    send_at_command(at_command);
    delay_ms(150);

    send_at_command("AT+SAPBR=1,1");
    delay_ms(150);

    glcd_clear();
    glcd_outtextxy(0, 0, "Fetching IP...");
    send_at_command("AT+SAPBR=2,1"); // Request IP
    // delay_ms(5000);
    
    // Attempt to read the response for 5 seconds, looking for "+SAPBR:"
    // FIX: Added the 4th argument, "+SAPBR:", to the function call.
    if (read_serial_response(response, sizeof(response), 200, "+SAPBR:")) {
        glcd_outtextxy(0, 10, "Resp:");
        glcd_outtextxy(0, 20, response); // Display the received response for debugging
        delay_ms(200);

        // Check if the response contains the IP address part
        if (strstr(response, "+SAPBR: 1,1,") != NULL) {
            char* token = strtok(response, "\"");
            token = strtok(NULL, "\"");

            if (token) {
                strcpy(ip_address_buffer, token);
                return 1; // Success
            }
        }
    }

    // If we reach here, it means getting the IP address failed
    return 0; // Failure
}


// —Ì”   „Ì“ SIM800: Œ—ÊÃ «“ œÌ « „Êœ° »” ‰ HTTP Ê ”Êò ùÂ«° Œ«„Ê‘ ò—œ‰ bearer° —Ì”  ‰—„ù«›“«—Ì
unsigned char sim800_reset_clean(void)
{
    char resp[256];  
    unsigned long waited = 0;

    // 1) Œ—ÊÃ œ—”  «“ œÌ « „Êœ (+++) ó »œÊ‰ CR/LF Ê »« ê«—œ «Ì„
    delay_ms(800);
    uart_flush0();
    send_at_command("+++");       // „Â„: »œÊ‰ \r
    delay_ms(800);

    // 2) «òÊ Œ«„Ê‘ »—«Ì Å«”Œ  „Ì“ («Œ Ì«—Ì Ê·Ì „›Ìœ)
    uart_flush0(); send_at_command("ATE0\r");
    read_serial_response(resp, sizeof(resp), 500, "OK");

    // 3) »” ‰ Â„Â? ”—ÊÌ”ùÂ«/ò«‰ò‘‰ùÂ« (Â— òœÊ„ OK Ì« ERROR „Â„ ‰Ì” ∫ Âœ› Å«òù”«“Ì «” )
    uart_flush0(); send_at_command("AT+HTTPTERM\r");  read_serial_response(resp, sizeof(resp), 600, "OK");   // Å«Ì«‰ HTTP
    uart_flush0(); send_at_command("AT+CIPCLOSE\r");  read_serial_response(resp, sizeof(resp), 800, "OK");   // »” ‰ TCP («ê— »«“ »«‘œ)
    uart_flush0(); send_at_command("AT+CIPSHUT\r");   read_serial_response(resp, sizeof(resp), 1500, "SHUT"); // —Ì”  «” ò IP
    uart_flush0(); send_at_command("AT+SAPBR=0,1\r"); read_serial_response(resp, sizeof(resp), 1200, "OK");   // Œ«„Ê‘ ò—œ‰ bearer

    // («Œ Ì«—Ì «ê— «” ›«œÂ ‘œÂ »Êœ)
    // uart_flush0(); send_at_command("AT+NETCLOSE\r"); read_serial_response(resp, sizeof(resp), 1000, "OK");

    // 4) —Ìù«” «—  ‰—„ù«›“«—Ì „«éÊ·
    uart_flush0(); send_at_command("AT+CFUN=1,1\r");

    // 5) „‰ Ÿ— »«·« ¬„œ‰ (RDY/Call Ready) Ê ”Å” ÅÌ‰ê AT
    
    while (waited < 20000) {
        if (read_serial_response(resp, sizeof(resp), 800, "RDY") ||
            read_serial_response(resp, sizeof(resp), 800, "Call Ready") ||
            read_serial_response(resp, sizeof(resp), 800, "SMS Ready")) {
            break;
        }
        waited += 800;
    }

    // ÅÌ‰ê ‰Â«ÌÌ
    uart_flush0(); send_at_command("AT\r");
    if (read_serial_response(resp, sizeof(resp), 1200, "OK")) {
        return 1;  // „Ê›ﬁ
    }

    // »⁄÷Ì „«éÊ·ùÂ« ò„Ì œÌ— AT „ÌùÅ–Ì—‰œ
    delay_ms(1500);
    uart_flush0(); send_at_command("AT\r");
    return read_serial_response(resp, sizeof(resp), 1200, "OK") ? 1 : 0;
}



// ’»— „Ìùò‰œ  « CREG=1 ‘Êœ. «ê— „Ê›ﬁ ‘œ 1 »—„Ìùê—œ«‰œ.
unsigned char wait_for_register_home(void)
{
    char line1[24], line2[24];
    int stat;
    unsigned char csq;

    for (;;) {
        stat = get_creg_stat();
        csq  = get_csq();

        // ‰„«Ì‘ Ê÷⁄Ì  ›⁄·Ì
        sprintf(line1, "REG=%d %s", stat, creg_text(stat));
        glcd_outtextxy(0, 0, line1);

        sprintf(line2, "CSQ=%u", csq);
        glcd_outtextxy(0, 8, line2);

        // ›ﬁÿ «ê— œ— ‘»òÂ Home —ÃÌ” — ‘œ
        if (stat == 1) {
            glcd_outtextxy(0, 16, "Registered(Home)");
            return 1;
        } else {
            glcd_outtextxy(0, 16, "Waiting...      ");
            delay_ms(1000);
        }
    }
}


// ›ﬁÿ „‰ Ÿ— „Ìù„Ê‰Â  « CSQ >= min_csq »‘Â (0..31). dBm „Õ«”»Â/‰„«Ì‘ ‰„Ìù‘Êœ.
// ⁄œœ Œ«„ ”Ìê‰«· (0..31) Ì« 99 «ê— ‰«„‘Œ’
unsigned char get_csq(void)
{
    char resp[256];
    int rssi = 99;

    uart_flush0();
    send_at_command("AT+CSQ\r");                 // Õ „« \r »›—” 
    if (read_serial_response(resp, sizeof(resp), 1500, "OK")) {  //  « ¬Œ— ÃÊ«»
        char *p = strstr(resp, "+CSQ:");
        if (p) {
            // ›—„ : "+CSQ: <rssi>,<ber>"
            if (sscanf(p, "+CSQ: %d", &rssi) != 1) rssi = 99;
        }
    }
    return (rssi >= 0 && rssi <= 31) ? (unsigned char)rssi : 99;
}

unsigned char wait_csq_greater_than(unsigned char limit)
{
    char line[20];
    if (limit > 31) limit = 31;

    // Ìòù»«— Echo Œ«„Ê‘ («Œ Ì«—Ì)
    {
        char tmp[32];
        uart_flush0();
        send_at_command("ATE0\r");
        read_serial_response(tmp, sizeof(tmp), 400, "OK");
    }

    for (;;) {
        unsigned char s = get_csq();

        sprintf(line, "CSQ=%u          ", s);
        glcd_outtextxy(0, 0, line);

        if (s != 99 && s > limit) {      // œﬁÌﬁ« »“—êù — «“ Õœ
            glcd_outtextxy(0, 8, "Signal OK       ");
            return 1;
        } else {
            glcd_outtextxy(0, 8, "Waiting...      ");
            delay_ms(700);
        }
    }
}


void main(void)
{

    GLCDINIT_t glcd_init_data;
    unsigned char s;
    char buf[16];

    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (1<<PORTD1) | (0<<PORTD0);

    DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
    PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

    DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
    PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

    DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
    PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

    // Timer Period: 32.768 ms
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0=0x00;

    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    OCR1CH=0x00;
    OCR1CL=0x00;

    TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;


    TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
    TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
    TCNT3H=0x00;
    TCNT3L=0x00;
    ICR3H=0x00;
    ICR3L=0x00;
    OCR3AH=0x00;
    OCR3AL=0x00;
    OCR3BH=0x00;
    OCR3BL=0x00;
    OCR3CH=0x00;
    OCR3CL=0x00;

    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

    EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
    EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
    EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);

    UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
    UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
    UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
    UBRR0H=0x00;
    UBRR0L=0x33;

    UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
    SFIOR=(0<<ACME);

    ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

    MCUCSR = (1 << JTD);
    MCUCSR = (1 << JTD);

    glcd_init_data.font=font5x7;
    glcd_init_data.readxmem=NULL;
    glcd_init_data.writexmem=NULL;
    glcd_init(&glcd_init_data);
    glcd_setfont(font5x7);

    // Global enable interrupts
    #asm("sei")

    glcd_clear();
    glcd_outtextxy(0, 0, "Module Init...");
    delay_ms(500);
    // --- «Ì‰Ã«” : —Ì”  Ê ’»—  « ¬„«œÂù‘œ‰ „«éÊ· ---
    sim800_restart();
    delay_ms(500); 
//    uart_flush0(); 
//    send_at_command("ATE0\r");


    // if (wait_for_register_home()) {
    //     glcd_outtextxy(0, 24, "Go next steps...");
    // }

    // s = get_csq();
    // glcd_clear();
    // sprintf(buf, "CSQ=%u", s);
    // glcd_outtextxy(0, 0, buf);   
    // delay_ms(1000);

    // wait_csq_greater_than(5);

      
    // send_at_command("ATE0");
    // delay_ms(100);
    // send_at_command("AT");
    // delay_ms(100);

    // if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
    // if (!init_GPRS()) { glcd_outtextxy(0, 10, "GPRS Init Failed!"); while(1); }



    glcd_clear();
    draw_bitmap(0, 0, shomare_soton_ra_payamak, 128, 64);

    while (1){
        process_uart_data();
        if (sms_received) {
            handle_sms();        // ECE?? ?? header_buffer ? content_buffer ?C ??C?O ???I?I
        }
    }
}