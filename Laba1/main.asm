;
; Laba1.asm
;
; Created: 22.03.2022 14:37:50
; Author : asoko
;

start:
	SER R20			;R20 ����� 255
	OUT DDRA,R20	;�������� ����� �� ����
	IN R21,PORTA	;������ ��������� ����� � � R21
	COM R21			;�������������� R21
	OUT PORTA, R21	;������ � ���� �
delay:
	LDI R18, 25; z	;������ ��������
	LDI R17, 97; y	;������ ��������
	LDI R16, 53; x	;������ ��������
delay_sub:
	DEC R16			;�������� 1
	NOP
	NOP
	BRNE delay_sub	;���� ����� �� ����� 0, �� ������� � delay_sub
	DEC R17			;�������� 1
	BRNE delay_sub	;���� �� 0, �� � delay_sub
	DEC R18			;�������� 1
	BRNE delay_sub	;���� �� 0, �� � delay_sub
	NOP
	rjmp start		;������� �� �����