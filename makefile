.PHONY: clean
objects = parser.tab.o lex.yy.o error.o sym_table.o lib_flet.o 
c_files = parser.tab.c parser.tab.h lex.yy.c lex.yy.h

%.o : %.c
	gcc -c $^ -o $@ 

#create static library
library: $(objects)
	ar rcs lib_flet.a $^ 

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

clean:
	-rm $(objects) $(c_files) lib_flet.a main.o test

test: main.c 
	gcc -c main.c -o main.o
	gcc -o $@ main.o -L. lib_flet.a -lm