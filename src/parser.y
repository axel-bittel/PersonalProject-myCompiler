%{
	#include <stdio.h>
	#include "ft_tree/ft_tree.h"
	#include "compiler.h"
	
	//#define YYDEBUG 1
	t_data	data;
%}
%union {
	int		val;
	char	*name;
	char	*type;
	char	op;
	void	*tree;
};
%token RETURN END_INST FUNCTION
%token IF ELSE_IF ELSE WHILE
%token BOOL_EQ BOOL_LEQ BOOL_GEQ BOOL_L BOOL_G
%token BRACKET_LEFT BRACKET_RIGHT ACCOLADE_LEFT ACCOLADE_RIGHT 
%token <name> IDENTIFIER 
%token <type> TYPE
%token <val> INTEGER
%token <op> OP_EQ OP_ADD OP_MINUS OP_MULT OP_DIV
%type  <tree> expr end_cond inter_cond inst_lst dec boucle cond arg arg_lst prog funct all call_arg_lst
%nonassoc OP_EQ
%right OP_ADD OP_MINUS
%right OP_MULT OP_DIV
%start all
%%
all 		:	prog all			{	data.ast = $1;	}
			|						{}
			;
prog		:	funct prog			{	$$ = create_parent_tree($2, $1, INSTRUCTION_NODE, 		0);	}
			|	dec END_INST prog	{	$$ = create_parent_tree($3, $1, INSTRUCTION_NODE, 		0);	}
			|					{$$ = 0;}
			;
funct		: FUNCTION IDENTIFIER BRACKET_LEFT arg_lst BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT 	{	
					$$ = create_parent_tree($7, $4, FUNCTION_NODE, $2);
				}
			;
arg_lst 	: arg 											{	$$ = create_parent_tree(0, $1, ARG_LIST_NODE, 0); }
			| arg ',' arg_lst 								{	$$ = create_parent_tree($3, $1, ARG_LIST_NODE, 0); }
			|												{	$$ = 0;	}
			;
arg 		: TYPE IDENTIFIER 	{ 
					char	*name = $2;
					char	*type = $1;
					t_symbol_table_elem *symbol = new_elem_table(name, TYPE_ARG, 0, 0, 0);
					if (!strcmp(type, "int"))
						symbol->type = TYPE_INT;
					else if (!strcmp(type, "bool"))
						symbol->type = TYPE_BOOL;
					else if (!strcmp(type, "float"))
						symbol->type = TYPE_FLOAT;
					$$ = create_parent_tree(0, 0, ARG_NODE, symbol);
				}
			;
inst_lst	: cond inst_lst {
					$$ = create_parent_tree($2, $1, INSTRUCTION_NODE, 		0);
			}
			| expr END_INST inst_lst {
					$$ = create_parent_tree($3, $1, INSTRUCTION_NODE, 		0);
			}
			| expr END_INST  {
					$$ = create_parent_tree(0, $1, INSTRUCTION_NODE, 		0);
			}
			| dec END_INST inst_lst {
					$$ = create_parent_tree($3, $1, INSTRUCTION_NODE, 		0);
			}
			| dec END_INST 		{
					$$ = create_parent_tree(0, $1, INSTRUCTION_NODE, 		0);
				}
			| boucle	inst_lst {
					$$ = create_parent_tree($2, $1, INSTRUCTION_NODE, 		0);
				}
			|	{	$$ = 0;}
			;
dec			: TYPE IDENTIFIER		{
					t_symbol_table_elem *symbol = new_elem_table($1, TYPE_VAR, 0, 0, 0);
					char	*inter = $1;
					if (!strcmp(inter, "int"))
						symbol->type = TYPE_INT;
					else if (!strcmp(inter, "bool"))
						symbol->type = TYPE_BOOL;
					else if (!strcmp(inter, "float"))
						symbol->type = TYPE_FLOAT;
					$$ = create_parent_tree(0, 0, LET_ID_NODE, $2);
				}
			| IDENTIFIER '=' expr {
				$$ = create_parent_tree( create_parent_tree(0, 0, ID_NODE, $1) , $3, EQ_NODE, 		0);
			}
			;
boucle		: WHILE BRACKET_LEFT expr BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT {
					$$ = create_parent_tree($6, $3, WHILE_NODE, 		0);
				}
			;
