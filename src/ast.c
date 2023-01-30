/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ast.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abittel <abittel@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/01/30 13:48:27 by abittel           #+#    #+#             */
/*   Updated: 2023/01/31 00:28:06 by abittel          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "compiler.h"
#include "ft_tree/ft_tree.h"


t_node	*create_new_node(int	type, void	*data)
{
	t_node	*new_node;
	
	new_node = malloc (sizeof(t_node));
	new_node->type = type;
	new_node->datas = data;
	return (new_node);
}

t_tree	*create_parent_tree(t_tree	*sub_g, t_tree	*sub_d, int type, void	*data)
{
	t_tree	*new_tree;
	
	new_tree = ft_treenew((void *)create_new_node(type, data));
	new_tree->f_a = sub_g;
	new_tree->f_b = sub_d;
	//print_tree(new_tree);
	//printf("---------------------------------\n");
	return (new_tree);
}

void	print_tree(t_tree	*tree, int i)
{
	int	j = i;
	while (j-- > 0)
		printf("  ");
	if (tree)
		printf("ROOT->%d\n", ((t_node *)tree->content)->type);
	else
		return ;
	if (tree->f_b)
	{
		j = i;
		while (j-- > 0)
			printf("  ");
		printf("Droite->");
		print_tree(tree->f_b, i + 1);
	}
	if (tree->f_a)
	{
		j = i;
		while (j-- > 0)
			printf("\t");
		printf("Gauche->");
		print_tree(tree->f_a, i + 1);
	}
}