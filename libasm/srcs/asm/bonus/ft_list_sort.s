BITS 64

struc s_list
	.data resq 1
	.next resq 1
endstruc

section .text
global ft_list_sort

; void ft_list_sort(t_list **begin_list, int (*cmp)());
ft_list_sort:
	; --- Initialize stack ---
	push r10w
	push rbx
	push rsi
	push rdi

	; --- End stack Initialization ---

	mov byte r10w, 1										; swapped = 1

	test rsi, rsi
	jz ft_list_sort.end										; if (cmp == NULL)

	mov rbx, [rdi]											; node = *begin_list

	bubble_sort:
		.loop:
			cmp r10w, 0
			je ft_list_sort.end								; if (swapped == 0)
			.inner_loop:
				; Check current node
				test rbx, rbx
				jz bubble_sort.loop							; if (node == NULL)

				; Check next node
				mov rcx, [rbx + s_list.next]				; next_node = node->next
				test rcx, rcx
				jz bubble_sort.loop							; if (next_node == NULL)

				; Call (*cmp)(void *, void*)
				mov rax, [rsp + 8]
				mov rdi, [rbx + s_list.data]
				mov rsi, [rcx + s_list.data]
				call rax									; (cmp)(node->data, next_node->data)

				cmp rax, 0
				jge bubble_sort.loop.inner_loop.will_swap	;	if ((*cmp)(void*,void*) > 0)
				jmp bubble_sort.loop.inner_loop
				.will_swap:
					mov r10w, 1
					jmp ft_swap
					jmp  bubble_sort.loop.inner_loop

	.end:
		pop rdi
		pop rsi
		pop rbx
		pop r10w

; void ft_swap(void *data1, void *data2)
ft_swap:
	; --- Initialize stack ---
	push r8
	push rbp
	push rsi
	push rdi
	mov rbp, rsp
	; --- End stack Initialization ---

	; --- Check before swap ---
	test rdi, rdi
	jz ft_swap.end				; if (data1 == NULL)

	test rsi, rsi
	jz ft_swap.end				; if (data2 == NULL)

	; --- Swap ---
	mov r8, qword [rdi]			; save = *data1
	mov rdi, rsi				; *data1 = *data2
	mov rsi, r8					; *data2 = *save

	.end:
		; --- Epilogue ---
		mov rsp, rbp
		pop rdi
		pop rsi
		pop rbp
		pop r8
		; --- End epilogue ---