cond		: IF BRACKET_LEFT expr BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT inter_cond	{
					$$ = create_parent_tree($8, create_parent_tree($6, $3, IF_NODE, 		0), COND_NODE, 0);
				}
			| IF BRACKET_LEFT expr BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT end_cond		{
					$$ = create_parent_tree($8, create_parent_tree($6, $3, IF_NODE, 		0), INSTRUCTION_NODE, 0);
				}
			;
inter_cond	: ELSE_IF BRACKET_LEFT expr BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT end_cond	{
					$$ = create_parent_tree($8, create_parent_tree($6, $3, ELSEIF_NODE, 		0), INSTRUCTION_NODE, 0);
				}
			| ELSE_IF BRACKET_LEFT expr BRACKET_RIGHT ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT inter_cond {
					$$ = create_parent_tree($8, create_parent_tree($6, $3, ELSEIF_NODE, 		0), INSTRUCTION_NODE, 0);
				}
			|	{	$$ = 0;	}
			;
end_cond	: ELSE ACCOLADE_LEFT inst_lst ACCOLADE_RIGHT	{	
					$$ = create_parent_tree($3, 0, BOOL_L_NODE,0);	
				}
			;
call_arg_lst: IDENTIFIER ',' call_arg_lst 	{	$$ = create_parent_tree($3, create_parent_tree(0, 0, ID_NODE, $1), ARG_CALL_LIST_NODE, 		0);	}
			| IDENTIFIER					{	$$ = create_parent_tree(0, create_parent_tree(0, 0, ID_NODE, $1), ARG_CALL_LIST_NODE, 		0);	}
			|								{	$$ = 0;	}
			;
expr		: IDENTIFIER						{
					$$ = create_parent_tree(0, 0, ID_NODE, $1);		
				}	
			| INTEGER							{	
					int	*val = malloc(sizeof(int));
					*val = $1;
					$$ = create_parent_tree(0, 0, CONST_NODE, val);		
				}
			| IDENTIFIER OP_EQ expr 			{	$$ = create_parent_tree(create_parent_tree(0, 0, ID_NODE, $1), $3, EQ_NODE, 		0);	}
			| IDENTIFIER BRACKET_LEFT call_arg_lst BRACKET_RIGHT {	$$ = create_parent_tree(0, $3, CALL_NODE, 	$1);	}
			| expr OP_ADD expr 					{	$$ = create_parent_tree($1, $3, ADD_NODE, 		0);	}
			| expr OP_MINUS expr				{	$$ = create_parent_tree($1, $3, MINUS_NODE, 	0);	} 
			| expr OP_MULT expr					{	$$ = create_parent_tree($1, $3, MULT_NODE, 		0);	}
			| expr OP_DIV expr					{	$$ = create_parent_tree($1, $3, DIV_NODE, 		0);	}
			| expr BOOL_EQ expr					{	$$ = create_parent_tree($1, $3, BOOL_EQ_NODE, 	0);	}
			| expr BOOL_LEQ expr				{	$$ = create_parent_tree($1, $3, BOOL_LE_NODE, 	0);	}
			| expr BOOL_GEQ expr				{	$$ = create_parent_tree($1, $3, BOOL_GE_NODE, 	0);	}
			| expr BOOL_G expr					{	$$ = create_parent_tree($1, $3, BOOL_G_NODE, 	0);	}
			| expr BOOL_L expr					{	$$ = create_parent_tree($1, $3, BOOL_L_NODE, 	0);	}
			| BRACKET_LEFT expr BRACKET_RIGHT	{	$$ = $2;											}
			| RETURN expr						{	$$ = create_parent_tree(0, $2, RETURN_NODE, 	0);	}
			;
%%

#include "lex.yy.c"
void	yyerror(char *c)
{
	extern int yylineno;
	printf("Error at line %d: %s\n", yylineno, c);
}
int main()
{
	yyin = fopen("test.a", "r");
	data.ast = 0;
	data.table = 0;
	data.is_main = 1;
	#if YYDEBUG
        yydebug = 1;
    #endif
	if (yyparse())
		return (1);
	data.table = generate_new_table(data.ast);
	//print_tree(data.ast, 0);
	asm_generator(&data);
}