;
; Titre: U_GRAPH.ASM
;
; Auteur: Pr‚martin Patrick.
;
; Date: 09/03/1991.
;
; But: Proc‚dures assembleur utilis‚es par l'unit‚ U_GRAPH en Turbo Pascal.
;
;
data               segment byte public
;
couleur            db 1
;
data               ends
;
;
code               segment byte public
;
                   assume cs : code
                   assume ds : data
                   assume ss : nothing
                   assume es : nothing
;
; PROCEDURE GRAPH_INIT (MODE : T_GRAPH_MODE);
                   public graph_init
; PROCEDURE GRAPH_CLEAR;
                   public graph_clear
; PROCEDURE GRAPH_PLOT (X, Y : INTEGER);
                   public graph_plot
; PROCEDURE GRAPH_PSET (X, Y : INTEGER; COULEUR : T_GRAPH_COULEUR);
                   public graph_pset
; PROCEDURE GRAPH_COLOR (COULEUR : T_GRAPH_COULEUR);
                   public graph_color
; FUNCTION GRAPH_POINT (X, Y : INTEGER) : T_GRAPH_COULEUR;
                   public graph_point
;
GRAPH_INIT         proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push ds
                   mov  ax, [bp+6]
                   mov  ah, 00h
                   int  10h
                   mov  ax, data
                   mov  ds, ax
                   mov  couleur, 1
                   pop  ds
                   pop  ax
                   pop  bp
                   ret  2
graph_init         endp
;
GRAPH_CLEAR        proc far
                   push ax
                   xor  ax, ax
                   int  10h
                   pop  ax
                   ret
graph_clear        endp
;
graph_plot         proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push bx
                   push cx
                   push dx
                   push ds
                   mov  ax, data
                   mov  ds, ax
                   mov  ah, 0Ch
                   mov  al, couleur
                   mov  cx, word ptr [bp+8]
                   mov  dx, word ptr [bp+6]
                   xor  bx, bx
                   int  10h
                   pop ds
                   pop dx
                   pop cx
                   pop bx
                   pop ax
                   pop bp
                   ret 4
graph_plot         endp
;
graph_pset         proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push bx
                   push cx
                   push dx
                   push ds
                   mov  ax, data
                   mov  ds, ax
                   mov  ah, 0Ch
                   mov  al, byte ptr [bp+6]
                   mov  cx, word ptr [bp+10]
                   mov  dx, word ptr [bp+8]
                   xor  bx, bx
                   int  10h
                   pop ds
                   pop dx
                   pop cx
                   pop bx
                   pop ax
                   pop bp
                   ret 6
graph_pset         endp
;
graph_color        proc far
                   push bp
                   mov  bp, sp
                   push ax
                   push ds
                   mov  ax, data
                   mov  ds, ax
                   mov  al, byte ptr [bp+6]
                   mov  couleur, al
                   pop  ds
                   pop  ax
                   pop  bp
                   ret  2
graph_color        endp
;
graph_point        proc far
                   push bp
                   mov bp, sp
                   push bx
                   push cx
                   push dx
                   push ds
                   push si
                   mov  al, 0Dh
                   lds  si, dword ptr [bp+10]
                   mov  cx, word ptr [si]
                   lds  si, dword ptr [bp+6]
                   mov  dx, word ptr [si]
                   xor  bx, bx
                   int  10h
                   pop  si
                   pop  ds
                   pop  dx
                   pop  cx
                   pop  bx
                   pop  bp
                   ret  8
graph_point        endp
;
code               ends
                   end
