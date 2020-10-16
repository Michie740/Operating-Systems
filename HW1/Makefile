help:
	@echo 'For convenience'
	@echo
	@echo 'Available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

# Try to infer the correct TOOLPREFIX if not set
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if i386-jos-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	then echo 'i386-jos-elf-'; \
	elif objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; \
	then echo ''; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find an i386-*-elf version of GCC/binutils." 1>&2; \
	echo "*** Is the directory with i386-jos-elf-gcc in your PATH?" 1>&2; \
	echo "*** If your i386-*-elf toolchain is installed with a command" 1>&2; \
	echo "*** prefix other than 'i386-jos-elf-', set your TOOLPREFIX" 1>&2; \
	echo "*** environment variable to that prefix and run 'make' again." 1>&2; \
	echo "*** To turn off this error, run 'gmake TOOLPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif

AS = $(TOOLPREFIX)as
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

bootblocks = hello guess demo

STARTADDR = $(shell \
	objdump -M intel -d hello.elf | \
	nice grep '<_start>' | \
	awk '{print "0x"$$1}' \
	2> /dev/null)

$(bootblocks) : % : %.elf
	$(OBJCOPY) -O binary $< $@

%.elf: %.o
	$(LD) -N -e start -Ttext 0x7C00 $< -o $@

%.o: %.s
	$(AS) $< -o $@

.PHONY: qemu-hello          # boot to hello using qemu
qemu-hello: hello
	qemu-system-i386 -hda hello

.PHONY: qemu-gdb-hello      # boot to hello using qemu in debug mode
qemu-gdb-hello: hello
	qemu-system-i386 -hda hello -s -S

.PHONY: gdb                 # connect to qemu when running in debug mode
gdb: guess
	gdb -ex 'target remote localhost:1234' \
			-ex 'b *$(STARTADDR)' \
			-ex 'c'

.PHONY: clean               # clean up build environment
clean:
	rm -f *.elf *.o $(bootblocks) linkedList
