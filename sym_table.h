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
