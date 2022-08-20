;
; Titre: U_DATE.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 01/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_DATE en Turbo Pascal
;      afin de pouvoir acc‚der … la date sans passer par DOS.
;
code               segment byte public
;
                   assume cs : code
                   assume ds : nothing
                   assume ss : nothing
                   assume es : nothing
;
; PROCEDURE GET_DATE (VAR JOUR, MOIS, ANNEE, JOUR_SEMAINE : WORD);
                   public get_date
; PROCEDURE SET_DATE (JOUR, MOIS, ANNEE : WORD);
                   public set_date
;
get_date           proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push cx
                   push dx
                   push ds
                   push si
                   mov  ah, 2Ah
                   int  21h
                   lds  si, dword ptr [bp+6]  ; jour semaine
                   mov  word ptr [si], 0
                   mov  byte ptr [si], al
                   lds  si, dword ptr [bp+10] ; annee
                   mov  word ptr [si], cx
                   lds  si, dword ptr [bp+14] ; mois
                   mov  word ptr [si], 0
                   mov  byte ptr [si], dh
                   lds  si, dword ptr [bp+18] ; jour
                   mov  word ptr [si], 0
                   mov  byte ptr [si], dl
                   pop  si
                   pop  ds
                   pop  dx
                   pop  cx
                   pop  ax
                   pop  bp
                   ret  16
get_date           endp
;
set_date           proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push cx
                   push dx
                   mov  ah, 2Bh
                   mov  cx, word ptr [BP+6]  ; ann‚e
                   mov  dh, byte ptr [BP+8]  ; mois
                   mov  dl, byte ptr [bp+10] ; jour
                   int  21h
                   pop dx
                   pop cx
                   pop ax
                   pop bp
                   ret 6
set_date           endp
;
code               ends
                   end
