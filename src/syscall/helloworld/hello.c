#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>

int main() {
    const char *msg = "Hello, World!\n";

    syscall(SYS_write, 1, msg, strlen(msg)); // fd, *buf, size

    return 42;
}
