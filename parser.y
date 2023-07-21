%define api.prefix {fyy}

%code top{
  /* This is the prologue section. This code goes
  on the top of the parser implementation file. */
  #include <stdio.h>
  #include <math.h>
  #include "sym_table.h"

  extern int fyynerrs;
  extern int fyylex(); //add in scanner declaraion
  extern int fyyerror();
  extern int fyyerror_fmt();
}

%code {
  /*PI is defined in Math.h library */
  #define DEG2RAD M_PI/180.0
  #define RAD2DEG 1/DEG2RAD

}

/* Bison uses type int as default for semantic values.
You may specify a different type with the syntax:
  #define YYSTYPE double
The following notation makes bison 
to use a union for store the
semantic value of tokens.*/
%union {
  char  *string;
  float real_value;
  int   boolean_value;
  int   hex_value;
}

/* The qualifier requires tells Bison to put
the following code before the declaration of YYSTYPE.
Since YYSTYPE contains a sym_entry, we need to include
sym_table.h first. 
In production version the symbol table could be substituted 
directly eith the bash variables table.
*/
%code requires {
  #include "sym_table.h"
}
%debug
%locations

%type   <real_value>    scalar_expr scalar
%type   <boolean_value> boolean_expr boolean

/* If you use the union notation, then you need to
specify the type of each non-terminal
among the types specified in the union.*/
%token                    CM S  QM PLUS MINUS C
                          SLASH STAR CIRCUMFLEX EQ RO RC
                          BO BC ABO ABC EM TILDE PERCENT PIPE 
                          AMPERSAND TRUE FALSE
                          ACOS ACOSH ASIN ASINH ATAN ATAN2 ATANH
                          CBRT CEIL COS COSH EXP POW FABS FLOOR 
                          LOG LOG10 SIN SINH SQRT TAN TANH HYPOT
                          DEG2RAD RAD2DEG PI E SQRT2
                          INCREMENT DECREMENT EQUAL 
                          RSHIFT LSHIFT OR AND
                          SUM SUB MUL DIV MODULE EXPEQ
                          RSHIFTEQ LSHIFTEQ ANDBIT ORBIT

%token    <string>        ID
%token    <real_value>    SCALAR

%left EQUAL RSHIFT LSHIFT 
%left OR 
%left AND
%left ACOS ACOSH ASIN ASINH ATAN ATAN2 ATANH CBRT CEIL COS COSH EXP POW FABS FLOOR LOG LOG10 SIN SINH SQRT TAN TANH HYPOT
%right DEG2RAD RAD2DEG PI E SQRT2
%left PLUS MINUS C PERCENT
%left STAR SLASH 
%left CIRCUMFLEX
%left AMPERSAND PIPE
%left ABO ABC
/*operate and assign*/
%right SUM SUB MUL DIV MODULE EXPEQ RSHIFTEQ LSHIFTEQ ANDBIT ORBIT 
%left UMINUS EM TILDE
%left INCREMENT DECREMENT
%right QM  EQ

%%
prog: statement_list {
  if(fyynerrs > 0)
    printf("\033[0;32mExpression not parsed. Number of errors: %d.\033[0m\n", fyynerrs);
};

statement_list: statement_list statement S | statement S ;

statement : assignment | op_assignment
              | scalar_expr   { printf("scalar expr:%.5f\n",$1); }
              | boolean_expr  { printf("boolean expr:%d\n",$1); }
              | error         { }
            ;
              
/* Assignments */
assignment: ID EQ scalar_expr
                  {
                    sym_table_put_scalar($1, $3);
                    printf("scalar assignment:%s = %.5f\n",$1, $3);
                  }
            |ID EQ boolean_expr 
                  {
                    sym_table_put_scalar($1, (float) $3);
                    printf("boolean assignment:%s = %d\n",$1, $3);
                  }
            ;

