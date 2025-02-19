;
; Pruebas_Display.asm
;
; Created: 2/10/2025 11:05:55 PM
; Author : oscar
;

.INCLUDE "M328PDEF.INC"
.CSEG
.ORG 0x00

//Configuración de la pila
LDI R16, LOW(RAMEND)
OUT SPL, R16 // Cargar 0xff a SPL
LDI R16, HIGH(RAMEND)
OUT SPH, R16 // Cargar 0x08 a SPH

// Configuraci n de MCU?
SETUP:
LDI R16, 0x00
STS UCSR0B, R16
OUT DDRC, R16		//configura las entradas
LDI R16, 0xFF
OUT PORTC, R16
OUT DDRB, R16
OUT DDRD, R16
LDI R16, 0x04
STS CLKPR, R16 // Configurar Prescaler a 16 F_cpu = 1MHz

//Leer botones
LDI R16,0x00

//contadores
LDI R17,0x00
LDI R18,0x00

//Estado inicial de los botones
LDI R21,0x7F

//Salidas display
DIS: .DB 0x3F,0x05,0x5B,0x4F,0x65,0x6E,0x7E,0x07,0x7F,0x67,0x77,0x7F,0x3A,0x3F,0x7A,0x72

; Replace with your application code
INICIO:
	LDI ZH, HIGH(DIS << 1)
	LDI ZL, LOW(DIS << 1)
	ADD ZL,R17
	LPM R22, Z
	OUT PORTD, R22
	IN R16, PINC
	CP R21,R16
	BREQ INICIO
	CALL DELAY
	IN R16, PINC
	CP R21,R16
	BREQ INICIO
	CALL DELAY
	IN R16, PINC
	CP R21,R16
	MOV R21,R16
	SBIS PINC,0
	JMP RS1
	SBIS PINC,1
	JMP RR1
	JMP INICIO

	

RS1:
	CPI R17,0x0F
	BREQ OVERF1
	JMP suma

OVERF1:
	LDI R17, 0xFF
	JMP suma

suma:
	INC R17
	JMP inicio

RR1:
	CPI R17, 0x00
	BREQ UNDERF1
	JMP resta

UNDERF1:
	LDI R17,0x10
	JMP resta

resta:
	DEC R17
	JMP INICIO

DELAY:
	LDI R31,0x00
	subdelay1:
	INC R31
	CPI R31,0x00
	BRNE subdelay1
	LDI R31,0x00
	subdelay2:
	INC R31
	CPI R31,0x00
	BRNE subdelay2
	LDI R31,0x00
	subdelay3:
	INC R31
	CPI R31,0x00
	BRNE subdelay3
	LDI R31,0x00
	subdelay4:
	INC R31
	CPI R31,0x00
	BRNE subdelay4
RET


INIT_TMR0:
	LDI R16, (1<<CS01) | (1<<CS00)
	OUT TCCR0B, R16 // Setear prescaler del TIMER 0 a 64
	LDI R16, 100
	OUT TCNT0, R16 // Cargar valor inicial en TCNT0
	RET
