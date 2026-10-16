
#include "includes/main.h"
#include <stdlib.h>

void	test(void)
{
	t_list *lst1;
	t_list *lst2;
	t_list *lst3;
	t_list *lst4;
	int		data = 42;

	lst1 = malloc(sizeof(t_list));
	lst2 = malloc(sizeof(t_list));
	lst3 = malloc(sizeof(t_list));

	lst1->next = lst2;
	lst2->next = lst3;
	lst3->next = NULL;

	ft_list_push_front(&lst1, &data);
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
