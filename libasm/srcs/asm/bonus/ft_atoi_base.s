
extern ft_strlen

section .text
global ft_atoi_base
global ft_is_whitespace

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int ft_atoi_base(char *str, char *base)
; Convert a based string to his base10 number
; Todo:
;   - Fix overflow by storing the result on a 64bit (long long) instead of a 32bit (int)
;     and then return the result in
ft_atoi_base:
	; --- Stack initialization ---
	push r8										; Only for stack alignment
	push rbp
	push rsi									; The base "char *base"
	push rdi									; The string to convert "char *str"

	mov rbp, rsp
	sub rsp, 16									; Allocate two int on the stack, those int will be
												;    1. The return value (8 bytes for int overflow handling)
												;    2. An int to keep the sign (4 bytes)
												;    3. Padding to stack align (4 bytes)

	mov qword [rsp], 0x00						; Initialized our int result to 0
	mov dword [rsp + 8], 0x01					; Initialized our int sign to 1

	; --- Base checking ---
	; Check if out base is valid
	mov rdi, rsi
	call check_base
	; Checking the result of check_base()
	cmp rax, 1
	jnz ft_atoi_base_error						; if (!check_base(base))

	; --- Real algorithm initialization ---
	; Keeping the size of our base
	call ft_strlen
	mov r9, rax

	mov rdi, [rsp + 16]							; Recover from the stack our string "str"
	xor r8, r8

	; --- Skipping every whitespace we found ---
	skip_whitespace:
		skip_whitespace_loop:
			mov al, byte [rdi + r8]
			cmp al, 0x00
			jz skip_whitespace_loop_end			; if (!str[i])
			mov rcx, rdi						; Saving the our entier string "str" in rcx
			movzx edi, al						; Put the character on the function parameter
			call ft_is_whitespace				; ft_is_whitespace(str[i])
			mov rdi, rcx						; Recover our string "str" in rdi
			cmp rax, 0x1
			jnz skip_whitespace_loop_end		; if (!ft_is_whitespace(str[i]))
			jmp skip_whitespace_loop
		skip_whitespace_loop_end:
			nop

	; --- Process every mathematical operation sign ---
	process_sign:
		process_sign_loop:
			mov al, byte [rdi + r8]
			cmp al, 0x00
			jz process_sign_loop_end			; if (!str[i])
			cmp al, '+'
			jz found_plus						; if (str[i] == '+')
			cmp al, '-'
			jz found_minus						; if (str[i] == '-')
			jmp process_sign_loop_end
			found_plus:
				mov dword [rsp + 8], 0x01		; sign = 1
				inc r8
				jmp process_sign_loop
			found_minus:
				neg dword [rsp + 8]				; sign *= -1
				inc r8
				jmp process_sign_loop
		process_sign_loop_end:
			nop

	; --- Convert based number in a base10 int ---
	process_number:
		process_number_loop:
			mov al, byte [rdi + r8]
			cmp al, 0x00
			jz process_number_loop_end
			; Get the value of a based number, like for F in hex this will be 15
			get_value_based:
				xor r13, r13
				get_value_based_loop:
					cmp byte [rsi + r13], 0x00
					jz process_number_loop_end	; if base[j] == '\0'
					cmp al, byte [rsi + r13]
					jz get_value_based_loop_end	; if base[j] == str[i]
					inc r13
					jmp get_value_based_loop

				get_value_based_loop_end:
					nop

			mov rax, qword [rsp]				; Get result from the stack
			imul rax, r9						; result *= base_length
			cmp dword [rsp + 8], 0
			jl 	negative_value					; if (sign < 0)
			add rax, r13						; result += base[j]
			jmp handle_overflow

			negative_value:
				sub rax, r13
			handle_overflow:
				; Checking underflow/overflow
				cmp rax, INT_MIN
				jl ft_atoi_base_error				; if (result < INT_MIN)
				cmp rax, INT_MAX
				jg ft_atoi_base_error				; if (result > INT_MAX)

			mov qword [rsp], rax
			inc r8									; i++
			jmp process_number_loop
		process_number_loop_end:
			nop

	mov eax, dword [rsp]
	imul eax, dword [rsp + 8]						; result *= sign
	jmp ft_atoi_base_end



	ft_atoi_base_error:
		xor rax, rax
	ft_atoi_base_end:
		add rsp, 16
		mov rsp, rbp
		pop rdi
		pop rsi
		pop rbp
		pop r8
		ret										; return (result)

