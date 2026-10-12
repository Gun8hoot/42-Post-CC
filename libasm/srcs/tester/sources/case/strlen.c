
#include "includes/main.h"

static void	individual_strlen(char *str, char *test_in_progress)
{
	size_t	libasm_len;
	size_t	libc_len;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	libasm_len = ft_strlen(str);
	libc_len = strlen(str);

	if (libasm_len != libc_len)
		printf("\e[0;31m[-] Result differ:\n\
str:    \"%s\"\n\
libasm: %ld\n\
libc:   %ld\e[0m\n", str, libasm_len, libc_len);
	else
		printf("\e[0;32m[+] Test pass!\e[0m\n");
}

void	test_strlen(void)
{
	printf("\e[0;34m=== TEST FT_STRLEN ===\e[0m\n");
	individual_strlen("String", "Testing with a small string");
	individual_strlen("Lorem ipsum dolor sit amet consectetur adipiscing elit. Ex sapien vitae pellentesque sem placerat in id. Pretium tellus duis convallis tempus leo eu aenean. Urna tempor pulvinar vivamus fringilla lacus nec metus. Iaculis massa nisl malesuada lacinia integer nunc posuere. Semper vel class aptent taciti sociosqu ad litora. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Dis parturient montes nascetur ridiculus mus donec rhoncus. Nulla molestie mattis scelerisque maximus eget fermentum odio. Purus est efficitur laoreet mauris pharetra vestibulum fusce.", "Testing with a big string");
	individual_strlen("", "Testing empty string");
	individual_strlen("hello\0world", "Testing embeded null byte");
}
