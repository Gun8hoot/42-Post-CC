BITS 64

section .text
global ft_strcmp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function compare two strings to check if the content is the same by
; comparing every character and returning the difference
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int ft_strcpy(char *s1, char *s2)
ft_strcmp:
	push rsi
	push rdi

	loop:
		movzx eax, byte [rdi]		; c1 = *s1
		movzx ecx, byte [rsi]		; c2 = *s2

		cmp eax, 0x00
		jz .different				; if (c1 == '\0')
		cmp ecx, 0x00
		jz .different				; if (c2 == '\0')

		; Compare them
		cmp eax, ecx
		jne .different				; if (*s1 != *s2)
		inc rdi						; s1++
		inc rsi						; s2++
		jmp loop
		.different:
			sub eax, ecx			; ret = c1 - c2
	end:
		pop rdi
		pop rsi
		ret							; return (ret)
