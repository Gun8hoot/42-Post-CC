#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern char *ft_strcpy(char *dst, const char *src);

int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	size_t n = strlen(argv[1]);
	char *buf_asm  = malloc(n + 1);
	char *buf_libc = malloc(n + 1);
	if (!buf_asm || !buf_libc) return (2);

	char *ret_asm  = ft_strcpy(buf_asm,  argv[1]);
	char *ret_libc = strcpy(buf_libc, argv[1]);

	int ok = 1;
	if (strcmp(buf_asm, buf_libc) != 0) ok = 0;
	if (ret_asm != buf_asm)             ok = 0;

	if (!ok)
	{
		printf("%s[-] ft_strcpy : %s result differ!\nExpected: \"%s\"\nGot:      \"%s\"\n%s",
			FR_RED, argv[2], buf_libc, buf_asm, RESET);
		free(buf_asm); free(buf_libc);
		return (1);
	}
	free(buf_asm); free(buf_libc);
	printf("%s[+] ft_strcpy : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
