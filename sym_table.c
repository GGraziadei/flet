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

#include <string.h>
#include <stdlib.h>
#include "sym_table.h"
#include "parser.tab.h"
#include <string.h>

/* Function used to push an entry in the symbol table (Scalar) */
sym_entry *sym_table_put_scalar(char const *name, float value){
  float val;
  if(sym_table_get_scalar(name, &val) == FOUND )
    return NULL;
  sym_entry *new_node = (sym_entry *) malloc(sizeof(sym_entry));
  new_node->name = malloc( (strlen(name)+1) * sizeof(char)  );
  strcpy(new_node->name, name); //
  new_node->type = SCALAR;
  new_node->action = INSERT;
  (new_node->value).real_value = value;
  new_node->next = sym_table;
  sym_table = new_node;
  return new_node;
}

/* Function used to push an entry in the symbol table (Scalar) */
status_e sym_table_update_scalar(char const *name, float value){
  
  if(sym_table == NULL )
    return NOT_FOUND;

  for (sym_entry *p = sym_table; p; p = p->next)
    if(strcmp (p->name, name) == 0){
       p->value.real_value = value;
       return UPDATED;
    }
    
  return NOT_FOUND;
}

/* Function used to update an entry of the symbol table (scalar)*/
status_e sym_table_get_scalar(char const *name, float* val){
  
  if(sym_table == NULL )
    return NOT_FOUND;
  
  for (sym_entry *p = sym_table; p; p = p->next)
    if(strcmp (p->name, name) == 0){
      *val = p->value.real_value;
      return FOUND;
    }
  return NOT_FOUND;
}

/* Function used to free the symbol table */
void free_sym_table(){
  sym_entry *p = sym_table;
  sym_entry *n = NULL;
  while(p != NULL) {
    free((void *)p->name);
    n = p->next;
    free(p);
    p = n;
  }
  sym_table = NULL;
}
