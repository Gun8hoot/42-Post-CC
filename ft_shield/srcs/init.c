
#include "incs/ft_shield.h"
#include "incs/types.h"

#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h>
#include <stdlib.h>

static bool	strIsDigit(char *str)
{
	while (*str)
	{
		if (!(*str >= '0' && *str <= '9'))
			return (true);
		str++;
	}
	return (false);
}

char	*trim(char *str)
{
	size_t	start = 0;
	size_t	len = strlen(str);
	size_t	end = len - 1;
	char	*trimmed = NULL;

	while (end > 0 && isspace(str[end]))
		end--;
	while (start < end && isspace(str[start]))
		start++;
	trimmed = malloc(sizeof(char) * end - start + 1);
	if (trimmed == NULL)
		return (NULL);
	strncpy(trimmed, &str[start], len - start - (len - end) + 1);
	return (trimmed);
}

bool	isAlreadyLaunched(char *path)
{
	DIR				*dir = opendir(path);
	struct dirent	*dir_info;

	int				fd;
	char			comm_path[1024];
	char			comm[1024];
	char			*trimmed;
	ssize_t			readed;

	if (dir == NULL)
		return (true);

	while ((dir_info = readdir(dir)) != NULL)
	{
		if (strcmp(dir_info->d_name, ".") == 0 || strcmp(dir_info->d_name, "..") == 0 || strIsDigit(dir_info->d_name))
			continue;

		snprintf(comm_path, 1024, "%s/%s/comm", path, dir_info->d_name);
		fd = open(comm_path, O_RDONLY);
		if (fd < 0)
			continue;
		readed = read(fd, &comm, 9);
		close(fd);
		if (readed == 0 || readed < 0)
			break;
		comm[readed - 1] = '\0';
		if (strcmp(comm, FT_SHIELD_NAME) == 0)
		{
			printf("ft_shield found !\n");
			break;
		}
		if (strncmp(comm, FT_SHIELD_NAME, 2) == 0)
		{
			trimmed = trim(comm);
			printf("%s : %d\n", comm, strcmp(comm, FT_SHIELD_NAME));
			free(trimmed);
		}
	}
	closedir(dir);
	return (false);
}

bool	createDaemon(u8_t *status)
{
	pid_t pid = fork();
	if (pid != 0)
		return (true);
	close(0);
	close(1);
	close(2);
	if (open("/dev/null", O_RDWR) ||\
		open("/dev/null", O_RDWR) ||\
		open("/dev/null", O_RDWR))
	{
		*status = 1;
		return (true);
	}
	return (false);
}
