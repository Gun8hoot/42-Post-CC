#include <stdio.h>
#include <string.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern void *ft_simd_memchr(const void *s, int c, size_t n);

int main(int argc, char **argv)
{
	if (argc != 4) return (2);

	const char *str  = argv[1];
	const char *carg = argv[2];
	const char *test = argv[3];

	int c;
	if      (!strcmp(carg, "_null_")) c = 0;
	else if (!strcmp(carg, "_ff_"))   c = 0xFF;
	else                              c = (unsigned char)carg[0];

	size_t n = strlen(str) + 1;   /* include the null terminator */

	void *got  = ft_simd_memchr(str, c, n);
	void *want = memchr(str, c, n);

	if (got != want)
	{
		printf("%s[-] ft_simd_memchr : %s result differ!\nExpected: %p\nGot:      %p\n%s",
			FR_RED, test, want, got, RESET);
		return (1);
	}
	printf("%s[+] ft_simd_memchr : %s passed!%s\n", FR_GREEN, test, RESET);
	return (0);
}
