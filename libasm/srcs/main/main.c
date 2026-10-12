
#include <stdio.h>
#include <string.h>
#include <stddef.h>

size_t	ft_strlen(char *str);
char	*ft_strcpy(char *dest, char *src);
int		ft_strcmp(char *str1, char *str2);
ssize_t	ft_write(int filedes, const void *buff, size_t nbyte);

int main(int argc, char **argv)
{
	char *str = "Writing a 21c string\n";

	int ret = ft_write(-1, str, strlen(str));
	return (0);
}
