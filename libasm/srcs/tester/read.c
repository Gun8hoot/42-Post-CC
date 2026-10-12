
#include "main.h"
#include <fcntl.h>
#include <stdio.h>

static void	individual_read(int fd)
{
	char	libasm_buff[32];

	ft_read(fd, &libasm_buff, 32);

}

void	test_read(void)
{
	int fd;
	printf("[&] Testing normal read\n");
	fd = open("/dev/urandom", O_RDONLY);
	individual_read(fd);
	close(fd);
}
