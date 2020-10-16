.code16
.globl _start

_start:
    movw $prompt, %si
	movb $0x00, %ah		# set video mode
	movb $0x03, %al
	int $0x10
	movb $0x00, %bl		# random number not generated yet. Flag
	movb $0x0d, %cl		# game start
	movb $0x00, %bh     # clear random number
	jmp print_char

loops:
	movb $0x0d,%al  # return
	movb $0x0e,%ah
	int $0x10
	movb $0x0a,%al  # return
	movb $0x0e,%ah
	int $0x10
	movw $prompt, %si
	movb $0x0d, %cl		# game is not finished
	movb $0x00, %bl		# random number not generated yet. Flag
	movb $0x00, %bh     # clear random number
	jmp print_char

get_input:
	movb $0x00,%ah
	int $0x16	# read from user
	movb $0x0E,%ah # print user choice
	int $0x10
	jmp check

check:
	movw $right_ans,%si
	cmp %al,%bh		# compare user input in AL with random number in bh
	movb $0x00,%cl	# mark as finished
	movb $0x0d,%al  # return
	movb $0x0e,%ah
	int $0x10
	movb $0x0a,%al  # return
	movb $0x0e,%ah
	int $0x10
	je print_char
	movw $wrong_ans,%si
	movb $0x01,%cl	# mark as not finished
	movb $0x0d,%al  # return
	movb $0x0e,%ah
	int $0x10
	movb $0x0a,%al  # return
	movb $0x0e,%ah
	int $0x10
	jne print_char

	# Put your code here

done:
	testb %cl,%cl	# see if the game is completed
	jz loops     # if yes go to loops
	testb %bl,%bl	# see if the game was not started yet
	jz generate_rand
	jmp get_input	# continue guess

print_char:
	lodsb			# loads a single byte from [si] into al and increments si
	testb %al,%al   # checks to see if the byte is 0
	jz done			# if so, jump out (jz jumps if the ZF in EFLAGS is set)
	movb $0x0E,%ah  # 0x0E is the BIOS code to print the single character
	int $0x10		# call into the BIOS using a software interrupt
	jmp print_char	# go back to the start of the loops

generate_rand:				 # Setups the random number in %bh using the clock
	movb $0x00, %bh      # Moves the value of zero into bh
	movb $0x00, %al      # Setup to call clock
	outb %al, $0x70
	inb $0x71, %al        # Saves the time to al
	and $0x0F, %al      
	add $0x30, %al
	movb %al, %bh        # Puts the remainder in bh
	movb $0x01,%bl		# number generated flag
	jmp get_input

prompt:
	.string		"What number am I thinking of (0-9)?"

wrong_ans:
	.string		"Wrong!"

right_ans:
	.string		"Right! Congratulations."


.fill 510 - (. - _start), 1, 0
.byte 0x55
.byte 0xAA
