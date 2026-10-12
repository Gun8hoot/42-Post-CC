
extern ft_strlen

section .text
	global ft_atoi_base

	; int ft_atoi_base(char *str, char *base);
	ft_atoi_base:
		push rsi ; Push the base on the stack
		push rdi ; Push the number to convert on the stack
		end:
			add rsp, 16 ; Reset the stack at his normal state
			ret ; return

	check_base:
		call ft_strlen
		mov rsi, rax ; Take the result of strlen in rsi
		lea r11, [rel invalid_base]
		xor r8, r8 ; Setting r8 (i) to zero
		loop:
			xor r10, r10 ; Setting r10 (j) to zero
			inner_loop:
				mov bl, byte [rdi + r10]

section .rodata
invalid_base db "+-\a\b\t\n\v\f\r "
invalid_base_len db 10
