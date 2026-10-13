
extern ft_strlen

section .text
global ft_atoi_base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int ft_atoi_base(char *str, char *base)
; Convert a based string to his base10 number
ft_atoi_base:
	push rsi ; Push the base on the stack
	push rdi ; Push the number to convert on the stack

	; Check our base
	mov rdi, rsi
	call check_base
	;cmp rax, 1 ; If the base is invalid
	;jnz end

	ft_atoi_base_end:
		add rsp, 16 ; Reset the stack at his normal state
		ret ; return

; https://www.youtube.com/watch?v=woCCcOlopNo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function check if our base (put in rdi) is valid by looking if the size > 1,
;   if it contain unallow character (see invalid_base in .rodata) and if the base
;   contain duplicated character.
; Todo:
;   - Complete rewrite v1 is ulgy asf
check_base:
	; Stack initialization
	push rbp
	push rdi
	mov rbp, rsp
	sub rsp, 256								; Back from 256 bytes (256 ascii character available)

	; Clearing array
	lea rdi, [rsp]								; Load the address of the array
	mov rsi, 0x00								; We want fill our array with 0s
	mov rdx, 256								; The size of our array
	call ft_memset

	; Check that our base is not empty or have one char
	mov rdi, [rsp + 256] ; Take the base string from the stack from the
	call ft_strlen
	cmp rax, 1
	jle error ; if strlen(base) <= 1

	; Init before loop start
	lea r11, [rel invalid_base] ; Load the address of the symbole with invalid base character
	xor r8, r8 ; Setting r8 (i) to zero

	; Main loop
	loop:
		xor r10, r10 			; j = 0
		mov bl, byte [rdi + r8]
		cmp bl, 0x00			; base[i] == '\0'
		jz done
		movzx rax, bl
		cmp byte [rsp + rax], 1 		; bitmap[i] == 1
		jz error
		mov byte [rsp + rax], 1

		mov sil, 1
		; Second loop
		inner_loop:
			mov cl, [r11 + r10]		; cl = invalid_base[j]
			cmp cl, 0x00			; invalid_base[j] == '\0' ?
			jz end_inner_loop		; == '\0'
			cmp bl, cl				; base[i] == invalid_base[j] ?
			jz error				; == invalid_base[j]
			inc r10					; r10++
			jmp inner_loop			; Redo the loop
		end_inner_loop:
			inc r8
			jmp loop
	done:
		mov rax, 1
		jmp end
	error:
		mov rax, 0
		jmp end
	end:
		add rsp, 256
		pop rdi
		pop rbp
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function initialize n bytes from buff to the value store in c
; Prototype:
;   void *ft_memset(void *buff, int c, size_t n);
; Register:
;   - rax : The address of the buffer
;   - r8  : The register where the counter is store
;   - sil : The register where the value of byte to set is stored
ft_memset:
	push r8
	push rdx
	push rsi
	push rdi

	mov rax, rdi
	xor r8, r8
	memset_loop: 					; while (i < n)
		cmp r8, rdx
		jz memset_end				; If i == c, break
		mov byte [rax + r8], sil	; buff[i] = c
		inc r8 						; i++
		jmp memset_loop

	memset_end:
		pop rdi
		pop rsi
		pop rdx
		pop r8
		ret


section .rodata
	invalid_base db "+-", 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, " ", 0 ; "+-\a\b\t\n\v\f\r "
	invalid_base_len equ $ - invalid_base - 1

	NUMBER_ASCII_CHAR equ 256
