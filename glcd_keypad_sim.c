#include <mega64a.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h> // E?C? C?E?CI? C? ECE? atoi
//#include <stdint.h>
#include "bitmaps.h"

typedef unsigned char uint8_t;
typedef unsigned int  uint16_t;
typedef signed char   int8_t;


#define glcd_pixel(x, y, color) glcd_setpixel(x, y)



// #define F_CPU 8000000UL
#include <delay.h>

// --- E?U??CE C??? ---
#define APN "mcinet" // APN C??CE?? I?I ?C ?C?I ???I
//#define SERVER_URL "http://google.com/api/authorize" // AI?? ?C?? ???? I?I ?C C???C ??C? I??I
#define SERVER_URL_POST "http://193.5.44.191/home/post/"

#define HTTP_TIMEOUT_MS 500

#define read_flash_byte(p) (*(p))

// --- EC???C? ??C??? ---
char header_buffer[100];
char content_buffer[100];
char ip_address_buffer[16];
char phone_number[16];
char response_buffer[256]; // C??C?O ?C?? EC?? E?C? I??C?E ?C?I??C? HTTP

// --- E???? ?????C? ??E?? ---
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





// ECE? C??C? I?E?? AT E? ?C???
void send_at_command(char *command)
{
    printf("%s\r\n", command);
}

unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, char* expected_response) {
    int i = 0;
    unsigned int timeout_counter = 0;
    char c;

    // Clear the buffer at the start
    memset(buffer, 0, buffer_size);

    // Loop until the timeout period is reached
    while (timeout_counter < timeout_ms) {
        // This is the correct way to check if a character has been received on USART0
        if (UCSR0A & (1 << RXC0)) {
            c = getchar(); // Read the character from the buffer
            if (i < (buffer_size - 1)) {
                buffer[i++] = c; // Add it to our response buffer
            }
            // Optional: You can reset the timeout counter each time a character is received
            // to wait for the *entire* message to finish. For simplicity, we'll use a fixed timeout.
        } else {
            // If no character is waiting, wait 1ms and increment the counter
            delay_ms(1);
            timeout_counter++;
        }
    }

    // After the loop finishes, check if the expected text exists in the buffer
    if (strstr(buffer, expected_response) != NULL) {
        return 1; // Success!
    }

    return 0; // Failed to find the response
}


void usart_puts(const char* str)
{
    while (*str)
    {
        putchar(*str++); // 'usart_putchar' is your function to send a single byte
    }
}




unsigned char init_sms(void)
{
    glcd_clear();
    glcd_outtextxy(0, 0, "Setting SMS Mode...");
    send_at_command("AT+CMGF=1");
    delay_ms(50);

    send_at_command("AT+CNMI=2,2,0,0,0");
    delay_ms(50);

    send_at_command("AT+CMGDA=\"DEL ALL\"");
    delay_ms(100);


    // C????C? C? ??C? E?I? ?C?? ?C??? ? U????C? E?I? sleep
    send_at_command("AT+CFUN=1");    // ??C???C?? ?C?? ?C???
    delay_ms(50);
    send_at_command("AT+CSCLK=0");   // U????C???C?? ?C?E sleep
    delay_ms(50);

    glcd_outtextxy(0, 10, "SMS Ready.");
    delay_ms(100);
    return 1;
}