op_assignment: ID  SUM scalar_expr
                  {
                    
                    float val;
                    switch (sym_table_get_scalar($1, &val)) {
                      case FOUND :
                        float new_val = val + $3;
                        if(sym_table_update_scalar($1, new_val) != UPDATED ){
                          fyyerror_fmt("Generic error during update of %s value.", $1);
                          YYERROR;
                        }
                        break;
                      case NOT_FOUND:
                      default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                    }
                    printf("scalar assignment:%s = %.5f\n",$1, val);
                  }  
                |ID  SUB scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            float new_val = val - $3;
                            if(sym_table_update_scalar($1, new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f\n",$1, val);
                      } 
                |ID MUL scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            float new_val = val * $3;
                            if(sym_table_update_scalar($1, new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f\n",$1, val);
                      } 
                |ID  DIV scalar_expr 
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            float new_val = val / $3;
                            if(sym_table_update_scalar($1, new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f\n",$1, val);
                      } 
                |ID  MODULE scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = ((int)val) % (int) $3;
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f\n",$1, val);
                      }
                |ID  EXPEQ scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = pow( ((int)val),(int) $3);
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f\n",$1, val);
                      } 
                |ID  LSHIFTEQ scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = ((int)val) << (int) $3;
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f \n",$1, val);
                      } 
                |ID  RSHIFTEQ scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = ((int)val) >> (int) $3;
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f \n",$1, val);
                      }  
                |ID  ANDBIT scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = ((int)val) & (int) $3;
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f \n",$1, val);
                      } 
                |ID  ORBIT scalar_expr
                      {
                        float val;
                        switch (sym_table_get_scalar($1, &val)) {
                          case FOUND :
                            int new_val = ((int)val) | (int) $3;
                            if(sym_table_update_scalar($1, (float) new_val) != UPDATED ){
                              fyyerror_fmt("Generic error during update of %s value.", $1);
                              YYERROR;
                            }
                            break;
                          case NOT_FOUND:
                          default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
                        }
                        printf("scalar assignment:%s = %.5f \n",$1, val);
                      }
            ; 
          
/* Scalar expressions */
scalar_expr: RO scalar_expr RC {$$ = $2;}
          | BO scalar_expr BC {$$ = $2;}
          | scalar_expr PLUS scalar_expr  {$$ = $1 + $3;} 
          | scalar_expr MINUS scalar_expr  {$$ = $1 - $3;} 
          | scalar_expr STAR scalar_expr  {$$ = $1 * $3;} 
          | scalar_expr SLASH scalar_expr  {$$ = $1 / $3;} 
          | scalar_expr STAR STAR  {$$ = pow($1, 2);} 
          | scalar_expr CIRCUMFLEX scalar_expr  {$$ = pow($1, $3);} 
          | scalar {$$ = $1;}
          | MINUS scalar_expr {$$ = -$2;} %prec UMINUS
          | ACOS RO scalar_expr RC {$$ = acos($3) ;}
          | ACOSH RO scalar_expr RC {$$ = acosh($3) ;}
          | ASIN RO scalar_expr RC  {$$ = asin($3) ;}
          | ASINH RO scalar_expr RC  {$$ = asinh($3) ;}
          | ATAN RO scalar_expr RC  {$$ = atan($3) ;}
          | ATAN2 RO scalar_expr CM scalar_expr RC  {$$ = atan2($3, $5) ;}
          | ATANH RO scalar_expr RC  {$$ = atanh($3) ;}
          | CBRT RO scalar_expr RC  {$$ = cbrt($3) ;}
          | CEIL RO scalar_expr RC {$$ = ceil($3) ;}
          | COS RO scalar_expr RC  {$$ = cos($3) ;}
          | COSH RO scalar_expr RC  {$$ = cosh($3) ;}
          | EXP RO scalar_expr RC  {$$ = exp($3) ;} 
          | FABS RO scalar_expr RC  {$$ = fabs($3) ;}
          | FLOOR RO scalar_expr RC  {$$ = floor($3) ;}
          | HYPOT RO scalar_expr CM scalar_expr RC  {$$ = hypot($3, $5) ;}
          | LOG RO scalar_expr RC  {$$ = log($3) ;}
          | LOG10 RO scalar_expr RC  {$$ = log10($3) ;}
          | POW RO scalar_expr CM scalar_expr RC {$$ = pow($3, $5) ;}
          | SIN RO scalar_expr RC {$$ = sin($3) ;}
          | SINH RO scalar_expr RC {$$ = sinh($3) ;}
          | SQRT RO scalar_expr RC {$$ = sqrt($3) ;}
          | TAN RO scalar_expr RC {$$ = tan($3) ;}
          | TANH RO scalar_expr RC {$$ = tanh($3) ;}
          | DEG2RAD RO scalar_expr RC 
            {
              if ($3<0) $3 = 360 + $3;
              $$ = $3 * DEG2RAD ;
            }
          | RAD2DEG RO scalar_expr RC {$$ = $3 * RAD2DEG ;}
          | ID INCREMENT
            {
              float val;
              switch (sym_table_get_scalar($1, &val)) {
                case FOUND :
                  if(sym_table_update_scalar($1, val+1) == UPDATED ){
                    $$ = val; 
                  }else{
                    fyyerror_fmt("Generic error during update of %s value.", $1);
                    YYERROR;
                  }
                  break;
                case NOT_FOUND:
                default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
              }
            }  
          | ID DECREMENT 
            {
              float val;
              switch (sym_table_get_scalar($1, &val)) {
                case FOUND :
                  if(sym_table_update_scalar($1, val-1) == UPDATED ){
                    $$ = val; 
                  }else{
                    fyyerror_fmt("Generic error during update of %s value.", $1);
                    YYERROR;
                  }
                  break;
                case NOT_FOUND:
                default : fyyerror_fmt("Symbol %s not found.", $1); YYERROR; break;
              }
            }  
          | DECREMENT ID 
            {
              float val;
              switch (sym_table_get_scalar($2, &val)) {
                case FOUND :
                  val -= 1;
                  if(sym_table_update_scalar($2, val) == UPDATED ){
                    $$ = val; 
                  }else{
                    fyyerror_fmt("Generic error during update of %s value.", $2);
                    YYERROR;
                  }
                  break;
                case NOT_FOUND:
                default : fyyerror_fmt("Symbol %s not found.", $2); YYERROR; break;
              }
            }  
          | INCREMENT ID 
            {
              float val;
              switch (sym_table_get_scalar($2, &val)) {
                case FOUND :
                  val += 1;
                  if(sym_table_update_scalar($2, val) == UPDATED ){
                    $$ = val; 
                  }else{
                    fyyerror_fmt("Generic error during update of %s value.", $2);
                    YYERROR;
                  }
                  break;
                case NOT_FOUND:
                default : fyyerror_fmt("Symbol %s not found.", $2); YYERROR; break;
              }
            } 
          | scalar_expr AMPERSAND scalar_expr 
            {
              $$ = ((int)$1 & (int)$3); 
            } 
          | scalar_expr PIPE scalar_expr 
            {
              $$ = ((int)$1 | (int)$3); 
            } 
          | scalar_expr LSHIFT scalar_expr 
            {
              $$ = ((int)$1 << (int)$3); 
            } 
          | scalar_expr RSHIFT scalar_expr 
            {
              $$ = ((int)$1 >> (int)$3); 
            } 
          | scalar_expr PERCENT scalar_expr 
            {
              $$ = ((int)$1 % (int)$3); 
            } 
          | boolean_expr QM scalar_expr C scalar_expr 
            {
              $$ = $1 ? $3 : $5;
            }
          ;

