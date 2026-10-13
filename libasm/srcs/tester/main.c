
#include "includes/main.h"

int main(int argc, char **argv)
{
	ft_atoi_base("str", "0123456789ABCDEF") ? printf("valid base\n") : printf("invalid base\n");

	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();

	return (0);
}
