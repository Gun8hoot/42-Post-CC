
#include "main.h"

int main(int argc, char **argv)
{
	char *str = "Writing a 21c string\n";
	int ret;

	printf("\e[1;34m=== TESTING FT_WRITE ===\e[0m\n");
	test_write();
	return (0);
}
