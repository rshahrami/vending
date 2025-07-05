#include <mega64a.h>
#include <delay.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <string.h> // E?C? ?C? EC ?OE???C
#include <stdlib.h> // E?C? E?CE? ???? ?C??I rand() ? atoi


// =================================================================
// ===== E?U??CE GPRS? ???? ? ?IE?C??C? (C?? EIO ?C ???C?O ???I) ===========
// =================================================================
#define APN "mtnirancell"
#define SERVER_URL "http://192.168.1.100:8080/api/data" // AI?? IP ???? O?C
//#define SERVER_PORT "8080" // O?C?? ???E ???? O?C
#define DEVICE_ID 1 // O?C?? ECEE I?E?C? O?C



// --- E???? ???E ? ??? ??E?? ---
#define MOTOR_DDR DDRE
#define MOTOR_PORT PORTE
#define MOTOR_PIN_1 2
#define MOTOR_PIN_2 3
#define MOTOR_PIN_3 4
#define MOTOR_PIN_4 5
// =================================================================

// ... (EIO EC???C? ??C???? E?C??? ????I ? E?CE? get_key, send_at_command, get_full_response EI?? EU???) ...
//char response_buffer[256];
char sender_number[20];
//char sms_content[100];
char formatted_phone_number[15]; // E?C? ?I??? O?C?? ??EC?? EI?? +98 ?C 0


//  €ÌÌ— «‰œ«“Â »«›—Â«
#define RESP_BUF_SIZE 512
char response_buffer[RESP_BUF_SIZE];

#define HEADER_BUF_SIZE 256
char header_copy[HEADER_BUF_SIZE];

#define SMS_CONTENT_SIZE 160
char sms_content[SMS_CONTENT_SIZE];

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

char pressed_key;

// ECE? E?C? I?C?I? ???I ?O?I? OI? (???? C??? ?E??)
char get_key(void)
{
unsigned char row, col;

// A?C????C?? E?C? ?I???E ?????C? ?C??EE
const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};

// A?C?? E?C? ??COE ?C?C?E??C? ????I
const char key_map[4][3] = {
{'1', '2', '3'},
{'4', '5', '6'},
{'7', '8', '9'},
{'*', '0', '#'}
};

// ???? C???: C??? ?E????C
for (col = 0; col < 3; col++)
{
// ??? ?E????C ?C ?? ??????? (?C E? ?C?E C??IC?? EC?C ???E???)
KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);

// ?E?? ???? ?C ??? ??????? EC ??C? O?I
KEYPAD_PORT &= ~(1 << column_pins[col]);

// ????C ?C E?C? EOI?? ???I ?O?I? OI? E???? ???????
for (row = 0; row < 4; row++)
{
// C?? ?? ??? ??? E? IC?? ?E?? ??C?? ??? OI? ECOI
if (!(KEYPAD_PIN & (1 << row_pins[row])))
{
// E?C? ??? ???? (Debouncing)
delay_ms(10);

// I?EC?? ?? ??????? EC C? ?O?I? ???I ????? O???
if (!(KEYPAD_PIN & (1 << row_pins[row])))
{
// ??EU? ????C??? EC ?C?E? I?E I?I ?C C? ??? ???I E?IC?I
while (!(KEYPAD_PIN & (1 << row_pins[row])));

// ?C?C?E? ??E??? ?C E??????IC???
return key_map[row][col];
}
}
}
}

// C?? ??? ???I? ?O?I? ?OI? E?I? ??IC? ??? (NULL) ?C E???IC?
return 0;
}


void send_at_command(char *command)
{
printf("%s\r\n", command);
}

void get_full_response(unsigned int timeout_ms)
{
    char line_buffer[128];
    unsigned long int counter = 0;
    memset(response_buffer, 0, sizeof(response_buffer));
    while(counter < timeout_ms)
    {
        if (gets(line_buffer, sizeof(line_buffer)))
        {
            strncat(response_buffer, line_buffer, sizeof(response_buffer) - strlen(response_buffer) - 1);
            strncat(response_buffer, "\n", sizeof(response_buffer) - strlen(response_buffer) - 1);

            // ‘—ÿ "+CMT:" «“ «Ì‰Ã« Õ–› ‘œÂ «” 
            if (strstr(line_buffer, "OK") || strstr(line_buffer, "ERROR") ||
                strstr(line_buffer, ">") || strstr(line_buffer, "DOWNLOAD") ||
                strstr(line_buffer, "SEND OK") || strstr(line_buffer, "CLOSE OK") ||
                strstr(line_buffer, "+HTTPACTION"))
            {
                break;
            }
        }
        delay_ms(1);
        counter++;
    }
}

// =================================================================================
// ===== E?CE? ?C??C?IC?? ?C??? ===================================================
// =================================================================================

