#ifndef FLET_PARSER_H
#define FLET_PARSER_H

#include <stdio.h>
#include "lex.yy.h"
#include "parser.tab.h"
#include "sym_table.h"

extern int yyparse (void);
extern int yydebug;

sym_entry *sym_table = NULL; /* Symbol table */
int str_buf_flet(char* buf, int debug_mode);
int file_flet(char* file_name, int debug_mode);

int file_flet(char* file_name, int debug_mode){
  yyin = fopen(file_name, "r");
  yydebug = debug_mode;
  int result_code = yyparse();
  fclose(yyin);
  free_sym_table();
  return result_code;
}

int str_buf_flet(char* buf, int debug_mode){
    yy_scan_string(buf);
    yydebug = debug_mode;
	int result_code = yyparse();
    free_sym_table();
    return result_code;
}

#endif