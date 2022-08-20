;
; Auteur: Pr‚martin Patrick.
; Date: 05/08/1991.
;       06/08/1991.
;       08/08/1991.
;       16/05/1991.
;
; Fichier: U_SCROLL.ASM
; But: Fonctions de scrolling en assembleur dans divers modes.
;
; SystŠme d'interaction avec le Turbo Pascal (voir unit‚ U_SCROLL.PAS).
;
;
; FUNCTION Scroll_Txt (X, Y, Larg, Haut, Sens : Integer) : Integer;
;          Scrollings en mode texte.
;
; FUNCTION Scroll_Graph (X, Y, Larg, Haut, Sens : Integer) : Integer;
;          Scrollings en mode graphique.
;
; Valeurs de Sens: ÉÍÑÍÑÍÑÍÑÍÑÍÑÍÑÍ»
;                  ÈÑÏÑÏÑÏÑÏÑÏÑÏÑÏÑ¼
;                   ³ ³ ³ ³ ³ ³ ³ ÀÄÄ vers la gauche
;                   ³ ³ ³ ³ ³ ³ ÀÄÄÄÄ vers la droite
;                   ³ ³ ³ ³ ³ ÀÄÄÄÄÄÄ vers le haut
;                   ³ ³ ³ ³ ÀÄÄÄÄÄÄÄÄ vers le bas
;                   ³ ³ ³ ÀÄÄÄÄÄÄÄÄÄÄ reserv‚
;                   ³ ³ ÀÄÄÄÄÄÄÄÄÄÄÄÄ reserv‚
;                   ³ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄ reserv‚
;                   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ reserv‚
;
; Codes retourn‚s: 0 = Scrolling r‚ussi.
;                  1 = X infŠrieur … 1.
;                  2 = Y infŠrieur … 1.
;                  3 = Larg infŠrieur … 1.
;                  4 = Haut infŠrieur … 1.
;                  5 = X + Larg-1 supŠrieur … la largeur de l'‚cran.
;                  6 = Y + Haut-1 supŠrieur … la derniŠre ligne de l'‚cran.
;                  7 = Mode vid‚o courant inconnu ou inadapt‚.
;                  8 = Mode vid‚o pr‚vu, mais pas encore trait‚.
;
scr_left                equ 01h
scr_right               equ 02h
scr_up                  equ 04h
scr_down                equ 08h
;
data                    segment word public
;
nb_col                  dw ?
nb_lig                  dw ?
larg_ecran              dw ?
;
data                    ends
;
code                    segment word public
;
                        assume cs : code
                        assume ds : data
                        assume es : nothing
                        assume ss : nothing
;
                        public scroll_txt
                        public scroll_graph
;
; Routine de scrolling en mode texte.
;
scroll_txt              proc far
                        push bp
                        mov bp, sp
                        push bx
                        push cx
                        push dx
                        push es
                        push di
                        push si
;
; Initialisation du segment de l'‚cran en fonction du mode vid‚o.
scroll_txt_video:
                        mov ah, 0fh
                        int 10h                         ; interruption vid‚o.
                        mov bl, al
                        mov al, ah
                        mov ah, 0
                        mov nb_col, ax
                        shl ax, 1
                        mov larg_ecran, ax
                        mov al, bl
                        cmp al, 3h
                        jle scroll_txt_v0
                        cmp al, 55h
                        je scroll_txt_v0
                        cmp al, 7h
                        je scroll_txt_v1
                        cmp al, 57h
                        je scroll_txt_v1
                        cmp al, 56h
                        je scroll_txt_v2
                        cmp al, 54h
                        je scroll_txt_v3
                        mov ax, 7                       ; Arrˆt: Mode vid‚o
                                                        ; inconnu ou pas texte.
                        jmp scroll_txt_fin
scroll_txt_v0:
                        mov nb_lig, 25
                        mov ax, 0b800h
                        mov es, ax
                        jmp scroll_txt_test
scroll_txt_v1:
                        mov nb_lig, 25
                        mov ax, 0b000h
                        mov es, ax
                        jmp scroll_txt_test
scroll_txt_v2:
                        mov nb_lig, 43
                        mov ax, 0b800h
                        mov es, ax
                        jmp scroll_txt_test
scroll_txt_v3:
                        mov nb_lig, 43
                        mov ax, 0b000h
                        mov es, ax
                        jmp scroll_txt_test