unsigned char init_GPRS(void)
{
    char at_command[50];
    char response[100]; // Local buffer for the response

    glcd_clear();
    glcd_outtextxy(0, 0, "Connecting to GPRS...");


    // 1?? ÍÊãÇð ÍÇáÊ ÎæÇÈ ÑÇ ÛíÑÝÚÇá ˜ä (ÍÊí ÇÑ ÏÑ SMS ÊäÙíã ÔÏå)
    send_at_command("AT+CSCLK=0");   // ÖÑæÑí ÈÑÇí ÌáæíÑí ÇÒ ÞØÚí GPRS
    delay_ms(50);

    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(100);

    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
    send_at_command(at_command);
    delay_ms(100);


    // ?? ÇÖÇÝå ˜ÑÏä Çíä ÎØ ÍíÇÊí ÇÓÊ: ÛíÑÝÚÇá ˜ÑÏä Idle Timeout
    send_at_command("AT+SAPBR=3,1,\"Idle Timeout\",\"0\""); 
    delay_ms(100);

    // 3?? ÝÚÇáÓÇÒí Keep-Alive ÈÑÇí ÇÑÓÇá ˜íÊåÇí ÊÓÊ ÏæÑåÇí
    send_at_command("AT+CIPKEEPALIVE=1"); // ÇÑÓÇá ˜íÊ åÑ 20 ËÇäíå
    delay_ms(50);

    // 4?? ÇØãíäÇä ÇÒ ËÈÊäÇã ÎæÏ˜ÇÑ ÏÑ ÔÈ˜å (ÖÑæÑí ÈÑÇí Ñí˜Çä˜Ê ÎæÏ˜ÇÑ)
    send_at_command("AT+CGREG=1"); // ÒÇÑÔ æÖÚíÊ GPRS
    delay_ms(50);


    send_at_command("AT+SAPBR=1,1");
    delay_ms(100);

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


unsigned char active_GPRS(void)
{
    char at_command[50];
    char response[100]; // Local buffer for the response

    //glcd_clear();
    //glcd_outtextxy(0, 0, "Connecting to GPRS...");

    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(100);

    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
    send_at_command(at_command);
    delay_ms(100);

    send_at_command("AT+SAPBR=1,1");
    delay_ms(100);

    //glcd_clear();
    //glcd_outtextxy(0, 0, "Fetching IP...");
    send_at_command("AT+SAPBR=2,1"); // Request IP
    // delay_ms(5000);
    
    // Attempt to read the response for 5 seconds, looking for "+SAPBR:"
    // FIX: Added the 4th argument, "+SAPBR:", to the function call.
//    if (read_serial_response(response, sizeof(response), 200, "+SAPBR:")) {
//        //glcd_outtextxy(0, 10, "Resp:");
//        //glcd_outtextxy(0, 20, response); // Display the received response for debugging
//        //delay_ms(200);
//
//        // Check if the response contains the IP address part
//        if (strstr(response, "+SAPBR: 1,1,") != NULL) {
//            char* token = strtok(response, "\"");
//            token = strtok(NULL, "\"");
//
//            if (token) {
//                strcpy(ip_address_buffer, token);
//                return 1; // Success
//            }
//        }
//    }

    // If we reach here, it means getting the IP address failed
    return 0; // Failure
}




unsigned char check_and_activate_GPRS(void) {
    char response[100];
    
    // 1. Check if GPRS is already active
    send_at_command("AT+SAPBR=2,1");
    if (read_serial_response(response, sizeof(response), 1000, "+SAPBR: 1,1")) {
        return 1; // GPRS is already active
    }
    
    // 2. If not active, try to activate it
    if (!active_GPRS()) {
        // Failed to activate GPRS
        glcd_clear();
        glcd_outtextxy(0, 0, "GPRS Activation");
        glcd_outtextxy(0, 10, "Failed!");
        delay_ms(1000);
        return 0;
    }
    
    return 1; // GPRS activated successfully
}




unsigned char send_json_post(const char* base_url, const char* phone_number) {
    char cmd[256];
    char response[256];
    char full_url[256];    
    char* action_ptr;
    int method = 0, status_code = 0, data_len = 0;  
    
    

    glcd_clear();
    draw_bitmap(0, 0, lotfan_montazer_bemanid, 128, 64);
    
    
    if (!check_and_activate_GPRS()) {
        return 0;
    }
    
 
//    glcd_clear();
//    glcd_outtextxy(0,10,phone_number);
//    glcd_outtextxy(0,20,"lev 0");
   
    // 1. Initialize HTTP service
    send_at_command("AT+HTTPINIT");
    if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;

//    glcd_clear();
//    glcd_outtextxy(0,10,phone_number);
//    glcd_outtextxy(0,20,"lev 1");

    // 2. Set CID to bearer profile 1
    send_at_command("AT+HTTPPARA=\"CID\",1");
    if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;

//    glcd_outtextxy(0,20,"lev 2");

    // 3. Build the full URL with query parameter
    sprintf(full_url, "%s?phone_number=%s", base_url, phone_number);

    // 4. Set the target URL
    sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", full_url);
    send_at_command(cmd);
    if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;

//    glcd_outtextxy(0,20,"lev 3");

    // 5. Start POST action
    send_at_command("AT+HTTPACTION=1");
    if (!read_serial_response(response, sizeof(response), HTTP_TIMEOUT_MS, "+HTTPACTION:")) {
        glcd_clear();
        glcd_outtextxy(0,0,"No Action Resp");
        delay_ms(100);
        return 0;
    }

//    glcd_outtextxy(0,20,"lev 4");

    // 6. Parse status code from response

    action_ptr = strstr(response, "+HTTPACTION:");
    if (action_ptr == NULL || sscanf(action_ptr, "+HTTPACTION: %d,%d,%d", &method, &status_code, &data_len) != 3) {
//        glcd_clear();
//        glcd_outtextxy(0,0,"Parse Err");
//        glcd_outtextxy(0,10,response);  // ??C?O ??E?C? response ?C?? E?C? I?EC?
//        delay_ms(500);
        return 0;
    }
    
//    glcd_outtextxy(0,20,"lev 5");
    //delay_ms(200);
    // 7. Show response based on status
//    glcd_clear();
//    glcd_outtextxy(0,0,"HTTP Status:");
//    if (status_code == 200) {
//        glcd_outtextxy(0,10,"OK");
//    } else {
//        glcd_outtextxy(0,10,"Not OK");
//    }             
    //delay_ms(200);
//    glcd_outtextxy(0,20,"lev 6");

    // 8. Read server response if needed
    send_at_command("AT+HTTPREAD");
    read_serial_response(response, sizeof(response), 100, "OK");

//    glcd_outtextxy(0,20,"lev 7");

    // 9. Terminate HTTP service
    send_at_command("AT+HTTPTERM");
    read_serial_response(response, sizeof(response), 100, "OK");
                                                                   
//    glcd_outtextxy(0,20,"lev 8");
    return (status_code == 200) ? 1 : 0;
}

///////////////////////////////////////////////////////////////////////////////////////////

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
    int timeout = 5000;

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
    
//    while (!(PIND & (1 << PIND1)) && timeout > 0)
//    {
//        delay_ms(1);
//        timeout--;
//    }    

    while ((PIND & (1 << PIND1)) && timeout > 0)
    {
        delay_ms(1);
        timeout--;
    }
 
    MOTOR_PORT &= ~(1 << motor_pin);

//    sprintf(motor_msg, "MOTOR %d OFF!", product_id);
//    glcd_outtextxy(10, 40, motor_msg);
    draw_bitmap(0, 0, mahsol_ra_bardarid, 128, 64);
    delay_ms(300);
}

