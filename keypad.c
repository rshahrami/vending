#include "keypad.h"
#include "common.h"
#include <glcd.h>
#include <font5x7.h>


char get_key(void)
{
    unsigned char row, col;
    const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
    const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};

//    const char key_map[4][3] = {
//        {'1', '2', '3'},
//        {'4', '5', '6'},
//        {'7', '8', '9'},
//        {'*', '0', '#'}
//    };

    const char key_map[4][3] = {
        {'#', '0', '*'},  // ���� 1
        {'9', '8', '7'},  // ���� 2
        {'6', '5', '4'},  // ���� 3
        {'3', '2', '1'}   // ���� 4
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

    return 0;
}



void test_keypad(void)
{
    char key;
    char buf[2];

    
    glcd_clear();
    glcd_outtextxy(0, 0, "Press a key...");

    while (1)
    {
        key = get_key();  // ����� �� �흁� �� ������
        if (key != 0)
        {
            glcd_clear();
            glcd_outtextxy(0, 0, "Key Pressed:");
            
            buf[0] = key;  // ���ǘ�� ����
            buf[1] = '\0';
            
            glcd_outtextxy(0, 16, buf);  // ����� ��� GLCD
            delay_ms(500);               // ��� �� ���� ����
        }
    }
}
