BITS 64

section .text
	global ft_strcpy

	; char *ft_strcpy(char *dest, char *src)
	ft_strcpy:
		; --- Saving pointer on the stack ---
		push rsi ; Putting the second parameter in the stack
		push rdi ; Putting the first parameter in the stack

		xor rsi, rsi ; Setting rsi to 0

		mov rax, [rsp + 8] ; Taking the address of the second parameter in rax
		loop:
			; --- Checking if character on both string in a \0 ---
			cmp [rax + rsi], 0x00
			jz end

			; --- Moving the content from the source to the destination ---
			mov bl, byte [rax + rsi]
			mov byte [rdi + rsi], bl

			inc rsi ; Increate rsi (i) by one
			jmp loop ; Hopping at the top of the loop

		end:
			mov byte [rdi + rsi], 0x00 ; Null terminate the string
			; Clearing the stack
			add rsp, 16
			; Returning the address of destination string
			mov rax, rdi
			ret
