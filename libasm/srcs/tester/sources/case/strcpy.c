
#include "includes/main.h"
#include <string.h>
#include <stdlib.h>

static void	individual_strcpy(char *str, char *test_in_progress)
{
	char	*libasm_dest;
	char	*libc_dest;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	{
		libasm_dest = calloc(strlen(str) + 1, sizeof(char));
		if (libasm_dest == NULL)
		{
			printf("[!] Failed to allocated memory for a string, passing ...\n");
			return;
		}
		libc_dest = calloc(strlen(str) + 1, sizeof(char));
		if (libasm_dest == NULL)
		{
			printf("[!] Failed to allocated memory for a string, passing ...\n");
			free(libasm_dest);
			return;
		}
	}
	ft_strcpy(libasm_dest, str);
	strcpy(libc_dest, str);

	if (memcmp(libasm_dest, libc_dest, sizeof(char) * strlen(str) + 1) != 0)
		printf("\e[0;31m[-] Content differ\n\e[0m");
	else if (strlen(libasm_dest) != strlen(libc_dest))
		printf("\e[0;31m[-] Result differ:\n\
libasm: %s\n\
libc:   %s\e[0m\n", libasm_dest, libc_dest);
	else
		printf("\e[0;32m[+] Test pass!\e[0m\n");
	free(libasm_dest);
	free(libc_dest);
}

void	test_strcpy(void)
{
	printf("\n\e[0;34m=== TEST FT_STRCPY ===\e[0m\n");
	individual_strcpy("string", "Testing on a small string");
	individual_strcpy("Lorem ipsum dolor sit amet consectetur adipiscing elit. Placerat in id cursus mi pretium tellus duis. Urna tempor pulvinar vivamus fringilla lacus nec metus. Integer nunc posuere ut hendrerit semper vel class. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Mus donec rhoncus eros lobortis nulla molestie mattis. Purus est efficitur laoreet mauris pharetra vestibulum fusce. Sodales consequat magna ante condimentum neque at luctus. Ligula congue sollicitudin erat viverra ac tincidunt nam. Lectus commodo augue arcu dignissim velit aliquam imperdiet. Cras eleifend turpis fames primis vulputate ornare sagittis. Libero feugiat tristique accumsan maecenas potenti ultricies habitant. Cubilia curae hac habitasse platea dictumst lorem ipsum. Faucibus ex sapien vitae pellentesque sem placerat in. Tempus leo eu aenean sed diam urna tempor.", "Testing on a big string");
}
