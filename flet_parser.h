#ifndef FLET_PARSER_H
#define FLET_PARSER_H

#include <stdio.h>
#include "lex.yy.h"
#include "parser.tab.h"
#include "sym_table.h"

extern int fyyparse (void);
extern int fyydebug;

sym_entry *sym_table = NULL; /* Symbol table */
int str_buf_flet(char* buf, int debug_mode);
int file_flet(char* file_name, int debug_mode);

int str_buf_flet(char* buf, int debug_mode);
int file_flet(char* file_name, int debug_mode);

#endif