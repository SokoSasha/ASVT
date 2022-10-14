#include <stdio.h>

int main(){
	/*delay:
	LDI R18, 255; z	;задаем значение
	LDI R17, 255; y	;задаем значение
	LDI R16, 255; x	;задаем значение
delay_sub:
	DEC R16			;вычитаем 1
	NOP
	NOP
	BRNE delay_sub	;если число не равно 0, то по новой
	DEC R17			;вычитаем 1
	BRNE delay_sub	;если не 0, то заново
	DEC R18			;вычитаем 1
	BRNE delay_sub	;если не 0, то заново
	rjmp start		;валим на старт*/

	unsigned char x = 255, y = 0, z = 0, x_t;
	unsigned long i = 0;
delayy:
	x--;
	i++;
	i += 2;
	x_t = (x >> 6) % 2;
	if (x_t == 0) {
		i++;
		goto iii;
	}
	/*i += 2;
	i++;*/
	if (x > 0) {
		i++;
		goto delayy;
	}
iii:
	y--;
	i++;
	i++;
	if (y > 0) {
		i++;
		goto delayy;
	}
	z--;
	//i++;
	//i++;
	if (z > 0) {
		i++;
		goto delayy;
	}
	//i += 3;
	printf("Ticks = %d", i);
	return 0;
}