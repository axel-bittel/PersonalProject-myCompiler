/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_lstnew.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abittel <abittel@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/07/27 19:54:10 by abittel           #+#    #+#             */
/*   Updated: 2022/01/27 10:35:37 by abittel          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "ft_tree.h"
#include <stdlib.h>
#include <stddef.h>

t_tree	*ft_treenew(void *content)
{
	t_tree	*res;

	res = (t_tree *)malloc(sizeof(t_tree));
	if (!res)
		return (NULL);
	res->f_a = NULL;
	res->f_b = NULL;
	res->content = content;
	return (res);
}
