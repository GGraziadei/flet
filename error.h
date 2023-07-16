#ifndef ERROR_H
#define ERROR_H

#include "lex.yy.h"
#include "parser.tab.h"
#include "sym_table.h"

void fyyerror(char const *message);
void fyyerror_fmt(char const *message, char const **par);

#endif