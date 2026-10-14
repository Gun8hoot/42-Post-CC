
#include <errno.h>
#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include "includes/main.h"
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

static void	individual_write(int pty_fd, char *str, size_t bytes_nb, char *test_in_progress)
{
	/* === Return value === */
	int libasm_ret;
	int libc_ret;

	/* === Save errno === */
	int libasm_errno;
	int libc_errno;

	printf("\e[0;34m[&] %s\n\e[0m", test_in_progress);

	errno = 0;
	libasm_ret = ft_write(pty_fd, str, bytes_nb);
	libasm_errno = errno;

	errno = 0;
	libc_ret = write(pty_fd, str, bytes_nb);
	libc_errno = errno;

	if (libasm_ret != libc_ret)
		printf("\e[0;31m[-] Number of written bytes differ !\n\
string = \"%s\"\n\
libasm = %d\n\
libc = %d\e[0m\n", str, libasm_ret, libc_ret);
	else if (libasm_errno != libc_errno)
		errno_check(libasm_errno, libc_errno);
	else
		printf("\e[0;32m[+] TEST PASSED\e[0m\n");
}

void	test_write(void)
{
	char	*str = "write this string on an alternative tty and do your things on it!\n";
	char	*big_str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n";
	struct test_pty pty;

	memset(&pty, 0, sizeof(pty));

	printf("\n\e[0;34m=== TEST FT_WRITE ===\e[0m\n");

	if (test_pty_create(&pty))
	{
		printf("[!] Failed to create an alternative pty for ft_write test, skipping ...\n");
		return;
	}

	individual_write(pty.slave_fd, str, strlen(str), "Testing write a simple string");
	individual_write(pty.slave_fd, big_str, strlen(big_str), "Testing write a big string");
	individual_write(-1, str, strlen(str), "Testing write on an invalid fd");
	individual_write(pty.slave_fd, "", strlen(""), "Testing write an empty string");
	individual_write(pty.slave_fd, str, 0, "Testing write 0 bytes");

	test_pty_destroy(&pty);
}
