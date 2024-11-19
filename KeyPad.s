#include <xc.inc>
    
global  KeyPad_setup, KeyPad_output, Keypad_to_LCD

psect	udata_acs   ; reserve data space in access ram
KeyPad_counter: ds    1	    ; reserve 1 byte for variable KeyPad_counter
KeyPad_Row: ds 1             ; reserve 1 byte for row scanning
KeyPad_Col: ds 1             ; reserve 1 byte for column scanning
combineddata: ds 1
tempchar: ds    1
    
psect	uart_code,class=CODE
    
KeyPad_setup:
      
    movlb   0x0F    ;Loads 1111 to BSR
    bsf	    REPU    ;Makes SBR15 ready for inputs
    movlb   0x00    ;Loads 0000 to lower bits of BSR 
    clrf    TRISF
    clrf    LATE
    return

    
KeyPad_main:
    
    movlw   0x0F    ;Move 00001111 to WR
    movwf   TRISE   ;Sets lower 4 bits to 1-configures them as inputs
    movf    PORTE, W         ; Read the value of PORTE (RC0-RC3)
 
    movwf   KeyPad_Row  ; Store the row state 

    movlw   0xF0    ;Move 11110000 to WR
    movwf   TRISE
    movlw   0xF0	    ;	Make all rows 0 to read columns
    
    movf    PORTE, W         ; Read the value of PORTC (RC0-RC3)

    movwf   KeyPad_Col        ; Store the col state
    
    movf    KeyPad_Row, W, A   ; Load the row state into W
    iorwf   KeyPad_Col, W, A   ; Perform OR with the column state (combines the states)
    movwf    combineddata   ; Store the combined row and column state in KeyPad_RowCol
    movwf    LATF
    return
    
KeyPad_output:
    call    KeyPad_main
    bra	    test_none
    return

test_none:
    movlw   0xFF
    cpfseq  combineddata	
    bra	    test_0
    retlw   0xFF	
test_0:
    movlw   0xEB	
    cpfseq  combineddata	
    bra	    test_1
    retlw   0x0E	   
test_1:
    movlw   0x77	
    cpfseq  combineddata	
    bra	    test_2
    retlw   0x01
test_2:
    movlw   0x7B
    cpfseq  combineddata	
    bra	    test_3
    retlw   0x04
test_3:
    movlw   0x7D	
    cpfseq  combineddata	
    bra	    test_4
    retlw   0x07
test_4:
    movlw   0xB7	
    cpfseq  combineddata	
    bra	    test_5
    retlw   0x02
test_5:
    movlw   0xBB
    cpfseq  combineddata	
    bra	    test_6
    retlw   0x05	
test_6:
    movlw   0xBD
    cpfseq  combineddata	
    bra	    test_7
    retlw   0x08
test_7:
    movlw   0xD7	
    cpfseq  combineddata
    bra	    test_8
    retlw   0x03
test_8:
    movlw   0xDB
    cpfseq  combineddata	
    bra	    test_9
    retlw   0x06
test_9:
    movlw   0xDD	
    cpfseq  combineddata	
    bra	    test_A
    retlw   0x09
test_A:
    movlw   0xE7
    cpfseq  combineddata	
    bra	    test_B
    retlw   0x0F
test_B:
    movlw   0xED
    cpfseq  combineddata	
    bra	    test_C
    retlw   0x0D
test_C:
    movlw   0xEE
    cpfseq  combineddata	
    bra	    test_D
    retlw   0x0C
test_D:
    movlw   0xDE
    cpfseq  combineddata	
    bra	    test_E
    retlw   0x0B
test_E:
    movlw   0xBE
    cpfseq  combineddata	
    bra	    test_F
    retlw   0x00
test_F:
    movlw   0x7E
    cpfseq  combineddata	
    bra	    invalid
    retlw   0x0A
invalid:
    bra	    KeyPad_output
    
Keypad_to_LCD:
    movwf    tempchar
    
Delay:
    movlw   0xFF
    
    end

