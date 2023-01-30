#ifndef COMPILER_H
#define COMPILER_H

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "ft_tree/ft_tree.h"

#define COND_NODE			19
#define IF_NODE 			0
#define ELSEIF_NODE     	1
#define ELSE_NODE		    2

#define ADD_NODE			4
#define MINUS_NODE	    	5
#define MULT_NODE		    6
#define DIV_NODE			7
#define EQ_NODE				8

#define BOOL_EQ_NODE		9
#define BOOL_L_NODE    		10
#define BOOL_G_NODE    		11
#define BOOL_LE_NODE		12
#define BOOL_GE_NODE		13

#define INSTRUCTION_NODE	14
#define FUNCTION_NODE		15

#define WHILE_NODE			16

#define CONST_NODE			17
#define	ID_NODE				18
#define	LET_ID_NODE			20

#define ARG_NODE			21

typedef struct	s_node
{
	char	type;
	void	*datas;
}				t_node;

typedef	struct	s_symbol_table_elem
{
	char	*name;
	char	type_symbol;
	char	type;
	short 	nb_args;
	int		line_declaration;
}				t_symbol_table_elem;

typedef	struct	s_symbol_table
{
	t_symbol_table_elem	*elems;
	int					size;
	struct	s_symbol_table		*next;
}				t_symbol_table;

typedef	struct	s_data
{
	t_symbol_table	*table;
	t_tree			*ast;	
}				t_data;

void	print_tree(t_tree	*tree, int i);
t_node	*create_new_node(int	type, void	*data);
t_tree	*create_parent_tree(t_tree	*sub_g, t_tree	*sub_d, int type, void	*data);
#endif