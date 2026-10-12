BITS 64

section .text
	global ft_strcmp

	ft_strcmp:
		xor rdx, rdx ; Setting rsi to 0

		loop:
			movzx eax, byte [rdi + rdx]
			movzx ecx, byte [rsi + rdx]
			cmp eax, ecx
			jne .different
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
