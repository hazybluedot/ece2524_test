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
    char buffer[BUF_SIZE];

    printf("Parent process %d\n", getpid());

    signal(SIGUSR1, sig_handler);
    signal(SIGUSR2, sig_handler);

    int fd = open(argv[1], O_WRONLY|O_CREAT|O_APPEND, 0644); //open a file for writing

    if(-1 == fd)
    {
        fprintf(stderr, "open() failed with error [%s]\n",strerror(errno));
    } else {
	fprintf(stderr, "opened file %s for writing on FD %d\n", argv[1], fd);
	sprintf(buffer, "hello world, from PID %d\n", getpid());
	write(fd, buffer, strlen(buffer));
	close(fd);
    }
    
    while(!g_stop) {
	pause();
	pid_t pid = fork();
	if (pid < 0) {
	    // fork failed
	    return -1;
	} else if (pid == 0) {
	    // child process
	    printf("Child process with PID %d\n", getpid());
	    pause();
	    execv("./child", NULL);
	    perror("child execv"); // if we get to this line, the call to execv must have failed
	    _Exit(EXIT_FAILURE); // use _exit in child, not exit
	} else {
	    // parent
	    printf("Parent spawned child %d\n", pid);
	}
    }
    
    // if there had been no execv or exit in the child process, it
    // would execute this code as well
    int status;
    pid_t cpid;
    do {
      cpid = waitpid(0, &status);
      if (cpid == -1) {
	perror("waitpid");
	exit(EXIT_FAILURE);
      }
      if (WIFEXITED(status)) {
	printf("exited, status=%d\n", WEXITSTATUS(status));
      } else if (WIFSIGNALED(status)) {
	printf("killed by signal %d\n", WTERMSIG(status));
      } else if (WIFSTOPPED(status)) {
	printf("stopped by signal %d\n", WSTOPSIG(status));
      } else if (WIFCONTINUED(status)) {
	printf("continued\n");
      }
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));

    exit(EXIT_SUCCESS);
}