; Teste des bornes de l'‚cran.
scroll_txt_test:
                        mov ax, word ptr [bp+10]        ; variable Larg.
                        dec ax
                        mov word ptr [bp+10], ax
                        mov ax, word ptr [bp+8]         ; variable Haut.
                        dec ax
                        mov word ptr [bp+8], ax

                        mov ax, word ptr [bp+14]        ; variable X.
                        cmp ax, 1
                        jnl scroll_txt_t0
                        mov ax, 1
                        jmp scroll_txt_fin              ; Arrˆt: X < 1.
scroll_txt_t0:
                        add ax, word ptr [bp+10]        ; variable Larg.
                        dec ax
                        cmp ax, nb_col
                        jng scroll_txt_t1
                        mov ax, 5
                        jmp scroll_txt_fin              ; Arrˆt: X+Larg-1 > nb_col.
scroll_txt_t1:
                        mov ax, word ptr [bp+12]        ; variable Y.
                        cmp ax, 1
                        jnl scroll_txt_t2
                        mov ax, 2
                        jmp scroll_txt_fin              ; Arrˆt: Y < 1.
scroll_txt_t2:
                        add ax, word ptr [bp+8]         ; variable Haut.
                        dec ax
                        cmp ax, nb_lig
                        jng scroll_txt_t3
                        mov ax, 6
                        jmp scroll_txt_fin              ; Arrˆt: Y+Haut-1 > 25.
scroll_txt_t3:
                        mov ax, word ptr [bp+10]        ; variable Larg.
                        cmp ax, 0
                        jnl scroll_txt_t4
                        mov ax, 3
                        jmp scroll_txt_fin
scroll_txt_t4:
                        mov ax, word ptr [bp+8]         ; variable Larg.
                        cmp ax, 0
                        jnl scroll_txt_calcul
                        mov ax, 4
                        jmp scroll_txt_fin
; Calcul de l'offset du premier caractŠre.
scroll_txt_calcul:
                        mov ax, word ptr [bp+12]        ; variable Y.
                        dec ax
                        mov cx, nb_col
                        mul cl
                        mov bx, ax
                        mov ax, word ptr [bp+14]        ; variable X.
                        dec ax
                        add bx, ax
                        shl bx, 1
                        ; Fin du calcul:
                        ; BX = ((Y-1) * nb_col + (X-1)) * 2
; Choix de la direction du scrolling.
scroll_txt_scroll:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_left
                        jcxz scroll_txt_s0
                        jmp scroll_txt_gauche
scroll_txt_s0:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_right
                        jcxz scroll_txt_s1
                        jmp scroll_txt_droite
scroll_txt_s1:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_up
                        jcxz scroll_txt_s2
                        jmp scroll_txt_haut
scroll_txt_s2:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_down
                        jcxz scroll_txt_s3
                        jmp scroll_txt_bas
scroll_txt_s3:
                        mov ax, 0
                        jmp scroll_txt_fin
;
scroll_txt_fin:
                        pop si
                        pop di
                        pop es
                        pop dx
                        pop cx
                        pop bx
                        pop bp
                        ret 10
;
; Boucles des scrollings.
;                               - Scrolling vers la gauche:
scroll_txt_gauche:
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        inc cx
                        mov si, 0
scroll_txt_g0:
                        push cx
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        jcxz scroll_txt_g2
                        mov di, si
                        mov dx, word ptr es:[bx][di]
scroll_txt_g1:
                        mov ax, es:word ptr [bx+2][di]
                        mov es:word ptr [bx][di], ax
                        inc di
                        inc di
                        loop scroll_txt_g1
                        mov es:word ptr [bx][di], dx
                        add si, larg_ecran
scroll_txt_g2:
                        pop cx
                        loop scroll_txt_g0
                        jmp scroll_txt_s0
;                               - Scrolling vers la droite:
scroll_txt_droite:
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        inc cx
                        mov si, 0
scroll_txt_d0:
                        push cx
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        jcxz scroll_txt_d2
                        mov di, cx
                        shl di, 1
                        add di, si
                        mov dx, word ptr es:[bx][di]
scroll_txt_d1:
                        mov ax, es:word ptr [bx-2][di]
                        mov es:word ptr [bx][di], ax
                        dec di
                        dec di
                        loop scroll_txt_d1
                        mov es:word ptr [bx][di], dx
                        add si, larg_ecran
