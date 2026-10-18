#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <stdint.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern void *ft_calloc(size_t nmemb, size_t size);

int main(int argc, char **argv)
{
	if (argc != 4) return (2);

	size_t nmemb = strtoull(argv[1], NULL, 10);
	size_t size  = strtoull(argv[2], NULL, 10);
	const char *test = argv[3];

	int overflow = (size != 0 && nmemb > SIZE_MAX / size);

	errno = 0;
	void *ptr = ft_calloc(nmemb, size);

	if (overflow)
	{
		if (ptr != NULL)
		{
			printf("%s[-] ft_calloc : %s should return NULL on overflow\n%s",
				FR_RED, test, RESET);
			free(ptr);
			return (1);
		}
		printf("%s[+] ft_calloc : %s passed!%s\n", FR_GREEN, test, RESET);
		return (0);
	}

	if (nmemb == 0 || size == 0)
	{
		/* NULL is acceptable per POSIX */
		if (ptr) free(ptr);
		printf("%s[+] ft_calloc : %s passed!%s\n", FR_GREEN, test, RESET);
		return (0);
	}

	if (!ptr)
	{
		printf("%s[-] ft_calloc : %s returned NULL\n%s", FR_RED, test, RESET);
		return (1);
	}
	unsigned char *p = ptr;
	for (size_t i = 0; i < nmemb * size; i++)
	{
		if (p[i] != 0)
		{
			printf("%s[-] ft_calloc : %s memory not zero at offset %zu\n%s",
				FR_RED, test, i, RESET);
			free(ptr);
			return (1);
		}
	}
	free(ptr);
	printf("%s[+] ft_calloc : %s passed!%s\n", FR_GREEN, test, RESET);
	return (0);
}