; https://www.youtube.com/watch?v=woCCcOlopNo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function check if our base (put in rdi) is valid by looking if the size > 1,
;   if it contain unallow character (see invalid_base in .rodata) and if the base
;   contain duplicated character.
; Todo:
;   - Complete rewrite v1 is ulgy asf
; Register usage:
;   - rdi = Our base to check
;   - r11 = A set with invalid character
;   - r8  = Our main loop index (i)
;   - r10 = Our inner loop index (j)
;   - bl  = Our base current character (base[i])
;   - cl  = Our set current character (invalid_base[j])
check_base:
	; Initialized our stack
	push rbp									; Save our original base pointer on the stack
	push rdx									; Save our rdx register on the stack
	push rsi									; Save our rsi register on the stack
	push rdi									; Save our base on the stack
	push r10
	push r8										; Save r8 on the stack
	mov rbp, rsp								; Save our rsp on rbp
	sub rsp, 256								; Back from 256 bytes (256 ascii character available for the array)

	; Setting our array at 0s
	lea rdi, [rsp]								; Load the address of the array
	mov rsi, 0x00								; We want fill our array with 0s
	mov rdx, 256								; The size of our array
	call ft_memset

	; Check that our base is not empty or have one char
	mov rdi, [rbp + 16] ; Take the base string from the stack from the
	call ft_strlen
	cmp rax, 1
	jle error ; if strlen(base) <= 1

	; Initialized our main loop
	lea r11, [rel invalid_base] ; Load the address of the symbole with invalid base character
	xor r8, r8 ; i = 0

	; Main loop
	loop:
		xor r10, r10 					; j = 0
		mov bl, byte [rdi + r8]
		cmp bl, 0x00					; while (base[i])
		jz done
		movzx rax, bl					; We cannot do CPU operation between a two register that are not at the same size,
										; so here i put our base[i] in rax to do like bitmap[current_character] == 1
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
			inc r10					; j++
			jmp inner_loop			; Redo the loop
		end_inner_loop:
			inc r8					; i++
			jmp loop
	done:
		mov rax, 1
		jmp end
	error:
		mov rax, 0
		jmp end
	end:
		add rsp, 256
		pop r8
		pop r10
		pop rdi
		pop rsi
		pop rdx
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function check whether a character is a whitespace or not
;
; Return (rax):
;   0 : If the character is not a whitespace
;   1 : If the character is a whitespace
ft_is_whitespace:
	push rdi
	push rsi
	push rcx
	push r8

	lea rsi, [rel whitespace]		; Load the address of the array
	xor r8, r8						; i = 0
	xor eax, eax					; Setting our return register to zero

	; Loop through our whitespace character set
	is_whitespace_loop:
		mov cl, byte [rsi + r8]
		cmp cl, 0x00				; if (c == '\0)
		jz is_whitespace_end
		cmp dil, cl					; if (c == whitespace[i])
		jz is_whitespace_change_state
		inc r8
		jmp is_whitespace_loop

	; Change our return value to 1
	is_whitespace_change_state:
		mov eax, 1

	; Restore the stack and used register
	is_whitespace_end:
		pop r8
		pop rcx
		pop rsi
		pop rdi
		ret

section .rodata
	invalid_base db "+-", 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, " ", 0 ; "+-\a\b\t\n\v\f\r "
	whitespace db 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, " ", 0 ; "\a\b\t\n\v\f\r "

	INT_MIN equ -2147483648
	INT_MAX equ 2147483647
