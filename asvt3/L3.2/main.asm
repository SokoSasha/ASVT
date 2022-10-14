.def k1 = R24
.def k2 = R25
.def a1 = R16
.def a2 = R17
.def a3 = R18
.def b1 = R19
.def b2 = R20
.def c1 = R21
.def c2 = R22
.def c3 = R23
.def uno = R5
.def nul = R0

clr nul
clr uno
inc uno

start:
	ser R24
	out DDRA, R24
	out DDRB, R24
	out DDRC, R24
	out DDRD, R24

	;a
	ldi a1, 0x80
	ldi a2, 0x00
	ldi a3, 0x16

	;b
	ldi b1, 0x80
	ldi b2, 0x02

	;c
	ldi c1, 0x21
	ldi c2, 0x22
	ldi c3, 0x23

	ldi k1, 0x40	;16570
	ldi k2, 0xBA	; НЕ ТРОГАТЬ!!!!

	mov R31, a1
	andi R31, 0x80
	mov R1, R31
	breq b_
	andi a1, 0x7F
	sub a3, uno
	sbc a2, nul
	sbc a1, nul
	com a3
	com a2
	com a1

b_:
	clr R29
	mov R31, b1
	andi R31, 0x80
	mov R2, R31
	breq c_
	andi b1, 0x7F
	sub b2, uno
	sbc b1, nul
	com b2
	com b1
	ser R29

c_:
	mov R31, c1
	andi R31, 0x80
	mov R3, R31
	breq zn
	andi c1, 0x7F
	sub c3, uno
	sbc c2, nul
	sbc c1, nul
	com c3
	com c2
	com c1

;установка знака
zn:
	cp R1, R2
	breq one_zero
	mov R31, R1
	rjmp subs

one_zero:
	mov R31, nul
	cp b2, a3
	cpc b1, a2
	cpc R29, a1
	brlo subs
	ldi R31, 0x80

;вычетание
subs:
	mov R1, R31
	sub a3, b2
	sbc a2, b1
	sbc a1, R29

	ldi R26, 0x04
	

;сдвиг
loop:
	clc
	rol a3
	rol a2
	rol a1
	dec R26
	cpse R26, nul
	rjmp loop

	mov R31, nul
	cp R1, R31
	brne one_zero2
	rjmp plus

one_zero2:
	cp a3, nul
	cpc a2, nul
	cpc a1, nul
	breq plus
	mov R26, k2
	mov R27, k1
	sub R26, uno
	sbc R27, nul
	com R26
	com R27
	ser R28
	cp R26, a3
	cpc R27, a2
	cpc R28, a1
	brlo plus
	ldi R31, 0x80
	rjmp plus
	
;+16570
plus:
	mov R1, R31
	add a3, k2
	adc a2, k1
	adc a1, nul
	
;сравнение с С
	cp R1, R3
	brlo greater
	cp R3, R1
	brlo less
	mov R28, R1

	cp c3, a3
	cpc c2, a2
	cpc c1, a1
	brlo greater	;если полученное число больше с
	cp a3, c3
	cpc a2, c2
	cpc a1, c1
	brlo less		;если меньше
	mov R31, nul	;если равны
	rjmp znak
less:
	ldi R31, 0xff
	rjmp znak
greater:
	ldi R31, 0x01

znak:
	cp R1, nul
	brne back
	rjmp display

back:
	sub a3, uno
	sbc a2, nul
	sbc a1, nul
	com a3
	com a2
	com a1
	andi a1, 0x7F
	or a1, R1

display:
	out PORTA, a1
	out PORTB, a2
	out PORTC, a3
	out PORTD, R31
	rjmp display