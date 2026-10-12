
#include "includes/main.h"
#include <string.h>

static void	individual_strcmp(char *str1, char *str2, char *test_in_progress)
{
	size_t libasm_cmp;
	size_t libc_cmp;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	libasm_cmp = ft_strcmp(str1, str2);
	libc_cmp = strcmp(str1, str2);

	if (libasm_cmp != libc_cmp)
		printf("\e[0;31m[-] Result differ:\n\
string 1: \"%s\"\n\
string 2: \"%s\"\n\
libasm:   %ld\n\
libc:     %ld\e[0m\n", str1, str2, libasm_cmp, libc_cmp);
	else
		printf("\e[0;32m[+] Test pass!\e[0m\n");
}

void	test_strcmp(void)
{
	printf("\n\e[0;34m=== TEST FT_STRCMP ===\e[0m\n");
	individual_strcmp("string", "string", "Testing on two a small string");
	individual_strcmp("Lorem ipsum dolor sit amet consectetur adipiscing elit. Placerat in id cursus mi pretium tellus duis. Urna tempor pulvinar vivamus fringilla lacus nec metus. Integer nunc posuere ut hendrerit semper vel class. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Mus donec rhoncus eros lobortis nulla molestie mattis. Purus est efficitur laoreet mauris pharetra vestibulum fusce. Sodales consequat magna ante condimentum neque at luctus. Ligula congue sollicitudin erat viverra ac tincidunt nam. Lectus commodo augue arcu dignissim velit aliquam imperdiet. Cras eleifend turpis fames primis vulputate ornare sagittis. Libero feugiat tristique accumsan maecenas potenti ultricies habitant. Cubilia curae hac habitasse platea dictumst lorem ipsum. Faucibus ex sapien vitae pellentesque sem placerat in. Tempus leo eu aenean sed diam urna tempor.", "Lorem ipsum dolor sit amet consectetur adipiscing elit. Placerat in id cursus mi pretium tellus duis. Urna tempor pulvinar vivamus fringilla lacus nec metus. Integer nunc posuere ut hendrerit semper vel class. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Mus donec rhoncus eros lobortis nulla molestie mattis. Purus est efficitur laoreet mauris pharetra vestibulum fusce. Sodales consequat magna ante condimentum neque at luctus. Ligula congue sollicitudin erat viverra ac tincidunt nam. Lectus commodo augue arcu dignissim velit aliquam imperdiet. Cras eleifend turpis fames primis vulputate ornare sagittis. Libero feugiat tristique accumsan maecenas potenti ultricies habitant. Cubilia curae hac habitasse platea dictumst lorem ipsum. Faucibus ex sapien vitae pellentesque sem placerat in. Tempus leo eu aenean sed diam urna tempor.", "Testing on two a big string");
}
