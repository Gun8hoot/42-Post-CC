BITS 64

section .text
global ft_simd_memchr

; void *ft_simd_memchr(const void *s, int c, size_t n);
ft_simd_memchr:
	push rcx
	push rsi
	push rdi
	;; Stack size 24

	cmp qword rdi, 0x00
	jz ft_simd_memchr_end_err				; if (s == NULL)
	cmp qword rcx, 0
	je ft_simd_memchr_end_err				; if (n == 0)

	ft_simd_memchr_end_err:
		xor rax, rax
	ft_simd_memchr_end:
		pop rdi
		pop rsi
		pop rcx
		;; Stack size 0
		ret
