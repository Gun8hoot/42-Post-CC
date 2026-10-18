BITS 64

extern malloc

section .text
	global ft_calloc

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; This function allocated a place on the heap of the size of n * size
	; void		*ft_calloc(size_t n, size_t size);
	ft_calloc:
		; --- Save on the stack every arguments ---
		push rsi 							; size save_size = size
		push rdi 							; size save_n = n

		; --- Compute the size to allocated in memory ---
		imul rdi, rsi						; total_size = n * size

		; --- Check if our value overflow size_t ---
		test edi, edi
		jo overflow

		push rdi							; Save total_size for later

		; --- Allocated the memory using malloc ---
		call malloc wrt ..plt				; malloc(total_size)

		pop rcx								; Recover total_size

		test rax, rax
		jz done								; if (!arr)

		; Check if the size of each elem is 0
		cmp [rsp + 8], 0x00
		je done								; if (save_size == 0)

		xor r8d, r8d						; i = 0
		loop:
			cmp r8d, ecx
			je done							; if (i == total_size)
			mov byte [rax + r8], 0x00		; arr[i] = '\0'
			inc r8d							; i++
			jmp loop

		overflow:
			xor rax, rax					; return (NULL) // OVERFLOW CASE
		done:
			pop rdi
			pop rsi
			ret
