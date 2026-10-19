BITS 64

struc s_list
	.data resq 1
	.next resq 1
endstruc

extern free

section .text
global ft_list_remove_if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function will search every node to remove on a linked list using the cmp
; function and remove it using the free_fct pointed function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
ft_list_remove_if:
	; --- Save on the stack every arguments ---
	push rcx								; save void (*free_fct)(void *)
	push rdx								; save int (*cmp)()
	push rsi								; save void *data_ref
	push rdi								; save t_list **begin_list
	;; 32 bytes stack

	; --- Check pointer ---
	test rdi, rdi
	jz remove_if_end						; if (begin_list == NULL)
	test rdx, rdx
	jz remove_if_end						; if (cmp == NULL)
	test rcx, rcx
	jz remove_if_end						; if (free_fct == NULL)

	mov rcx, rdi							; struct s_list **ptr_save = begin_list

	loop:
		cmp qword [rcx], 0x00
		jz remove_if_end					; if (*ptr_save == NULL)

		mov r10, [rcx]						; struct s_list *node = *ptr_save

		; --- Prepare function parameter ---
		mov rax, [rsp + 16]					; cmp
		mov rdi, [rsp + 8]					; data_ref
		mov rsi, [r10 + s_list.data]		; node->data

		; --- Prepare stack ---
		push rcx
		push r10
		sub rsp, 8
		;; 56 bytes stack (+ 8 bytes of return address on the function)

		; --- Call cmp ---
		call rax							; cmp(data_ref, node->data)

		; --- Restore stack
		add rsp, 8
		pop r10
		pop rcx
		;; 32 bytes stack

		cmp eax, 0
		jz remove_node						; if (cmp_ret == 0)

		; else
		mov rdx, [rcx]
		lea rcx, [rdx + s_list.next]		; ptr_save = &(*ptr_save)->next
		jmp loop
		remove_node:
			mov r11, [r10 + s_list.next]
			mov [rcx], r11					; *ptr_save = node->next

			mov rax, [rsp + 24]				; free_fct
			mov rdi, [r10 + s_list.data]	; node->data

			push rcx
			push r10
			sub rsp, 8
			;; 56 bytes stack

			call rax					; free_fct(node->data)

			mov rdi, [rsp + 8]			; node
			call free wrt ..plt			; free(node)

			add rsp, 8
			pop r10
			pop rcx
			;; 32 bytes stack

			jmp loop

	remove_if_end:
		pop rdi
		pop rsi
		pop rdx
		pop r10
		;; 0 bytes stack
		ret