///////////////////////////////////////////////////////////////////////////////////

void main(void)
{
    const char* server_url = "http://193.5.44.191/home/post/";
    // const char* my_phone    = "+989152608582";
    
    GLCDINIT_t glcd_init_data;

    // --- C?? EIO ??IC?I?? C???? ???E??C ? USART C?E ?? C? ?I I?IEC? ??? OI? ---
    // --- ? ???? C?E. ??C?? E? EU??? A? ???E.                             ---
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
    
    DDRD = (0 << DDD7) | (0 << DDD6) | (0 << DDD5) | (0 << DDD4) | (0 << DDD3) | (0 << DDD2) | (0 << DDD1) | (0 << DDD0);  // ??? ???I?
    PORTD = (0 << PORTD7) | (0 << PORTD6) | (0 << PORTD5) | (0 << PORTD4) | (0 << PORTD3) | (0 << PORTD2) | (1 << PORTD1) | (0 << PORTD0); // Pull-down (???? U????C? ??I? pull-up)    
      
    DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
    PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
    DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
    PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
    UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
    UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
    UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
    UBRR0H=0x00;
    UBRR0L=0x33; // 9600 Baud Rate for 8MHz clock
    MCUCSR = (1 << JTD);
    MCUCSR = (1 << JTD);
    glcd_init_data.font=font5x7;
    glcd_init_data.readxmem=NULL;
    glcd_init_data.writexmem=NULL;
    glcd_init(&glcd_init_data);
    glcd_setfont(font5x7);
    // --- ?C?C? EIO ??IC?I?? C???? ---

    glcd_clear();
    glcd_outtextxy(0, 0, "Module Init...");
    delay_ms(3000);

    send_at_command("ATE0");
    delay_ms(200);
    send_at_command("AT");
    delay_ms(200);

    if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
    if (!init_GPRS()) { glcd_outtextxy(0, 10, "GPRS Init Failed!"); while(1); }

    
//    glcd_clear();
//    draw_bitmap(0, 0, adad_ra_vared_namaeid, 128, 64);
//    delay_ms(500); 


    glcd_clear();
    draw_bitmap(0, 0, shomare_soton_ra_payamak, 128, 64);


    while (1)
    {
        char sms_char;
        char key_pressed;
        char display_buffer[2] = {0};
        int product_id = 0;
        int timeout_counter = 0;
        char* token;

        char content_buffer[32];
        memset(header_buffer, 0, sizeof(header_buffer));
        memset(content_buffer, 0, sizeof(content_buffer));

        if (gets(header_buffer, sizeof(header_buffer)))
        {
            if (strstr(header_buffer, "+CMT:") != NULL)
            {
                // ?? ???C? ?E? ??C?? ?? EI?? ? ??? IC?
                if (!gets(content_buffer, sizeof(content_buffer))) {
                    glcd_clear();
                    glcd_outtextxy(0, 0, "Failed to read msg");
                    delay_ms(1000);
                    continue;
                }

                // ?? O?C?? E??? ?? E???
                token = strtok(header_buffer, "\"");
                if (token != NULL) token = strtok(NULL, "\"");
                if (token != NULL)
                ///////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////
                {
                    strcpy(phone_number, token);
                    sms_char = content_buffer[0];  // ?E?C '1'

                    if (sms_char == '1' || sms_char == '2' || sms_char == '3')
                    {
                    // if (send_json_post(server_url, phone_number))
                    // {
//                        glcd_clear();
//                        glcd_outtextxy(0, 5, "step 1");
//                        delay_ms(200);

                        // sms_char = content_buffer[0];  // ?E?C '1'

//                        glcd_outtextxy(0, 5, "step 2");
//                        delay_ms(200);

                        if (send_json_post(server_url, phone_number))
                        {
                            glcd_clear();
//                            glcd_outtextxy(0, 5, "SMS Code:");
                            draw_bitmap(0, 0, square, 128, 32);
                            display_buffer[0] = sms_char;
                            glcd_outtextxy(65, 10, display_buffer);
//                            glcd_outtextxy(0, 25, "Enter code on keypad:");
                            draw_bitmap(0, 20, adad_ra_vared_namaeid, 128, 64);

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
//                                glcd_outtextxy(0, 45, "You pressed:");
                                //draw_bitmap(70, 45, square, 128, 32);
                                draw_bitmap(65, 0, square, 128, 32);
                                display_buffer[0] = key_pressed;
                                glcd_outtextxy(65, 50, display_buffer);
                                
                                delay_ms(200);

                                if (key_pressed == sms_char)
                                {
                                    glcd_clear(); 
//                                    draw_bitmap(0, 0, adad_ra_vared_namaeid, 128, 64);
                                    //glcd_outtextxy(10, 25, "Code is CORRECT!");
                                    //draw_bitmap(0, 0, shomare_soton_dorost_vared_nashode, 128, 32);
                                    //delay_ms(300);
                                    product_id = sms_char - '0';
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



//                     else
//                     {
//                         glcd_clear();
// //                        glcd_outtextxy(0, 25, "You are not authorized!");
//                         draw_bitmap(0, 0, tedad_bish_az_had, 128, 64);
//                         delay_ms(300);
//                     }
                    else
                    {
                        glcd_clear();
//                            glcd_outtextxy(5, 25, "Invalid SMS Code!");
                        draw_bitmap(0, 0, shomare_dorost_payamak_nashode, 128, 64);
                        delay_ms(300);
                    }
                }
                ///////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////
                // EC??OE E? ????E A?CI??E???C?
                glcd_clear();
                draw_bitmap(0, 0, shomare_soton_ra_payamak, 128, 64);
//                glcd_outtextxy(0, 0, "System Ready.");
//                glcd_outtextxy(0, 10, "Waiting for SMS...");

            }
        }
    }
}