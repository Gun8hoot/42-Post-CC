#!/bin/bash

FR_RED="\e[31m"
FR_GREEN="\e[32m"
FR_YELLOW="\e[33m"
FR_BLUE="\e[34m"
RESET="\e[0m"

COMPILED_BINARY_PATH="/tmp/libasm_test"
LIBASM_PATH="$1"
CC="cc"

SEGFAULT_CODE=139
SUCCESS_CODE=0
FAILED_CODE=1

# ============================================================================
# CONVENTION
# ----------------------------------------------------------------------------
# Every test binary is called as:
#     <binary> [data_arg ...] <test_name>
# The test name is ALWAYS the last argument. The .c file prints the PASS/FAIL.
# ============================================================================

function repeat_char()
{
	python3 -c "import sys; sys.stdout.write('$1' * $2)"
}

function run_test()
{
	local FUNC_NAME="$1"
	local TEST_NAME="$2"
	local TEST_FILENAME="$3"
	shift 3
	local DATA_ARGS=("$@")

	"$CC" "$TEST_FILENAME" "$LIBASM_PATH" -o "$COMPILED_BINARY_PATH" &> /dev/null
	if [ $? -ne 0 ]; then
		printf "${FR_RED}[-] ${FUNC_NAME} : '${TEST_NAME}' failed to compile!\n${RESET}"
		return
	fi

	"$COMPILED_BINARY_PATH" "${DATA_ARGS[@]}" "$TEST_NAME"
	local RET=$?
	if [ $RET -eq $SEGFAULT_CODE ]; then
		printf "${FR_RED}[-] ${FUNC_NAME} : Segfault occurred on '${TEST_NAME}'!\n${RESET}"
	fi
}

# =====================
# = LIBC STRING TESTS =
# =====================

function test_strlen()
{
	local D="./srcs/ft_strlen/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)
	local BIG2=$(repeat_char "a" 65536)
	local BIG3=$(repeat_char "x" 1048576) 2>/dev/null

	run_test "ft_strlen" "empty string"                 "$D" ""
	run_test "ft_strlen" "single char"                  "$D" "a"
	run_test "ft_strlen" "short string"                 "$D" "hello"
	run_test "ft_strlen" "with spaces"                  "$D" "hello world"
	run_test "ft_strlen" "with newlines"                "$D" "$(printf 'line1\nline2\nline3')"
	run_test "ft_strlen" "with tabs"                    "$D" "$(printf 'a\tb\tc')"
	run_test "ft_strlen" "special chars"                "$D" '!@#$%^&*()_+-=[]{}|;:,.<>?'
	run_test "ft_strlen" "UTF-8 multibyte"              "$D" "héllo wörld"
	run_test "ft_strlen" "4096 bytes"                   "$D" "$BIG1"
	run_test "ft_strlen" "65536 bytes"                  "$D" "$BIG2"
}

function test_strcpy()
{
	local D="./srcs/ft_strcpy/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)
	local BIG2=$(repeat_char "a" 65536)

	run_test "ft_strcpy" "empty string"                 "$D" ""
	run_test "ft_strcpy" "single char"                  "$D" "a"
	run_test "ft_strcpy" "short string"                 "$D" "hello"
	run_test "ft_strcpy" "with spaces"                  "$D" "hello world"
	run_test "ft_strcpy" "with newlines"                "$D" "$(printf 'line1\nline2')"
	run_test "ft_strcpy" "special chars"                "$D" '!@#$%^&*()'
	run_test "ft_strcpy" "UTF-8"                        "$D" "héllo wörld"
	run_test "ft_strcpy" "4096 bytes"                   "$D" "$BIG1"
	run_test "ft_strcpy" "65536 bytes"                  "$D" "$BIG2"
}

