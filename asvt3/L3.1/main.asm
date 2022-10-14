.def k1 = R24
.def k2 = R25

start:
	ser R24
	out DDRA, R24
	out DDRB, R24
	out DDRC, R24
	out DDRD, R24
	ldi R16, 16	;a
	ldi R17, 17
	ldi R18, 18

	ldi R19, 19	;b
	ldi R20, 20

	ldi R21, 0	;c
	ldi R22, 32
	ldi R23, 155

	ldi k1, 64	;16570
	ldi k2, 186

	sub R18, R20
	sbc R17, R19
	sbci R16, 0

	ldi R30, 4
	ldi R31, 0

loop:
	clc
	rol R18
	rol R17
	rol R16
	dec R30
	cpse R30, R31
	rjmp loop
	
	add R18, k2
	adc R17, k1
	clr k1
	adc R16, k1

	cp R23, R18
	cpc R22, R17
	cpc R21, R16
	brlo greater	;если полученное число больше с
	cp R18, R23
	cpc R17, R22
	cpc R16, R21
	brlo less		;если меньше
	ldi R31, 0x00	;если равны
	rjmp display
less:
	ldi R31, 0xff
	rjmp display
greater:
	ldi R31, 0x01
	rjmp display

display:
	out PORTA, R16
	out PORTB, R17
	out PORTC, R18
	out PORTD, R31
	rjmp display