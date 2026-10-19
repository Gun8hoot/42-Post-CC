#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern ssize_t ft_read(int fd, void *buf, size_t count);

int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	const char *data = argv[1];
	const char *test = argv[2];
	size_t      len  = strlen(data);

	/* --- invalid fd cases --- */
	if (!strcmp(test, "invalid fd returns -1") ||
	    !strcmp(test, "errno EBADF on invalid fd"))
	{
		char buf[16];
		errno = 0;
		ssize_t ret = ft_read(9999, buf, sizeof(buf));
		int saved = errno;

		if (!strcmp(test, "invalid fd returns -1") && ret != -1)
		{
			printf("%s[-] ft_read : %s should return -1, got %ld\n%s",
				FR_RED, test, (long)ret, RESET);
			return (1);
		}
		if (!strcmp(test, "errno EBADF on invalid fd") && saved != EBADF)
		{
			printf("%s[-] ft_read : %s errno should be EBADF(%d), got %d\n%s",
				FR_RED, test, EBADF, saved, RESET);
			return (1);
		}
		printf("%s[+] ft_read : %s passed!%s\n", FR_GREEN, test, RESET);
		return (0);
	}

	/* --- prepare source --- */
	int fd = -1;
	int cleanup = 0;              /* 1 => must close fd we created */
	if (!strcmp(test, "read from regular file"))
	{
		char tmpl[] = "/tmp/ft_read_XXXXXX";
		fd = mkstemp(tmpl);
		if (fd < 0) return (2);
		write(fd, data, len);
		lseek(fd, 0, SEEK_SET);
		unlink(tmpl);
		cleanup = 1;
	}
	else
	{
		int p[2];
		if (pipe(p) < 0) return (2);
		if (len) write(p[1], data, len);
		close(p[1]);
		fd = p[0];
		cleanup = 1;
	}

	/* --- count --- */
	size_t count = (!strcmp(test, "read zero bytes")) ? 0 : len + 16;
	char *buf = calloc(1, count ? count : 1);

	errno = 0;
	ssize_t ret = ft_read(fd, buf, count);

	int ok = 1;
	if (ret != (ssize_t)len) ok = 0;
	else if (len && memcmp(buf, data, len) != 0) ok = 0;

	if (cleanup) close(fd);
	free(buf);

	if (!ok)
	{
		printf("%s[-] ft_read : %s result differ!\nExpected: %ld\nGot: %ld\n%s",
			FR_RED, test, (long)len, (long)ret, RESET);
		return (1);
	}
	printf("%s[+] ft_read : %s passed!%s\n", FR_GREEN, test, RESET);
	return (0);
}
