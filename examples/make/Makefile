acctest: main.o accumulator.o
	g++ -o acctest main.o accumulator.o

accumulator.o: accumulator.cc accumulator.hpp
	g++ -c accumulator.cc

main.o: main.cc accumulator.hpp
	g++ -c main.cc

clean:
	rm -f *.o
