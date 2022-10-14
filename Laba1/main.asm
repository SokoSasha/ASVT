;
; Laba1.asm
;
; Created: 22.03.2022 14:37:50
; Author : asoko
;

start:
	SER R20			;R20 равно 255
	OUT DDRA,R20	;открытие порта на ввод
	IN R21,PORTA	;запись состояния порта А в R21
	COM R21			;инвентирование R21
	OUT PORTA, R21	;запись в порт А
delay:
	LDI R18, 25; z	;задаем значение
	LDI R17, 97; y	;задаем значение
	LDI R16, 53; x	;задаем значение
delay_sub:
	DEC R16			;вычитаем 1
	NOP
	NOP
	BRNE delay_sub	;если число не равно 0, то переход в delay_sub
	DEC R17			;вычитаем 1
	BRNE delay_sub	;если не 0, то в delay_sub
	DEC R18			;вычитаем 1
	BRNE delay_sub	;если не 0, то в delay_sub
	NOP
	rjmp start		;переход на старт