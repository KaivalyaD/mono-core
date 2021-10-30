; a routine to print strings using only BIOS routines

;
; to use, initialize bx with base address of the null terminated string,
; then call
;
print_string:
	pusha

	mov 	ah,	0x0e					; int 10/(ah=0e) invokes BIOS routine scrolling teletype
loop:
	mov 	cl, [bx]					; move into cl, the byte at address of bx
	mov		al,	cl 						; move into al, the byte in cl
	int 	0x10 						; invoke routine 0x10 on ah=0e & al=cl
	inc 	bx							; bx now points to the next byte in the string
	cmp 	cl, 0 						; compare the byte in cl to 0
	jne 	loop 						; jump to the address 'loop' if cl != 0

	popa
	ret									; return to the address following the function call
