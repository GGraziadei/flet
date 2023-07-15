#include "error.h"

char ERROR_BUFFER[256];
extern YYLTYPE yylloc;

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