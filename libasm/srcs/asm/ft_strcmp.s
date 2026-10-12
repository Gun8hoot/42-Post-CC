BITS 64

section .text
	global ft_strcmp

	; int ft_strcpy(char *s1, char *s2)
	ft_strcmp:
		xor rdx, rdx ; Setting rsi to 0

		loop:
			; Moving our character two on eax and ecx
			movzx eax, byte [rdi + rdx]
			movzx ecx, byte [rsi + rdx]

			; Compare them
			cmp eax, ecx
			jne .different ; If they different
			test eax, eax
			je .egal
			inc rdx
			jmp loop
			.different:
				sub eax, ecx ; Getting the difference between those two character
				ret
			.egal:
				xor rax, rax
				ret
