;;
; Lab_y_Pos_1_micros.asm
;
; Created: 1/30/2025 3:46:22 PM
; Author : Oscar
;

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

;Leer botones
LDI R16, 0x00

;contadores
LDI R17,0x00
LDI R18,0x00

;Salidas PORT D y B
LDI R19,0x00
LDI R20,0x00

;estado inicial de los botones
LDI R21,0x7F

;suma 2 contadores con carry
LDI R22,0x00

;Bucle
inicio:
IN R16, PINC
CP R21,R16
BREQ inicio
call delay
IN R16, PINC
CP R21,R16
BREQ inicio
call delay
IN R16, PINC
CP R21,R16
MOV R21,R16
SBIS PINC,0
jmp RS1
SBIS PINC,1
jmp RR1
SBIS PINC,2
jmp RR2
SBIS PINC,3
jmp RS2
SBIS PINC,5
jmp sumar
JMP inicio

RS1:
CPI R17,0x0F
BREQ OVERF1
jmp suma

OVERF1:
LDI R17, 0xFF
jmp suma

suma:
INC R17
ANDI R19,0xF0
ADD R19,R17
OUT PORTB, R19
JMP inicio

RR1:
CPI R17, 0x00
BREQ UNDERF1
jmp resta

UNDERF1:
LDI R17,0x10
JMP resta

resta:
DEC R17
ANDI R19,0xF0
ADD R19,R17
OUT PORTB, R19
JMP inicio

RS2:
CPI R18,0x0F
BREQ OVERF2
jmp suma2

OVERF2:
LDI R18, 0xFF
jmp suma2

suma2:
INC R18
ANDI R20,0xF0
ADD R20,R18
OUT PORTD, R20
JMP inicio

RR2:
CPI R18, 0x00
BREQ UNDERF2
JMP resta2

UNDERF2:
LDI R18,0x10
JMP resta2

resta2:
DEC R18
ANDI R20,0xF0
ADD R20,R18
OUT PORTD, R20
JMP inicio

sumar:
LDI R22, 0x00
ADD R22, R17
ADD R22, R18
LSL R22
LSL R22
LSL R22
LSL R22
BRCS carry
CBI PORTB, 4
mostrar:
ANDI R20, 0x0F
ADD R20, R22
OUT PORTD, R20
jmp inicio

carry:
SBI PORTB, 4
JMP mostrar

delay:
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