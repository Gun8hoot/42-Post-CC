BITS 64


section .text
	global ft_write
	extern __errno_location

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; This function is a wrapper who call the actual write syscall
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ssize_t	ft_write(int fd, void buf[count], size_t count);
	ft_write:
		; Calling the syscall (function parameter is already on correct register)
		mov rax, 1
		syscall

		; Check if the result
		test rax, rax
		jns .done 						; if (ret >= 0)

		neg rax							; ret *= -1
		mov rdi, rax

		call __errno_location wrt ..plt ; Get a pointer to the errno thread
		mov [rax], rdi					; *errno = ret
		mov rax, -1						; ret = -1
		.done:
			ret
