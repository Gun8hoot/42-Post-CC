#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern char *ft_strdup(const char *s);

int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	char *ret = ft_strdup(argv[1]);
	if (!ret)
	{
		printf("%s[-] ft_strdup : %s returned NULL!%s\n", FR_RED, argv[2], RESET);
		return (1);
	}
	if (ret == argv[1] || strcmp(ret, argv[1]) != 0)
	{
		printf("%s[-] ft_strdup : %s result differ!\nExpected: \"%s\"\nGot:      \"%s\"\n%s",
			FR_RED, argv[2], argv[1], ret, RESET);
		free(ret);
		return (1);
	}
	free(ret);
	printf("%s[+] ft_strdup : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