function test_strcmp()
{
	local D="./srcs/ft_strcmp/regular_use.c"

	run_test "ft_strcmp" "equal strings"                "$D" "hello"  "hello"
	run_test "ft_strcmp" "first less"                   "$D" "abc"    "abd"
	run_test "ft_strcmp" "first greater"                "$D" "abd"    "abc"
	run_test "ft_strcmp" "single char equal"            "$D" "a"      "a"
	run_test "ft_strcmp" "first char differs"           "$D" "a"      "b"
	run_test "ft_strcmp" "empty vs empty"               "$D" ""       ""
	run_test "ft_strcmp" "empty vs non-empty"           "$D" ""       "abc"
	run_test "ft_strcmp" "non-empty vs empty"           "$D" "abc"    ""
	run_test "ft_strcmp" "prefix shorter"               "$D" "abc"    "abcdef"
	run_test "ft_strcmp" "prefix longer"                "$D" "abcdef" "abc"
	run_test "ft_strcmp" "case sensitivity"             "$D" "Hello"  "hello"
	run_test "ft_strcmp" "numeric strings"              "$D" "123"    "124"
	run_test "ft_strcmp" "UTF-8 comparison"             "$D" "héllo"  "hello"
	run_test "ft_strcmp" "last byte differs"            "$D" "hello"  "hellp"
}

# =====================
# = LIBC I/O TESTS    =
# =====================

function test_write()
{
	local D="./srcs/ft_write/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)

	run_test "ft_write" "short string to stdout"        "$D" "hello"
	run_test "ft_write" "empty string"                  "$D" ""
	run_test "ft_write" "with newlines"                 "$D" "$(printf 'line1\nline2')"
	run_test "ft_write" "4096 bytes"                    "$D" "$BIG1"
	run_test "ft_write" "to stderr"                     "$D" "hello stderr"
	run_test "ft_write" "invalid fd returns -1"         "$D" "should fail"
	run_test "ft_write" "errno EBADF on invalid fd"     "$D" "check errno"
	run_test "ft_write" "zero bytes written"            "$D" ""
	run_test "ft_write" "partial write"                 "$D" "partial"
}

function test_read()
{
	local D="./srcs/ft_read/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)

	run_test "ft_read" "short string from pipe"         "$D" "hello"
	run_test "ft_read" "empty input from pipe"          "$D" ""
	run_test "ft_read" "with newlines"                  "$D" "$(printf 'line1\nline2')"
	run_test "ft_read" "4096 bytes from pipe"           "$D" "$BIG1"
	run_test "ft_read" "invalid fd returns -1"          "$D" "should fail"
	run_test "ft_read" "errno EBADF on invalid fd"      "$D" "check errno"
	run_test "ft_read" "read from regular file"         "$D" "from file"
	run_test "ft_read" "read zero bytes"                "$D" ""
}

# =====================
# = ALLOCATION TESTS  =
# =====================

function test_strdup()
{
	local D="./srcs/ft_strdup/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)
	local BIG2=$(repeat_char "a" 65536)

	run_test "ft_strdup" "empty string"                 "$D" ""
	run_test "ft_strdup" "single char"                  "$D" "a"
	run_test "ft_strdup" "short string"                 "$D" "hello"
	run_test "ft_strdup" "with spaces"                  "$D" "hello world"
	run_test "ft_strdup" "special chars"                "$D" '!@#$%^&*()'
	run_test "ft_strdup" "UTF-8"                        "$D" "héllo wörld"
	run_test "ft_strdup" "4096 bytes"                   "$D" "$BIG1"
	run_test "ft_strdup" "65536 bytes"                  "$D" "$BIG2"
}

function test_calloc()
{
	local D="./srcs/ft_calloc/regular_use.c"

	run_test "ft_calloc" "basic 10x1"                   "$D" "10"  "1"
	run_test "ft_calloc" "basic 1x10"                   "$D" "1"   "10"
	run_test "ft_calloc" "basic 8x8"                    "$D" "8"   "8"
	run_test "ft_calloc" "zero nmemb"                   "$D" "0"   "10"
	run_test "ft_calloc" "zero size"                    "$D" "10"  "0"
	run_test "ft_calloc" "zero both"                    "$D" "0"   "0"
	run_test "ft_calloc" "zeroed memory"                "$D" "100" "4"
	run_test "ft_calloc" "overflow SIZE_MAX x 2"        "$D" "18446744073709551615" "2"
	run_test "ft_calloc" "overflow 2 x SIZE_MAX"        "$D" "2" "18446744073709551615"
	run_test "ft_calloc" "overflow SIZE_MAX x SIZE_MAX" "$D" "18446744073709551615" "18446744073709551615"
	run_test "ft_calloc" "overflow large x large"       "$D" "9223372036854775808" "2"
	run_test "ft_calloc" "1MB alloc"                    "$D" "1048576" "1"
	run_test "ft_calloc" "16MB alloc"                   "$D" "4096" "4096"
}