scroll_txt_d2:
                        pop cx
                        loop scroll_txt_d0
                        jmp scroll_txt_s1
;                               - Scrolling vers le haut:
scroll_txt_haut:
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        inc cx
                        mov di, 0
scroll_txt_h0:
                        push cx
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        jcxz scroll_txt_h2
                        mov si, di
                        mov dx, word ptr es:[bx][si]
scroll_txt_h1:
                        add si, larg_ecran
                        mov ax, es:word ptr [bx][si]
                        sub si, larg_ecran
                        mov es:word ptr [bx][si], ax
                        add si, larg_ecran
                        loop scroll_txt_h1
                        mov es:word ptr [bx][si], dx
                        inc di
                        inc di
scroll_txt_h2:
                        pop cx
                        loop scroll_txt_h0
                        jmp scroll_txt_s2
;                               - Scrolling vers le bas:
scroll_txt_bas:
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        inc cx
                        mov di, 0
scroll_txt_b0:
                        push cx
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        jcxz scroll_txt_b2
                        mov si, 0
scroll_txt_b0bis:
                        add si, larg_ecran
                        loop scroll_txt_b0bis
                        mov cx, word ptr [bp+8]
                        add si, di
                        mov dx, word ptr es:[bx][si]
scroll_txt_b1:
                        sub si, larg_ecran
                        mov ax, es:word ptr [bx][si]
                        add si, larg_ecran
                        mov es:word ptr [bx][si], ax
                        sub si, larg_ecran
                        loop scroll_txt_b1
                        mov es:word ptr [bx][si], dx
                        inc di
                        inc di
scroll_txt_b2:
                        pop cx
                        loop scroll_txt_b0
                        jmp scroll_txt_s3
scroll_txt              endp
;
; Routines de scrolling en modes graphiques.
;
scroll_cga_4            proc far
                        mov ax, 8
                        ret
scroll_cga_4            endp
scroll_cga_5            proc far
                        mov ax, 8
                        ret
scroll_cga_5            endp
scroll_cga_6            proc far
                        mov ax, 8
                        ret
scroll_cga_6            endp
scroll_ega_13           proc far
                        mov ax, 8
                        ret
scroll_ega_13           endp
scroll_ega_14           proc far
                        mov ax, 8
                        ret
scroll_ega_14           endp
scroll_ega_15           proc far
                        mov ax, 8
                        ret
scroll_ega_15           endp
scroll_ega_16           proc far
                        mov ax, 8
                        ret
scroll_ega_16           endp
scroll_mcga_17          proc far
                        mov ax, 8
                        ret
scroll_mcga_17          endp
scroll_vga_18           proc far
                        mov ax, 8
                        ret
scroll_vga_18           endp
scroll_mcga_19          proc far
                        mov nb_col, 320
                        mov nb_lig, 200
                        mov larg_ecran, 320
                        mov ax, 0a000h
                        mov es, ax
scroll_mcga_19_test:
                        mov ax, word ptr [bp+8]
                        dec ax
                        mov word ptr [bp+8], ax
                        mov ax, word ptr [bp+12]
                        dec ax
                        mov word ptr [bp+12], ax

                        mov ax, word ptr [bp+14]        ; variable X.
                        cmp ax, 0
                        jnl scroll_mcga_19_t0
                        mov ax, 1
                        jmp scroll_mcga_19_fin              ; Arrˆt: X < 0.
scroll_mcga_19_t0:
                        add ax, word ptr [bp+10]        ; variable Larg.
                        dec ax
                        cmp ax, nb_col
                        jng scroll_mcga_19_t1
                        mov ax, 5
                        jmp scroll_mcga_19_fin              ; Arrˆt: X+Larg-1 > nb_col.
scroll_mcga_19_t1:
                        mov ax, word ptr [bp+12]        ; variable Y.
                        cmp ax, 0
                        jnl scroll_mcga_19_t2
                        mov ax, 2
                        jmp scroll_mcga_19_fin              ; Arrˆt: Y < 0.
scroll_mcga_19_t2:
                        add ax, word ptr [bp+8]         ; variable Haut.
                        dec ax
                        cmp ax, nb_lig
                        jng scroll_mcga_19_t3
                        mov ax, 6
                        jmp scroll_mcga_19_fin              ; Arrˆt: Y+Haut-1 > nb_lig.
