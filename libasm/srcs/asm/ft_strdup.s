BITS 64

extern malloc
extern ft_strlen

section .text
	global ft_strdup

	ft_strdup:
		push rbp
		push rdi
		mov rbp, rsp

		; Get the size of our strijng
		mov rax, rdi
		call ft_strlen

		; Allocated memory for our string
		add rax, 1 ; Adding one for the null byte
		mov rdi, rax
		call malloc wrt ..plt ; Calling malloc

		; Check if malloc have return NULL
		test rax, rax
		jz done

		mov rdi, [rsp]
		xor rsi, rsi
		loop:
			mov cl, byte [rdi + rsi]
			mov [rax + rsi], cl
			cmp cl, 0x00
			jz done
			inc rsi
			jmp loop
		done:
			pop rdi
			pop rbp
			ret
