BITS 64

section .text
global ft_strlen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function calculate the length of a string by passing through every
; character and check if the current character is a \0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; size_t	ft_strlen(char *str)
ft_strlen:
	; --- INITIALIZE ---
	push rsi
	xor rsi, rsi				; i = 0

	cmp rdi, 0
	jz endloop					; if (!str)

	; --- Loop through elements ---
	loop:
		cmp [rdi + rsi], 0x00
		jz endloop				; str[i] == '\0'
		inc rsi					; i++
		jmp loop
	endloop:
		mov rax, rsi			; return (i)
		pop rsi
		ret
