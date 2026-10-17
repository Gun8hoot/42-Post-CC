
#include <stdio.h>
#include <string.h>

#define FR_GREEN "\e[32m"
#define FR_RED "\e[31m"
#define RESET "\e[0m"

extern size_t ft_strlen(const char *s);

int main(int argc, char **argv)
{
	size_t	libasm_res;
	size_t	libc_res;

	if (argc != 3)
		return  (2);

	libasm_res = ft_strlen(argv[1]);
	libc_res = strlen(argv[1]);

	if (libc_res != libasm_res)
	{
		printf("%s[-] ft_strlen : %s result differ!\nExpected: %ld\nGot: %ld\n%s", FR_RED, argv[2], libc_res, libasm_res, RESET);
		return (1);
	}
	else
		printf("%s[+] ft_strlen : %s passed!%s\n", FR_GREEN, argv[2], RESET);
	return (0);
}
