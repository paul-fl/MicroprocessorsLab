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
setup:
	movlw	0x0F		    ; Sets amplitude
	movwf	0x20, A
	movlw	0x64
	movwf	0x40, A		    ; Sets big loop

main_loop:
	movlw	0x0F	    ;reset amplitude counter
	movwf	0x20, A
up_loop: 
	incf	LATC, F
	call	delay
	decfsz	0x20, A		  
	goto	up_loop

	movlw	0x0F		    ;reset amplitude counter
	movwf	0x20, A
	
down_loop:
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
	
	
	end	main

	
	