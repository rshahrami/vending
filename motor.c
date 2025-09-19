#include "motor.h"
#include "common.h"

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
    
    while ((PIND & (1 << PIND1)) && timeout > 0)
    {
        delay_ms(1);
        timeout--;
    }
 
    MOTOR_PORT &= ~(1 << motor_pin);
    
}
