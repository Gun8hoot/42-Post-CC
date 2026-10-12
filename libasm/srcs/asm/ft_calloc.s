BITS 64

extern malloc

section .text
	global ft_calloc

	; void		*ft_calloc(size_t n, size_t size);
	ft_calloc:
		; Push for stack align
		push rsi ; Pushing size of each elem

		; Calculate the size to alloc
		mov rax, rdi
		mul rsi
		mov rdi, rax
		push rdi ; Save the real size to allocated on the stack

		; Allocated memory
		call malloc wrt ..plt
		pop rcx ; Recover the size to allocated

		; Check for malloc error
		test rax, rax
		jz done

		; Check if the size of each elem is 0
		cmp [rsp], 0x00
		je done

		xor r8, r8 ; Reset r8 to get 0
		sub rcx, 1   ; Align rcx to zero
		loop:
			mov byte [rax + r8], 0x00 ; Setting the current element to 0
			cmp r8, rcx ; Check we have write every bytes we should
			je done ; Exit the loop
			inc r8 ; Increase the counter by one
			jmp loop ; Redo the loop

		done:
			add rsp, 8
			ret
