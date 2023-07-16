#include "error.h"

char ERROR_BUFFER[256];
extern FYYLTYPE fyylloc;

/* This function is invoked by yyparse()
whenever it runs into an error. */
void fyyerror(char const *message){
  printf("\033[0;31mError\033[0m "); /* Write in red */
  printf("on line:%d:%d :\t %s\n", fyylloc.first_line, fyylloc.first_column, message);
}

void fyyerror_fmt(char const *message, char const **par){
  sprintf(ERROR_BUFFER, message, par);
  fyyerror(ERROR_BUFFER);
}