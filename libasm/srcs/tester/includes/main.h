
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

#include "includes/test_prototype.h"

void	errno_check(int libasm_errno, int libc_errno);

void	test_strlen(void);
void	test_strcpy(void);
void	test_strcmp(void);
void	test_write(void);
void	test_read(void);


/*
 * =============
 * = STRUCTURE =
 * =============
 */

// typedef struct s_stat
// {
// 	s_stat	*stat;
// 	size_t	test_passed;
// 	size_t	test_failed;
// 	size_t	total;
// } t_stat;
