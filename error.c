/*Copyright (C) 2023 Gianluca Graziadei - Stefano Scanzio

 This file is part of Flet library.

    Flet library is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Flet library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Flet library.  If not, see <http://www.gnu.org/licenses/>.
 * */

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