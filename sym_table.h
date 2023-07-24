#ifndef SYM_TABLE_H
#define SYM_TABLE_H

typedef enum status{
  FOUND,
  NOT_FOUND,
  UPDATED
} status_e;

typedef enum symbolaction{ 
  UPDATE,
  INSERT,
  DELETE
} symbolaction_e;

typedef struct sym_entry{
  char  *name; /* Name of the symbol */
  int type; /* Type of symbol */
  symbolaction_e action;
  union
  {
    float real_value;
  } value; /* Value of symbol */
  struct sym_entry *next; /* Next node */
} sym_entry;

extern sym_entry *sym_table;

sym_entry *sym_table_put_scalar(char const *name, float value);
status_e sym_table_get_scalar(char const *name, float * val);
status_e sym_table_update_scalar(char const *name, float value);
void free_sym_table(void);
#endif