# =====================
# = ATOI_BASE TESTS   =
# =====================

function test_atoi_base()
{
	local D="./srcs/ft_atoi_base/regular_use.c"

	run_test "ft_atoi_base" "decimal 42"                "$D" "42"          "0123456789"
	run_test "ft_atoi_base" "decimal negative"          "$D" "-42"         "0123456789"
	run_test "ft_atoi_base" "decimal positive sign"     "$D" "+42"         "0123456789"
	run_test "ft_atoi_base" "zero"                      "$D" "0"           "0123456789"
	run_test "ft_atoi_base" "empty string"              "$D" ""            "0123456789"
	run_test "ft_atoi_base" "whitespace prefix"         "$D" "  42"        "0123456789"
	run_test "ft_atoi_base" "invalid digit"             "$D" "42abc"       "0123456789"
	run_test "ft_atoi_base" "hex ff lower"              "$D" "ff"          "0123456789ABCDEF"
	run_test "ft_atoi_base" "hex FF upper"              "$D" "FF"          "0123456789ABCDEF"
	run_test "ft_atoi_base" "hex 1f"                    "$D" "1f"          "0123456789ABCDEF"
	run_test "ft_atoi_base" "binary 1010"               "$D" "1010"        "01"
	run_test "ft_atoi_base" "octal 777"                 "$D" "777"         "01234567"
	run_test "ft_atoi_base" "base 1 invalid"            "$D" "0"           "0"
	run_test "ft_atoi_base" "base 0 invalid"            "$D" "0"           ""
	run_test "ft_atoi_base" "INT_MAX"                   "$D" "2147483647"  "0123456789"
	run_test "ft_atoi_base" "INT_MIN"                   "$D" "-2147483648" "0123456789"
	run_test "ft_atoi_base" "base with duplicates"      "$D" "42"          "0123456789"
}

# =====================
# = LIST TESTS        =
# =====================

function test_list_push_front()
{
	local D="./srcs/ft_list_push_front/regular_use.c"
	local MANY=$(python3 -c 'print(",".join(["x"] * 100))')

	run_test "ft_list_push_front" "empty list"          "$D" ""
	run_test "ft_list_push_front" "single element"      "$D" "a"
	run_test "ft_list_push_front" "multiple elements"   "$D" "a,b,c,d,e"
	run_test "ft_list_push_front" "with spaces"         "$D" "hello,world,foo,bar"
	run_test "ft_list_push_front" "special chars"       "$D" '!@#,$$,%%'
	run_test "ft_list_push_front" "100 elements"        "$D" "$MANY"
}

function test_list_size()
{
	local D="./srcs/ft_list_size/regular_use.c"
	local MANY=$(python3 -c 'print(",".join(["x"] * 100))')

	run_test "ft_list_size" "empty list"                "$D" ""
	run_test "ft_list_size" "one element"               "$D" "a"
	run_test "ft_list_size" "two elements"              "$D" "a,b"
	run_test "ft_list_size" "five elements"             "$D" "1,2,3,4,5"
	run_test "ft_list_size" "100 elements"              "$D" "$MANY"
}

function test_list_sort()
{
	local D="./srcs/ft_list_sort/regular_use.c"
	local MANY=$(python3 -c 'import random; random.seed(42); print(",".join(map(str, random.sample(range(1000), 100))))')

	run_test "ft_list_sort" "empty list"                "$D" ""
	run_test "ft_list_sort" "single element"            "$D" "a"
	run_test "ft_list_sort" "already sorted"            "$D" "a,b,c,d"
	run_test "ft_list_sort" "reverse sorted"            "$D" "d,c,b,a"
	run_test "ft_list_sort" "random order"              "$D" "c,a,d,b,e"
	run_test "ft_list_sort" "with duplicates"           "$D" "b,a,b,a,c"
	run_test "ft_list_sort" "numeric strings"           "$D" "5,3,1,4,2"
	run_test "ft_list_sort" "100 elements"              "$D" "$MANY"
}

