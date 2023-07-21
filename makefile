.PHONY: clean
objects = sym_table.o parser.tab.o lex.yy.o error.o libFlet.so flet_parser.o
c_files = parser.tab.c parser.tab.h lex.yy.c lex.yy.h

%.o: %.c %.h
	gcc -g -c -o $@ $<

#create shared library
main: parser.tab.c lex.yy.c sym_table.c error.c
	gcc -c -fPIC *.c 
	gcc -shared -o libFlet.so *.o -lm
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/home/ggraziadei/flc/flet
	export LD_LIBRARY_PATH

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

clean:
	-rm main $(objects) $(c_files)