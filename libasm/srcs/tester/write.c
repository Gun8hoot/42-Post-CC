
#include <errno.h>
#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include "main.h"
#include <pty.h>

/*
 * ==============
 * = PTY HELPER =
 * ==============
 */
struct test_pty {
	int master_fd;
	int slave_fd;
};

static int test_pty_create(struct test_pty *pty)
{
	pty->master_fd = -1;
	pty->slave_fd = -1;

	if (openpty(&pty->master_fd, &pty->slave_fd, NULL, NULL, NULL) == -1)
		return -1;

	return 0;
}

static void test_pty_destroy(struct test_pty *pty)
{
	if (pty->master_fd >= 0) {
		close(pty->master_fd);
		pty->master_fd = -1;
	}

	if (pty->slave_fd >= 0) {
		close(pty->slave_fd);
		pty->slave_fd = -1;
	}
}

/*
 * ==============
 * = WRITE TEST =
 * ==============
 */

static void	individual_write(int pty_fd, char *str, size_t bytes_nb)
{
	int libasm_ret;
	int libasm_errno;
	int libc_ret;
	int libc_errno;

	libasm_ret = ft_write(pty_fd, str, bytes_nb);
	libasm_errno = errno;

	libc_ret = write(pty_fd, str, bytes_nb);
	libc_errno = errno;

	if (libasm_ret != libc_ret)
		printf("\e[0;31m[-] Number of written bytes differ !\nlibasm = %d\nlibc = %d\e[0m\n", libasm_ret, libc_ret);
	else if (libasm_ret != libc_ret)
		errno_check(libasm_errno, libc_errno);
	else
		printf("\e[0;32m[+] TEST PASSED\e[0m\n");
}

void	test_write(void)
{
	char	*str = "write this string on an alternative tty and do your things on it!\n";
	struct test_pty pty;
	ssize_t bytes;
	memset(&pty, 0, sizeof(pty));

	if (test_pty_create(&pty))
	{
		printf("[!] Failed to create an alternative pty for ft_write test, skipping ...\n");
		return;
	}

	printf("\e[0;33m[!] Testing ft_write normal use\e[0m\n");
	individual_write(pty.slave_fd, str, strlen(str));

	printf("\e[0;33m[!] Testing ft_write invalid fd\e[0m\n");
	individual_write(-1, str, strlen(str));

	test_pty_destroy(&pty);
}
