#include <mega64a.h>
#include <delay.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <string.h>


#define APN_MOD "mcinet"
#define SERVER_URL "http://google.com/api/authorize" // AI?? IP ???? O?C

// »«›— »—«Ì œ—Ì«›  œ«œÂ «“ „«éÊ·
char header_buffer[100];
char content_buffer[100];
char ip_address_buffer[16];
// »«›— »—«Ì ‘„«—Â  ·›‰ «” Œ—«Ã ‘œÂ
char phone_number[16];
// »«›— »—«Ì ŒÊ«‰œ‰ Å«”Œ Â«Ì „«éÊ·
char response_buffer[100];

//// --- E???? ???E ? ??? ??E?? ---
#define MOTOR_DDR DDRE
#define MOTOR_PORT PORTE
#define MOTOR_PIN_1 2
#define MOTOR_PIN_2 3
#define MOTOR_PIN_3 4
#define MOTOR_PIN_4 5


// E???? ???E C E?C? ????I
#define KEYPAD_PORT PORTC
#define KEYPAD_DDR DDRC
#define KEYPAD_PIN PINC

// E???? ?????C? ?E?? (I????)
#define COL1_PIN 0
#define COL2_PIN 1
#define COL3_PIN 2

// E???? ?????C? ??? (???I?) - E? ???E ?C??EE
#define ROW1_PIN 7
#define ROW2_PIN 5
#define ROW3_PIN 6
#define ROW4_PIN 4



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






//  «»⁄ ”«œÂ »—«Ì «—”«· œ” Ê—«  AT
void send_at_command(char *command)
{
    printf("%s\r\n", command);
}

unsigned char init_sms(void)
{
    glcd_clear();
    glcd_outtextxy(0, 0, "Setting SMS Mode...");
    send_at_command("AT+CMGF=1");
    delay_ms(500);

    send_at_command("AT+CNMI=2,2,0,0,0");
    delay_ms(500);

    send_at_command("AT+CMGDA=\"DEL ALL\"");
    delay_ms(2000);

    glcd_outtextxy(0, 10, "SMS Ready.");
    delay_ms(1000);
    return 1;
}


unsigned char init_GPRS(void)
{
    char at_command[50];
    glcd_clear();
    glcd_outtextxy(0, 0, "Setting GPRS Mode...");
    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
    delay_ms(1500);


    //  ‰ŸÌ„ APN »« „ﬁœ«—  ⁄—Ì› ‘œÂ œ— APN_MOD
    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN_MOD);
    send_at_command(at_command);
    delay_ms(1500);

    send_at_command("AT+SAPBR=1,1");
    delay_ms(3000);

    send_at_command("AT+SAPBR=2,1");
    delay_ms(1500);

    glcd_outtextxy(0, 10, "IP:");
//    glcd_outtextxy(10, 40, motor_msg);
    delay_ms(1000);
    return 1;
}

