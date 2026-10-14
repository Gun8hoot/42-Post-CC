
#include "includes/main.h"

bool ft_is_whitespace(char c);

int main(int argc, char **argv)
{
	int num = ft_atoi_base("-2147483648", "0123456789");
	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();
	test_read();
	test_strdup();
	test_calloc();
	test_atoi_base();

	return (0);
}
