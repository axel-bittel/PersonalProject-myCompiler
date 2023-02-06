file=test.s

all:
	as -o $(file).o  --64 $(file)
	ld -o res $(file).o
clean:
	rm -rf *.o
re : clean all
