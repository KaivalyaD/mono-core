;
; bootstrap for mono
;


[org	0x7c00]							; BIOS reads the boot sector into memory from offset 0x7c00
										; to offset 0x7e00; align all addresses accordingly
KERNEL_OFFSET	equ	0x1000

start:
	mov		[BOOT_DRIVE], dl			; BIOS stores the drive used to boot in dl
	mov		bp,	0x9000					; initialize the stack base and top
	mov		sp,	bp
	mov		bx,	MSG_REAL_MODE			; announce that the CPU is currently in the real mode
	call	print_string
	call	kernel_load					; load the kernel from disk
	call	exec_switch					; switch to 32-bit protected mode
	jmp		$							; we never reach here
	
%include "print_string.asm"		; include all necessary routines
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits	16]

kernel_load:							; load the kernel code into memory
	push	bx
	push	dx
	
	mov		bx,	MSG_LOADING_KERNEL		; announce that the kernel is being loaded into memory
	call	print_string
	mov		bx,	KERNEL_OFFSET			; load starting from offset: KERNEL_OFFSET (0x0000:0x1000)
	mov		dh,	1						; 1 sector excluding the boot sector (i.e. beginning of sector 2 --> end of sector 2)
	mov		dl,	[BOOT_DRIVE]			; of the BOOT_DRIVE
	call	disk_load					; invoke disk loading routine
	
	pop		dx
	pop		bx
	ret
	
[bits	32]

begin_pm:
	mov		ebx, MSG_PROTECTED_MODE		; announce that the CPU has now entered the protected mode
	call	print_string_pm
	
	call	KERNEL_OFFSET				; jump to the kernel code: boot into mono
	
	mov		ebx, MSG_KERNEL_CANNOT_RUN
	call	print_string_pm
	
	jmp		$							; hang up if the kernel returns
	

; global data
BOOT_DRIVE			db	0
MSG_REAL_MODE		db	"Started in 16 bit Real Mode...", 0
MSG_LOADING_KERNEL	db	"Loading mono into memory...", 0
MSG_PROTECTED_MODE	db	"Successfully landed into the 32 bit Protected mode", 0
MSG_KERNEL_CANNOT_RUN	db	"Cannot run mono", 0

; padding and boot sector signature
times	510-($-$$)	db	0
dw		0xaa55