// ECE? E?C? ?C??C?IC?? C???? ????? ??C??
unsigned char init_sms(void)
{
glcd_clear();
glcd_outtextxy(0, 0, "Setting SMS Mode...");
send_at_command("AT+CMGF=1");
get_full_response(1000);
if (strstr(response_buffer, "OK") == NULL) return 0;

send_at_command("AT+CNMI=2,2,0,0,0");
get_full_response(1000);
if (strstr(response_buffer, "OK") == NULL) return 0;

send_at_command("AT+CMGDA=\"DEL ALL\"");
get_full_response(5000);
if (strstr(response_buffer, "OK") == NULL) return 0;

glcd_outtextxy(0, 10, "SMS Ready.");
delay_ms(1000);
return 1;
}

// =================================================================================
// ===== E?CE? C??? ???? E??C?? ====================================================
// =================================================================================

// ECE? E?C? ??C???C?? ??E?? ??E?? E? ?????
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


// ECE? E?C? ?C???C?? O?C?? ??EC??
void format_phone_number(char* raw_number)
{
if (strncmp(raw_number, "+98", 3) == 0) strcpy(formatted_phone_number, raw_number + 3);
else if (raw_number[0] == '0') strcpy(formatted_phone_number, raw_number + 1);
else strcpy(formatted_phone_number, raw_number);
}

//////////////////////////////////////////////////////////////////////////////////////

void process_sms(void) {
    char header_copy[256];
    char *line1, *line2;
    char *token, *end_quote;
    int product_id;

    // »——”Ì «Ì‰òÂ ÅÌ«„ œ—Ì«› Ì ‘«„· +CMT: Â” 
    if (strstr(response_buffer, "+CMT:") != NULL) {
        // Ìò òÅÌ «“ »«›— »—«Ì Ãœ«”«“Ì ŒÿÊÿ œ—”  „Ìùò‰Ì„
        strncpy(header_copy, response_buffer, sizeof(header_copy) - 1);
        header_copy[sizeof(header_copy) - 1] = '\0';

        // Ãœ« ò—œ‰ ŒÿÊÿ »« «” ›«œÂ «“ \r\n
        line1 = strtok(header_copy, "\r\n"); // Œÿ «Ê·: +CMT: "‘„«—Â",," «—ÌŒ"
        line2 = strtok(NULL, "\r\n"); // Œÿ œÊ„: „ ‰ ÅÌ«„ò

        // «” Œ—«Ã ‘„«—Â ›—” ‰œÂ «“ Œÿ «Ê·
        if (line1) {
        token = strchr(line1, '"'); // ÅÌœ« ò—œ‰ «Ê·Ì‰ "
        if (token) {
        token++; // »⁄œ «“ "
        end_quote = strchr(token, '"'); //  « œÊ„Ì‰ "
        if (end_quote) {
        *end_quote = '\0'; // Å«Ì«‰ —‘ Â ‘„«—Â
        strcpy(sender_number, token); // –ŒÌ—Â ‘„«—Â ›—” ‰œÂ
        }
        }
        }

        // «” Œ—«Ã „ ‰ ÅÌ«„ò «“ Œÿ œÊ„
        if (line2) {
        strncpy(sms_content, line2, sizeof(sms_content) - 1);
        sms_content[sizeof(sms_content) - 1] = '\0';
        } else {
        sms_content[0] = '\0'; // «ê— Œÿ œÊ„ „ÊÃÊœ ‰»Êœ
        }

        // ‰„«Ì‘ œ— GLCD
        glcd_clear();
        glcd_outtextxy(0, 0, "Payamak Jadid:");
        glcd_outtextxy(0, 10, "From:");
        glcd_outtextxy(0, 20, sender_number);
        delay_ms(1000);

        glcd_clear();
        glcd_outtextxy(0, 0, "Mohtava:");
        glcd_outtextxy(0, 10, sms_content);
        delay_ms(5000);

        // Å—œ«“‘ „Õ Ê«Ì ÅÌ«„ò »Âù⁄‰Ê«‰ ⁄œœ
        product_id = atoi(sms_content);
        if (product_id >= 1 && product_id <= 3) {
        activate_motor(product_id);
        } else {
        glcd_clear();
        glcd_outtextxy(0, 10, "Adad Mo'tabar Nist!");
        delay_ms(2000);
        }

        // Õ–› ÅÌ«„ò ŒÊ«‰œÂù‘œÂ «“ Õ«›ŸÂ
        send_at_command("AT+CMGDA=\"DEL READ\"");
        get_full_response(2000);
    }
}




// =================================================================================
// ===== ECE? C??? E??C?? (main) ===================================================
// =============================================================================



