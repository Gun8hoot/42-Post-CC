
#include "main.h"
#include <stdlib.h>

int main(int argc, char **argv)
{
	int ret;

	int *str = ft_calloc(2, 0);
	// str[0] = 444;
	// str[1] = 222;
	// printf("%d, %d\n", str[0], str[1]);
	free(str);
	printf("\e[1;34m=== TESTING FT_WRITE ===\e[0m\n");
	test_write();
	printf("\e[1;34m=== TESTING FT_READ ===\e[0m\n");
	test_read();
	return (0);
}
