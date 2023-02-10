#ifndef COMPILER_H
#define COMPILER_H

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "ft_tree/ft_tree.h"

#define COND_NODE			19	//NODE FOR BEGIN CONDITION
#define IF_NODE 			0	//NODE FOR IF
#define ELSEIF_NODE     	1	//NODE FOR ELSE IF
#define ELSE_NODE		    2	//NODE FOR ELSE
#define RETURN_NODE			23	//NODE FOR RETURN OF FUNCTION
#define CALL_NODE			24	//NODE CALL FUNCTION

#define ADD_NODE			4	//NODE FOR ADDITION
#define MINUS_NODE	    	5	//NODE FOR SUBSTRACTION
#define MULT_NODE		    6	//NODE FOR MULTIPLICATION
#define DIV_NODE			7	//NODE FOR DIVISION
#define EQ_NODE				8	//NODE FOR EQUALITY

#define BOOL_EQ_NODE		9	//NODE FOR ==
#define BOOL_L_NODE    		10	//NODE FOR <
#define BOOL_G_NODE    		11	//NODE FOR >
#define BOOL_LE_NODE		12	//NODE FOR <=
#define BOOL_GE_NODE		13	//NODE FOR >=

#define INSTRUCTION_NODE	14	//NODE FOR INSTRUCTION
#define FUNCTION_NODE		15	//NODE FOR FUNCTION

#define WHILE_NODE			16	//NODE FOR WHILE

#define CONST_NODE			17	//NODE FOR CONST
#define	ID_NODE				18	//NODE FOR ID (VAR)
#define	LET_ID_NODE			20	//NODE FOR DECLARATION OF ID (VAR)

#define ARG_NODE			21	//NODE FOR ARGUMENT OF FUNCTION
#define ARG_LIST_NODE		22	//NODE FOR LIST OF ARGUMENT OF FUNCTION
#define ARG_CALL_LIST_NODE	25	//NODE FOR LIST OF ARGUMENT OF FUNCTION

//AST
typedef struct	s_node
{
	char	type;
	void	*datas;
}				t_node;

void	print_tree(t_tree	*tree, int i);
t_node	*create_new_node(int	type, void	*data);
t_tree	*create_parent_tree(t_tree	*sub_g, t_tree	*sub_d, int type, void	*data);

#define TYPE_VAR		0 	//ID VAR
#define TYPE_ARG		2	//ID ARG
#define TYPE_FUNCTION	1	//ID FUNCTION

#define TYPE_INT		0	
#define TYPE_FLOAT		1	
#define TYPE_BOOL		3	
#define TYPE_PTR		4	

//SYMBOL TABLE
typedef	struct	s_symbol_table_elem
{
	char	*name;
	char	type_symbol;
	char	type;
	short 	nb_args;
	int		line_declaration;
	unsigned long	long int	offset;
	struct s_symbol_table_elem*	next;
}				t_symbol_table_elem;

typedef	struct	s_symbol_table
{
	int					size;
	t_symbol_table_elem		*begin;
	t_symbol_table_elem		*end;
}				t_symbol_table;

typedef	struct	s_data
{
	t_symbol_table	*table;
	t_tree			*ast;	
	char			is_main;
}				t_data;

int	add_element_in_table(t_symbol_table *table, t_symbol_table_elem *elem);
t_symbol_table	*new_elem_table(char	*name, char	type_symbol, char	type, short nb_args, int line_declaration);
t_symbol_table	*new_table();
t_symbol_table	*generate_new_table(t_tree *tree);
void			asm_generator(t_data	*data);	
#endif