//unsigned char init_GPRS(void)
//{
//    char at_command[50];
//    char response_buffer[100]; // »«›—Ì »—«Ì ŒÊ«‰œ‰ Å«”ŒùÂ«Ì „«éÊ·
//    int timeout = 0;
//
//    glcd_clear();
//    glcd_outtextxy(0, 0, "Setting GPRS Mode...");
//    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
//    delay_ms(1500);
//
//    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN_MOD);
//    send_at_command(at_command);
//    delay_ms(1500);
//
//    send_at_command("AT+SAPBR=1,1"); // « ’«· »Â GPRS
//    delay_ms(3000);
//
//    // --- »Œ‘ ÃœÌœ »—«Ì œ—Ì«›  Ê ‰„«Ì‘ IP ---
//    glcd_clear();
//    glcd_outtextxy(0, 0, "Fetching IP Address...");
//    send_at_command("AT+SAPBR=2,1"); // «—”«· œ” Ê— œ—ŒÊ«”  IP
//
//    // „‰ Ÿ— Å«”Œ „Ìù„«‰Ì„ Ê ¬‰ —« „ÌùŒÊ«‰Ì„
//    while(timeout < 100) // ÕœÊœ 5 À«‰ÌÂ »—«Ì œ—Ì«›  Å«”Œ ’»— ò‰
//    {
//        glcd_outtextxy(0, 10, "level1");
//        delay_ms(10);
//        if (gets(response_buffer, sizeof(response_buffer)))
//        {
//            // »——”Ì „Ìùò‰Ì„ òÂ ¬Ì« «Ì‰ Â„«‰ Œÿ Å«”Œ Õ«ÊÌ IP «”  Ì« ‰Â
//            // Å«”Œ „Ê›ﬁÌ ù¬„Ì“ ‘»ÌÂ »Â «Ì‰ «” : +SAPBR: 1,1,"10.150.80.75" 
//            glcd_outtextxy(0, 10, "level2");
//            delay_ms(100);
//            if (strstr(response_buffer, "+SAPBR: 1,1,") != NULL)
//            {
//                char* token;
//
//                // »« «” ›«œÂ «“ strtok° —‘ Â —« »— «”«” ò«—«ò — " Ãœ« „Ìùò‰Ì„
//                token = strtok(response_buffer, "\""); // «Ì‰ »Œ‘ «Ê· —‘ Â «” 
//                token = strtok(NULL, "\"");           // «Ì‰  Êò‰ œÊ„° Ì⁄‰Ì Â„«‰ IP «” 
//                glcd_outtextxy(0, 10, "level3");
//                delay_ms(10);
//                if (token)
//                {
//                    strcpy(ip_address_buffer, token); // IP —« œ— »«›— òÅÌ „Ìùò‰Ì„
//
//                    glcd_clear();
//                    glcd_outtextxy(0, 10, "GPRS Connected!");
//                    glcd_outtextxy(0, 25, "IP:");
//                    glcd_outtextxy(20, 25, ip_address_buffer); // ‰„«Ì‘ IP —ÊÌ GLCD
//
//                    delay_ms(1000); // 3 À«‰ÌÂ IP —« ‰„«Ì‘ »œÂ
//                    return 1; // „ﬁœ«—œÂÌ GPRS „Ê›ﬁ »Êœ
//                }
//            }
//        }
//        delay_ms(1);
//        timeout++;
//    }
//
//    // «ê— »⁄œ «“ 5 À«‰ÌÂ Å«”ŒÌ œ—Ì«›  ‰‘œ
//    glcd_clear();
//    glcd_outtextxy(0, 20, "Failed to get IP!");
//    delay_ms(2000);
//    return 0; // „ﬁœ«—œÂÌ GPRS ‰«„Ê›ﬁ »Êœ
//}
//  

void activate_motor(int product_id)
{
    unsigned char motor_pin;
    char motor_msg[20];

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
    delay_ms(10000);
    MOTOR_PORT &= ~(1 << motor_pin);

    sprintf(motor_msg, "MOTOR %d OFF!", product_id);
    glcd_outtextxy(10, 40, motor_msg);
    delay_ms(2000);
}

