
extern ft_strlen

section .text
	global ft_atoi_base

	; int ft_atoi_base(char *str, char *base);
	ft_atoi_base:
		push rsi ; Push the base on the stack
		push rdi ; Push the number to convert on the stack
		mov rdi, rsi
		call check_base
		end:
			add rsp, 16 ; Reset the stack at his normal state
			ret ; return

	check_base:
		; Init before loop start
		lea r11, [rel invalid_base] ; Load the address of the symbole with invalid base character
		xor r8, r8 ; Setting r8 (i) to zero
		; Main loop
		loop:
			xor r10, r10 ; Setting r10 (j) to zero
			mov bl, [rdi + r8] ; Load our current base character in bl
			cmp bl, 0x00 ; If we are at the null terminator
			jz done
			; Second loop
			inner_loop:
				mov cl, [r11 + r10]
				cmp cl, 0x00			; Check if invalid_base[j] == '\0'
				jz end_inner_loop		; If last cmp is true
				cmp bl, cl				; Check if base[i] == invalid_base[j]
				jz error				; If its an error
				inc r10					; Increase r10 by one
				jmp inner_loop			; Redo the loop
			end_inner_loop:
				inc r8
				jmp loop
		done:
			mov rax, 1
			ret
		error:
			mov rax, 0
			ret


section .rodata
invalid_base db "+-\a\b\t\n\v\f\r ", 0x00
invalid_base_len db 10
