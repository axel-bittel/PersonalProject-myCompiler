#include "ft_tree/ft_tree.h"
#include "compiler.h"


t_symbol_table_elem	*get_elem_by_id(t_data	*data, char	*name)
{
	t_symbol_table_elem	*elem;

	elem = data->table->begin;
	while (elem)
	{
		if (strcmp(elem->name, name) == 0)
			return (elem);
		elem = elem->next;
	}
	return (NULL);
}

char	*get_name_reg(int nb_reg)
{
	char	*name;
	if (nb_reg == 1)
		name = "%rax";
	else if (nb_reg == 2)
		name = "%rbx";
	else if (nb_reg == 3)
		name = "%rcx";
	else if (nb_reg == 4)
		name = "%rdx";
	return (name);
}

//part = id du 
//nb_reg reprensente le registre dans lequel on va mettre la valeur (rax = 1, rbx = 2, rcx = 3, rdx = 4)
void	rec_asm_generator(t_data	*data, t_tree	*tree, int part, char	*name, int res_reg)
{
	if (((t_node*)tree->content)->type == INSTRUCTION_NODE)
	{
		if (tree->f_b)
			rec_asm_generator(data, tree->f_b, part, name, 1);
		if (tree->f_a)
			rec_asm_generator(data, tree->f_a, part, name, 1);
	}
	else if (((t_node*)tree->content)->type == FUNCTION_NODE)
	{
		t_symbol_table_elem	*elem = get_elem_by_id(data, ((t_node*)tree->content)->datas);
		printf( "%s:\n", elem->name);
		printf( ".0_%s:\npushq %%rbp\nmovq %%rsp, %%rbp\nsubq $%d, %%rsp\n", elem->name, (int)elem->offset);
		if (tree->f_a)
			rec_asm_generator(data, tree->f_a, 1, ((t_symbol_table_elem*)tree->content)->name, 1);
		printf( "movq %%rbp, %%rsp\npopq %%rbp\nret\n");
	}
	else if (((t_node*)tree->content)->type == CONST_NODE)
		printf( "movq $%d, %s\n", *(int*)((t_node*)tree->content)->datas, get_name_reg(res_reg));
	else if (((t_node*)tree->content)->type == ID_NODE)
		printf( "movq -%d(%%rbp), %s\n", (int)get_elem_by_id(data, ((t_node*)tree->content)->datas)->offset, get_name_reg(res_reg));
	else if (((t_node*)tree->content)->type == ADD_NODE)
	{
		rec_asm_generator(data, tree->f_a, part, name, res_reg);
		printf( "pushq %s\n", get_name_reg(res_reg));
		rec_asm_generator(data, tree->f_b, part, name, (res_reg == 2 ? 1 : 2));
		printf( "popq %s\n", get_name_reg(res_reg));
		printf( "addq %s, %s\n", get_name_reg((res_reg == 2 ? 1 : 2)), get_name_reg(res_reg));	
	}
	else if (((t_node*)tree->content)->type == MINUS_NODE)
	{
		rec_asm_generator(data, tree->f_a, part, name, res_reg);
		printf( "pushq %s\n", get_name_reg(res_reg));
		rec_asm_generator(data, tree->f_b, part, name, (res_reg == 2 ? 1 : 2));
		printf( "popq %s\n", get_name_reg(res_reg));
		printf( "subq %s, %s\n", get_name_reg((res_reg == 2 ? 1 : 2)), get_name_reg(res_reg));	
	}
	else if (((t_node*)tree->content)->type == MULT_NODE)
	{
		rec_asm_generator(data, tree->f_a, part, name, res_reg);
		printf( "pushq %s\n", get_name_reg(res_reg));
		rec_asm_generator(data, tree->f_b, part, name, (res_reg == 2 ? 1 : 2));
		printf( "popq %s\n", get_name_reg(res_reg));
		printf( "imulq %s, %s\n", get_name_reg((res_reg == 2 ? 1 : 2)), get_name_reg(res_reg));	
	}
	else if (((t_node*)tree->content)->type == DIV_NODE)
	{
		if (res_reg != 1)
			printf( "pushq %s\n", get_name_reg(1));
		rec_asm_generator(data, tree->f_a, part, name, 1);
		printf( "pushq %s\n", get_name_reg(1));
		rec_asm_generator(data, tree->f_b, part, name, (res_reg == 2 ? 1 : 2));
		printf( "popq %s\n", get_name_reg(1));
		printf( "div %s\n", get_name_reg((res_reg == 2 ? 1 : 2)));
		if (res_reg != 1)
			printf( "movq %s, %s\npopq %s\n", get_name_reg(res_reg), get_name_reg(1) ,get_name_reg(1));
	}
}

void	asm_generator(t_data	*data)
{
	printf( ".text\n");
	if (data->is_main)
		printf(".global _start\n _start:\ncall main\n\
movq %%rax, %%rbx\nmovq $1, %%rax\nint $0x80\n");
	rec_asm_generator(data, data->ast, 0, NULL, 1);
}