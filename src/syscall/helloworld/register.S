  .global _start

  .text

_start:
  mov $60, %rax # system call number: sys_exit(60)
  mov $42, %rdi # return code
  syscall
