#include <iostream>
#include <cstdlib>

using namespace std;

int main() {
    string line;
    int acc=1;

    while(getline(cin, line)) { // reading streams from std::cin is
				// just wrapping system calls to read
				// from file descriptor 0
	int value = atoi(line.c_str()); // library functions such as
					// atoi are also in the man
					// pages! Will be we able to
					// use the same call for the
					// next assignment in which we
					// need to check for errors?
	acc *= value;
    }
    cout << acc << endl; // writing streams to std::cout wraps system
			 // calls to write to file descriptor 1
}
