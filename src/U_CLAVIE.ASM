;
; Titre: U_CLAVIER.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 01/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_CLAVIER en Turbo Pascal
;      afin de remplacer CRT pour READKEY et KEYPRESSED.
;
code               segment byte public
;
                   assume cs : code
                   assume ds : nothing
                   assume ss : nothing
                   assume es : nothing
;
; FUNCTION READKEY : CHAR;
                   public readkey
; FUNCTION TOUCHE_PRESSEE : BYTE;
                   public touche_pressee
; FUNCTION SHIFTKEY : BYTE;
                   public shiftkey
;
readkey            proc far
                   mov  ah, 00h
                   int  16h
                   ret
readkey            endp
;
touche_pressee     proc far
                   mov  ah, 01h
                   int  16h
                   jnz  touche
pas_touche:
                   xor  ax, ax
                   jmp  fin_touche_pressee
touche:
                   mov  ax, 1
fin_touche_pressee:
                   ret
touche_pressee     endp
;
shiftkey           proc far
                   mov  ah, 02h
                   int  16h
                   xor  ah, ah
                   ret
shiftkey           endp
;
code               ends
                   end
