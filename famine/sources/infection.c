#include "includes/famine.h"
#include <elf.h>

static bool	is_elf(u8_t *id)
{
	if (id[0] != EI_MAG0
			&& id[1] != EI_MAG1
			&& id[2] != EI_MAG2
			&& id[3] != EI_MAG3)
		goto invalid;
	if (id[4] == ELFCLASS32)
		goto valid;
	else if (id[4] == ELFCLASS64)
		goto valid;

	invalid:
		return (false);
	valid:
		return (false);

}

static bool	already_signed(FILE *file, void)
{
	return (false);
}

/*
 * @brief: This function will check if a file can be infected and if yes it will do it
 */
void	infect_file(char *filename)
{
	u8_t	elf_magic[5];	// ELF MAGIC + ELF TYPE (32 bit/64bit)
	FILE	*file;
	void	*header;

	if (!filename)
		return;
	file = fopen(filename, "rb");
	if (!file)
		return;
	if (fread(&elf_magic, sizeof(u8_t), 5, file) == 0)
		return;
	if (!is_elf(elf_magic))
		return;

	// Allocate memory for the header
	if (elf_magic[4] == ELFCLASS32)
		header = calloc(1, sizeof(Elf32_Ehdr));
	else
		header = calloc(1, sizeof(Elf64_Ehdr));
	if (!header)
		return;

	exit:
		if (header)
			free(header);
}

/*
 * @brief: This function will search every binary in every folder and subfolder
 * @param: The path where the function will start to search
 * @param: An index who protect the recursion
 */
void	search_file(char *starting_path, size_t rec)
{
	// opendir();
}
