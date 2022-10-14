.org $000
	jmp start
.org INT0addr
	jmp EXT_INT0
.org INT1addr
	jmp EXT_INT1

.def light1 = r16
.def light2 = r17
.def light3 = r18
.def Xx = r19
.def Yy = r20
.def nul = r2
.def adr = r26
.def temp = r25
clr nul

.macro inputDelay
		ldi r21, 0
		ldi r22, 0
		ldi r23, 4
	DLoop:
		dec R21
		brne DLoop
		dec R22
		brne DLoop
		dec R23
		brne DLoop
.endm	

.macro delay_ms
		cpi Yy, 1
		breq y250
		cpi Yy, 2
		breq y500
		jmp y1000

	begin:
		dec r21
		brne begin
		dec r22
		brne begin
		dec r23
		brne begin
		jmp aut

	y250:
		ldi r21, 96
		ldi r22, 38
		ldi r23, 11
		jmp begin
	
	y500:
		ldi r21, 193
		ldi r22, 75
		ldi r23, 21
		jmp begin
	
	y1000:
		ldi r21, 130
		ldi r22, 150
		ldi r23, 41
		jmp begin
.endm

start:
		LDI R20, HIGH(RAMEND)
		OUT SPH, R20
		LDI R20, LOW(RAMEND)
		OUT SPL, R20
		ser r24
		out ddra, r24
		out ddrb, r24
		out ddrc, r24
		ldi r24, 0xF3
		out ddrd, r24
		
		ldi light1, 0x80
		clr light2
		clr light3
		clr adr
		call read
		mov Xx, temp
		inc adr
		call read
		mov Yy, temp
		cpi Xx, 0x0d
		brsh ordX
		cp Xx, nul
		breq ordX
		rjmp chkY
	ordX:
		ldi Xx, 0x01	; задаем шаг

	chkY:
		cpi Yy, 0x04
		brsh ordY
		cp Yy, nul
		breq ordY
		rjmp okey
	ordY:
		ldi Yy, 0x01	; по умолчанию время = 0,25 сек
		mov temp, Yy
		clr adr
		inc adr
		call write

	okey:
		clr adr
		cpi Xx, 0x04
		brne mi
		ldi temp, 0x04
		call write 
		rjmp init
	mi:
		ldi temp, 0x0c
		call write 
	
init:
	ldi r24, 0x0F
	out mcucr, r24
	ldi r24, 0xc0
	out gicr, r24
	out gifr, r24
	sei

display:
		out porta, light1
		out portb, light2
		out portc, light3

		ldi r27, 0x10
		mov temp, Xx
		mul temp, r27
		mov temp, r0
		add temp, Yy
		out portd, temp

		mov temp, Xx
	loop:
		cpi Xx, 0x08
		brsh minus
		cp temp, nul
		breq ext
		ror light1
		ror light2
		ror light3
		brcc next
		ori light1, 0x80
		clc
		jmp next

	minus:
		cpi temp, 0x08
		breq ext
		rol light3
		rol light2
		rol light1
		brcc next
		ori light3, 0x01
		clc
	next:
		dec temp
		jmp loop
	ext:
		delay_ms
	aut:
		jmp display

EXT_INT0:
		push temp
		in temp, sreg
		push temp
		ldi r28, 0x08
		clr adr
		call read
		eor temp, r28
		mov Xx, temp
		call write
		pop temp
		out sreg, temp
		pop temp
		reti

EXT_INT1:
		push temp
		in temp, sreg
		push temp
		ldi adr, 0x01
		call read
		cpi Yy, 0x03
		brne ok
		clr temp
	ok:
		inc temp
		call write
		mov Yy, temp
		pop temp
		out sreg, temp
		pop temp
		reti

read:
	sbic eecr, eewe
	jmp read			
	out eearl, adr
	out eearh, nul
	sbi eecr, eere
	in temp, eedr
	ret


write:
	sbic eecr, eewe
	jmp write
	;cli
	out eearl, adr
	out eearh, nul
	out eedr, temp
	sbi eecr, eemwe
	sbi eecr, eewe
	;sei
	ret