.org $000
	rjmp start
.org INT0addr
	rjmp EXT_INT0
.org INT1addr
	rjmp EXT_INT1
.org OC1Aaddr
	rjmp TCompA
.org OC1Baddr
	rjmp TCompB
.org OVF2addr
	rjmp Timer2
.org OVF1addr
	rjmp Timer1

.def temp = r31
.def temp_1 = r23
.def temp_2 = r24
.def temp_3 = r25
.def temp_4 = r26
.def temp_n = r14
.def blk = r30
.def blk_t = r15
.def nul = r0
.def num1 = r16
.def num2 = r17
.def num3 = r18
.def num4 = r19
.def ad = r29
.def adr = r28
.def sig = r11
.def flag = r27 ;0 - проверка, 1 - настройка
.def count1 = r20
.def count2 = r21
.def count21 = r22
clr nul

.macro define
	clr temp
	inc temp
	cp @0, temp
		breq n0
	lsl temp
	cp @0, temp
		breq n1
	lsl temp
	cp @0, temp
		breq n2
	lsl temp
	cp @0, temp
		breq n3
	lsl temp
	cp @0, temp
		breq n4
	lsl temp
	cp @0, temp
		breq n5
	lsl temp
	cp @0, temp
		breq n6
	lsl temp
	cp @0, temp
		breq n7
	ldi temp, 0x11
	cp @0, temp
		breq n8
	ldi temp, 0x21
	cp @0, temp
		breq n9
	
	n0:
		ldi temp, 0x3f
		mov @0, temp
		jmp at
	n1:
		ldi temp, 0x06
		mov @0, temp
		jmp at
	n2:
		ldi temp, 0x5b
		mov @0, temp
		jmp at
	n3:
		ldi temp, 0x4f
		mov @0, temp
		jmp at
	n4:
		ldi temp, 0x66
		mov @0, temp
		jmp at
	n5:
		ldi temp, 0x6d
		mov @0, temp
		jmp at
	n6:
		ldi temp, 0x7d
		mov @0, temp
		jmp at
	n7:
		ldi temp, 0x07
		mov @0, temp
		jmp at
	n8:
		ldi temp, 0x7f
		mov @0, temp
		jmp at
	n9:
		ldi temp, 0x6f
		mov @0, temp
	at:
.endm

.macro input
	begin:
		in temp, @0
		sbrc ad, 0
		andi temp, 0x30
		cpi temp, 0x00
		breq begin
		in temp_n, @0
		add temp_n, ad
	outt:
		in temp, @0
		sbrc ad, 0
		andi temp, 0x30
		cpi temp, 0x00
		brne outt
	
		define temp_n
		sbrc blk, 0
		mov temp_1, temp_n
		sbrc blk, 1
		mov temp_2, temp_n
		sbrc blk, 2
		mov temp_3, temp_n
		sbrc blk, 3
		mov temp_4, temp_n
		
		sbrc blk, 0
		mov temp, num1
		sbrc blk, 1
		mov temp, num2
		sbrc blk, 2
		mov temp, num3
		sbrc blk, 3
		mov temp, num4
.endm

start:
	ser temp
	out ddrc, temp
	ldi temp, 0xcf
	out ddra, temp
	ldi temp, 0xf3
	out ddrd, temp
	clr temp
	out ddrb, temp
	clr nul
	LDI R20, HIGH(RAMEND)
	OUT SPH, R20
	LDI R20, LOW(RAMEND)
	OUT SPL, R20
	ldi temp, 0x0F
	out mcucr, temp
	ldi temp, 0xc0
	out gicr, temp
	out gifr, temp

	ldi temp, 0x04
	out tccr1b, temp
	ldi temp, 0x07
	out tccr2, temp
	clr temp
	cli
	out tcnt1h, temp
	out tcnt1l, temp
	out ocr1ah, temp
	out ocr1al, temp
	ldi temp, 0x7f
	out ocr1bh, temp
	ldi temp, 0xff
	out ocr1bl, temp
	sei

	clr temp
	out tifr, temp

	ldi blk, 0x01
	jmp check_pass

disp:
	clr blk_t
	inc blk_t
	out porta, blk_t
	out portc, temp_1
	rcall delay
	lsl blk_t
	out porta, blk_t
	out portc, temp_2
	rcall delay
	lsl blk_t
	out porta, blk_t
	out portc, temp_3
	rcall delay
	lsl blk_t
	out porta, blk_t
	out portc, temp_4
	rcall delay
	out porta, sig
	rcall delay
	ret

A:
	clr ad
	inc ad
	input pina
	jmp outb
B:
	clr ad
	input pinb
	jmp outb
A_:
	jmp A
