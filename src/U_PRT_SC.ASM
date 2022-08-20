;
; Titre: U_PRT_SC.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 16/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_PRT_SC en Turbo Pascal
;      afin de conecter ou d‚connecter le Print Screen … volonte.
;
code               segment byte public
;
                   assume cs : code
                   assume ds : code
                   assume ss : nothing
                   assume es : nothing
;
; PROCEDURE INIT_PRINT_SCREEN;
                   public init_print_screen
; PROCEDURE PRINT_SCREEN_ON;
                   public print_screen_on
; PROCEDURE PRINT_SCREEN_OFF;
                   public print_screen_off
;
init_print_screen  proc far
                   push ax
                   push es
                   push bx
                   push ds
                   mov  ah, 35h
                   mov  al, 05h
                   int  21h
                   push cs
                   pop  ds
                   mov  old_print_screen_segment, es
                   mov  old_print_screen_offset, bx
                   pop  ds
                   pop  bx
                   pop  es
                   pop  ax
                   ret
                   ;
old_print_screen_segment     dw ?
old_print_screen_offset      dw ?
                   ;
init_print_screen  endp
;
new_print_screen   proc far
                   iret
new_print_screen   endp
;
print_screen_on    proc far
                   push ax
                   push ds
                   push dx
                   mov  ah, 25h
                   mov  al, 05h
                   mov  ds, old_print_screen_segment
                   mov  dx, old_print_screen_offset
                   int  21h
                   pop  dx
                   pop  ds
                   pop  ax
                   ret
print_screen_on    endp
;
print_screen_off   proc far
                   push ax
                   push ds
                   push dx
                   mov  ax, seg new_print_screen
                   mov  ds, ax
                   mov  dx, offset new_print_screen
                   mov  ah, 25h
                   mov  al, 05h
                   int  21h
                   pop  dx
                   pop  ds
                   pop  ax
                   ret
print_screen_off   endp
;
code               ends
                   end
