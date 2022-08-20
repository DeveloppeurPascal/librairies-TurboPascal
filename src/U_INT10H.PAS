unit u_int10h;
{
Auteur: Patrick Pr‚martin.
Date: 17/07/1992. 21/07/1992. 14/02/1993.
Langage: Turbo PAscal 6.0
But: Impl‚mentation de quelques fonctions de l'interruption 10H en Turbo Pascal.

Bibliographie: GUIDE MICROSOFT DE LA PROGRAMMATION DES CARTES GRAPHIQUES
                    (Richard Wilton, Microsoft Corporation)
}

interface
const
     cga_40x25x16 = {0 ou} 1; { Cartes CGA }
     cga_80x25x16 = {2 ou} 3;
     cga_320x200x4 = {4 ou} 5;
     cga_640x200x4 = 6;
     hgc_80x85x2 = 7; { Cartes Hercule }
     pcj_160x200x16 = 8; { PC Junior seulement }
     pcj_320x200x16 = 9;
     pcj_640x200x4 = $a;
     ega_320x200x16 = $d; { Cartes EGA }
     ega_640x200x16 = $e;
     ega_640x350x2 = $f;
     ega_640x650x16 = $10;
     mcga_640x480x2 = $11; { Cartes MCGA }
     mcga_320x200x256 = $13;
     vga_640x480x16 = $12; { Cartes VGA }

type
    t_rvb = record
                  r, v, b : byte;
    end;
    t_tab_rvb = array [0..255] of t_rvb;
    t_tab_17_byte = array [0..16] of byte;

