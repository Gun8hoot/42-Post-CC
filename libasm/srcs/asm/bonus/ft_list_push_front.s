;;;;;;;;;;;;;;;;;;;;;;;;;
;typedef struct s_list
;{
;    void *data;
;    struct s_list *next;
;} t_list;

BITS 64

extern ft_calloc

;;;;;;;;;;
; STRUCT ;
;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;typedef struct s_list
;{
;    void *data;
;    struct s_list *next;
;} t_list;
; @brief: This struct is the base of every node on or linked list
; @size: 16 bytes
struc s_list
	.data resq 1 ; Quadword allocated for the pointer where the data is stored
	.next resq 1 ; Pointer where the next element is stored
endstruc

;;;;;;;;;
; .TEXT ;
;;;;;;;;;

section .text
global ft_list_push_front

; void ft_list_push_front(t_list **begin_list, void *data);
ft_list_push_front:
	; --- Initialize the stack ---
	push rbp
	push rcx
	push rsi
	push rdi

	; --- First check of begin_list ---
	test rdi, rdi
	jz ft_list_push_front_end			; if (begin_list == NULL) ; return (NULL)


	; --- Allocated memory for a new node ---
	mov rdi, 1
	mov rsi, 16							; The size of our structure (2 ptr = 16 bytes)
	call ft_calloc						; new_node = ft_calloc(1, sizeof(t_list))

	test rax, rax
	jz ft_list_push_front_end			; if (new_node == NULL) ; return (NULL)

	; --- Change new node .next element ---
	mov rcx, [rsp + 0]
	mov rcx, [rcx]						; Dereferencing the begin_list first pointer
	mov qword [rax + s_list.next], rcx	; new_node->next = *begin_list

	; --- Change new node .data element ---
	mov rcx, qword [rsp + 8]
	mov qword [rax + s_list.data], rcx	; new_node->data = data

	; --- Change the head by our new node ---
	mov rcx, qword [rsp + 0]
	mov [rcx], rax						; *begin_list = new_node

	ft_list_push_front_end:
		pop rdi
		pop rsi
		pop rcx
		pop rbp
		ret
