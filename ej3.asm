        org 100h
section .text
        call    v_mode
        call    fibo
	xor	bx, bx
	mov	bl, byte[cont]
        mov     al, byte[420h+bx]
        mov     byte[num], al
        mov     ax, word[max_base]
        div     byte[num]    
        mov     byte[min_base], al



        mov     word[x], 632d
        mov     word[y], 40d
        mov     word[start_x], 632d
        mov     word[start_y], 40d
        
   
        

m_loop: 
        cmp     byte[cont], 0d
        je     end
       
	 mov     al, byte[num]
        mul     byte[min_base]
        mov     [lenght], ax


;        call    kb


        mov     ax, word[lenght]
        mov     [405h],ax

        mov     al, byte[line_type]
        mov     [400h],al
        call    s_squre
       
        

        mov     bx,     word[start_x]
        mov     word[x], bx
        mov     bx,     word[start_y]
        mov     word[y], bx

    
       cmp     byte[line_type] , 0d
        je      case_0
        cmp     byte[line_type] , 1d
        je      case_1
        sub     byte[line_type],1d
        
       

tipe:     mov     al, byte[line_type]
        mov     [401h],al
     	call draw_di  
        sub     byte[cont],1d
 
        xor     bx, bx
        mov     bl, byte[cont]
        mov     al, byte[420h + bx]
        mov     [460h],al
        mov     byte[num],al      

       
	 jmp     m_loop


end:    call    kb
 
        int     20h


case_1: mov byte[line_type], 4d
        jmp tipe


case_0: mov byte[line_type], 3d
        jmp tipe

draw_di:mov	ax, [lenght]
	mov	bl, 2d
	div	bl
	mov	cx, word[x]
	mov	dx, word[y]
	cmp	byte[line_type], 1d
	je 	pos_1
	cmp	byte[line_type], 2d
	je	pos_2
	cmp	byte[line_type], 3d
	je	pos_3
	cmp	byte[line_type], 4d
	je	pos_4

	ret

pos_2:
	add 	cx, ax
	sub	dx, ax
	jmp	put_di

pos_1: 	add 	cx, ax
	add	dx, ax
	jmp	put_di

pos_4: 	sub 	cx, ax
	add	dx, ax
	jmp	put_di


pos_3: 	sub 	cx, ax
	sub	dx, ax
	jmp	put_di



put_di:	mov	bl, 8d
	mov	bh, 17d
	mov     ax,cx
	div	bl
	mov	bl, dl
	mov	dl, al
	mov	ah, dh
	mov	al, bl
	
	div	bh
	mov	dh, al
	call 	cursor
	mov	al, byte[num]
	add	al, 30h
	call	w_char
	ret


cursor: mov     ah, 02h
        mov     bh, 00h
        int     10h
        ret

w_char: mov     ah, 09h
        mov     bh, 0h
        mov     bl, [cont]
        mov     cx, 1h
        int     10h
        ret


 	 


l_set:	xor	di,	di;draws horizontal line
line:	mov	cx,	[x]
	mov	dx,	[y]
        cmp     byte[line_type] , 1d
        je      line_1
        cmp     byte[line_type] , 2d
        je      line_2
        cmp     byte[line_type] , 3d
        je      line_3
        cmp     byte[line_type] , 4d
        je      line_4

line_rt:inc	di
	call	pix		
	cmp	di, word[lenght]
	jb	line
        mov     word[x], cx
        mov     word[y], dx
	ret;fiin

line_1: sub	dx,	di
        jmp     line_rt
line_2: sub	cx,	di
        jmp     line_rt
line_3: add	dx,	di
        jmp     line_rt
line_4: add	cx,	di
        jmp     line_rt

s_squre:xor     si,si
d_squre:cmp     byte[line_type], 0d
        jnz     no_zero
        mov     byte[line_type], 4d
no_zero:call    l_set
        sub     byte[line_type], 1d
        inc     si
        cmp     si,2d
        jz      set_start
s_cmp:  cmp     si,4d
        jz      end_s
        jmp     d_squre     

end_s:  ret   


set_start:mov     word[start_x], cx
        mov     word[start_y], dx
        
        jmp s_cmp

v_mode: mov     ah,     00h
        mov     al,	12h
        int     10h
        ret

pix:    mov     ah,     0Ch
        mov     bl,     byte[cont]
        inc     bl
        mov	al,     bl
        int     10h
        ret

kb:     mov     ah,     00h
	int	16h
        ret

fibo:	mov	ax, 0001h			
	mov 	bx, 0000h
	xor 	cx, cx
	mov	cl, byte[cont]
	mov	[420h],bx
	mov	[421h],ax
	mov	si,1d	

l2:	mov	dx,ax
	add	ax,bx
	mov	bx,dx
	cmp	bx,256d
	ja	jmp12
	inc	si
	jmp	jmp13
jmp12:	add	si,2d
jmp13:	mov	[420h+si],ax
	loop	l2
	ret

section .data

y               dw      0d ;y axis
x               dw      0d ;x axis

start_y         dw      0d ;y axis
start_x         dw      0d ;x axis

lenght          dw     	0d ;value of the current square base     
min_base        db      0d ;  min value in succession square base     
max_base        dw      390d ;max value in succession square base
num             db      0d
line_type       db      3d

cont            db      6d
