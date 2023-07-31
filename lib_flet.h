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

#ifndef FLET_PARSER_H
#define FLET_PARSER_H


int str_buf_flet(char* buf, int debug_mode);
int file_flet(char* file_name, int debug_mode);

#endif