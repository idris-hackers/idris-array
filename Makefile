
Array.o : Array.h Array.c
	$(CC) `idris --include` -c Array.c -o Array.o

.PHONY: clean
clean :
	-rm Array.o

