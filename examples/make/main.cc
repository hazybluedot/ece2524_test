#include <iostream>
#include <string>
#include <sstream>

#include "accumulator.hpp"

using namespace std;

int main(int argc, const char *argv[]) {
    Accumulator acc;
    
    string line;
    while(getline(cin, line)) { 
	double value;
	istringstream iss(line);
	if (iss >> value)
	    acc.increment(value);
    }

    cout << acc.get() << endl;
}
