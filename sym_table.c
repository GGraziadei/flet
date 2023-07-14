#include <string.h>
#include <stdlib.h>
#include "sym_table.h"
#include "parser.tab.h"

/* Function used to push an entry in the symbol table (Scalar) */
sym_entry *sym_table_put_scalar(char const *name, float value){
  float val;
  if(sym_table_get_scalar(name, &val) == FOUND )
    return NULL;
  sym_entry *new_node = (sym_entry *) malloc(sizeof(sym_entry));
  new_node->name = name;
  new_node->type = SCALAR;
  (new_node->value).real_value = value;
  new_node->next = sym_table;
  sym_table = new_node;
  return new_node;
}

/* Function used to push an entry in the symbol table (Scalar) */
status_e sym_table_update_scalar(char const *name, float value){
  
  for (sym_entry *p = sym_table; p; p = p->next)
    if(strcmp (p->name, name) == 0){
       p->value.real_value = value;
       return UPDATED;
    }
    
  return NOT_FOUND;
}

/* Function used to update an entry of the symbol table (scalar)*/
status_e sym_table_get_scalar(char const *name, float* val){
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
}
