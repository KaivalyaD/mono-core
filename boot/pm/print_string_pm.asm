;
; a routine that prints a null-terminated string pointed to by ebx
; onto the screen using literally no other pre-cooked routine
;

[bits	32]

; define some constants
VIDEO_MEMORY		equ		0xb8000				; video memory starts from the offset 0xb8000
TM_WHITE_ON_BLACK	equ		0x0f				; VGA text mode and attributes

print_string_pm:
	pusha
	mov		edx, VIDEO_MEMORY					; set edx to point to the starting offset of the video memory

	print_string_pm_loop:
		;
		; register ax is used as the rough draft of register dx
		;
		mov		al,	[ebx]						; dl stores what character to print,
		mov		ah,	TM_WHITE_ON_BLACK			; while dh stores the attributes associated with the character

		cmp		al,	0 							; if the end of string is detected,
		je		print_string_pm_done			; jump to the epilogue

		mov		[edx], ax						; copy prepared data onto the fair notebook -- this will instantly
												; be printed, without any interrupt in real-time!

		add		ebx, 1								; raise ebx to point to the next character in the string
		add		edx, 2 							; raise edx to point to the next character position

		jmp		print_string_pm_loop			; run until the string terminator is encountered

	print_string_pm_done:
		popa									; restore all register context
		ret 									; return to the next line after call to this function
