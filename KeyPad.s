#include <xc.inc>
    
global  KeyPad_Setup, Read_Key

psect	udata_acs   ; reserve data space in access ram
KeyPad_counter: ds    1	    ; reserve 1 byte for variable KeyPad_counter
KeyPad_Row: ds 1             ; reserve 1 byte for row scanning
KeyPad_Col: ds 1             ; reserve 1 byte for column scanning
KeyPad_RowCol: ds 1
    
psect	uart_code,class=CODE
    
KeyPad_Setup:
    bsf	    BSR, 4	;sets the 4th bit to high which selects bank 4
    bsf	    REPU	;enables the pill-ups to on for PORTE (bits 0 - 3 set as high unless a button is pressed 
    clrf    LATE	;set all of Port E as an output 
    movlw   0x0F
    movwf   TRISE	; Set PORTE 4-7 as outputs and 0-3 as inputs (makes call collumns 0) 
    clrf    LATF
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
    
   movf    KeyPad_RowCol, W

   btfss   KeyPad_Row, 0            ; Test bit 0 of RowState for row 0
    bra     Row0_Active            ; If bit 0 is clear (0), row 0 is active

    ; Check for the second row (RowState = 0x02 means row 1 is active)
    btfss   KeyPad_Row, 1            ; Test bit 1 of RowState for row 1
    bra     Row1_Active            ; If bit 1 is clear (0), row 1 is active

    ; Check for the third row (RowState = 0x04 means row 2 is active)
    btfss   KeyPad_Row, 2            ; Test bit 2 of RowState for row 2
    bra     Row2_Active            ; If bit 2 is clear (0), row 2 is active

    ; Check for the fourth row (RowState = 0x08 means row 3 is active)
    btfss   KeyPad_Row, 3            ; Test bit 3 of RowState for row 3
    bra     Row3_Active            ; If bit 3 is clear (0), row 3 is active

    bra	    Nada		;nothing is pressed
    
Row0_Active:
    btfss   KeyPad_Col, 4            ; Check if column 0 is active (bit 0 of ColState)
    bra     Row0_Col0_Pressed      ; If bit 0 of ColState is clear (0), column 0 is pressed

    btfss   KeyPad_Col, 5            ; Check if column 1 is active (bit 1 of ColState)
    bra     Row0_Col1_Pressed      ; If bit 1 of ColState is clear (0), column 1 is pressed

    btfss   KeyPad_Col, 6            ; Check if column 2 is active (bit 2 of ColState)
    bra     Row0_Col2_Pressed      ; If bit 2 of ColState is clear (0), column 2 is pressed

    btfss   KeyPad_Col, 7            ; Check if column 3 is active (bit 3 of ColState)
    bra     Row0_Col3_Pressed      ; If bit 3 of ColState is clear (0), column 3 is pressed

Row1_Active:
    btfss   KeyPad_Col, 4            ; Check if column 0 is active (bit 0 of ColState)
    bra     Row1_Col0_Pressed      ; If bit 0 of ColState is clear (0), column 0 is pressed

    btfss   KeyPad_Col, 5            ; Check if column 1 is active (bit 1 of ColState)
    bra     Row1_Col1_Pressed      ; If bit 1 of ColState is clear (0), column 1 is pressed

    btfss   KeyPad_Col, 6            ; Check if column 2 is active (bit 2 of ColState)
    bra     Row1_Col2_Pressed      ; If bit 2 of ColState is clear (0), column 2 is pressed

    btfss   KeyPad_Col, 7            ; Check if column 3 is active (bit 3 of ColState)
    bra     Row1_Col3_Pressed      ; If bit 3 of ColState is clear (0), column 3 is pressed

Row2_Active:
    btfss   KeyPad_Col, 4            ; Check if column 0 is active (bit 0 of ColState)
    bra     Row2_Col0_Pressed      ; If bit 0 of ColState is clear (0), column 0 is pressed

    btfss   KeyPad_Col, 5            ; Check if column 1 is active (bit 1 of ColState)
    bra     Row2_Col1_Pressed      ; If bit 1 of ColState is clear (0), column 1 is pressed

    btfss   KeyPad_Col, 6            ; Check if column 2 is active (bit 2 of ColState)
    bra     Row2_Col2_Pressed      ; If bit 2 of ColState is clear (0), column 2 is pressed

    btfss   KeyPad_Col, 7            ; Check if column 3 is active (bit 3 of ColState)
    bra     Row2_Col3_Pressed      ; If bit 3 of ColState is clear (0), column 3 is pressed

Row3_Active:
    btfss   KeyPad_Col, 4            ; Check if column 0 is active (bit 0 of ColState)
    bra     Row3_Col0_Pressed      ; If bit 0 of ColState is clear (0), column 0 is pressed

    btfss   KeyPad_Col, 5            ; Check if column 1 is active (bit 1 of ColState)
    bra     Row3_Col1_Pressed      ; If bit 1 of ColState is clear (0), column 1 is pressed

    btfss   KeyPad_Col, 6            ; Check if column 2 is active (bit 2 of ColState)
    bra     Row3_Col2_Pressed      ; If bit 2 of ColState is clear (0), column 2 is pressed

    btfss   KeyPad_Col, 7            ; Check if column 3 is active (bit 3 of ColState)
    bra     Row3_Col3_Pressed      ; If bit 3 of ColState is clear (0), column 3 is pressed

    
    
Row0_Col0_Pressed:
    movwf   LATG
    return
Row0_Col1_Pressed:
    movwf   LATG
    return
Row0_Col2_Pressed:
    movwf   LATG
    return
Row0_Col3_Pressed:
    movwf   LATG
    return
Row1_Col0_Pressed:
    movwf   LATG
    return
Row1_Col1_Pressed:
    movwf   LATG
    return
Row1_Col2_Pressed:
    movwf   LATG
    return
Row1_Col3_Pressed:
    movwf   LATG
    return
Row2_Col0_Pressed:
    movwf   LATG
    return
Row2_Col1_Pressed:
    movwf   LATG
    return
Row2_Col2_Pressed:
    movwf   LATG
    return
Row2_Col3_Pressed:
    movwf   LATG
    return
Row3_Col0_Pressed:
    movwf   LATG
    return
Row3_Col1_Pressed:
    movwf   LATG
    return
Row3_Col2_Pressed:
    movwf   LATG
    return
Row3_Col3_Pressed:
    movwf   LATG
    return
Nada:
    movwf   LATG
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

