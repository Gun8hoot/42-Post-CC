BITS 64

; To check read special error case
section .text
	global ft_read
	extern __errno_location

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; This function is a wrapper who call the actual read syscall
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ssize_t	ft_read(int fd, void buf[count], size_t count);
	ft_read:
		push rsi
		push rdi

		mov rax, 0x00
		syscall							; read(fd, str, length_str) // fd == rdi, str == rsi, length_str == rcx

		test rax, rax
		jns ft_read_end					; if (ret >= 0)

		neg rax							; ret *= -1
		mov rdi, rax

		call __errno_location wrt ..plt ; This function get a pointer to the actual errno thread
		mov [rax], rdi					; *errno = ret
		mov rax, -1						; ret = -1
		ft_read_end:
			pop rdi
			pop rsi
			ret							; return (ret)
