
#include "includes/main.h"
#include <stdbool.h>

bool ft_is_whitespace(char c);

int main(int argc, char **argv)
{
	// printf("%d\n", ft_atoi_base("-2147483648", "0123456789"));
	// ft_is_whitespace('a') ? printf("Is a whitespace\n") : printf("Is not a whitespace\n");

	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();
	// test_read();
	test_strdup();
	test_calloc();
	test_atoi_base();

	return (0);
}
