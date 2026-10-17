
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

function	test_strcmp
{
	local TEST_NAME=$1
	local TEST_FILENAME=$2
	local STRING=$3
	local CATCH_STDOUT

	$CC $TEST_FILENAME $LIBASM_PATH -o $COMPILED_BINARY_PATH &> /dev/null
	if [ $? -ne 0 ]; then
		printf "[-] ft_strlen : $TEST_NAME failed to compiled!\n"
		return
	fi
	$COMPILED_BINARY_PATH "$STRING" "$TEST_NAME"
	if [ $? == $SEGFAULT_CODE ]; then
		printf "$FR_RED[-] ft_strlen : Segfault occurent with '$STRING' as argument!\n$RESET"
	fi
}

function	test_strcpy
{
	local TEST_NAME=$1
	local TEST_FILENAME=$2
	local STRING=$3
	local CATCH_STDOUT

	$CC $TEST_FILENAME $LIBASM_PATH -o $COMPILED_BINARY_PATH &> /dev/null
	if [ $? -ne 0 ]; then
		printf "[-] ft_strlen : $TEST_NAME failed to compiled!\n"
		return
	fi
	$COMPILED_BINARY_PATH "$STRING" "$TEST_NAME"
	if [ $? == $SEGFAULT_CODE ]; then
		printf "$FR_RED[-] ft_strlen : Segfault occurent with '$STRING' as argument!\n$RESET"
	fi
}

function	test_strlen
{
	local TEST_NAME=$1
	local TEST_FILENAME=$2
	local STRING=$3
	local CATCH_STDOUT

	$CC $TEST_FILENAME $LIBASM_PATH -o $COMPILED_BINARY_PATH &> /dev/null
	if [ $? -ne 0 ]; then
		printf "[-] ft_strlen : $TEST_NAME failed to compiled!\n"
		return
	fi
	$COMPILED_BINARY_PATH "$STRING" "$TEST_NAME"
	if [ $? == $SEGFAULT_CODE ]; then
		printf "$FR_RED[-] ft_strlen : Segfault occurent with '$STRING' as argument!\n$RESET"
	fi
}

function main
{
	if [ "$LIBASM_PATH" == "" ] && [ -f "./libasm.a" ]; then
		LIBASM_PATH="./libasm.a"
	elif [ "$LIBASM_PATH" == "" ] && [ -f "./libasm.a" ]; then
		printf "Missing libasm path, set it manually with : %s /path/to/libasm.a\n" $0
		exit 1
	fi

	printf "$FR_BLUE=== TEST FT_STRLEN ===\n$RESET"
	test_strlen "short string n°1" "./srcs/ft_strlen/regular_use.c" "hello"
	test_strlen "short string n°2" "./srcs/ft_strlen/regular_use.c" "This is a string\nidk what to write"
	test_strlen "big string n°1" "./srcs/ft_strlen/regular_use.c" "$(python3 -c 'print("a" * 777)')"
	test_strlen "big string n°2" "./srcs/ft_strlen/regular_use.c" "$(python3 -c 'print("a" * 777)')"
	test_strlen "Empty string" "./srcs/ft_strlen/regular_use.c" ""

	printf "\n$FR_BLUE=== TEST FT_STRCPY ===\n$RESET"
	test_strcpy "short string n°1" "./srcs/ft_strcpy/regular_use.c" "hello"
	test_strcpy "short string n°1" "./srcs/ft_strcpy/regular_use.c" "akzhgkhjzeahkjzeakhjeza"
	test_strcpy "short string n°1" "./srcs/ft_strcpy/regular_use.c" "$(python3 -c 'print("a" * 777)')"

	printf "\n$FR_BLUE=== TEST FT_STRCMP ===\n$RESET"
	test_strcmp "short string n°1" "./srcs/ft_strcmp/regular_use.c" "hello"
	test_strcmp "short string n°1" "./srcs/ft_strcmp/regular_use.c" "azezaezaeazeazeazezaezaee"
	test_strcmp "short string n°1" "./srcs/ft_strcmp/regular_use.c" "$(python3 -c 'print("a" * 777)')"
}

main