void main(void)
{

    // Declare your local variables here
    // Variable used to store graphic display
    // controller initialization data
    GLCDINIT_t glcd_init_data;

    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    // Port B initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T
    PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=T Bit2=0 Bit1=0 Bit0=0
    PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

    // Port E initialization
    // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
    DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
    // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
    PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

    // Port F initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
    DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
    PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

    // Port G initialization
    // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
    DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
    // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
    PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    ASSR=0<<AS0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer1 Stopped
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // OC1C output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    // Compare C Match Interrupt: Off
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

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;

    // Timer/Counter 3 initialization
    // Clock source: System Clock
    // Clock value: Timer3 Stopped
    // Mode: Normal top=0xFFFF
    // OC3A output: Disconnected
    // OC3B output: Disconnected
    // OC3C output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer3 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    // Compare C Match Interrupt: Off
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

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
    ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    // INT3: Off
    // INT4: Off
    // INT5: Off
    // INT6: Off
    // INT7: Off
    EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
    EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
    EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);

    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud Rate: 9600
    UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
    UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
    UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
    UBRR0H=0x00;
    UBRR0L=0x33;

    // USART1 initialization
    // USART1 disabled
    UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

    // Analog Comparator initialization
    // Analog Comparator: Off
    // The Analog Comparator's positive input is
    // connected to the AIN0 pin
    // The Analog Comparator's negative input is
    // connected to the AIN1 pin
    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
    SFIOR=(0<<ACME);

    // ADC initialization
    // ADC disabled
    ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

    // SPI initialization
    // SPI disabled
    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

    // TWI initialization
    // TWI disabled
    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
    // ----- U????C? ??I? JTAG (E?C? C?E?CI? C? ???E??C? C ? F I? ???E ??C?) -----
    MCUCSR = (1 << JTD);
    MCUCSR = (1 << JTD);
    // Graphic Display Controller initialization
    // The KS0108 connections are specified in the
    // Project|Configure|C Compiler|Libraries|Graphic Display menu:
    // DB0 - PORTA Bit 0
    // DB1 - PORTA Bit 1
    // DB2 - PORTA Bit 2
    // DB3 - PORTA Bit 3
    // DB4 - PORTA Bit 4
    // DB5 - PORTA Bit 5
    // DB6 - PORTA Bit 6
    // DB7 - PORTA Bit 7
    // E - PORTF Bit 4
    // RD /WR - PORTF Bit 3
    // RS - PORTF Bit 2
    // /RST - PORTF Bit 7
    // CS1 - PORTF Bit 5
    // CS2 - PORTF Bit 6

    // ??IC?I?? C???? E???I ???I? C?ICI E?CI??
    // E?C? E?CI?? E?I? E?OE?? ???E?C? C? ??IC? ?? EC??? A?CI C?E?CI? ??I
    // srand(TCNT0);
    srand(TCNT0); // ?? ??O C?EC?IC?I ??? ???? C?E I? ??? ?C??C????C? embedded ?C? ???I
    // C?E?CI? C? rand() E? E??C?? ?? E?C? O??? ?C?? C?E.

    // Specify the current font for displaying text
    glcd_init_data.font=font5x7;
    // No function is used for reading
    // image data from external memory
    glcd_init_data.readxmem=NULL;
    // No function is used for writing
    // image data to external memory
    glcd_init_data.writexmem=NULL;

    glcd_init(&glcd_init_data);


    glcd_setfont(font5x7);


    // ----- —«Âù«‰œ«“Ì „«éÊ· SIM800 -----
    glcd_clear();
    glcd_outtextxy(0, 0, "Module Init...");
    delay_ms(1000);

    send_at_command("ATE0"); get_full_response(1000);
    send_at_command("AT"); get_full_response(1000);
    if(strstr(response_buffer, "OK") == NULL) { glcd_outtextxy(0, 10, "Module Not Found!"); while(1); }

    // ----- —«Âù«‰œ«“Ì ”—ÊÌ”ùÂ«Ì ÅÌ«„ò Ê HTTP -----
    if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
    //if (!init_http_bearer()) { glcd_outtextxy(0, 10, "HTTP Bearer Failed!"); while(1); }

    glcd_clear();
    glcd_outtextxy(0, 0, "System Ready.");
    glcd_outtextxy(0, 10, "Waiting for SMS...");

    // ----- Õ·ﬁÂ «’·Ì »—‰«„Â -----

    // main loop
while (1)
{
    char *p;  //  ⁄—Ì› „ €Ì— œ— «» œ«Ì »·«ò
    int line;
    
    memset(response_buffer, 0, sizeof(response_buffer));
    get_full_response(5000);  // “„«‰ »Ì‘ — »—«Ì œ—Ì«›  ÅÌ«„ò

    if (strlen(response_buffer) > 0)
    {
        glcd_clear();
        glcd_outtextxy(0, 0, "Received:");
        
        p = response_buffer; // „ﬁœ«—œÂÌ »⁄œ «“  ⁄—Ì›
        line = 10;
        while (*p && line < 40)
        {
            char temp_line[21] = {0};
            int i = 0;
            while (*p && *p != '\n' && i < 20)
            {
                temp_line[i++] = *p++;
            }
            temp_line[i] = '\0';
            if (*p == '\n') p++;
            glcd_outtextxy(0, line, temp_line);
            line += 10;
        }

        delay_ms(3000);

        process_sms();

        glcd_clear();
        glcd_outtextxy(0, 0, "System Ready.");
        glcd_outtextxy(0, 10, "Waiting for SMS...");
    }

    delay_ms(100);
}
}