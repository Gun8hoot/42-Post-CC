BITS 64

; To check read special error case
section .text
	global ft_read
	extern __errno_location

	ft_read:
		push rsi
		push rdi

		mov rax, 0x00
		syscall

		test rax, rax
		jns ft_read_end

		neg rax ; Invert sign bit to get a positif number
		mov rdi, rax ; Save the result in rdi

		call __errno_location wrt ..plt ; Get the errno pointer
		mov [rax], rdi ; Put the actual errno code on errno
		mov rax, -1 ; Modify the return code to -1
		ft_read_end:
			pop rdi
			pop rsi
			ret
