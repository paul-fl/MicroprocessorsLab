#include <xc.inc>
    
global  KeyPad_Setup, Read_Key

psect	udata_acs   ; reserve data space in access ram
KeyPad_counter: ds    1	    ; reserve 1 byte for variable KeyPad_counter
KeyPad_Row: ds 1             ; reserve 1 byte for row scanning
KeyPad_Col: ds 1             ; reserve 1 byte for column scanning
keyval: ds 1
    
psect	uart_code,class=CODE
    
KeyPad_setup:
    movlb 15; go to access bank 15
    bsf REPU; pull-up the byte in access bank 15
    movlb 0; for cleanliness
    clrf LATE; we want LATCHE to be cleared throughout
    clrf TRISD
    return

    
Read_Key:
    
    movf    PORTE, W         ; Read the value of PORTE (RC0-RC3)
    andlw   0x0F             ; Mask out other bits, keep only RC0-RC3 (rows)

    movwf   KeyPad_Row  ; Store the row state 

    movlw   0xF0	    ;	Make all rows 0 to read columns
    
    movf    PORTE, W         ; Read the value of PORTC (RC0-RC3)
    andlw   0xF0             ; Mask out other bits, keep only Columns

    movwf   KeyPad_Col        ; Store the col state
    
    movf    KeyPad_Row, W   ; Load the row state into W
    iorwf   KeyPad_Col, W   ; Perform OR with the column state (combines the states)
    movwf   KeyPad_RowCol   ; Store the combined row and column state in KeyPad_RowCol
    
   movf    keyval, W

Combo_tests: ; iteratively go through each of the 16 combinations until the value in the keyval register matches with the one being tested
    movlw 0xFF ; i.e. if no value has been pressed, stay within this loop until no longer true 
    cpfseq keyval, A ; compare value in keyval with W, store result in A
    bra test_0 ; move on to next test if not equal
    retlw 0x00; clear W
    
test_0: ;0111 0111
    movlw 0x77 ; CHECK
    cpfseq keyval, A 
    bra test_1
    retlw 0x77 ; REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_1: ;0111 1011
    movlw 0x7B ; CHECK
    cpfseq keyval, A 
    bra test_2
    retlw 0x7B;REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_2: ;0111 1101
    movlw 0x7D ; CHECK
    cpfseq keyval, A 
    bra test_3
    retlw 0x7D ; REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_3: ;0111 1110
    movlw 0x7E ; CHECK
    cpfseq keyval, A 
    bra test_4
    retlw 0x7E ; REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_4: ;1011 0111
    movlw 0xB7 ; CHECK
    cpfseq keyval, A 
    bra test_5
    retlw 0xB7 ; REPLACE WITH APPROPRIATE ASCII CHARACTER!
    
test_5: ;0111 1011
    movlw 0xBB ; CHECK
    cpfseq keyval, A 
    bra test_6
    retlw 0xBB ; REPLACE WITH APPROPRIATE ASCII CHARACTER!
    
test_6: ;0111 1101
    movlw 0xBD ; CHECK
    cpfseq keyval, A 
    bra test_7
    retlw 0xBD ; REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_7: ;0111 1110
    movlw 0xBE ; CHECK
    cpfseq keyval, A 
    bra test_8
    retlw 0xBE ; REPLACE WITH APPROPRIATE ASCII CHARACTER!

test_8: ;1101 0111
    movlw 0xD7 ; CHECK
    cpfseq keyval, A 
    bra test_1
    retlw 0xD7 ; REPLACE WITH APPROPRIATE ASCII CHARACTER!
    
;KeyPad_Transmit_Message:	    ; Message stored at FSR2, length stored in W
;    movwf   KeyPad_counter, A
;KeyPad_Loop_message:
;    movf    POSTINC2, W, A
 ;   call    KeyPad_Transmit_Byte
  ;  decfsz  KeyPad_counter, A
   ; bra	    KeyPad_Loop_message
    ;return

;KeyPad_Transmit_Byte:	    ; Transmits byte stored in W
 ;   btfss   TX1IF	    ; TX1IF is set when TXREG1 is empty
  ;  bra	    KeyPad_Transmit_Byte
   ; movwf   TXREG1, A
    ;return

Delay:
    movlw   0xFF
    
    end

