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

#include "lib_flet.h"

#include <stdio.h>
#include "lex.yy.h"
#include "parser.tab.h"
#include "sym_table.h"

extern int fyyparse (void);
extern int fyydebug;

sym_entry *sym_table = NULL; 

int file_flet(char* file_name, int debug_mode){
  yyin = fopen(file_name, "r");
  fyydebug = debug_mode;
  int result_code = fyyparse();
  fclose(yyin);
  free_sym_table();
  return result_code;
}

int str_buf_flet(char* buf, int debug_mode){
  yy_scan_string(buf);
  fyydebug = debug_mode;
  int result_code = fyyparse();
  free_sym_table();
  return result_code;
}