unsigned char check_authorization(char* number)
{
    char at_command[150];
    int timeout = 0;

    glcd_clear();
    glcd_outtextxy(0, 0, "Authorizing...");
    glcd_outtextxy(0, 10, number);

    // 1. „ﬁœ«—œÂÌ «Ê·ÌÂ ”—ÊÌ” HTTP
    send_at_command("AT+HTTPINIT");
    delay_ms(1000);

    // 2.  ‰ŸÌ„ Å«—«„ —Â«Ì HTTP (CID Ê URL)
    send_at_command("AT+HTTPPARA=\"CID\",1");
    delay_ms(500);

    // ”«Œ  URL ‰Â«ÌÌ »Â Â„—«Â ‘„«—Â  ·›‰
    sprintf(at_command, "AT+HTTPPARA=\"URL\",\"%s?phone=%s\"", SERVER_URL, number);
    send_at_command(at_command);
    delay_ms(1000);

    // 3. «—”«· œ—ŒÊ«”  GET (Action = 0)
    send_at_command("AT+HTTPACTION=0");
    delay_ms(1000); // ò„Ì “„«‰ »—«Ì ‘—Ê⁄ ⁄„·Ì« 

    // 4. „‰ Ÿ— Å«”Œ »„«‰
    // Å«”Œ »«Ìœ çÌ“Ì ‘»ÌÂ »Â "+HTTPACTION: 0,200,LENGTH" »«‘œ
//    while(timeout < 50) // Õœ«òÀ— 10 À«‰ÌÂ „‰ Ÿ— »„«‰
//    {
//        if (gets(response_buffer, sizeof(response_buffer)))
//        {
//            // »——”Ì „Ìùò‰Ì„ òÂ ¬Ì« Å«”Œ „Ê›ﬁÌ ù¬„Ì“ (òœ 200) «”  Ì« ‰Â
//            if (strstr(response_buffer, "+HTTPACTION: 0,404") != NULL)
//            {
//                glcd_outtextxy(0, 30, "Authorized!");
//                delay_ms(1500);
//                send_at_command("AT+HTTPTERM"); // Œ« „Â œ«œ‰ »Â ”—ÊÌ” HTTP
//                return 1; // „ÃÊ“  «ÌÌœ ‘œ
//            }
//            // «ê— Œÿ«Ì Œ«’Ì —Œ œ«œÂ »«‘œ
//            else if (strstr(response_buffer, "+HTTPACTION: 0,") != NULL)
//            {
//                break; // «“ Õ·ﬁÂ Œ«—Ã ‘Ê çÊ‰ Å«”Œ œ—Ì«›  ‘œÂ «„« 200 ‰Ì” 
//            }
//            glcd_clear();
//            glcd_outtextxy(0, 0, "not");
//        }
//        delay_ms(10);
//        timeout += 10;
//    }

    // «ê— »Â «Ì‰Ã« —”ÌœÌ„ Ì⁄‰Ì Ì«  «Ì„ù«Ê  ‘œÂ Ì« Å«”Œ 200 ‰»ÊœÂ
    glcd_clear();
    glcd_outtextxy(5, 25, "Authorization Failed!");
    delay_ms(1000);
    send_at_command("AT+HTTPTERM"); // Œ« „Â œ«œ‰ »Â ”—ÊÌ” HTTP
//    return 0; // „ÃÊ“ —œ ‘œ
    return 1;
}

