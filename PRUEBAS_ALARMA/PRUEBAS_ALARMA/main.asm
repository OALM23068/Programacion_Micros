;
; PRUEBAS_ALARMA.asm
;
; Created: 2/26/2025 7:28:29 PM
; Author : oscar
;
.include "M328PDEF.inc"
.cseg
.org 0x0000
	JMP START
.org 0x0008
	JMP PINCHANGEC_ISR
.org 0x0020
	JMP TMR0_ISR


START:
// Configuraci n de la pila?
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16	

DIS: .DB 0x3F,0x05,0x5B,0x4F,0x65,0x6E,0x7E,0x07,0x7F,0x67,0x77,0x7F,0x3A,0x3F,0x7A,0x72
MESES: .DB 0x31,0x28,0x31,0x30,0x31,0x30,0x31,0x31,0x30,0x31,0x30,0x31

SETUP:
	CLI

	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16
	LDI R16, 0b00000100
	STS CLKPR,R16

	LDI R16,(1 << CS01)|(1 << CS00)
	OUT TCCR0B, R16
	LDI R16,100
	OUT TCNT0, R16

	LDI R16, (1 << TOIE0)
	STS TIMSK0, R16

	LDI R16, (1 << PCIE1)
	STS PCICR, R16
	LDI R16,(1 << PCINT12)|(1 << PCINT11)|(1 << PCINT10)|(1 << PCINT9)|(1 << PCINT8)
	STS PCMSK1, R16

	
	LDI R16,0x00
	OUT PORTD, R16
	OUT PORTB, R16
	STS UCSR0B, R16
	LDI R16,0x10
	OUT DDRC,R16
	LDI R16,0xFF
	OUT PORTC, R16
	OUT DDRB,R16
	OUT DDRD, R16
	
	SEI

// Contador horas y mins
	LDI R16,0x00
	LDI R17,0x00
	LDI R18,0x00
	LDI R19,0x00
// Contadores para minutos
	LDI R20,0x00
	LDI R21,0x00
// Valor a mostrar en displays
	LDI R22,0x00
// Valores temporales
	LDI R23,0x00
// Modo del sistema
	LDI R24,0x01
// Registros Alarma y Fecha
	LDI R25,0x01
	LDI R26,0x00
	LDI R27,0x00
	LDI R28,0x00
// Registro para puntos cada 500ms
	LDI R29,0x00
//Mostrar display sin borrar 
// Registro para el delay de los displays
	LDI R31,0x00

	
	CBI PORTC,5
; Replace with your application code
MAIN_LOOP:
	CPI R24,0x00
	BREQ APAGADO
	CPI R24,0x02
	BREQ ALARMA
	CPI R24,0x03
	BREQ FECHA
	JMP MAIN_LOOP

APAGADO:
JMP M_APAGAR
FECHA:
JMP M_FECHA
ALARMA:
JMP M_ALARMA


M_APAGAR:
	CBI PORTC, 4
	CBI PORTB, 4
	CBI PORTB, 5
	JMP MAIN_LOOP

M_ALARMA:
	CBI PORTC, 4
	SBI PORTB,5
	CBI PORTB,4
	OUT PORTD,R22
	JMP MAIN_LOOP

M_FECHA:
	CBI PORTC, 4
	SBI PORTB,5
	SBI PORTB,4
	OUT PORTD,R22
	JMP MAIN_LOOP

DELAY:
LDI R31,0
subdelay1:
INC R31
CPI R31,0x00
BRNE subdelay1
RET

PINCHANGEC_ISR:
	SBIS PINC,0
	INC R24
	ANDI R24,0x03
	CPI R24,0x02
	BREQ CONF_ALARM
	CPI R24,0x03
	BREQ CONF_FECHA
RETI

CONF_ALARM:
	SBIS PINC,0
	INC R25
	SBIS PINC,1
	DEC R26
	SBIS PINC,2
	INC R27
	SBIS PINC,3
	INC R28
RETI

CONF_FECHA:
	SBIS PINC,0
	INC R25
	SBIS PINC,1
	DEC R26
	SBIS PINC,2
	INC R27
	SBIS PINC,3
	INC R28
RETI

TMR0_ISR:
	LDI R22, 100
	OUT TCNT0, R22
	INC R20
	INC R29
	CPI R20, 250
	BREQ REGISTRO2
RETI
	REGISTRO2:
	INC R21
RETI

