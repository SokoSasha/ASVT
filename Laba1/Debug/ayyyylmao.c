#include <stdio.h>

int main()
{
    /*delay:
	LDI R18, 255; z	;задаем значение
	LDI R17, 255; y	;задаем значение
	LDI R16, 255; x	;задаем значение
delay_sub:
	DEC R16			;вычитаем 1
	SBRC R16, 7		;если 7ой бит этого числа в двоичном представлении равен 0, то следующую команду попускаем
	BRNE delay_sub	;если число не равно 0, то по новой
	DEC R17			;вычитаем 1
	BRNE delay_sub	;если не 0, то заново
	DEC R18			;вычитаем 1
	BRNE delay_sub	;если не 0, то заново
	rjmp start		;валим на старт*/

    unsigned char x, y, z=0;
    z--;
    printf("%d", z);
}