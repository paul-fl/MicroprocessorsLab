#include <xc.inc>

psect	code, abs
	

main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	movwf	TRISD, A	    ; Port D set to 0, this is clock pulse
	movwf	LATC, A		    ; Set outout to 0
	call	SPI_MasterInit	    ; Initializes SPI transmission
setup:
	movlw	0x0F		    ; Sets amplitude
	movwf	0x20, A
	movlw	0x64
	movwf	0x40, A		    ; Sets big loop

main_loop:
	movlw	0xfF	    ;reset amplitude counter
	movwf	0x20, A
up_loop: 
	movf	LATC, W	    ;moves current amplitude into W
	call	SPI_MasterTransmit	;transmits the data over SPI
	incf	LATC, F
	call	delay
	decfsz	0x20, A		  
	goto	up_loop
	

	movlw	0xfF		    ;reset amplitude counter
	movwf	0x20, A
	
down_loop:
    	movf	LATC, W   ;moves current amplitude into W
	call	SPI_MasterTransmit	;transmits the data over SPI
	decf	LATC, F
	call	delay
	decfsz	0x20, A	
	goto	down_loop

	decfsz	0x40, A
	goto	main_loop

	goto	start

delay:
	movlw	0xFF		   ;set delay counter
	movwf	0x30, A		   ;store delay counter
delay_loop:
	decfsz	0x30, A
	goto	delay_loop
	return
	
SPI_MasterInit: ; Set Clock edge to negative
bcf CKE2 ; CKE bit in SSP2STAT, 
; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
movlw (SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
movwf SSP2CON1, A
; SDO2 output; SCK2 output
bcf TRISD, PORTD_SDO2_POSN, A ; SDO2 output
bcf TRISD, PORTD_SCK2_POSN, A ; SCK2 output
return
 
SPI_MasterTransmit: ; Start transmission of data (held in W)
movwf SSP2BUF, A ; write data to output buffer

Wait_Transmit: ; Wait for transmission to complete 
btfss PIR2, 5 ; check interrupt flag to see if data has been sent
bra Wait_Transmit
bcf PIR2, 5 ; clear interrupt flag
return
    
	
	
	end	main

	
	