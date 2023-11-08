%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines;
int pos_start;
int pos_end;

void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/*****************声明和选项设置  end*****************/

%}


%%
 /* to do for students */
 /* two cases for you, pass_node will send flex's token to bison */
\+ 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ADD;}
"-"  {pos_start=pos_end;pos_end+=yyleng; pass_node(yytext);return SUB;}
"*"  { pos_start=pos_end;pos_end+=yyleng;pass_node(yytext);return MUL;}
"/"  { pos_start=pos_end;pos_end+=yyleng;pass_node(yytext);return DIV;}
","  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return COMMA; }
";"  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return SEMICOLON; }
"="  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ASSIGN; }
"int"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INT; }
"float" { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOAT; }
"void"  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return VOID; }
\n   {lines++; pos_start=pos_end=0;}
\r\n|\r  { lines++;  pos_end = 0; }
\t    {pos_start=pos_end; pos_end +=yyleng;}
" "   {pos_start=pos_end; pos_end+=yyleng;}
"("   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LPAREN; }
")"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RPAREN; }
"["   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LBRACKET; }
"]"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RBRACKET; }
"{"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LBRACE; }
"}"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RBRACE; }
"<"    { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LT; }
">"    { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return GT; }
"<="   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LTE; }
">="   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return GTE; }
"!="   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return NE; }
"=="   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return EQ; }
"if"       { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return IF; }
"else"    { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ELSE; }
"while"   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return WHILE; }
"for"     { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FOR; }
"return"  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RETURN; }
[0-9]+  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INT_NUM; }
[0-9]+\.|[0-9]*\.[0-9]+ { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOAT_NUM; }
[A-Za-z]+  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext);return ID ;}
"/*"((("*"[^/])?)|[^*])*"*/"  {pos_start = pos_end; pos_end += strlen(yytext);}
. { pos_start = pos_end; pos_end++; return ERROR; }

 /****请在此补全所有flex的模式与动作  end******/
%%
