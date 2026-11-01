
#pragma once

# include <stdbool.h>
# include <stdio.h>
# include "incs/types.h"

# define FT_SHIELD_NAME "ft_shield\n"
# define FT_SHIELD_PORT 4242

bool	isAlreadyLaunched(char *path);
bool	createDaemon(u8_t *status);
char	*trim(char *str);
