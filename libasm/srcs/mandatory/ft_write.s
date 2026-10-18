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

		neg rax ; Invert sign bit to get a positif number
		mov rdi, rax ; Save the result in rdi

		call __errno_location wrt ..plt ; Get the errno pointer
		mov [rax], rdi ; Put the actual errno code on errno
		mov rax, -1 ; Modify the return code to -1

		.done:
			ret
