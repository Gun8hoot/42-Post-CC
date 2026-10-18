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

extern void ft_list_push_front(t_list **begin_list, void *data);

int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	char *csv = strdup(argv[1]);
	char *tokens[1024];
	int   n = 0;

	if (csv && *csv)
	{
		char *tok = strtok(csv, ",");
		while (tok && n < 1024) { tokens[n++] = tok; tok = strtok(NULL, ","); }
	}

	t_list *list = NULL;
	for (int i = 0; i < n; i++)
		ft_list_push_front(&list, tokens[i]);

	int ok = 1;
	t_list *cur = list;
	for (int i = n - 1; i >= 0; i--)
	{
		if (!cur || cur->data != tokens[i]) { ok = 0; break; }
		cur = cur->next;
	}
	if (cur != NULL) ok = 0;

	while (list) { t_list *nx = list->next; free(list); list = nx; }
	free(csv);

	if (!ok)
	{
		printf("%s[-] ft_list_push_front : %s failed!\n%s", FR_RED, argv[2], RESET);
		return (1);
	}
	printf("%s[+] ft_list_push_front : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
