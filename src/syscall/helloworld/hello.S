  .global _start

  .text

_start:
  mov $1, %rax
  mov $1, %rdi
  mov $hello_msg, %rsi
  mov $hello_msg_len, %rdx
  syscall
  jmp exit

exit:
  mov $60, %rax # system call number: sys_exit(60)
  mov $42, %rdi # return code
  syscall

hello_msg:
  .string "Hello, World!\n"

hello_msg_len = . - hello_msg
