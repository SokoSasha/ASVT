.def temp = R16
.def num1 = R20
.def num2 = R21
.def oper = R22
.def nul = R17
.def znak = R18
.def fl = R23
ldi nul, 0x00

.macro Delay
		ldi R25, 0
		ldi R26, 0
		ldi R27, 4
	DLoop:
		dec R25
		brne DLoop
		dec R26
		brne DLoop
		dec R27
		brne DLoop
.endm	

.macro input ;0 - PINx, 1 - numx
	begin:
		in temp, @0
		cp temp, nul
		breq begin
		Delay
		in @1, @0
	outt:
		in temp, @0
		cp temp, nul
		brne outt
.endm

clr temp
out DDRB, temp
out DDRC, temp
ser temp
out DDRA, temp
out DDRD, temp

start:
	out PORTD, nul
	input PINB, num1
;	begin:
;		in temp, PINB
;		cp temp, nul
;		breq begin
;		;Delay
;		in num1, PINB
;	outt:
;		in temp, PINB
;		cp temp, nul
;		brne outt
	jmp display1
C:
	input PINC, oper
;	begin1:
;		in temp, PINC
;		cp temp, nul
;		breq begin1
;		;Delay
;		in oper, PINC
;	outt1:
;		in temp, PINC
;		cp temp, nul
;		brne outt1
	sbrs oper, 0
	jmp display2
C2:
	sbrc oper, 0
	jmp nuller
	sbrc oper, 1
	jmp arrot
	sbrc oper, 2
	jmp alrot
	sbrc oper, 3
	jmp mult
flags:
	sbrc oper, 6
	out PORTD, fl
	sbrc oper, 7
	out PORTD, fl

display1:
	out PORTA, num1
	in temp, PINB
	cp temp, nul
	brne start_
	in temp, PINC
	cp temp, nul
	brne C_
	jmp display1

display2:
	out PORTA, num1
	in temp, PINB
	cp temp, nul
	brne C2_
	in temp, PINC
	cp temp, nul
	brne C_
	jmp display2

start_:
	jmp start

C_:
	jmp C

C2_:
	jmp C2

.macro flg
		clr fl
		breq Z1
	Zout:
		brcs C1
	Cout:
		jmp @0

	C1:
		sbrc oper, 7
		inc fl
		jmp Cout
	
	Z1:
		sbrc oper, 6
		inc fl
		sbrc oper, 6
		inc fl
		jmp Zout
.endm

nuller:
	clr num1
	flg nuller_out
	nuller_out:
	jmp flags

arrot:
		input PINB, num2
		sbrs num2, 7
		rjmp arloop2
		andi num2, 0x7F

	arloop1:
		cp num2, nul
		breq flags_
		dec num2
		asr num1
		flg ar1_out
		ar1_out:
		jmp arloop1

	arloop2:
		cp num2, nul
		breq flags_
		dec num2
		lsl num1
		flg ar2_out
		ar2_out:
		jmp arloop2

flags_:
	jmp flags

alrot:
		input PINB, num2
		sbrs num2, 7
		rjmp alloop2
		andi num2, 0x7F

	alloop1:
		cp num2, nul
		breq flags_
		dec num2
		lsl num1
		flg al1_out
		al1_out:
		jmp alloop1

	alloop2:
		cp num2, nul
		breq flags_
		dec num2
		lsr num1
		flg al2_out
		al2_out:
		jmp alloop2	

mult:
	input PINB, num2
	mov R1, num1
	mov R2, num2
	ldi R19, 0x80
	and R1, R19
	and R2, R19
	eor R1, R2
	and num1, num2
	cp num1, nul
	breq nnn
	andi num1, 0x7F
	or num1, R1
nnn:
	flg mult_out
	mult_out:
	jmp flags