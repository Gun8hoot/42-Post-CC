
#include "includes/main.h"
#include <stdlib.h>

static void	individual_calloc(size_t n, size_t size, char *test_in_progress)
{
	int	*libasm_buff;
	int	*libc_buff;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	libasm_buff = ft_calloc(n, size);
	libc_buff = calloc(n, size);

	if (memcmp(libasm_buff, libc_buff, size * n) != 0)
		printf("\e[0;31m[-] The allocated array is not entirely at 0 !\n\e[0m");
	else
		printf("\e[0;32m[+] TEST PASSED\e[0m\n");
	if (libasm_buff)
		free(libasm_buff);
	if (libc_buff)
		free(libc_buff);

}


void	test_calloc(void)
{
	printf("\n\e[0;34m=== TEST FT_CALLOC ===\e[0m\n");

	individual_calloc(16, sizeof(int), "Allocate an array of int composed by 16 elements");
	individual_calloc(256, sizeof(char), "Allocate an array of char composed by 256 elements");
	individual_calloc(4, 0, "Allocate an array of 256 elements without a size");
}
