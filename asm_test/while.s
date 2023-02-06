.text

.global	_start

_start:
	call main
	movq %rax, %rbx
	movq $1, %rax
	int  $0x80
main:
.P0_begin_main:
	pushq	%rbp
	movq	%rsp, %rbp
	sub	$16, %rsp
	movl	$0, -4(%rbp)
	jmp .P1_while_cond
.P2_while_body:
	addl	$1, -4(%rbp)
.P1_while_cond:
	cmp $41, -4(%rbp)
	jle .P2_while_body 
.P3_end_fct:
	movq	-4(%rbp), %rax
	movq	%rbp, %rsp
	popq	 %rbp
	ret
