BITS 64

section .text
	global ft_strlen
	ft_strlen:
		; INITIALIZE
		xor rsi, rsi ; Setting rsi to 0

		loop:
			cmp [rdi + rsi], 0x00 ; Check if the current character is a \0
			jz endloop ; If its not
			inc rsi ; Increase rsi
			jmp loop ; Redo the loop
		endloop:
			mov rax, rsi ; Put the value of rsi (our counter) in rax
			ret ; Return the value