scroll_mcga_19_t3:
                        mov ax, word ptr [bp+10]        ; variable Larg.
                        cmp ax, 0
                        jnl scroll_mcga_19_t4
                        mov ax, 3
                        jmp scroll_mcga_19_fin
scroll_mcga_19_t4:
                        mov ax, word ptr [bp+8]         ; variable Larg.
                        cmp ax, 0
                        jnl scroll_mcga_19_calcul
                        mov ax, 4
                        jmp scroll_mcga_19_fin
; Calcul de l'offset du premier caractŠre.
scroll_mcga_19_calcul:
                        mov ax, word ptr [bp+12]        ; variable Y.
                        dec ax
                        mov cx, nb_col
                        mul cx
                        mov bx, ax
                        mov ax, word ptr [bp+14]        ; variable X.
                        dec ax
                        add bx, ax
                        shl bx, 1
                        ; Fin du calcul:
                        ; BX = ((Y-1) * nb_col + (X-1)) * 2
; Choix de la direction du scrolling.
scroll_mcga_19_scroll:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_left
                        jcxz scroll_mcga_19_s0
                        jmp scroll_mcga_19_gauche
scroll_mcga_19_s0:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_right
                        jcxz scroll_mcga_19_s1
                        jmp scroll_mcga_19_droite
scroll_mcga_19_s1:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_up
                        jcxz scroll_mcga_19_s2
                        jmp scroll_mcga_19_haut
scroll_mcga_19_s2:
                        mov cx, word ptr [bp+6]         ; variable Sens.
                        and cx, scr_down
                        jcxz scroll_mcga_19_s3
                        jmp scroll_mcga_19_bas
scroll_mcga_19_s3:
                        mov ax, 0
                        jmp scroll_mcga_19_fin
;
scroll_mcga_19_fin:
                        ret
;
; Boucles des scrollings.
;                               - Scrolling vers la gauche:
scroll_mcga_19_gauche:
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        inc cx
                        mov si, 0
scroll_mcga_19_g0:
                        push cx
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        jcxz scroll_mcga_19_g2
                        mov di, si
                        mov dl, byte ptr es:[bx][di]
scroll_mcga_19_g1:
                        mov al, es:byte ptr [bx+1][di]
                        mov es:byte ptr [bx][di], al
                        inc di
                        loop scroll_mcga_19_g1
                        mov es:byte ptr [bx][di], dl
                        add si, larg_ecran
scroll_mcga_19_g2:
                        pop cx
                        loop scroll_mcga_19_g0
                        jmp scroll_mcga_19_s0
;                               - Scrolling vers la droite:
scroll_mcga_19_droite:
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        inc cx
                        mov si, 0
scroll_mcga_19_d0:
                        push cx
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        jcxz scroll_mcga_19_d2
                        mov di, cx
                        shl di, 1
                        add di, si
                        mov dl, byte ptr es:[bx][di]
scroll_mcga_19_d1:
                        mov al, es:byte ptr [bx-1][di]
                        mov es:byte ptr [bx][di], al
                        dec di
                        loop scroll_mcga_19_d1
                        mov es:byte ptr [bx][di], dl
                        add si, larg_ecran
scroll_mcga_19_d2:
                        pop cx
                        loop scroll_mcga_19_d0
                        jmp scroll_mcga_19_s1
;                               - Scrolling vers le haut:
scroll_mcga_19_haut:
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        inc cx
                        mov di, 0
scroll_mcga_19_h0:
                        push cx
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        jcxz scroll_mcga_19_h2
                        mov si, di
                        mov dl, byte ptr es:[bx][si]
scroll_mcga_19_h1:
                        add si, larg_ecran
                        mov al, es:byte ptr [bx][si]
                        sub si, larg_ecran
                        mov es:byte ptr [bx][si], al
                        add si, larg_ecran
                        loop scroll_mcga_19_h1
                        mov es:byte ptr [bx][si], dl
                        inc di
scroll_mcga_19_h2:
                        pop cx
                        loop scroll_mcga_19_h0
                        jmp scroll_mcga_19_s2
;                               - Scrolling vers le bas:
scroll_mcga_19_bas:
                        mov cx, word ptr [bp+10]        ; variable Larg.
                        inc cx
                        mov di, 0
scroll_mcga_19_b0:
                        push cx
                        mov cx, word ptr [bp+8]         ; variable Haut.
                        jcxz scroll_mcga_19_b2
                        mov si, 0
