#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <termios.h>
#include <pty.h>
#include <sys/types.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern ssize_t ft_write(int fd, const void *buf, size_t count);

/* ===================== */
/* = PTY HELPER        = */
/* ===================== */
struct test_pty {
	int master;
	int slave;
};

static int test_pty_create(struct test_pty *p)
{
	struct termios	t;

	p->master = -1;
	p->slave  = -1;

	if (openpty(&p->master, &p->slave, NULL, NULL, NULL) == -1)
		return (-1);

	/* Disable output post-processing so '\n' stays '\n' and we can
	   byte-compare the master side. */
	if (tcgetattr(p->slave, &t) == 0)
	{
		t.c_oflag &= ~OPOST;
		t.c_lflag &= ~ECHO;
		tcsetattr(p->slave, TCSANOW, &t);
	}
	return (0);
}

static void test_pty_destroy(struct test_pty *p)
{
	if (p->master >= 0) { close(p->master); p->master = -1; }
	if (p->slave  >= 0) { close(p->slave);  p->slave  = -1; }
}

/* Non-blocking read with retries so we don't race with the tty line
   discipline. Returns the number of bytes actually read. */
static ssize_t test_pty_drain(int master_fd, char *buf, size_t want)
{
	ssize_t	total   = 0;
	int	fl      = fcntl(master_fd, F_GETFL);
	int	retries = 0;

	if (fl == -1)
		return (-1);
	fcntl(master_fd, F_SETFL, fl | O_NONBLOCK);

	while (total < (ssize_t)want && retries < 1000)
	{
		ssize_t	r = read(master_fd, buf + total, want - total);

		if (r > 0)                                            { total += r; retries = 0; }
		else if (r == 0)                                        break;
		else if (errno == EAGAIN || errno == EWOULDBLOCK)      { usleep(100); retries++; }
		else                                                    break;
	}
	fcntl(master_fd, F_SETFL, fl);
	return (total);
}

/* ===================== */
/* = MAIN              = */
/* ===================== */
int main(int argc, char **argv)
{
	if (argc != 3) return (2);

	const char *data = argv[1];
	const char *test = argv[2];
	size_t      len  = strlen(data);
	ssize_t     ret;
	int         saved;

	/* --- invalid fd cases: nothing is actually written --- */
	if (!strcmp(test, "invalid fd returns -1") ||
	    !strcmp(test, "errno EBADF on invalid fd"))
	{
		errno = 0;
		ret = ft_write(9999, data, len);
		saved = errno;

		if (!strcmp(test, "invalid fd returns -1") && ret != -1)
		{
			printf("%s[-] ft_write : %s should return -1, got %ld\n%s",
				FR_RED, test, (long)ret, RESET);
			return (1);
		}
		if (!strcmp(test, "errno EBADF on invalid fd") && saved != EBADF)
		{
			printf("%s[-] ft_write : %s errno should be EBADF(%d), got %d\n%s",
				FR_RED, test, EBADF, saved, RESET);
			return (1);
		}
		printf("%s[+] ft_write : %s passed!%s\n", FR_GREEN, test, RESET);
		return (0);
	}

	/* --- everything else: write into an alternate pty --- */
	struct test_pty	pty;

	if (test_pty_create(&pty) != 0)
	{
		printf("%s[-] ft_write : %s could not open pty, skipping\n%s",
			FR_RED, test, RESET);
		return (2);
	}

	int	fd             = pty.slave;
	int	saved_stderr   = -1;

	/* "to stderr" is still exercised on fd 2 — but we redirect stderr
	   to the pty slave so the user's terminal stays clean. */
	if (!strcmp(test, "to stderr"))
	{
		saved_stderr = dup(STDERR_FILENO);
		if (saved_stderr < 0 || dup2(pty.slave, STDERR_FILENO) < 0)
		{
			if (saved_stderr >= 0) close(saved_stderr);
			test_pty_destroy(&pty);
			return (2);
		}
		fd = STDERR_FILENO;
	}

	/* --- the actual write --- */
	errno = 0;
	ret = ft_write(fd, data, len);
	saved = errno;

	int	ok = 1;

	/* return-value check (same as before) */
	if (ret != (ssize_t)len)
	{
		printf("%s[-] ft_write : %s result differ!\nExpected: %ld\nGot: %ld\n%s",
			FR_RED, test, (long)len, (long)ret, RESET);
		ok = 0;
	}

	/* content check: read the bytes back from the pty master */
	if (ok && len > 0 && len <= 4096)
	{
		char	buf[4096];
		ssize_t	got = test_pty_drain(pty.master, buf, len);

		if (got != (ssize_t)len || memcmp(buf, data, len) != 0)
		{
			printf("%s[-] ft_write : %s content differ on pty (got %zd/%zu)\n%s",
				FR_RED, test, got, len, RESET);
			ok = 0;
		}
	}

	/* restore stderr if we hijacked it */
	if (saved_stderr >= 0)
	{
		dup2(saved_stderr, STDERR_FILENO);
		close(saved_stderr);
	}

	test_pty_destroy(&pty);

	if (!ok)
		return (1);
	printf("%s[+] ft_write : %s passed!%s\n", FR_GREEN, test, RESET);
	return (0);
}
