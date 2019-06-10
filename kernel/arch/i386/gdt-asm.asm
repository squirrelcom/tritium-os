SECTION .DATA
gdtr DW 0 ; For limit storage
     DD 0 ; For base storage
 
SECTION .TEXT
	GLOBAL gdt_flush
; Inputs: Physical address of GDT to be loaded
gdt_flush:
	mov eax, [esp+4]
	lgdt [eax]

  ; Load 0x10 into all the selectors
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	; We now do a far jump to the new kernel code segment (0x08 is the selector for the new code segment)
	jmp 0x08:.flush
.flush:
  ret
	
	GLOBAL enter_usermode_fully
	EXTERN test_usermode
enter_usermode_fully:
	mov ax, 0x23;
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	
	mov eax,esp
	push 0x23
	push eax
	pushf
	push 0x1B
	push test_usermode
	iret