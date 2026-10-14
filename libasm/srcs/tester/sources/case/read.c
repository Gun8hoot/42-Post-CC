
#include "includes/main.h"
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>

static void	individual_read(char *filepath, ssize_t size_to_read, char *test_in_progress)
{
	unsigned char	*libasm_buff;
	unsigned char	*libc_buff;
	ssize_t			libasm_bytes;
	ssize_t			libc_bytes;
	int				libasm_errno;
	int				libc_errno;

	int fd1;
	int fd2;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	fd1 = open(filepath, O_RDONLY);
	fd2 = open(filepath, O_RDONLY);
	if (fd1 == -1 || fd1 == -1)
	{
		if (fd1 != -1)
			close(fd1);
		if (fd2 != -1)
			close(fd2);
		printf("[!] Failed to open file for ft_read test, skipping ...\n");
	}

	libasm_buff = (unsigned char *)malloc(sizeof(unsigned char) * size_to_read);
	libc_buff = (unsigned char *)malloc(sizeof(unsigned char) * size_to_read);

	if (!libasm_buff || !libc_buff)
	{
		if (libasm_buff)
			free(libasm_buff);
		if (libc_buff)
			free(libc_buff);
		printf("[!] Failed to allocated memory for ft_read test, skipping ...\n");
		return;
	}

	errno = 0;
	libasm_bytes = ft_read(fd1, &libasm_buff, size_to_read);

	errno = 0;
	libc_bytes = read(fd2, &libc_buff, size_to_read);

	if (libasm_bytes != libc_bytes)
		printf("\e[0;31m[-] Number of readed bytes differ !\n\
libasm = %d\n\
libc = %d\e[0m\n", libasm_bytes, libc_bytes);
	else if (libasm_errno != libc_errno)
		errno_check(libasm_errno, libc_errno);
	else if (memcmp(libasm_buff, libc_buff, size_to_read) != 0)
		printf("\e[0;31m[-] Readed content differ!\n\e[0m");
	else
		printf("\e[0;32m[+] TEST PASSED\e[0m\n");
	close(fd1);
	close(fd2);
	free(libasm_buff);
	free(libc_buff);
}

void	test_read(void)
{
	printf("\n\e[0;34m=== TEST FT_READ ===\e[0m\n");

	individual_read("./srcs/tester/test/dummy_file.txt", 256, "[&] Testing normal read");
}
