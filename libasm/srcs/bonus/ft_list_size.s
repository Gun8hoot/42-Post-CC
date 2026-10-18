BITS 64

struc s_list
	.data resq 1
	.next resq 1
endstruc

extern __errno_location

section .text
global ft_list_size

ft_list_size:
	push rcx
	push rsi
	push rdi

	xor rax, rax						; i = 0
	ft_list_size_loop:
		test rdi, rdi
		jz ft_list_size_end				; if (node == NULL)

		inc eax							;
		jz ft_list_size_ov				; if i overflow unsigned int
		mov rdi, [rdi + s_list.next]

		jmp ft_list_size_loop

	ft_list_size_ov:
		call __errno_location wrt ..plt
		mov [rax], 84					; EOVERFLOW errno
	ft_list_size_err:
		xor rax, rax
	ft_list_size_end:
		pop rsi
		pop rdi
		pop rcx
		ret
