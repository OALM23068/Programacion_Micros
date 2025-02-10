;
; AssemblerApplication4.asm
;
; Created: 1/30/2025 3:46:22 PM
; Author : oscar
;

;configuracion de la pila

LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16 , HIGH(RAMEND)
OUT SPH, R16

; configuracion de MCU

LDI R16, 0x00
OUT DDRC, R16
LDI R16, 0xFF
OUT DDRD, R16
OUT PORTC, R16


LDI r16, 0b11111110
LDI r17, 0b11111101
LDI r18, 0x00
LDI r20, 0x01
LDI r21, 0x0F
LDI r22, 0x00

main:
	Call Delay
	call Delay
	IN r19, PINC
	SBIC PINC, 0
	jmp RevisarS
	SBIC PINC, 1
	jmp RevisarR
	JMP main

RevisarS:
	CP r18, r21
	BRBS 1, overflow
	JMP sumar

overflow:
	LDI r18, 0xFF
	JMP Sumar

sumar:
	ADD r18,r20
	OUT PORTD, r18
	antirreboteS:
	MOV R16, R19
	IN r19, PINC
	CP r19, r16
	BRBS 1, antirreboteS
	call Delay
	call Delay
	JMP main

RevisarR:
	call Delay
	CP r18, r22
	BRBS 1, underflow
	JMP Resta

underflow:
	LDI r18, 0x10
	JMP Resta

Resta:
	SUB r18,r20
	OUT PORTD, r18
	antirreboteR:
	MOV R17, R19
	IN r19, PINC
	CP r19, r17
	BREQ antirreboteR
	call Delay
	JMP main

Delay:
	LDI r23,0x00
	Subdelay1:
	INC r23
	CPI r23,0x00
	BRNE subdelay1
	LDI r23,0x00
	Subdelay2:
	INC r23
	CPI r23,0x00
	BRNE subdelay2
	LDI r23,0x00
	Subdelay3:
	INC r23
	CPI r23,0x00
	BRNE subdelay3
	ret


