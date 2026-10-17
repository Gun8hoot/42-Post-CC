
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FR_GREEN "\e[32m"
#define FR_RED "\e[31m"
#define RESET "\e[0m"

extern char *ft_strcpy(char *restrict dst, const char *restrict src);

int main(int argc, char **argv)
{
	char	*libasm_buff;
	char	*libc_buff;

	if (argc != 3)
		return  (2);

	libasm_buff = malloc(sizeof(char) * strlen(argv[1]) + 1);
	if (!libasm_buff)
		return (3);

	libc_buff = malloc(sizeof(char) * strlen(argv[1]) + 1);
	if (!libc_buff)
	{
		free(libasm_buff);
		return (3);
	}

	libasm_buff = ft_strcpy(libasm_buff, argv[1]);
	libc_buff = strcpy(libasm_buff, argv[1]);

	if (strcmp(libc_buff, libc_buff) != 0)
	{
		printf("%s[-] ft_strlen : %s result differ!\nExpected: %s\nGot: %s\n%s", FR_RED, argv[2], libc_buff, libasm_buff, RESET);
		return (1);
	}
	else
		printf("%s[+] ft_strlen : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
