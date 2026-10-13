
#include "includes/main.h"
#include <stdbool.h>

bool ft_is_whitespace(char c);

int main(int argc, char **argv)
{
	printf("%d\n", ft_atoi_base("FF", "0123456789ABCDEF"));
	ft_is_whitespace('a') ? printf("Is a whitespace\n") : printf("Is not a whitespace\n");

	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();

	return (0);
}
