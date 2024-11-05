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
	movlw	0x5
	movwf	0x20, A
up_loop: 
	incf	LATC, F
	decfsz	0x20, A	
	;call delay	  
	goto	up_loop
	movwf	0x20, A
down_loop:
	decf	LATC, F
	decfsz	0x20, A	
	;call delay
	goto	down_loop

	end	main
