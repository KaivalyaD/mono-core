;
; a routine that undertakes the switch from 16 bit real mode to 32 bit protected mode
;

;
; referred from: 'How to write an Operating System from Scratch', Nick Blundell
; written by: Kaivalya V Deshpande
;

[bits	16]

	exec_switch:
		; prepare for the switch
		cli

		lgdt	[gdt_descriptor]

		mov		eax,	cr0
		or 		eax,	0x01
		mov		cr0,	eax

		; execute the switch
		jmp		CODE_SEG:init_pm					; the function never returns from here


;; ------ Protected Mode ------ ;;

[bits	32]

	init_pm:
		; initialize all registers in the new mode
		mov		ax, DATA_SEG
		mov		ds,	ax
		mov		ss,	ax
		mov		es,	ax
		mov		fs,	ax
		mov		gs,	ax

		; initialize the stack for the new mode
		mov		esp,	0x90000
		mov		ebp,	esp

		jmp		begin_pm
