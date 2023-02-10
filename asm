arg aarg bROOT->14
Droite->  ROOT->15
  Droite->    ROOT->22
    Droite->      ROOT->21
	Gauche->    ROOT->14
    Droite->      ROOT->20
		Gauche->      ROOT->14
      Droite->        ROOT->8
        Droite->          ROOT->7
          Droite->            ROOT->17
					Gauche->            ROOT->18
				Gauche->          ROOT->18
			Gauche->        ROOT->14
        Droite->          ROOT->14
          Droite->            ROOT->0
            Droite->              ROOT->11
              Droite->                ROOT->17
							Gauche->                ROOT->18
						Gauche->              ROOT->14
              Droite->                ROOT->23
                Droite->                  ROOT->17
					Gauche->            ROOT->10
						Gauche->              ROOT->14
              Droite->                ROOT->4
                Droite->                  ROOT->17
								Gauche->                  ROOT->17
Gauche->  ROOT->14
  Droite->    ROOT->15
    Droite->      ROOT->22
      Droite->        ROOT->21
		Gauche->      ROOT->14
      Droite->        ROOT->4
        Droite->          ROOT->17
				Gauche->          ROOT->17
.text
.global _start:
 _start:
call main
movq %rax, %rbx
movq $1, %rax
int $0x80
main:
.0_main
pushq %rbp
movq %rsp, %rbp
subq $20, %rsp
movq %rbp, %rsp
popq %rbp
 ret
test:
.0_test
pushq %rbp
movq %rsp, %rbp
subq $8, %rsp
movq $, %%rax
pushq %%rax
movq $, %%rbx
popq %%rax
addq %%rbx, %%rax
movq %rbp, %rsp
popq %rbp
 ret
