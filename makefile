C_SRC = ${wildcard kernel/*.c drivers/*.c}
C_HEAD = ${wildcard kernel/*.h drivers/*.h}
OBJ = ${C_SRC:.c=.o}

# default make target
all : core-image

# for running the emulation
run : all
	qemu-system-x86_64 -hda core-image
	
# building the image
core-image : boot/boot_sect.bin kernel.bin
	cat $^ > $@

# building the kernel image
kernel.bin : kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary
	
# building the kernel object
%.o : %.c ${C_HEAD}
	i386-elf-gcc -ffreestanding -c $< -o $@
	
# building the kernel entry-point caller object
%.o : %.asm
	nasm $< -f elf -o $@

# building the boot loader
%.bin : %.asm
	nasm $< -f bin -I './boot/rm' -I './boot/pm' -o $@
	
# for cleaning all generated binaries
clean :
	rm -fr *.bin *.o *.dis core-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
	
# for debugging, an option to disassemble the kernel
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@

