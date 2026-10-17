
#include "includes/main.h"
#include "includes/test_prototype.h"
#include <stdlib.h>

int		cmp(int *data1, int *data2)
{
	return (*data1 - *data2);
}

void	test(void)
{
	t_list *lst1;
	t_list *lst2;
	t_list *lst3;
	t_list *lst4;
	int		data = 42;
	int		data1 = 3;
	int		data2 = 1;
	int		data3 = 2;

	lst1 = malloc(sizeof(t_list));
	lst2 = malloc(sizeof(t_list));
	lst3 = malloc(sizeof(t_list));

	lst1->next = lst2;
	lst1->data = &data1;
	lst2->next = lst3;
	lst2->data = &data2;
	lst3->next = NULL;
	lst3->data = &data3;

	ft_list_sort(&lst1, &cmp);
}

int main(int argc, char **argv)
{
	test();
	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();
	test_read();
	test_strdup();
	test_calloc();
	test_atoi_base();

	return (0);
}
