.text
.global _start
 _start:
call main
movq %rax, %rbx
movq $1, %rax
int $0x80
main:
.0_main:
pushq %rbp
movq %rsp, %rbp
subq $20, %rsp
movq -12(%rbp), %rax
pushq %rax
pushq %rax
movq $2, %rax
pushq %rax
movq $3, %rax
popq %rax
div %rax
movq %rbx, %rax
popq %rax
popq %rax
imulq %rbx, %rax
pushq %rax
movq $45, %rbx
popq %rax
addq %rbx, %rax
movq %rbp, %rsp
popq %rbp
ret
test:
.0_test:
pushq %rbp
movq %rsp, %rbp
subq $8, %rsp
movq $1, %rax
pushq %rax
movq $1, %rbx
popq %rax
addq %rbx, %rax
movq %rbp, %rsp
popq %rbp
ret
