%option header-file="lex.yy.h"
%option noyywrap

%top{

  /* This goes at the top of the generated file */
  #include "parser.tab.h"

  #define YY_DECL    int fyylex (FYYSTYPE *yylval, FYYLTYPE *yylloc)

  /* Since they are defined globally in the parser
  implementation file, we can use yylloc and yylval
  as global variables. */
  extern FYYLTYPE fyyloc;
  extern FYYSTYPE fyylval;
  #include <string.h>
  extern int fyynerrs;

  #define YY_USER_ACTION \
    fyylloc.first_line = fyylloc.last_line; \
    fyylloc.first_column = fyylloc.last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            fyylloc.last_line++; \
            fyylloc.last_column = 0; \
        } \
        else { \
            fyylloc.last_column++; \
        } \
    }
}

letter [a-z]|[A-Z]
digit [0-9]
integer ("+"|"-")?{digit}+
exponent ("e"|"E"){integer}
scalar (({digit}+|({digit}+"."{digit}*)|("."{digit}+)){exponent}?)|(0[xX][0-9a-fA-F]+)

id ("_"|{letter})({letter}|{digit}|"_")*
newLine \n|\r|\r\n
comment ("//".{newLine})
true "true"|"T"|"True"
false "false"|"F"|"False"
skip ({newLine}|" "|\t|{comment})

%%
"acos" { return ACOS; }
"acosh" { return ACOSH; }
"asin" { return ASIN; }
"asinh" { return ASINH; }
"atan" { return ATAN; }
"atan2" { return ATAN2; }
"atanh" { return ATANH; }
"cbrt" { return CBRT; }
"ceil" { return CEIL; }
"cos" { return COS; }
"cosh" { return COSH; }
"exp" { return EXP; }
"fabs" { return FABS; }
"floor" { return FLOOR; }
"hypot" { return HYPOT; }
"log" { return LOG; }
"log10" { return LOG10; }
"pow" { return POW; }
"sin" { return SIN; }
"sinh" { return SINH; }
"sqrt" { return SQRT; }
"tan" { return TAN; }
"tanh" { return TANH; }
"deg2rad" { return DEG2RAD; }
"rad2deg" { return RAD2DEG; }

"pi"|"PI" { return PI; }
"e"|"E" { return E; }
"sqrt2"|"SQRT2" { return SQRT2; } 

"++" { return INCREMENT; }
"--" { return DECREMENT; }
"==" { return EQUAL; }
">>" { return RSHIFT; }
"<<" { return LSHIFT; }
"||" { return OR; }
"&&" { return AND; }

"+=" { return SUM; }
"-=" { return SUB; }
"*=" { return MUL; }
"/=" { return DIV; }
"%=" { return MODULE; }
"^=" { return EXPEQ; }
">>=" { return RSHIFTEQ; }
"<<=" { return LSHIFTEQ; }
"&="  { return ANDBIT; }
"|="  { return ORBIT; }
"," { return CM; }
";" { return S; }
":" { return C; }
"?" { return QM; }
"+" { return PLUS; }
"-" { return MINUS; }
"/" { return SLASH; }
"*" { return STAR; }
"^" { return CIRCUMFLEX; }
"=" { return EQ; }
"(" { return RO; }
")" { return RC; }
"{" { return BO; }
"}" { return BC; }
">" { return ABO; }
"<" { return ABC; }
"!" { return EM; }
"~" { return TILDE; }
"%" { return PERCENT; }
"|" { return PIPE; }
"&" { return AMPERSAND; }

{true} { return TRUE; }
{false} { return FALSE; }
{id} { fyylval.string = strdup(yytext);   return ID; }
{scalar} { fyylval.real_value = atof(yytext); return SCALAR; }
{skip} { ; } 

. {printf("Flet scanner. Syntax error at line %d:%d: %s\n", fyylloc.first_line, fyylloc.first_column, yytext); fyynerrs++;}
