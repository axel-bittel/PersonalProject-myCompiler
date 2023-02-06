#include "compiler.h"
#include "ft_tree/ft_tree.h"

int	add_element_in_table(t_symbol_table *table, t_symbol_table_elem *elem)
{
	if (!table)
		return (0);
	if (table->size == 0)
		table->end = table->begin = elem;
	else 
		table->end = table->end->next = elem;
	table->size++;
	return (1);
}

t_symbol_table	*new_elem_table(char	*name, char	type_symbol, char	type, short nb_args, int line_declaration)
{
	t_symbol_table_elem	*new_elem;

	new_elem = malloc(sizeof(t_symbol_table_elem));
	new_elem->name = strdup(name);
	new_elem->type_symbol = type_symbol;
	new_elem->type = type;
	new_elem->nb_args = nb_args;
	new_elem->line_declaration = line_declaration;
	new_elem->next = NULL;
	return (new_elem);
}

t_symbol_table	*new_table()
{
	t_symbol_table	*new_table;

	new_table = malloc(sizeof(t_symbol_table));
	new_table->size = 0;
	new_table->begin = NULL;
	new_table->end = NULL;
	return (new_table);
}

static int	rec_generate_new_table(t_tree *tree, t_symbol_table *table)
{
	t_node	*node;
	t_symbol_table_elem	*elem;

	if (!tree)
		return (0);
	node = tree->content;
	if (node->type == FUNCTION_NODE)
	{
		elem = new_elem_table(node->datas, TYPE_FUNCTION, TYPE_PTR, 0, 0);
		add_element_in_table(table, elem);
		if (tree->f_b)
			rec_generate_new_table(tree->f_b, table);
		if (tree->f_a)
			rec_generate_new_table(tree->f_b, table);	
	}
	else if (node->type == ARG_LIST_NODE)
	{
		if (tree->f_b)
		{
			elem = tree->f_b->content;
			add_element_in_table(table, elem);
		}
		if (tree->f_a)
			rec_generate_new_table(tree->f_b, table);	
	}
	else if (node->type == LET_ID_NODE)
	{
		elem = new_elem_table(node->datas, TYPE_VAR, TYPE_PTR, 0, 0);
		add_element_in_table(table, elem);
	}
	return (1);
}

t_symbol_table	*generate_new_table(t_tree *tree)
{
	t_symbol_table	*table;

	table = new_table();
	rec_generate_new_table(tree, table);
	return (table);
}	