#include <stdio.h>
#include <string.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern int ft_strcmp(const char *s1, const char *s2);

int main(int argc, char **argv)
{
	if (argc != 4) return (2);

	int r_asm  = ft_strcmp(argv[1], argv[2]);
	int r_libc = strcmp(argv[1], argv[2]);

	/* only the sign matters */
	int s_asm  = (r_asm  > 0) - (r_asm  < 0);
	int s_libc = (r_libc > 0) - (r_libc < 0);

	if (s_asm != s_libc)
	{
		printf("%s[-] ft_strcmp : %s result differ!\nExpected sign: %d\nGot sign:      %d\n%s",
			FR_RED, argv[3], s_libc, s_asm, RESET);
		return (1);
	}
	printf("%s[+] ft_strcmp : %s passed!%s\n", FR_GREEN, argv[3], RESET);
	return (0);
}
