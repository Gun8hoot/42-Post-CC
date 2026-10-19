#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

typedef struct s_list {
	void          *data;
	struct s_list *next;
} t_list;

extern int ft_list_size(t_list *begin_list);
extern void ft_list_push_front(t_list **begin_list, void *data);

int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	char *csv = strdup(argv[1]);
	int   n = 0;

	t_list *list = NULL;
	if (csv && *csv)
	{
		char *tok = strtok(csv, ",");
		while (tok) { ft_list_push_front(&list, tok); n++; tok = strtok(NULL, ","); }
	}

	int got = ft_list_size(list);

	while (list) { t_list *nx = list->next; free(list); list = nx; }
	free(csv);

	if (got != n)
	{
		printf("%s[-] ft_list_size : %s result differ!\nExpected: %d\nGot: %d\n%s",
			FR_RED, argv[2], n, got, RESET);
		return (1);
	}
	printf("%s[+] ft_list_size : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
