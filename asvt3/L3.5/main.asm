.def senior = R20
.def junior = R21
.def ten = R22
.def six = R23
.def Tten = R17
.def Ssix = R18

.macro overing ;0 - х, 1 - у, 2 - старший х, 3 - старший у, 4 - выход

.endm

start:
	ser R20
	out DDRA, R20
	out DDRB, R20
	out DDRC, R20
	out DDRD, R20

	;x
	ldi R24, 0x89
	ldi R25, 0x99
	ldi R26, 0x99

	;y
	ldi R27, 0x09
	ldi R28, 0x99

	;z
	ldi R29, 0x24
	ldi R30, 0x52
	ldi R31, 0x53

	;вспомогательные элементы
	ldi senior, 0xF0
	ldi junior, 0x0F
	ldi ten, 0x0A
	ldi six, 0x06
	ldi Tten, 0xA0
	ldi Ssix, 0x60
	mov R3, R24
	mov R13, R24
	mov R4, R27
	mov R14, R27
	mov R5, R28
	mov R15, R28
	and R3, senior ;старший разряд R24
	and R13, junior
	and R4, senior ;старший разряд R27
	and R14, junior
	and R5, senior ;старший разряд R28
	and R15, junior

	;сложение
	ldi R16, 0x00
	add R26, R28
	adc R25, R27
	adc R24, R16
	;overing R26, R28, R3, R5, out1

	mov R7, R26
	mov R8, R26
	and R7, junior
	and R8, senior
	cp R7, R15
	brlo over1
	cp R7, ten
	brsh over1
	rjmp senn1
over1:
	add R26, six
	adc R25, R16
	adc R24, R16
senn1:
	cp R8, R5
	brlo addd1
	cp R8, Tten
	brsh addd1
	rjmp out1
addd1:
	add R26, Ssix
	adc R25, R16
	adc R24, R16
out1:

	;overing R25, R27, R2, R4, out2
	mov R7, R25
	mov R8, R25
	and R7, junior
	and R8, senior
	cp R7, R14
	brlo over2
	cp R7, ten
	brsh over2
	rjmp senn2
over2:
	add R25, six
	adc R24, R16
senn2:
	cp R8, Tten
	brlo addd2
	cp R8, R4
	brsh addd2
	rjmp out2
addd2:
	add R25, Ssix
	adc R24, R16
out2:

	;overing R24, R16, R1, R19, comp
	mov R7, R24
	mov R8, R24
	and R7, junior
	and R8, senior
	cp R7, R13
	brlo over3
	cp R7, ten
	brsh over3
	rjmp senn3
over3:
	add R24, six
senn3:
	cp R8, R3
	brlo addd3
	cp R8, Tten
	brsh addd3
	rjmp comp
addd3:
	add R24, Ssix

comp:
	cp R31, R26
	cpc R30, R25
	cpc R29, R24
	brlo greater
	cp R26, R31
	cpc R25, R30
	cpc R24, R29
	brlo less
	ldi R16, 0x00
	rjmp display
less:
	ldi R16, 0xFF
	rjmp display
greater:
	ldi R16, 0x01

display:
	out PORTA, R24
	out PORTB, R25
	out PORTC, R26
	out PORTD, R16
	rjmp display	