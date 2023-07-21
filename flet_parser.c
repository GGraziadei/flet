#include "flet_parser.h"

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