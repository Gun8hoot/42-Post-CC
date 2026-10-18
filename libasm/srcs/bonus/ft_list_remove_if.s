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
	push r10
	push rdx
	push rsi
	push rdi

	; --- Check linked_list ptr and the data reference ptr ---
	test rdi, rdi
	jz remove_if_end				; if (begin_list == NULL)
	test rdx, rdx
	jz remove_if_end				; if (cmp == NULL)
	test r10, r10
	jz remove_if_end				; if (free_fct == NULL)

	mov rcx, rdi					; struct s_list **ptr_save = begin_list

	loop:
		cmp [rcx], 0x00
		jz remove_if_end			; if (ptr_save == NULL)

		mov r10, [rcx]				; struct s_list *node = *ptr_save

		; --- Prepare stack ---
		push rcx
		push r10
		sub rsp, 8

		; --- Call cmp ---
		mov rax, [rsp + 16]
		mov rdi, [rsp + 8]
		mov rsi, [rcx + s_list.data]
		call rax					; cmp(data_ref, ptr_save->data)

		; --- Restore stack
		add rsp, 8
		pop r10
		pop rcx

		cmp rax, 0
		jz remove_node				; if (cmp_ret == 0)

		; else
		lea rcx, [rdx + s_list.next]; ptr_save = &(*ptr_save)->next
		mov rdx, rcx
		jmp loop
		remove_node:
			lea rcx, [rdx + s_list.next]; ptr_save = &(*ptr_save)->next
			mov [rdx], rcx

			push rdx
			push r10
			add rsp, 8

			mov rax, [rsp + 40]
			mov rdi, [r10 + s_list.data]
			call rax					; free_fct(node->data)

			mov rdi, [rsp + 8]
			call free wrt ..plt			; free(node)

			sub rsp, 8
			pop r10
			pop rdx

			jmp loop

	remove_if_end:
		pop rdi
		pop rsi
		pop rdx
		pop r10
		ret
