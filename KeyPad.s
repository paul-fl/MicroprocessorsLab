#include <xc.inc>
    
global  KeyPad_Setup, KeyPad_Transmit_Message

psect	udata_acs   ; reserve data space in access ram
KeyPad_counter: ds    1	    ; reserve 1 byte for variable KeyPad_counter

psect	uart_code,class=CODE
KeyPad_Setup:
    bsf	    BSR, 4	;sets the 4th bit to high which selects bank 4
    bsf	    REPU	;enables the pill-ups to on for PORTE (bits 0 - 3 set as high unless a button is pressed 
    clrf    LATE	;set all of Port E as an output 
    movlw   0x0F
    movwf   TRISE	; Set PORTE 4-7 as outputs and 0-3 as inputs 
    return

    
    
KeyPad_Transmit_Message:	    ; Message stored at FSR2, length stored in W
    movwf   KeyPad_counter, A
KeyPad_Loop_message:
    movf    POSTINC2, W, A
    call    KeyPad_Transmit_Byte
    decfsz  KeyPad_counter, A
    bra	    KeyPad_Loop_message
    return

KeyPad_Transmit_Byte:	    ; Transmits byte stored in W
    btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
    bra	    KeyPad_Transmit_Byte
    movwf   TXREG1, A
    return

Delay:
    movlw   0xFF

