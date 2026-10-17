
#include "includes/main.h"
#include "includes/test_prototype.h"
#include <stdlib.h>
#include <string.h>

int		cmp(void *data1, void *data2)
{
	if (!data1 || !data2) return 0;
	return (*(int *)data1 - *(int *)data2);
}

void	dbg_ft_list_show(t_list *lst)
{
	size_t	elem = 0;
	while (lst != NULL)
	{
		printf("%ld : %s\n", elem, (char*)lst->data);
		elem++;
		lst = lst->next;
	}
}

void	test(void)
{
	t_list *lst1;
	t_list *lst2;
	t_list *lst3;
	t_list *lst4;
	int		data1 = 3;
	int		data2 = 42;
	int		data3 = 2;

	lst1 = malloc(sizeof(t_list));
	lst2 = malloc(sizeof(t_list));
	lst3 = malloc(sizeof(t_list));

	lst1->next = lst2;
	lst1->data = strdup("string3");
	lst2->next = lst3;
	lst2->data = strdup("string2");
	lst3->next = NULL;
	lst3->data = strdup("string1");

	ft_list_sort(&lst1, (int (*)(void *, void *))&ft_strcmp);
	dbg_ft_list_show(lst1);
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
