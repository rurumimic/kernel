  .global _start

  .text

_start:
  mov $1, %eax  # system call number: exit(1)
  mov $42, %ebx # return code
  int $0x80 # interrupt syscall
