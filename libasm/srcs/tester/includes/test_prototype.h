
#pragma once

#include <stddef.h>
#include <sys/types.h>

typedef struct s_list
{
	void			*data;
	struct s_list	*next;
} t_list;


extern size_t		ft_strlen(char *str);
extern char			*ft_strcpy(char *dest, char *src);
extern int			ft_strcmp(char *str1, char *str2);
extern ssize_t		ft_write(int filedes, const void *buff, size_t nbyte);
extern ssize_t		ft_read(int fd, void *buf, size_t count);
extern char			*ft_strdup(const char *s);
extern void			*ft_calloc(size_t n, size_t size);
extern int			ft_atoi_base(char *str, char *base);
extern void			ft_list_push_front(t_list **begin_list, void *data);
extern unsigned int	ft_list_size(t_list *begin_list);
extern void			ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *));
