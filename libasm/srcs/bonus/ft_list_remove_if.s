BITS 64

struc s_list
	.data resq 1
	.next resq 1
endstruc

section .text
global ft_list_remove_if

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function will search every node to remove on a linked list using the cmp
; function and remove it using the free_fct pointed function
; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
ft_list_remove_if:
	; --- Check linked_list ptr and the data reference ptr ---
	push r10
	push rdx
	push rsi
	push rdi

	; --- Check linked_list ptr and the data reference ptr ---
	test rdi, rdi
	jz .end
	test rsi, rsi
	jz .end

	mov rcx, rdi					; before_node = begin_list

	loop:
		cmp rcx, 0x00
		jz .end

		push rcx
		mov rax, [rsp + 16]
		mov rdi, [rsp + 8]
		mov rsi, [rcx + s_list.data]
		call rax
		pop rcx

		cmp rax, 0
		jz .remove

		mov rcx, [rcx + s_list.next]
		jmp loop
		.remove:


	.end:
		pop rdi
		pop rsi
		pop rdx
		pop r10
		ret
