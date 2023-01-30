%{
#include<stdio.h>
#include<string.h>
%}

digit [0-9]
letter [a-zA-Z]
id {letter}({letter}|{digit})*
integer [1-9]{digit}*
ws  [ \t\n]+
%%

function {
	return FUNCTION;
}
int {
  return TYPE;
}
return {
  return RETURN;
}
if {
  return IF;
}
"else if" {
  return ELSE_IF;
}
else {
  return ELSE;
}
while {
  return WHILE;
}

{integer} {
  yylval.val = atoi(yytext);
  return INTEGER;
}
{id} {
  yylval.name = strdup(yytext);
  return IDENTIFIER;
}

"=" {
  yylval.op = '=';
  return OP_EQ;
}
"+" {
  yylval.op = '+';
  return OP_ADD;
}
"-" {
  yylval.op = '-';
  return OP_MINUS;
}
"*" {
  yylval.op = '*';
  return OP_MULT;
}
"/" {
  yylval.op = '/';
  return OP_DIV;
}

"(" {
  return BRACKET_LEFT;
}
")" {
  return BRACKET_RIGHT;
}
"{" {
  return ACCOLADE_LEFT;
}
"}" {
  return ACCOLADE_RIGHT;
}
";" {
  return END_INST;
}
"==" {
  return BOOL_EQ;
}
"<=" {
  return BOOL_LEQ;
}
">=" {
  return BOOL_GEQ;
}
"<" {
  return BOOL_L;
}
">" {
  return BOOL_G;
}
{ws} { }

. {
	yyerror("Parse error");
}

%%

int	yywrap()
{
	return (1);
}