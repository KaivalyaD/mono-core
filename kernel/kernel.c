/* kernel entry point */
void main(void)
{
	/* create a pointer to the 1st cell of video memory (0xb8000)
	   that corresponds to the top left corner of screen */
	
	char *video_memory = (char *) 0xb8000;
	
	/* since the bootloader has already set up a 32-bit protected
	   mode environment, BIOS routines are meaningless. Merely
	   setting the value at video_memory to 'X' will display an 'X'
	   on the top left corner of the screen, without generating any
	   interrupts */
	
	*video_memory = 'X';  // displays an X
}

