#include <stdio.h>

int main(){
	/*delay:
	LDI R18, 255; z	;������ ��������
	LDI R17, 255; y	;������ ��������
	LDI R16, 255; x	;������ ��������
delay_sub:
	DEC R16			;�������� 1
	NOP
	NOP
	BRNE delay_sub	;���� ����� �� ����� 0, �� �� �����
	DEC R17			;�������� 1
	BRNE delay_sub	;���� �� 0, �� ������
	DEC R18			;�������� 1
	BRNE delay_sub	;���� �� 0, �� ������
	rjmp start		;����� �� �����*/

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