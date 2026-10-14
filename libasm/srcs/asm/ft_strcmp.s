BITS 64

section .text
global ft_strcmp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function compare two strings to check if the content is the same
; Register:
;   - eax : The current character of s1
;   - ecx : The current character of s2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int ft_strcpy(char *s1, char *s2)
ft_strcmp:
	push r8
	push rsi
	push rdi

	loop:
		movzx eax, byte [rdi]
		movzx ecx, byte [rsi]

		cmp eax, 0x00
		jz .different
		cmp ecx, 0x00
		jz .different

		; Compare them
		cmp eax, ecx
		jne .different				; if (*s1 != *s2)
		inc rdi
		inc rsi
		jmp loop
		.different:
			sub eax, ecx ; Getting the difference between those two character
			jmp end
		.egal:
			xor rax, rax
			jmp end
	end:
		pop rdi
		pop rsi
		pop r8
		ret
