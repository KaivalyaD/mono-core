;
; referred from: 'How to write an Operating System from Scratch', Nick Blundell
; written by: Kaivalya V Deshpande
;

; intel's 'basic flat model': 2 completely overlapped code and data segments

gdt_start:
	gdt_null:						; the mandatory null descriptor
		dw	0x0000
		dw	0x0000
		db	0x00
		db	00000000b
		db	00000000b
		db	0x00

	gdt_code:
		;
		; base address = 0x0000, segment limit = 0xfffff
		; 1st flags: (present)1 (privilage)00 (descriptor type)1 => 1001b
		; Type flags: (code)1 (conforming)0 (readable)1 (accessed)0 => 1010b
		; 2nd flags: (granularity)1 (32-bit default)1 (64-bit segment)0 (AVL)0 => 1100
		;
		dw	0xffff					; segment limit (first 2 bytes: 0-15)
		dw	0x0000					; base address (first 2 bytes: 0-15)
		db	0x00					; base address (next byte: 16-23)
		db	10011010b				; type flags (last 4 bits), flags 1 (1st 4 bits)
		db	11001111b				; last 4 bits of segment limit (making it 0xfffff) (last 4), flags 2 (1st 4)
		db	0x00 					; the last byte of base address (making it 0x00000000)

	gdt_data:
		;
		; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 => 0010b
		;
		dw	0xffff 					; segment limit (0-15): same as the code segment
		dw	0x0000 					; base address (0-15): same as the code segment
		db	0x00 					; base address (16-23): same as the code segment
		db	10010010b 				; flags 1 (same as the code segment), type flags (different from the code segment)
		db	11001111b 				; flags 2, last 4 bits of segment limit (16-19): same as the code segment
		db	0x00 					; last byte of the base address (24-31)

gdt_end:

;
; gdt descriptor
;
gdt_descriptor:
	dw 	gdt_end - gdt_start - 1 	; 16 bit size of the gdt (compensating for 1 extra offset added due to gdt_end)
	dd 	gdt_start 					; 32 bit starting address of the gdt

;
; pointers to the segment descriptors
;
CODE_SEG	equ		gdt_code - gdt_start
DATA_SEG	equ		gdt_data - gdt_start