function test_list_remove_if()
{
	local D="./srcs/ft_list_remove_if/regular_use.c"

	run_test "ft_list_remove_if" "empty list"           "$D" ""           "a"
	run_test "ft_list_remove_if" "remove first"         "$D" "a,b,c,d"    "a"
	run_test "ft_list_remove_if" "remove middle"        "$D" "a,b,c,d"    "c"
	run_test "ft_list_remove_if" "remove last"          "$D" "a,b,c,d"    "d"
	run_test "ft_list_remove_if" "remove all"           "$D" "a,a,a,a"    "a"
	run_test "ft_list_remove_if" "remove none"          "$D" "a,b,c,d"    "z"
	run_test "ft_list_remove_if" "remove duplicates"    "$D" "a,b,a,b,a"  "a"
	run_test "ft_list_remove_if" "remove empty string"  "$D" "a,,b,,c"    ""
	run_test "ft_list_remove_if" "single element match" "$D" "a"          "a"
	run_test "ft_list_remove_if" "single element no match" "$D" "a"       "z"
}

# =====================
# = SIMD MEMCHR TESTS =
# =====================

function test_simd_memchr()
{
	local D="./srcs/ft_simd_memchr/regular_use.c"
	local BIG1=$(repeat_char "a" 4096)

	run_test "ft_simd_memchr" "find at start"           "$D" "hello"    "h"
	run_test "ft_simd_memchr" "find in middle"          "$D" "hello"    "l"
	run_test "ft_simd_memchr" "find at end"             "$D" "hello"    "o"
	run_test "ft_simd_memchr" "not found"               "$D" "hello"    "z"
	run_test "ft_simd_memchr" "empty string"            "$D" ""         "a"
	run_test "ft_simd_memchr" "first of many matches"   "$D" "abcabc"   "a"
	run_test "ft_simd_memchr" "single char string"      "$D" "a"        "a"
	run_test "ft_simd_memchr" "single char no match"    "$D" "a"        "b"
	run_test "ft_simd_memchr" "find null byte"          "$D" "hello"    "_null_"
	run_test "ft_simd_memchr" "find high byte 0xff"     "$D" "hello"    "_ff_"
	run_test "ft_simd_memchr" "match on big buffer"     "$D" "$BIG1"    "a"
}

# ========
# = MAIN =
# ========
function main()
{
	if [ "$LIBASM_PATH" == "" ]; then
		if [ -f "./libasm.a" ]; then
			LIBASM_PATH="./libasm.a"
		else
			printf "Missing libasm path, set it manually with : %s /path/to/libasm.a\n" "$0"
			exit 1
		fi
	fi

	if [ ! -f "$LIBASM_PATH" ]; then
		printf "libasm path does not exist: %s\n" "$LIBASM_PATH"
		exit 1
	fi

	printf "${FR_BLUE}=== TEST FT_STRLEN ===\n${RESET}"
	test_strlen

	printf "\n${FR_BLUE}=== TEST FT_STRCPY ===\n${RESET}"
	test_strcpy

	printf "\n${FR_BLUE}=== TEST FT_STRCMP ===\n${RESET}"
	test_strcmp

	printf "\n${FR_BLUE}=== TEST FT_WRITE ===\n${RESET}"
	test_write

	printf "\n${FR_BLUE}=== TEST FT_READ ===\n${RESET}"
	test_read

	printf "\n${FR_BLUE}=== TEST FT_STRDUP ===\n${RESET}"
	test_strdup

	printf "\n${FR_BLUE}=== TEST FT_CALLOC ===\n${RESET}"
	test_calloc

	printf "\n${FR_BLUE}=== TEST FT_ATOI_BASE ===\n${RESET}"
	test_atoi_base

	printf "\n${FR_BLUE}=== TEST FT_LIST_PUSH_FRONT ===\n${RESET}"
	test_list_push_front

	printf "\n${FR_BLUE}=== TEST FT_LIST_SIZE ===\n${RESET}"
	test_list_size

	printf "\n${FR_BLUE}=== TEST FT_LIST_SORT ===\n${RESET}"
	test_list_sort

	printf "\n${FR_BLUE}=== TEST FT_LIST_REMOVE_IF ===\n${RESET}"
	test_list_remove_if

	printf "\n${FR_BLUE}=== TEST FT_SIMD_MEMCHR ===\n${RESET}"
	test_simd_memchr
}

main
