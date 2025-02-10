;
; Prelab2_micros_23068.asm
;
; Created: 2/6/2025 1:25:25 PM
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

// Configuracion de MCU
SETUP:
	// Configurar Prescaler "Principal"
	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16 // Habilitar cambio de PRESCALER
	LDI R16, 0x04
	STS CLKPR, R16 // Configurar Prescaler a 16 F_cpu = 1MHz
	CALL INIT_TMR0
	//Configuracion de Puertos
	LDI R16,0xFF
	OUT DDRD, R16
	OUT DDRB, R16
	LDI R16, 0x00
	OUT DDRC, R16
	OUT PORTD, R16
	OUT PORTB, R16
	STS UCSR0B, R16

// Definimos valores
	LDI R17,0x00
	LDI R19,0x0F
	LDI R20, 0x00

//Definimos el estado inicial de los botones
	LDI R21,0x7F


//bucle 
MAIN_LOOP:
	IN R16, TIFR0 // Leer registro de interrupci n de TIMER 0?
	SBRS R16, TOV0 // Salta si el bit 0 est "set" (TOV0 bit)?
	RJMP MAIN_LOOP // Reiniciar loop
	SBI TIFR0, TOV0 // Limpiar bandera de "overflow"
	LDI R16, 100
	OUT TCNT0, R16 // Volver a cargar valor inicial en TCNT0
	INC R20
	CPI R20, 10 // R20 = 10 after 100ms (since TCNT0 is set to 10 ms)
	BRNE MAIN_LOOP
	CLR R20
	CP R17, R19
	BRBS 1, OVERFLOW
	INC R17
	OUT PORTB, R17
	JMP MAIN_LOOP

OVERFLOW:
	LDI R17,0x00
	OUT PORTB, R17
	JMP MAIN_LOOP


INIT_TMR0:
	LDI R16, (1<<CS01) | (1<<CS00)
	OUT TCCR0B, R16 // Setear prescaler del TIMER 0 a 64
	LDI R16, 100
	OUT TCNT0, R16 // Cargar valor inicial en TCNT0
	RET