void main(void)
{
    GLCDINIT_t glcd_init_data;

    // --- «Ì‰ »Œ‘ „ﬁœ«—œÂÌ «Ê·ÌÂ ÅÊ— ùÂ« Ê USART «”  òÂ «“ òœ ŒÊœ «‰ òÅÌ ‘œÂ ---
    // --- Ê ’ÕÌÕ «” . ‰Ì«“Ì »Â  €ÌÌ— ¬‰ ‰Ì” .                             ---
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
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
    // --- Å«Ì«‰ »Œ‘ „ﬁœ«—œÂÌ «Ê·ÌÂ ---

 glcd_clear();
    glcd_outtextxy(0, 0, "Module Init...");
    delay_ms(1000);

    send_at_command("ATE0");
    delay_ms(500);
    send_at_command("AT");
    delay_ms(500);

    if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
    if (!init_GPRS()) { glcd_outtextxy(0, 10, "GPRS Init Failed!"); while(1); }

    glcd_clear();
    glcd_outtextxy(0, 0, "System Ready.");
    glcd_outtextxy(0, 10, "Waiting for SMS...");

    while (1)
    {
        char sms_char;
        char key_pressed;
        char display_buffer[2] = {0};
        int product_id = 0;

        memset(header_buffer, 0, sizeof(header_buffer));

        if (gets(header_buffer, sizeof(header_buffer)))
        {
            // çò ò‰ òÂ ¬Ì« «Ì‰ Œÿ° Â„«‰ Âœ— ÅÌ«„ò «” ø
            if (strstr(header_buffer, "+CMT:") != NULL)
            {
                char* token;

                // «” Œ—«Ã ‘„«—Â  ·›‰ «“ Âœ—
                // ›—„  Âœ—: +CMT: "PHONE_NUMBER","","TIMESTAMP"
                token = strtok(header_buffer, "\""); // »Œ‘ «Ê· ﬁ»· «“ "
                if (token != NULL) {
                    token = strtok(NULL, "\""); // «Ì‰  Êò‰ Â„«‰ ‘„«—Â  ·›‰ «” 
                    if (token != NULL) {
                        strcpy(phone_number, token);

                        // ===== »Œ‘ ÃœÌœ: »——”Ì „ÃÊ“ =====
                        if (check_authorization(phone_number))
                        {
                            // „ÃÊ“  «ÌÌœ ‘œ° Õ«·« «œ«„Â „‰ÿﬁ ﬁ»·Ì —« «Ã—« ò‰
                            memset(content_buffer, 0, sizeof(content_buffer));
                            gets(content_buffer, sizeof(content_buffer)); // „Õ Ê«Ì ÅÌ«„ò —« »ŒÊ«‰

                            if (strlen(content_buffer) > 0)
                            {
                                sms_char = content_buffer[0];
                                

                                if (sms_char == '1' || sms_char == '2' || sms_char == '3')
                                {
                                    int timeout_counter = 0;
                                    glcd_clear();
                                    glcd_outtextxy(0, 5, "SMS Code:");
                                    display_buffer[0] = sms_char;
                                    glcd_outtextxy(70, 5, display_buffer);
                                    glcd_outtextxy(0, 25, "Enter code on keypad:");
                                    
                                    for(timeout_counter = 0; timeout_counter < 200; timeout_counter++)
                                    {
                                       key_pressed = get_key();
                                       if(key_pressed != 0) break; // «ê— ò·ÌœÌ ›‘—œÂ ‘œ° «“ Õ·ﬁÂ Œ«—Ã ‘Ê
                                       delay_ms(10);
                                    }

                                    // «ê— Å” «“ ? À«‰ÌÂ ò·ÌœÌ ›‘—œÂ ‰‘œ
                                    if(key_pressed == 0) {
                                        glcd_clear();
                                        glcd_outtextxy(10, 25, "Timeout! Try again.");
                                        delay_ms(1000);
                                        glcd_clear();
                                        glcd_outtextxy(0, 0, "System Ready.");
                                        glcd_outtextxy(0, 10, "Waiting for SMS...");
                                        continue; // »—‰«„Â —« »Â «» œ«Ì Õ·ﬁÂ while(1) »—ê—œ«‰
                                    }

                                    glcd_outtextxy(0, 45, "You pressed:");
                                    display_buffer[0] = key_pressed;
                                    glcd_outtextxy(90, 45, display_buffer);
                                    delay_ms(1000);

                                    if (key_pressed == sms_char)
                                    {
                                        glcd_clear();
                                        glcd_outtextxy(10, 25, "Code is CORRECT!");
                                        delay_ms(1500);
                                        product_id = sms_char - '0';
                                        activate_motor(product_id);
                                    }
                                    else
                                    {
                                        glcd_clear();
                                        glcd_outtextxy(5, 25, "Error in entry!");
                                        delay_ms(2000);
                                    }
                                }
                                else
                                {
                                   glcd_clear();
                                   glcd_outtextxy(5, 25, "SMS code is invalid!");
                                   delay_ms(2000);
                                }
                            }
                        }
                        // «ê— „ÃÊ“  «ÌÌœ ‰‘Êœ°  «»⁄ check_authorization ÅÌ«„ Œÿ« ‰„«Ì‘ œ«œÂ
                        // Ê »—‰«„Â »Â ’Ê—  ŒÊœò«— »Â Õ«·  «‰ Ÿ«— »«“ „Ìùê—œœ.
                    }
                }

                // ’›ÕÂ —« »—«Ì ÅÌ«„ »⁄œÌ ¬„«œÂ ò‰
                glcd_clear();
                glcd_outtextxy(0, 0, "System Ready.");
                glcd_outtextxy(0, 10, "Waiting for SMS...");
            }
        }
    }
}

