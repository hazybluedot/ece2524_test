#include <unistd.h>
#include <stdio.h>
#include <string.h>

#define BUF_SIZE 8192

int main(int argc, char *argv[]) {
    char buffer[BUF_SIZE];

    printf("Test process with PID %d\n", getpid());
    
    sprintf(buffer, "child[%d]: writing to file\n", getpid());
    write(3, buffer, strlen(buffer));
    perror("write");
    pause();

    printf("Test process %d terminating\n", getpid());
    return 0;
}
