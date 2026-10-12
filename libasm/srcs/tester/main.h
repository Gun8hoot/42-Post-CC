
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
size_t	ft_strlen(char *str);
char	*ft_strcpy(char *dest, char *src);
int		ft_strcmp(char *str1, char *str2);
ssize_t	ft_write(int filedes, const void *buff, size_t nbyte);

/* tester */
void	errno_check(int libasm_errno, int libc_errno);
void	test_write(void);

/*
 * =============
 * = PROTOTYPE =
 * =============
 */
