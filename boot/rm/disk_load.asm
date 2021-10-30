; a routine that loads the specified sectors to memory

;
; to use,
;	1.	initialize dl with the disk drive from where to read;
;	2.	initialize dh with the number of sectors intented to be read;
;	3.	initialize ex:bx with the address, ahead of which this routine
;		shall load the specified sectors; and finally,
;	4. call
;

disk_load:
	push	dx								; dx is required for both: the BIOS routine to work, and for us to
											; check for disk errors. Thus, push its current content to the stack
											; that holds the number of sectors to intended to be loaded for later use

	mov 	ah,	0x02						; int 0x13/(ah = 0x02) => BIOS read sector routine
	mov 	al,	dh							; al stores the number of sectors to read (required by the BIOS routine)
	mov 	ch, 0x00						; select cylinder 0 (why ch? required by the BIOS routine)
	mov 	dh, 0x00						; select head 0 (why dh? required by the BIOS routine)
	mov 	cl, 0x02						; start reading from the 2nd sector, i.e. the one just after the boot
											; sector (why cl? required by the BIOS routine)

	int 	0x13							; generate the interrupt

	jc 		disk_error						; if the carry flag is set, jump to the disk_error subroutine

	pop		dx								; restore the value of dx before calling this routine
	cmp		dh,	al 							; if the intended number of sectors was not loaded,
	jne		disk_error						; then jump to the disk_error subroutine

	ret

	disk_error:
		mov 	bx,	DISK_ERROR_MSG
		call 	print_string
		jmp 	$

DISK_ERROR_MSG	db	"Disk read error!", 0
