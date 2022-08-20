;
; Titre: U_TIME.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 01/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_TIME en Turbo Pascal
;      afin de pouvoir acc‚der … l'heure sans passer par DOS.
;
code               segment byte public
;
                   assume cs : code
                   assume ds : nothing
                   assume ss : nothing
                   assume es : nothing
;
; PROCEDURE GET_TIME (VAR HEURE, MINUTE, SECONDE, SEC100 : BYTE);
                   public get_time
; PROCEDURE SET_TIME (HEURE, MINUTE, SECONDE, SEC100 : BYTE);
                   public set_time
;
get_time           proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push cx
                   push dx
                   push ds
                   push si
                   mov  ah, 2Ch
                   int  21h
                   lds  si, dword ptr [bp+6]  ; centiŠmes
                   mov  byte ptr [si], dl
                   lds  si, dword ptr [bp+10] ; secondes
                   mov  byte ptr [si], dh
                   lds  si, dword ptr [bp+14] ; minutes
                   mov  byte ptr [si], cl
                   lds  si, dword ptr [bp+18] ; heures
                   mov  byte ptr [si], ch
                   pop  si
                   pop  ds
                   pop  dx
                   pop  cx
                   pop  ax
                   pop  bp
                   ret  16
get_time           endp
;
set_time           proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push cx
                   push dx
                   mov  ah, 2Dh
                   mov  dl, byte ptr [BP+6]  ; centiŠmes
                   mov  dh, byte ptr [BP+8]  ; secondes
                   mov  cl, byte ptr [bp+10] ; minutes
                   mov  ch, byte ptr [bp+12] ; heures
                   int  21h
                   pop  dx
                   pop  cx
                   pop  ax
                   pop  bp
                   ret  8
set_time           endp
;
code               ends
                   end