check_pass:
		clr temp
		out timsk, temp
		out tifr, temp
		clr flag
		ldi temp_1, 0x08
		ldi temp_2, 0x08
		ldi temp_3, 0x08
		ldi temp_4, 0x08
		clr adr
		call read
		mov num1, temp
		inc adr
		call read
		mov num2, temp
		inc adr
		call read
		mov num3, temp
		inc adr
		call read
		mov num4, temp
		clr sig
		clr blk
		inc blk
	loop:
		call disp
		in temp, pina
		andi temp, 0x30
		cpi temp, 0x00
		brne A_
		in temp, pinb
		cpi temp, 0x00
		brne B_
		breq loop
			outb:
		cp temp_n, temp
		brne no
		lsl blk
		cpi blk, 0x10
		brsh aut
		jmp loop
B_:
jmp B
	aut:
		call disp
		rjmp aut
	no:
		inc r9
		clr temp
		out timsk, temp
		out tifr, temp
		clr count2
		clr count21
		ldi temp, 0x03
		cp r9, temp
		brsh nol
		clr temp
		out tcnt2, temp
		ldi temp, 0x40
		out timsk, temp
		out tifr, temp
		ldi temp, 0x40
		mov sig, temp
		rjmp nt
		nol:
		clr r9
		ldi temp, 0xc0
		mov sig, temp
		nt:
		call disp
		rjmp nt

delay:
	ldi temp, 10
	mov r1, temp
	mov r2, temp
	ldi temp, 1
	mov r3, temp

	dl:
	dec r1
	brne dl
	dec r2
	brne dl
	dec r3
	brne dl
	ret

A_1:
	clr ad
	inc ad
	input pina
	jmp outb1
B_1:
	clr ad
	input pinb
	jmp outb1
A__:
	jmp A_1
B__:
	jmp B_1
set_pass:
		clr temp
		out timsk, temp
		out tifr, temp
		clr adr
		call read
		mov temp_1, temp
		inc adr
		call read
		mov temp_2, temp
		inc adr
		call read
		mov temp_3, temp
		inc adr
		call read
		mov temp_4, temp
		ser flag
		clr blk
		inc blk
	loop1:
		cpi blk, 0x02
		brlo nxt
		clr temp
		cli
		out tcnt1h, temp
		out tcnt1l, temp
		sei
		ldi temp, 0x1c
		out timsk, temp
		out tifr, temp
		ldi temp, 0x01
		out portd, temp
		nxt:
		call disp
		in temp, pina
		andi temp, 0xf0
		cpi temp, 0x00
		brne A__
		in temp, pinb
		cpi temp, 0x00
		breq loop1
		brne B__
			outb1:
		lsl blk
		cpi blk, 0x10
		brsh aut1
		jmp loop1
	aut1:
		clr temp
		out timsk, temp
		out tifr, temp

		clr adr
		mov temp, temp_1
		call write
		inc adr
		mov temp, temp_2
		call write
		inc adr
		mov temp, temp_3
		call write
		inc adr
		mov temp, temp_4
		call write

		clr adr
		call read
		mov num1, temp
		inc adr
		call read
		mov num2, temp
		inc adr
		call read
		mov num3, temp
		inc adr
		call read
		mov num4, temp

		sett:
			clr blk_t
			inc blk_t
			out porta, blk_t
			out portc, num1
			rcall delay
			lsl blk_t
			out porta, blk_t
			out portc, num2
			rcall delay
			lsl blk_t
			out porta, blk_t
			out portc, num3
			rcall delay
			lsl blk_t
			out porta, blk_t
			out portc, num4
			rcall delay
			jmp sett

read:
	sbic eecr, eewe
	jmp read
	cli
	out eearl, adr
	clr nul
	out eearh, nul
	sbi eecr, eere
	in temp, eedr
	sei
	ret


write:
	sbic eecr, eewe
	jmp write
	cli
	out eearl, adr
	clr nul
	out eearh, nul
	out eedr, temp
	sbi eecr, eemwe
	sbi eecr, eewe
	sei
	ret

EXT_INT0:
	sbrc flag, 0
	jmp check_pass
	jmp set_pass
	;reti

EXT_INT1:
	clr temp
	out porta, temp
	out portc, temp
	jmp check_pass
	;reti

Timer2:
	inc count2
	cpi count2, 0x66
	brne ok2
	clr count2
	inc count21
	cpi count21, 0x06
	brne ok2
	clr count21
	clr count2
	jmp check_pass
	ok2:
	reti

Timer1:
	inc count1
	cpi count1, 0x0e
	brne ok
	clr count1
	ldi temp, 0x02
	out portd, temp
	jmp check_pass
	ok:
	reti

TCompA:
	ldi temp, 0xcf
	out ddra, temp
	reti

TCompB:
	cpi blk, 0x01
	brne b2
	ldi temp, 0xce
	out ddra, temp
	b2:
	cpi blk, 0x02
	brne b3
	ldi temp, 0xcd
	out ddra, temp
	b3:
	cpi blk, 0x04
	brne b4
	ldi temp, 0xcb
	out ddra, temp
	b4:
	cpi blk, 0x08
	brne bb
	ldi temp, 0xc7
	out ddra, temp
	bb:
	reti