scroll_mcga_19_b0bis:
                        add si, larg_ecran
                        loop scroll_mcga_19_b0bis
                        mov cx, word ptr [bp+8]
                        add si, di
                        mov dl, byte ptr es:[bx][si]
scroll_mcga_19_b1:
                        sub si, larg_ecran
                        mov al, es:byte ptr [bx][si]
                        add si, larg_ecran
                        mov es:byte ptr [bx][si], al
                        sub si, larg_ecran
                        loop scroll_mcga_19_b1
                        mov es:byte ptr [bx][si], dl
                        inc di
scroll_mcga_19_b2:
                        pop cx
                        loop scroll_mcga_19_b0
                        jmp scroll_mcga_19_s3
scroll_mcga_19          endp
scroll_svga_88          proc far
                        mov ax, 8
                        ret
scroll_svga_88          endp
scroll_svga_89          proc far
                        mov ax, 8
                        ret
scroll_svga_89          endp
scroll_svga_94          proc far
                        mov ax, 8
                        ret
scroll_svga_94          endp
scroll_svga_95          proc far
                        mov ax, 8
                        ret
scroll_svga_95          endp
;
scroll_graph            proc far
                        push bp
                        mov bp, sp
                        push bx
                        push cx
                        push dx
                        push ds
                        push es
                        push si
                        push di
                        mov ah, 0fh
                        int 10h
                        cmp al, 4                       ; CGA 320*200 4 coul
                        jne scroll_graph_0
                        call scroll_cga_4
                        jmp scroll_graph_fin
scroll_graph_0:
                        cmp al, 5                       ; CGA 320*200 4 coul
                        jne scroll_graph_1
                        call scroll_cga_5
                        jmp scroll_graph_fin
scroll_graph_1:
                        cmp al, 6                       ; CGA 640*200 2 coul
                        jne scroll_graph_2
                        call scroll_cga_6
                        jmp scroll_graph_fin
scroll_graph_2:
                        cmp al, 13                      ; EGA 320*200 16 coul
                        jne scroll_graph_3
                        call scroll_ega_13
                        jmp scroll_graph_fin
scroll_graph_3:
                        cmp al, 14                      ; EGA 640*200 16 coul
                        jne scroll_graph_4
                        call scroll_ega_14
                        jmp scroll_graph_fin
scroll_graph_4:
                        cmp al, 15                      ; EGA 640*350 mono
                        jne scroll_graph_5
                        call scroll_ega_15
                        jmp scroll_graph_fin
scroll_graph_5:
                        cmp al, 16                      ; EGA 640*350 16 coul
                        jne scroll_graph_6
                        call scroll_ega_16
                        jmp scroll_graph_fin
scroll_graph_6:
                        cmp al, 17                      ; MCGA/VGA 640*480 2
                                                        ; coul
                        jne scroll_graph_7
                        call scroll_mcga_17
                        jmp scroll_graph_fin
scroll_graph_7:
                        cmp al, 18                      ; VGA 640*480 16 coul
                        jne scroll_graph_8
                        call scroll_vga_18
                        jmp scroll_graph_fin
scroll_graph_8:
                        cmp al, 19                      ; MCGA/VGA 320*200 256
                                                        ; coul
                        jne scroll_graph_9
                        call scroll_mcga_19
                        jmp scroll_graph_fin
scroll_graph_9:
                        cmp al, 58h                     ; SVGA 800*600 16 coul
                        jne scroll_graph_10
                        call scroll_svga_88
                        jmp scroll_graph_fin
scroll_graph_10:
                        cmp al, 59h                     ; SVGA 800*600 2 coul
                        jne scroll_graph_11
                        call scroll_svga_89
                        jmp scroll_graph_fin
scroll_graph_11:
                        cmp al, 5eh                     ; SVGA 640*400 256 coul
                        jne scroll_graph_12
                        call scroll_svga_94
                        jmp scroll_graph_fin
scroll_graph_12:
                        cmp al, 5fh                     ; SVGA 640*480 256 coul
                        jne scroll_graph_13
                        call scroll_svga_95
                        jmp scroll_graph_fin
scroll_graph_13:
                        mov ax, 7                       ; Arrˆt: mode vid‚o
                                                        ; inconnu.
scroll_graph_fin:
                        pop di
                        pop si
                        pop es
                        pop ds
                        pop dx
                        pop cx
                        pop bx
                        ret 10
scroll_graph            endp
;
code                    ends
                        end
