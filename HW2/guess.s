.code16
.global _start

start:
  # print prompt to screen
  	movw $prompt, %si
	movb $0x00, %ah
	movb $0x03, %al # sets text
	int $0x10 # call in BIOS
	movb $0x01, %cl # start game
	jmp print_char # print out the prompt

# happens after something
loop:
	# Put your code here
	# jmp .rand # random number in bh
	# reset everyting perhaps
	movb $0x0a, %al # new row
	int $0x10
	movb $0x0d, %al # carriage return
	int $0x10
	movw $prompt, %si # have to read prompt every time
	movb $0x01, %dl # flag so that we don't read prompt without comparing
	jmp print_char

compare:
	movb $0x0a, %al # new row
	int $0x10
	movb $0x0d, %al # carriage return
	int $0x10
	movw $right_ans, %si # check if its the same
	cmp %bh, %ch 
	movb $0x01, %bl # setting flag to 1 (for rorw)
	je print_char # print out its right if its the same
	movw $wrong_ans, %si
	movb $0x00, %bl # setting flag to 0 for rorow
	jne print_char # check if its wrong

# only run once and run first
rand:				 	 # Setups the random number in %bh using the clock
	movb $0x00, %cl      # set to 0 so rorw will run properly
	movb $0x00, %bh      # Moves the value of zero into bh + resets it to zero?
	movw $0x00, %ax      # Setup to call clock innnnnn seconds
	out %al, $0x70
	in $0x71, %al        # Saves the time to al
	movb $0x0A, %bh      # Puts 10 in bh
	div %bh              # Divides the value by 10 div al by bh
	movb %ah, %bh        # Puts the remainder in bh from 0 - 9
	add $0x30, %bh 		 # converting it to ascii 0-9
	jmp readuser		 # starts to read user input

# reading user input
readuser:
	movb $0x00, %ah # set ah to 0 so we can read single char from user
	int $0x16 # reading user input and putting ascii value into al
	movb $0x0E, %ah # 0x0E is the BIOs code to print a single char
	int $0x10 # read out character letter is saved in al atm
	movb %al, %ch # put it somewhere so we can access it later since al changes a lot
	movb $0x00, %dl 
	jmp compare # check if this dude is the smae as

print_char:
	lodsb # load byte into al and increment si
    testb %al, %al # check if byte is 0 (nothing else to read)
    jz rorw # if so then go
    movb $0x0E, %ah # 0x0E is the BIOs code to print a single char
    int $0x10 # call into BIOs using softwre interupt
    jmp print_char # go back to the start of the loop

# need to check if we go to beginning of loop right or wrong
# check if we start the game 
rorw:
	cmp $0x01, %cl # game just started
	je rand
	cmp $0x01, %dl # decide wheter to read prompt or to read user
	je readuser 
	cmp $0x00, %bl # decide wheter to continue or to finish
	je loop
	jmp done

done:
	jmp done


prompt:
	.string		"What number am I thinking of (0-9)? "

wrong_ans:
	.string		"Wrong!"

right_ans:
	.string		"Right! Congratulations."

# Make sure the file is of the correct size
# What does a file of this end with?
.fill 510 - (. - start), 1, 0

.byte 0x55
.byte 0xAA
