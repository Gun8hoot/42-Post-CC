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
extern void ft_list_remove_if(t_list **begin_list, void *data_ref,
                              int (*cmp)(), void (*free_fct)(void *));

static int  cmp_str(void *a, void *b) { return strcmp((char *)a, (char *)b); }
static void no_free(void *p)          { (void)p; }

int main(int argc, char **argv)
{
	if (argc != 4) return (2);

	const char *target = argv[2];

	char *csv = strdup(argv[1]);
	char *tokens[1024];
	int   n = 0;

	if (csv && *csv)
	{
		char *tok = strtok(csv, ",");
		while (tok && n < 1024) { tokens[n++] = tok; tok = strtok(NULL, ","); }
	}

	t_list *list = NULL;
	for (int i = n - 1; i >= 0; i--)
		ft_list_push_front(&list, tokens[i]);

	ft_list_remove_if(&list, (void *)target, cmp_str, no_free);

	/* expected: original minus any element equal to target */
	int ok = 1;
	t_list *cur = list;
	for (int i = 0; i < n; i++)
	{
		if (strcmp(tokens[i], target) == 0) continue;
		if (!cur || strcmp((char *)cur->data, tokens[i]) != 0) { ok = 0; break; }
		cur = cur->next;
	}
	if (cur != NULL) ok = 0;

	while (list) { t_list *nx = list->next; free(list); list = nx; }
	free(csv);

	if (!ok)
	{
		printf("%s[-] ft_list_remove_if : %s failed!\n%s", FR_RED, argv[3], RESET);
		return (1);
	}
	printf("%s[+] ft_list_remove_if : %s passed!%s\n", FR_GREEN, argv[3], RESET);
	return (0);
}
