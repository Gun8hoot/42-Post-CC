BITS 64

section .text
	global ft_write

	ft_write:

		; Calling the syscall (function parameter is already on correct register)
		mov rax, 1 ; WRITE syscall code
		syscall

		; Check if the result
		test rax, rax
		jz .done ; If no error have happened

		; Error handling

		.done:
			ret
