CFLAGS := -std=c99

all: fork_demo forkexec child

fork_demo: fork_demo.o

forkexec: forkexec.o

child: child.o

memtest: memtest.o util.o

clean:
	-rm -f *.o