scalar :  ID  
          {
            float val;
            switch (sym_table_get_scalar($1, &val)) {
              case FOUND :
                $$ = val; 
                free((void *)$1);
                break;
              case NOT_FOUND:
              default : {
                fyyerror_fmt("Symbol %s not found.\n", $1); 
                YYERROR;
                break;
              }
            }
          } 
          | SCALAR {$$ = $1;}
          | PI {$$ = M_PI; }
          | E {$$ = M_E; }
          | SQRT2 {$$ = M_SQRT2; }
          | TILDE ID 
            {
              float val;
              switch (sym_table_get_scalar($2, &val)) {
                case FOUND :
                  $$ = ~((int)val); 
                  free((void *)$2);
                  break;
                case NOT_FOUND:
                default : fyyerror_fmt("Symbol %s not found.", $2); YYERROR; break;
              }
            } 
        ;
        
boolean_expr :  boolean { $$ = $1; }
              | RO boolean_expr RC { $$ = $2; }
              | BO boolean_expr BC { $$ = $2; }
              | EM scalar_expr { $$ = !(int)$2; } 
              | EM boolean_expr { $$ = !(int)$2; } 
              | scalar_expr AND scalar_expr { $$ = ($1 && $3); }
              | scalar_expr OR scalar_expr { $$ = ($1 || $3); }
              | boolean_expr AND boolean_expr { $$ = ($1 && $3); }
              | boolean_expr OR boolean_expr { $$ = ($1 || $3); }
              | scalar_expr ABO scalar_expr { $$ = $1 > $3; } 
              | scalar_expr ABC scalar_expr { $$ = $1 < $3; }
              | scalar_expr ABO EQ scalar_expr { $$ = $1 >= $4; } 
              | scalar_expr ABC EQ scalar_expr { $$ = $1 <= $4; }
              /*No partial eq supported */
              | scalar_expr EQUAL scalar_expr { 
                fyyerror ( "PartialEq is not supported. Generally you cannot evaluate equality between two floats.");
                YYERROR;
              } 
            ;

boolean : TRUE {$$ = 1; }
          | FALSE {$$ = 0; }
        ;

