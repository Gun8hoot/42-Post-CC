
#include "includes/main.h"
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>

static void	individual_read(int fd, char *filepath, ssize_t size_to_read, char *test_in_progress)
{
	/* The content of the file will be stored here */
	unsigned char	*libasm_buff;
	unsigned char	*libc_buff;

	/* The number of bytes that read have readed */
	ssize_t			libasm_bytes;
	ssize_t			libc_bytes;

	/* The errno code return by both read */
	int				libasm_errno;
	int				libc_errno;

	/* Just simple fds */
	int fd1;
	int fd2;

	/* Print the current test that we are  doing */
	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	/* If we need to open a file */
	if (filepath && filepath[0] != '\0')
	{
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
	}
	else
	{
		fd1 = fd;
		fd2 = fd;
	}

	/* Allocated memory for the buffer based on the size we have to read */
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

	/* Testing our actual read wrapper */
	errno = 0;
	libasm_bytes = ft_read(fd1, libasm_buff, size_to_read);
	if (libasm_bytes >= 0)
		libasm_buff[libasm_bytes] = '\0';
	libasm_errno = errno;

	/* Testing the real libc read wrapper */
	errno = 0;
	libc_bytes = read(fd2, libc_buff, size_to_read);
	if (libc_bytes >= 0)
		libc_buff[libc_bytes] = '\0';
	libc_errno = errno;

	/* If we dont have read the same number of bytes */
	if (libasm_bytes != libc_bytes)
		printf("\e[0;31m[-] Number of readed bytes differ !\n\
libasm = %d\n\
libc = %d\e[0m\n", libasm_bytes, libc_bytes);
		/* If the errno code is differ */
	else if (libasm_errno != libc_errno)
		errno_check(libasm_errno, libc_errno);
		/* If the content of the buffer is not the same */
	else if ((libasm_bytes != -1 && libasm_bytes != -1) && memcmp(libasm_buff, libc_buff, size_to_read) != 0)
		printf("\e[0;31m[-] Readed content differ!\n\e[0m");
	else
		/* Everything is alright */
		printf("\e[0;32m[+] TEST PASSED\e[0m\n");

	/* Close fds / Free allocated memory */
	close(fd1);
	close(fd2);
	free(libasm_buff);
	free(libc_buff);
}

void	test_read(void)
{
	printf("\n\e[0;34m=== TEST FT_READ ===\e[0m\n");

	individual_read(0, "./srcs/tester/test/dummy_file.txt", 256, "Testing normal read");
	individual_read(0, "./srcs/tester/test/large_file.txt", 32768, "Testing huge read");
	individual_read(0, "./srcs/tester/test/large_file.txt", 0, "Testing 0 bytes read");
	individual_read(-1, NULL, 256, "Testing invalid fd");
}
