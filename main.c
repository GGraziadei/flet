#include <stdio.h>
#include "lex.yy.h"
#include "parser.tab.h"
#include "sym_table.h"

extern int yyparse (void);
extern int yydebug;
extern YYLTYPE yylloc;

sym_entry *sym_table = NULL; /* Symbol table */
char ERROR_BUFFER[256];

/* This function is invoked by yyparse()
whenever it runs into an error. */
void yyerror(char const *message){
  printf("\033[0;31mError\033[0m "); /* Write in red */
  printf("on line:%d:%d :\t %s\n", yylloc.first_line, yylloc.first_column, message);
}

void yyerror_fmt(char const *message, char const **par){
  sprintf(ERROR_BUFFER, message, par);
  yyerror(ERROR_BUFFER);
}

int main(int argc, char const *argv[]) {
  yyin = fopen(argv[1], "r");
  yydebug = 0;
  int result_code = yyparse();
  fclose(yyin);
  free_sym_table();
  return result_code;
}
