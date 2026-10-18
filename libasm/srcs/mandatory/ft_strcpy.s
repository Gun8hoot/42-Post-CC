BITS 64

section .text
	global ft_strcpy

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; This function will copy the data store on src on the dest
	; Register:
	;   - rdi: Our destination string
	;   - rsi: Our source string
	; Return:
	;   - The address of the first character of the destination
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; char *ft_strcpy(char *dest, char *src)
	ft_strcpy:
		; --- Saving pointer on the stack ---
		push rbx
		push rsi
		push rdi

		loop:
			cmp byte [rsi], 0x00
			jz end						; if (*src == '\0')
			mov bl, byte [rsi]
			mov byte [rdi], bl			; *dest = *src
			inc rdi						; dest++
			inc rsi						; src++
			jmp loop

		end:
			mov byte [rdi], 0x00		; *dest = '\0'
			pop rdi
			pop rsi
			pop rbx
			mov rax, rdi				; return (dest)
			ret
