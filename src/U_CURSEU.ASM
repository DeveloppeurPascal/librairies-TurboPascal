;
; Titre: U_CURSEUR.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 01/03/1991.
;       09/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_CURSEUR en Turbo Pascal
;      afin de pouvoir g‚rer le curseur normalement sans acc‚der par CRT.
;
code               segment byte public
;
                   assume cs : code
                   assume ds : nothing
                   assume ss : nothing
                   assume es : nothing
;
; PROCEDURE CURSEUR_ON;
                   public curseur_on
; PROCEDURE CURSEUR_OFF;
                   public curseur_off
; PROCEDURE CURSEUR_PAVE;
                   public curseur_pave
; PROCEDURE CURSEUR_HAUT;
                   public curseur_haut
; PROCEDURE CURSEUR_MILIEU;
                   public curseur_milieu
; PROCEDURE CURSEUR_BAS;
                   public curseur_bas
; PROCEDURE CURSEUR_LOCATE (X, Y : INTEGER);
                   public curseur_locate
; FUNCTION CURSEUR_X : INTEGER;
                   public curseur_x
; FUNCTION CURSEUR_Y : INTEGER;
                   public curseur_y
;
curseur_on         proc far
                   push ax
                   push cx
                   mov  ah, 01h
                   mov  cl, 7
                   mov  ch, 6
                   int  10h
                   pop  cx
                   pop  ax
                   ret
curseur_on         endp
;
curseur_off        proc far
                   push ax
                   push cx
                   mov  ah, 01h
                   mov  ch, 20h
                   int  10h
                   pop  cx
                   pop  ax
                   ret
curseur_off        endp
;
curseur_pave       proc far
                   push ax
                   push cx
                   mov ah, 01h
                   mov ch, 00h
                   mov cl, 07h
                   int 10h
                   pop cx
                   pop ax
                   ret
curseur_pave       endp
;
curseur_haut       proc far
                   push ax
                   push cx
                   mov ah, 01h
                   mov ch, 00h
                   mov cl, 01h
                   int 10h
                   pop cx
                   pop ax
                   ret
curseur_haut       endp
;
curseur_milieu     proc far
                   push ax
                   push cx
                   mov ah, 01h
                   mov ch, 03h
                   mov cl, 04h
                   int 10h
                   pop cx
                   pop ax
                   ret
curseur_milieu     endp
;
curseur_bas        proc far
                   push ax
                   push cx
                   mov ah, 01h
                   mov ch, 06h
                   mov cl, 07h
                   int 10h
                   pop cx
                   pop ax
                   ret
curseur_bas        endp
;
curseur_locate     proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push bx
                   push dx
                   mov  ah, 02h
                   mov  dh, byte ptr [bp+6] ; Y
                   dec  dh
                   mov  dl, byte ptr [bp+8] ; X
                   dec  dl
                   mov  bh, 0               ; Page 0
                   int  10h
                   pop  dx
                   pop  bx
                   pop  ax
                   pop  bp
                   ret  4
curseur_locate     endp
;
curseur_x          proc far
                   push bx
                   push cx
                   push dx
                   mov  ah, 03h
                   mov  bh, 0               ; Page 0
                   int  10h
                   xor  ax, ax
                   inc  dl
                   mov  al, dl              ; X
                   pop  dx
                   pop  cx
                   pop  bx
                   ret
curseur_x          endp
;
curseur_y          proc far
                   push bx
                   push cx
                   push dx
                   mov  ah, 03h
                   mov  bh, 0               ; Page 0
                   int  10h
                   xor  ax, ax
                   inc  dh
                   mov  al, dh              ; Y
                   pop  dx
                   pop  cx
                   pop  bx
                   ret
curseur_y          endp
;
code               ends
                   end
