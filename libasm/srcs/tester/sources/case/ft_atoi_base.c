
#include "includes/main.h"

static void	individual_atoi_base(char *str, char *base, int expected, char *test_in_progress)
{
	int	libasm_ret;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	libasm_ret = ft_atoi_base(str, base);

	if (libasm_ret != expected)
		printf("[-] The content differ:\n\
libasm_str = \"%d\"\n\
libc_str = \"%d\"\n", libasm_ret, expected);
	else
		printf("\e[0;32m[+] TEST PASSED\n\e[0m");
}

void test_atoi_base(void)
{
	printf("\n\e[0;34m=== TEST FT_ATOI_BASE ===\e[0m\n");

	individual_atoi_base("FF", "0123456789ABCDEF", 255, "Testing with a base16 little number");
	individual_atoi_base("1011", "01", 11, "Testing with a base2 little number");
	individual_atoi_base("674", "01234567", 444, "Testing with a base6 little number");
	individual_atoi_base("777", "0123456789", 777, "Testing with a base10 little number");
	individual_atoi_base("2147483647", "0123456789", 2147483647, "Testing with a base10 INT_MAX");
	individual_atoi_base("-2147483648", "0123456789", -2147483648, "Testing with a base10 INT_MIN");
	individual_atoi_base("2147483650", "0123456789", 0, "Testing with a little overflow value");
	individual_atoi_base("9999999999999", "0123456789", 0, "Testing with a big overflow value");
	individual_atoi_base("-2147483650", "0123456789", 0, "Testing with a little underflow value");
	individual_atoi_base("-9999999999999", "0123456789", 0, "Testing with a big underflow value");
	individual_atoi_base("3", "0123456789\t", 0, "Testing with a base how contain whitespace");
	individual_atoi_base("3", "0", 0, "Testing with a base with one character");
	individual_atoi_base("3", "", 0, "Testing with an empty base");

}
