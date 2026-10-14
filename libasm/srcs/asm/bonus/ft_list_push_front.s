;;;;;;;;;;;;;;;;;;;;;;;;;
;typedef struct s_list
;{
;    void *data;
;    struct s_list *next;
;} t_list;

BITS 64

extern ft_calloc

section .text
global ft_list_push_front

; void ft_list_push_front(t_list **begin_list, void *data);
ft_list_push_front:
	; --- Initialize the stack ---
	push rbp
	push rax		; Stack alignement
	push rcx
	push rsi
	push rdi
	sub rsp, 8

	mov rbp, rsp


	; --- Allocated memory for a new node ---
	mov rdi, 1
	mov rsi, 16
	call ft_calloc

	cmp rax, 0
	jz ft_list_push_front_end			; if (new_node == NULL)

	; --- Change new node .next element ---
	lea rcx, qword [rsp]
	mov qword [rax + s_list.next], rcx

	; --- Change new node .data element ---
	mov rcx, [rsi]
	mov qword [rax + s_list.data], rcx

	; --- Change the head by our new node ---
	mov rdi, rax

	ft_list_push_front_end:
		add rsp, 8
		pop rdi
		pop rsi
		pop rcx
		pop rax
		mov rsp, rbp
		pop rbp
		ret


section .data
struc s_list
	.data resq 1 ; Quadword allocated for the pointer where the data is stored
	.next resq 1 ; Pointer where the next element is stored
endstruc
