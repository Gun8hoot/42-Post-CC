BITS 64


section .text
	global ft_write
	extern __errno_location
	ft_write:

		; Calling the syscall (function parameter is already on correct register)
		mov rax, 1 ; WRITE syscall code
		syscall

		; Check if the result
		test rax, rax
		jns .done ; Check if the sign bits is a 0

		; Error handling
		neg rax
		mov rdi, rax
		call __errno_location wrt ..plt
		mov [rax], rdi
		mov rax, -1 ;

		.done:
			ret