{
********************************************************************************
          Fonctions diverses
********************************************************************************
}
function set_mode (n : byte) : boolean;
{ Fct. 0 = S‚lection d'un mode vid‚o. }

procedure define_cursor (ls, li : byte);
{ Fct. 1 = D‚finition du curseur alphanum‚rique. }
{          Si ls = 32, le curseur est invisible. }

procedure goto_xy (page, x, y : byte);
{ Fct. 2 = Positionnement du curseur dans la page sp‚cifi‚e. }

procedure info_cursor (page : byte; var ls, li, x, y : byte);
{ Fct. 3 = Lire l'‚tat du curseur. }

procedure read_pen (var is_ok : boolean; var x, y : word; var l, c : byte);
{ Fct. 4 = Lire la position du photostyle. }

procedure set_page (n : byte);
{ Fct. 5 = Choisir une page vid‚o. }

procedure scroll_up (nb_lig, text_attr, x1, y1, x2, y2 : byte);
{ Fct. 6 = D‚filement vers le haut. }

procedure scroll_down (nb_lig, text_attr, x1, y1, x2, y2 : byte);
{ Fct. 7 = D‚fillement vers le bas. }

procedure put_pixel (page, color : byte; x, y : word);
{ Fct. C = Changer la valeur d'un pixel. }

function get_pixel (page : byte; x, y : word) : byte;

function get_mode : byte;
procedure info_mode (var mode_num, nb_col, page : byte);
{ Fct. F = Lire l'‚tat vid‚o courant. }

{
********************************************************************************
          Fonction 10h = D‚finir le contenu des registres de palette et les
                         attributs d'intensit‚ et de clignotement.
********************************************************************************
}
procedure set_reg_pal (reg, coul : byte);
{ Sfct. 0 = Modifier un registre de palette. }

procedure set_bordure_coul (coul : byte);
{ Sfct. 1 = Sp‚cifier la couleur de surbalayage. }

procedure set_reg_pal_16_bord (t : t_tab_17_byte);
{ Sfct. 2 = Modifier les 16 registres de couleurs plus le surbalayage. }

function get_reg_pal (reg : byte) : byte;
{ Sfct. 7 = Lire un registre de palette. }

function get_bordure_coul : byte;
{ Sfct. 8 = Lire le contenu du refistre de surbalayage. }

procedure get_reg_pal_16_bord (var t : t_tab_17_byte);
{ Sfct. 9 = Lire les 16 registres de palette plus le registre de surbalayage. }

procedure set_cna_reg (reg : word; v, b, r : byte);
{ Sfct. 10h = Modifier un registre du CNA vid‚o. }

procedure set_blk_cna_reg (reg1, nb_reg : word; t : t_tab_rvb);
{ Sfct. 12h = Modifier un bloc de registres de couleur du CNA vid‚o. }

procedure get_cna_reg (reg : word; var v, b, r : byte);
{ Sfct. 15h = Lire un registre de couleur du CNA vid‚o. }

procedure get_blk_cna_reg (reg1, nb_reg : word; var t : t_tab_rvb);
{ Sfct. 17h = Lire un bloc de registres de couleur du CNA vid‚o. }

procedure set_coul2gray (reg1, nb_reg : word);
{ Sfct. 1Bh = Conversion en gamme de gris d'un bloc de registres de couleur du
              CNA vid‚o. }

implementation
procedure swap_byte (var a, b : byte);
var
   c : byte;
begin
     c := a;
     a := b;
     b := c;
end; { swap_byte }

function set_mode (n : byte) : boolean;
begin
     asm
        push ax
        mov ah, 0
        mov al, n
        int 10h
        pop ax
     end;
     set_mode := (get_mode = n);
end; { set_mode }

procedure define_cursor (ls, li : byte);
begin
     asm
        push ax
        push cx
        mov ah, 1
        mov ch, ls
        mov cl, li
        int 10h
        pop cx
        pop ax
     end;
end; { define_cursor }

procedure goto_xy (page, x, y : byte);
begin
     asm
        push ax
        push bx
        push dx
        mov ah, 2
        mov bh, page
        mov dl, x
        mov dh, y
        int 10h
        pop dx
        pop bx
        pop ax
     end;
end; { goto_xy }

procedure info_cursor (page : byte; var ls, li, x, y : byte);
var
   a, b, c, d : byte;
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 3
        mov bh, page
        int 10h
        mov a, ch
        mov b, cl
        mov c, dl
        mov d, dh
        pop dx
        pop cx
        pop bx
        pop ax
     end;
     ls := a;
     li := b;
     x := c;
     y := d;
end; { info_cursor }

procedure read_pen (var is_ok : boolean; var x, y : word; var l, c : byte);
var
   a, d, e : byte;
   b, col : word;
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 4
        int 10h
        mov a, ah
        mov b, bx
        mov col, cx
        mov d, dh
        mov e, dl
        pop dx
        pop cx
        pop bx
        pop ax
     end;
     is_ok := (a = 1);
     x := b;
     if (get_mode in [4..6])
     then
         y := (col and $f0) shr 4
     else
         y := col;
     {endif}
     l := d;
     c := e;
end; { read_pen }

procedure set_page (n : byte);
begin
     asm
        push ax
        mov ah, 5
        mov al, n
        int 10h
        pop ax
     end;
end; { set_page }

procedure scroll_up (nb_lig, text_attr, x1, y1, x2, y2 : byte);
begin
     if (x1 > x2)
     then
         swap_byte (x1, x2);
     {endif}
     if (y1 > y2)
     then
         swap_byte (y1, y2);
     {endif}
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 6
        mov al, nb_lig
        mov bh, text_attr
        mov ch, y1
        mov cl, x1
        mov dh, y2
        mov dl, x2
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { scroll_up }

procedure scroll_down (nb_lig, text_attr, x1, y1, x2, y2 : byte);
begin
     if (x1 > x2)
     then
         swap_byte (x1, x2);
     {endif}
     if (y1 > y2)
     then
         swap_byte (y1, y2);
     {endif}
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 7
        mov al, nb_lig
        mov bh, text_attr
        mov ch, y1
        mov cl, x1
        mov dh, y2
        mov dl, x2
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { scroll_down }

procedure put_pixel (page, color : byte; x, y : word);
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 0ch
        mov al, color
        mov bh, page
        mov cx, x
        mov dx, y
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { put_pixel }

function get_pixel (page : byte; x, y : word) : byte;
var
   res : byte;
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 0dh
        mov bh, page
        mov cx, x
        mov dx, y
        int 10h
        mov res, al
        pop dx
        pop cx
        pop bx
        pop ax
     end;
     get_pixel := res;
end; { get_pixel }

function get_mode : byte;
var
   res, c, p : byte;
begin
     info_mode (res, c, p);
     get_mode := res;
end; { get_mode }

procedure info_mode (var mode_num, nb_col, page : byte);
var
   m, c, p : byte;
begin
     asm
        push ax
        push bx
        mov ah, 0fh
        int 10h
        mov m, al
        mov c, ah
        mov p, bh
        pop bx
        pop ax
     end;
     mode_num := m;
     nb_col := c;
     page := p;
end; { info_mode }

procedure set_reg_pal (reg, coul : byte);
begin
     asm
        push ax
        push bx
        mov ah, 10h
        mov al, 0
        mov bh, coul
        mov bl, reg
        int 10h
        pop bx
        pop ax
     end;
end; { set_reg_pal }

procedure set_bordure_coul (coul : byte);
begin
     asm
        push ax
        push bx
        mov ah, 10h
        mov al, 1
        mov bh, coul
        int 10h
        pop bx
        pop ax
     end;
end; { set_bordure_coul }

procedure set_reg_pal_16_bord (t : t_tab_17_byte);
var
   o, s : word;
begin
     o := ofs (t);
     s := seg (t);
     asm
        push ax
        push dx
        push es
        mov ah, 10h
        mov al, 2
        mov es, s
        mov dx, o
        int 10h
        pop es
        pop dx
        pop ax
     end;
end; { set_reg_pal_16_bord }

function get_reg_pal (reg : byte) : byte;
var
   res : byte;
begin
     asm
        push ax
        push bx
        mov ah, 10h
        mov al, 7
        mov bl, reg
        int 10h
        mov res, bh
        pop bx
        pop ax
     end;
     get_reg_pal := res;
end; { get_reg_pal }

function get_bordure_coul : byte;
var
   res : byte;
begin
     asm
        push ax
        push bx
        mov ah, 10h
        mov al, 8
        int 10h
        mov res, bh
        pop bx
        pop ax
     end;
     get_bordure_coul := res;
end; { get_bordure_coul }

procedure get_reg_pal_16_bord (var t : t_tab_17_byte);
var
   o, s : word;
begin
     o := ofs (t);
     s := seg (t);
     asm
        push ax
        push dx
        push es
        mov ah, 10h
        mov al, 9
        mov es, s
        mov dx, o
        int 10h
        pop es
        pop dx
        pop ax
     end;
end; { get_reg_pal_16_bord }

procedure set_cna_reg (reg : word; v, b, r : byte);
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 10h
        mov al, 10h
        mov bx, reg
        mov ch, v
        mov cl, b
        mov dh, r
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { set_cna_reg }

procedure set_blk_cna_reg (reg1, nb_reg : word ; t : t_tab_rvb);
var
   o, s : word;
begin
     o := ofs (t);
     s := seg (t);
     asm
        push ax
        push bx
        push cx
        push dx
        push es

        mov dx, $3da { VSYNC }
     @bcl:
        in  al, dx
        and al, 8
        je  @bcl

        mov ah, 10h
        mov al, 12h
        mov bx, reg1
        mov cx, nb_reg
        mov es, s
        mov dx, o
        int 10h

        mov dx, $3da { VSYNC }
     @bcl2:
        in  al, dx
        and al, 8
        je  @bcl2

        pop es
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { set_blk_cna_reg }

procedure get_cna_reg (reg : word; var v, b, r : byte);
var
   a, d, c : byte;
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 10h
        mov al, 15h
        mov bx, reg
        int 10h
        mov a, ch
        mov d, cl
        mov c, dh
        pop dx
        pop cx
        pop bx
        pop ax
     end;
     v := a;
     b := d;
     r := c;
end; { get_cna_reg }

procedure get_blk_cna_reg (reg1, nb_reg : word; var t : t_tab_rvb);
var
   o, s : word;
begin
     o := ofs (t);
     s := seg (t);
     asm
        push ax
        push bx
        push cx
        push dx
        push es
        mov ah, 10h
        mov al, 17h
        mov bx, reg1
        mov cx, nb_reg
        mov es, s
        mov dx, o
        int 10h
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
     end;
end; { get_blk_cna_reg }

procedure set_coul2gray (reg1, nb_reg : word);
begin
     asm
        push ax
        push bx
        push cx
        mov ah, 10h
        mov al, 1bh
        mov bx, reg1
        mov cx, nb_reg
        int 10h
        pop cx
        pop bx
        pop ax
     end;
end; { set_coul2gray }

end.
