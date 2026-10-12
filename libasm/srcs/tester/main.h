
#pragma once

/*
 * ============
 * = INCLUDES =
 * ============
 */
#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>

/*
 * =============
 * = PROTOTYPE =
 * =============
 */

/* libasm */
extern size_t	ft_strlen(char *str);
extern char		*ft_strcpy(char *dest, char *src);
extern int		ft_strcmp(char *str1, char *str2);
extern ssize_t	ft_write(int filedes, const void *buff, size_t nbyte);
extern ssize_t	ft_read(int fd, void *buf, size_t count);
extern char		*ft_strdup(const char *s);
extern void		*ft_calloc(size_t n, size_t size);

/* tester */
void	errno_check(int libasm_errno, int libc_errno);
void	test_write(void);
void	test_read(void);

/*
 * =============
 * = PROTOTYPE =
 * =============
 */
