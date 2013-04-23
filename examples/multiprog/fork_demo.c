#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>

#define BUF_SIZE 8192

int g_stop;

void sig_handler(int signum)
{
    printf("Received signal %d\n", signum);
    if (signum == SIGUSR2) {
	g_stop = 1;
    };
}

int main(int argc, char *argv[]) {
    g_stop = 0;
    int counter = 0;
    char buffer[BUF_SIZE];

    printf("Parent process %d\n", getpid());

    signal(SIGUSR1, sig_handler);
    signal(SIGUSR2, sig_handler);
    
    while(!g_stop) {
	pause();
	pid_t pid = fork();
	if (pid < 0) {
	    // fork failed
	    return -1;
	} else if (pid == 0) {
	  // child process
	  printf("Child process %d started with PID %d\n", counter, getpid());
	  pause();
	  exit(EXIT_SUCCESS);
	} else {
	    // parent
	  printf("Parent spawned child number %d with PID %d\n", counter+1, pid);
	  ++counter;
	}
    }
    
    printf("process %d continuing past loop and exiting\n", getpid());
    printf("Total of %d children spawned\n", counter);
    return EXIT_SUCCESS;
}
