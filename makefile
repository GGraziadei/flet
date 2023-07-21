.PHONY: clean
objects = sym_table.o parser.tab.o lex.yy.o error.o libFlet.so flet_parser.o test main.o
c_files = parser.tab.c parser.tab.h lex.yy.c lex.yy.h


#create shared library
library: parser.tab.c lex.yy.c sym_table.c error.c
	gcc -c -fPIC *.c 
	gcc -shared -o libFlet.so *.o -lm
#	pwd | sudo tee /etc/ld.so.conf
#	ldconfig

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

clean:
	-rm main $(objects) $(c_files)

test: main.c 
	gcc -c main.c
	gcc -o $@ main.o -L./ -lFlet
	ldd ./$@