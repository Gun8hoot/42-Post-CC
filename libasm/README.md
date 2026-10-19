
<div align="center">
	<h1>Libasm</h1>
</div>

<div align="center">
	<h2>Description :</h2>
</div>

On this project we have create a static library entirely coded in ASM x86-x64.
The library contain:
#### Mendatory
- **ft_strlen** : A replication of **strlen** that count every character on a c-string
- **ft_strcpy** : A replication of **strcpy** that copy a c-string on an another c-string
- **ft_strcmp** : A replication of **strcmp** that compare two C-string and return the difference between the two different character if one of the string is different
- **ft_read**   : A replication of **the wrapper for the read linux syscall**. The function will read n th bytes from the given fd and put the content on a buffer
- **ft_write**  : A replication of **the wrapper for the write linux syscall**. The function will write a buffer on a fd
- **ft_calloc** : A replication of **calloc** that allocated a space on the heap memory and setting every bytes allocated to 0
- **ft_strdup** : A replication of **strdup** that copy a C-string on a buffer allocated on the heap memory
#### Bonus
- **ft_atoi_base** : A function that convert any number from any base (binary, octal, decimal, hexadecimal, ...) and return the result on a integer
- **ft_list_push_front** : A function that add a node at the beginning of a s_list linked list
- **ft_list_size** : A function that count every element on a s_list linked list
- **ft_list_sort** : A function that sort every node of a linked list based on his content
- **ft_list_remove_if** : A function that remove any node
- **ft_simd_memchr** : 

<div align="center">
	<h2>Requirement :</h2>
</div>

- **glibc**
- **GNU Make** 
- **NASM**

<div align="center">
	<h2>Usage :</h2>
</div>

- Create the library with the mandatory part using GNU Make
```sh
make
```
- Create the library with the mandatory + bonus part using GNU Make
```sh
make bonus
```
- Use it when compile / linking
```sh
# Using gcc
gcc /path/to/c/sources.c ./libasm.a -o program
# Using g++
g++ /path/to/c/sources.cpp ./libasm.a -o program
# Using ld
ld /path/to/any/object/file.o ./libasm.a -o program
```
