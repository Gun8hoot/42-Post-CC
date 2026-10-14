
#include "includes/main.h"
#include "includes/test_prototype.h"
#include <stdlib.h>

static void	individual_strdup(char *str, char *test_in_progress)
{
	char	*libasm_str;
	char	*libc_str;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	libasm_str = ft_strdup(str);
	libc_str = strdup(str);

	if (strcmp(libc_str, libasm_str) != 0)
		printf("[-] The content differ:\n\
libasm_str = \"%s\"\n\
libc_str = \"%s\"\n", libasm_str, libc_str);
	else
		printf("\e[0;32m[+] Test pass!\e[0m\n");

	if (libc_str)
		free(libc_str);
	if (libasm_str)
		free(libasm_str);

}

void	test_strdup(void)
{
	printf("\n\e[0;34m=== TEST FT_STRDUP ===\e[0m\n");

	individual_strdup("string", "Testing with a basic string");
	individual_strdup("", "Testing with a empty string");
	// individual_strdup(NULL, "Testing with a NULL string"); // My strdup is more hardened against this
}
