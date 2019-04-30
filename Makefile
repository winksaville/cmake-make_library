.PHONY: all
all: main

main: main.o s1.o s2.o
	${CC} -o main $^

main.o: main.c s1.h s2.h
	${CC} -c -o $@ $<

s1.o: s1.c s1.h
	${CC} -c -o $@ $<

s2.o: s2.c s2.h
	${CC} -c -o $@ $<


.PHONY: clean
clean:
	rm main *.o
