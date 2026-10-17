BITS 64

struc s_list
	.data resq 1
	.next resq 1
endstruc

section .text
global ft_list_sort
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function take the head of a linked list struct s_list and sort every
; data on the right order
; void ft_list_sort(t_list **begin_list, int (*cmp)());
ft_list_sort:
	; --- Initialize stack ---
	push rsi
	push rdi

	; --- End stack Initialization ---

	mov r10w, 0x1											; swapped = 1

	test rsi, rsi
	jz ft_list_sort_end										; if (cmp == NULL)

	bubble_sort:
		bubble_sort_loop:
			cmp r10w, 0
			je ft_list_sort_end								; if (swapped == 0)
			mov r10w, 0										; swapped = 0
			mov rbx, [rsp + 0]
			mov rbx, [rbx]									; node = *begin_list
			bubble_sort_inner_loop:
				; Check current node
				test rbx, rbx
				jz bubble_sort_loop							; if (node == NULL)

				; Check next node
				mov rcx, [rbx + s_list.next]				; next_node = node->next
				test rcx, rcx
				jz bubble_sort_loop							; if (next_node == NULL)

				; -- Pre call stack preparation --
				push rbx
				push rcx

				; Call (*cmp)(void *, void*)
				mov rax, [rsp + 24]
				mov rdi, [rbx + s_list.data]
				mov rsi, [rcx + s_list.data]
				call rax									; (cmp)(cmp1, cmp2)

				; -- Post call stack restitution --
				pop rcx
				pop rbx

				cmp eax, 0
				jg bubble_sort_inner_loop_will_swap			; if ((*cmp)(void*,void*) > 0)
				mov rbx, [rbx + s_list.next]				; node = node->next
				jmp bubble_sort_inner_loop
				bubble_sort_inner_loop_will_swap:
					lea rdi, [rbx + s_list.data]
					lea rsi, [rcx + s_list.data]
					call ft_swap
					mov r10w, 1								; swapped = 1
					mov rbx, [rbx + s_list.next]			; node = node->next
					jmp  bubble_sort_inner_loop

	ft_list_sort_end:
		pop rdi
		pop rsi
		ret

; void ft_swap(void *data1, void *data2)
ft_swap:
	; --- Initialize stack ---
	push r8
	push rsi
	push rdi
	; --- End stack Initialization ---

	; --- Check before swap ---
	test rdi, rdi
	jz ft_swap.end				; if (data1 == NULL)

	test rsi, rsi
	jz ft_swap.end				; if (data2 == NULL)

	; --- Swap ---
	mov r8, [rdi]				; save = data1
	mov r9, [rsi]				; save = data1
	mov [rdi], r9				; data1 = data2
	mov [rsi], r8				; data2 = save

	.end:
		; --- Epilogue ---
		pop rdi
		pop rsi
		pop r8
		ret
		; --- End epilogue ---
