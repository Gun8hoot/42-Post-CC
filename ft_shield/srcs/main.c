
#include "incs/ft_shield.h"

int main(void)
{
	u8_t status = 0;
	// if (createDaemon(&status))
	// 	goto exit;
	if (isAlreadyLaunched("/proc"))
		goto exit;
	exit:
		return (status);
}
