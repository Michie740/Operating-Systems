  .global sumto

sumto:
  pushl %ebp # prologue
  movl %esp, %ebp 
  subl $8, %esp
  cmpl $1, 8(%ebp)
  jg recurse
  movl $1, %eax
  jmp done

recurse:
  movl 8(%ebp), %eax
  subl $1, %eax
  subl $12, %esp
  pushl %eax
  call sumto
  addl $16, %esp
  movl 8(%ebp), %ebx
  addl %ebx, %eax

done:
  mov %ebp, %esp
  pop %ebp
  ret
