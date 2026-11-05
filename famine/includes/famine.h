
#pragma once
#include <stddef.h>
#include <elf.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <dirent.h>
#include <stdbool.h>

#define NAME_1 "nclavel"
#define NAME_2 "user"

#define SIGNATURE "Famine version 1.0 (c)oded by %s-%s"
#define BINARY_PATH_1 ["/tmp/test", "/tmp/test2", NULL]

typedef uint8_t u8_t;
typedef uint16_t u16_t;
typedef uint32_t u32_t;
typedef uint64_t u64_t;
