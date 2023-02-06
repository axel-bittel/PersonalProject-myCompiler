
.text
.global	_start

main:
.main_BEGIN:
pushq	%rbp
movq	%rsp, %rbp
sub	$10, %rsp
movq	$42, -4(%rbp)
cmp	$10 ,-4(%rbp)
jge	.main_IF_BODY_1	
cmp	$5 ,-4(%rbp)
jge	.main_END
jmp	.main_END
.main_IF_BODY_1:
jmp .main_END
.main_BODY_0:
jmp	.main_END
.main_END:
movq	%rbp, %rsp
popq	%rbp
movq	$1,	%rax
ret

_start:
call main
movq	%rax, %rbx
movq	$1, %rax
int	$0x80
