.PHONY: clean
objects = sym_table.o parser.tab.o main.o lex.yy.o
c_files = parser.tab.c parser.tab.h lex.yy.c lex.yy.h
%.o: %.c %.h
	gcc -g -c -o $@ $<

main: parser.tab.o lex.yy.o sym_table.o main.o
	gcc -o $@ sym_table.o parser.tab.o -lm lex.yy.o main.o

parser.tab.c: parser.y
	bison -d parser.y

parser_yacc.tab.c: parser.y
	yacc -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

clean:
	-rm main $(objects) $(c_files)