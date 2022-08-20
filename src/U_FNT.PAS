unit u_fnt;
{
Auteur: Premartin Patrick
Date: 08/09/1991.
      09/09/1991.
      14/11/1991.
      31/12/1992.
Langage: Turbo Pascal 6.0
But: Proc‚dures et fonctions permettant de modifier les trames des caractŠres
     de codes 0 … 255. (en fait, les 256 nouveaux caractŠres sont accessibles
     en mode graphique avec les proc‚dures d'affichage incluses)
}
interface
const
     nb_max_fnt = 10;

type
    t_char_mat = array [1..8] of byte;
    p_fnt = ^t_fnt;
    t_fnt = array [0..255] of t_char_mat;
    t_fnt_regs = byte;
    t_ecr_mode = (transparent, normal);

var
   fnt_last : t_fnt_regs;
   ecr_mode : t_ecr_mode;

function fnt_load (nom_fich : string) : p_fnt;
         { Codes de retour: - pointeur vers la fonte charg‚e;
                            - NIL si erreur (pas assez de m‚moire, nom de
                            fichier incorrect ...).
         }
function fnt_save (nom_fich : string; number : t_fnt_regs) : byte;
         { Codes de retour: - 0 si aucune erreur;
                            - 1 si erreur de sauvegarde;
                            - 2 si NUMBER n'est pas valide;
                            - 3 si ce num‚ro n'est pas affect‚.
         }
function fnt_register (fnt : p_fnt; number : t_fnt_regs) : byte;
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si FNT = NIL;
                            - 2 si NUMBER n'est pas valide (autre que dans
                            1..NB_MAX_FNT).
         }
function fnt_select (number : t_fnt_regs) : byte;
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si NUMBER non valide (autre que dans
                            0..NB_MAX_FNT);
                            - 2 si la fonte correspondante n'a pas ‚t‚
                            enregistr‚e par Fnt_Register.
         }
function fnt_erase (number : t_fnt_regs) : byte;
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si NUMBER non valide (autre que dans
                            0..NB_MAX_FNT);
                            - 2 si la fonte correspondante n'existe pas.
         }
procedure fnt_clear;
          { Efface toutes les fontes de la m‚moire et remet la fonte par
          d‚faut. }

procedure ecr_char (carac : char);
          { Ecriture d'un caractŠre dans la fonte courante … la position
          actuelle. }
procedure ecr_int (nb : longint);
          { Ecriture d'un entier … la position courante dans la fonte
          actuelle. }
procedure ecr_str (ch : string);
          { Ecriture d'une chaine … la position courante. }
procedure ecr_xy (x, y : integer);
          { Deplacement du curseur. (coordonnees textes). }
procedure ecr_color (forme, fond : byte);
          { Choix des couleurs de forme et de fond. }

implementation
uses
    dos;

type
    t_fnt_table = array [0..nb_max_fnt] of p_fnt;

var
   fnt_table : t_fnt_table;
   fnt_current : t_fnt_regs;
   ecr_x, ecr_y : integer;
   ecr_coul1, ecr_coul2 : byte;

procedure fnt_init;
var
   i,
   j : word;
begin
     for i := 0 to nb_max_fnt do
         fnt_table [i] := nil;
     {endfor}
     asm
        push ax
        push bx
        push es
        mov ah, $35
        mov al, $1f
        int $21
        mov i, es
        mov j, bx
        pop es
        pop bx
        pop ax
     end;
     fnt_table [0] := ptr (i, j);
     fnt_last := 0;
     fnt_current := 0;
     ecr_mode := normal;
     ecr_x := 1;
     ecr_y := 1;
     ecr_coul1 := 1;
     ecr_coul2 := 0;
end; { Fnt_Init }

function fnt_load (nom_fich : string) : p_fnt;
var
   fich : file of t_fnt;
   fnt : p_fnt;
   dir : dirstr;
   name : namestr;
   ext : extstr;
begin
     new (fnt);
     if (fnt <> nil)
     then
         begin
              fsplit (fexpand (nom_fich), dir, name, ext);
              assign (fich, dir+name+'.FNT');
              {$i-}
              reset (fich);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       dispose (fnt);
                       fnt := nil;
                  end
              else
                  begin
                       {$i-}
                       read (fich, fnt^);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           begin
                                dispose (fnt);
                                fnt := nil;
                           end;
                       {endif}
                       close (fich);
                  end;
              {endif}
         end;
     {endif}
     fnt_load := fnt;
end; { Fnt_Load }

function fnt_save (nom_fich : string; number : t_fnt_regs) : byte;
var
   fich : file of t_fnt;
   fnt : p_fnt;
   dir : dirstr;
   name : namestr;
   ext : extstr;
   result : byte;
begin
     result := 0;
     if ((number > nb_max_fnt) or (number < 1))
     then
         result := 2
     else
         begin
              fnt := fnt_table [number];
              if (fnt = nil)
              then
                  result := 3
              else
                  begin
                       fsplit (fexpand (nom_fich), dir, name, ext);
                       assign (fich, dir+name+'.FNT');
                       {$i-}
                       rewrite (fich);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           result := 1
                       else
                           begin
                                {$i-}
                                write (fich, fnt^);
                                {$i+}
                                if (ioresult <> 0)
                                then
                                    result := 1;
                                {endif}
                                close (fich);
                           end;
                       {endif}
                  end;
              {endif}
         end;
     {endif}
     fnt_save := result;
end; { Fnt_Save }

function fnt_register (fnt : p_fnt; number : t_fnt_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if ((number < 1) or (number > nb_max_fnt))
     then
         result := 2
     else
         if (fnt = nil)
         then
             result := 1
         else
             begin
                  if (fnt_table [number] <> nil)
                  then
                      result := fnt_erase (number);
                  {endif}
                  fnt_table [number] := fnt;
             end;
         {endif}
     {endif}
     fnt_register := result;
end; { Fnt_Register }

function fnt_select (number : t_fnt_regs) : byte;
var
   result : byte;
   i,
   j : word;
begin
     result := 0;
     if ((number < 0) or (number > nb_max_fnt))
     then
         result := 1
     else
         if (fnt_table [number] = nil)
         then
             result := 2
         else
             if (fnt_current <> number)
             then
                 begin
                      fnt_last := fnt_current;
                      fnt_current := number;
                 end;
             {endif}
         {endif}
     {endif}
     fnt_select := result;
end; { Fnt_Select }

function fnt_erase (number : t_fnt_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if (fnt_current = number)
     then
         result := fnt_select (0);
     {endif}
     if ((number < 1) or (number > nb_max_fnt))
     then
         result := 1
     else
         if (fnt_table [number] = nil)
         then
             result := 2
         else
             begin
                  dispose (fnt_table [number]);
                  fnt_table [number] := nil;
             end;
         {endif}
     {endif}
     fnt_erase := result;
end; { Fnt_Erase }

procedure fnt_clear;
var
   err : byte;
   i : integer;
begin
     if (fnt_select (0) = 0)
     then
         for i := 1 to nb_max_fnt do
             err := fnt_erase (i);
         {endfor}
     {endif}
end; { Fnt_Clear }

procedure put_pixel (i, j : integer; coul : byte);
var
   col, lig : word;
begin { Put_Pixel }
      col := 8 * pred (ecr_x) + i;
      lig := 8 * pred (ecr_y) + j;
      asm
         push ax
         push cx
         push dx
         mov ah, 0ch
         mov al, coul
         mov cx, col
         mov dx, lig
         int 10h
         pop dx
         pop cx
         pop ax
      end;
end; { Put_Pixel }

procedure ecr_char (carac : char);
var
   octet : byte;
   i, j : integer;
begin { Ecr_Char }
      for j := 1 to 8 do
          begin
               octet := fnt_table [fnt_current]^ [ord (carac)] [j];
               for i := 0 to 7 do
                   if (octet and (1 shl (7-i)) > 0)
                   then
                       put_pixel (i, pred (j), ecr_coul1)
                   else
                       if (ecr_mode = normal)
                       then
                           put_pixel (i, pred (j), ecr_coul2);
                       {endif}
                   {endif}
               {endfor}
          end;
      {endfor}
      inc (ecr_x);
      if (ecr_x > 80)
      then
          begin
               inc (ecr_y);
               ecr_x := 80-ecr_x;
          end;
      {endif}
      if (ecr_y > 25)
      then
          ecr_y := 25;
      {endif}
end; { Ecr_Char }

procedure ecr_str (ch : string);
var
   i : byte;
begin { Ecr_Str }
      for i := 1 to length (ch) do
          ecr_char (ch [i]);
      {endfor}
end; { Ecr_Str }

procedure ecr_int (nb : longint);
var
   ch : string;
begin { Ecr_Int }
      str (nb, ch);
      ecr_str (ch);
end; { Ecr_Int }

procedure ecr_xy (x, y : integer);
begin { Ecr_Xy }
      ecr_x := x;
      ecr_y := y;
end; { Ecr_Xy }

procedure ecr_color (forme, fond : byte);
begin { Ecr_Color }
      ecr_coul1 := forme;
      ecr_coul2 := fond;
end; { Ecr_Color }

var
   old_exitproc : pointer;

{$f+}
procedure fnt_exit;
begin
     fnt_clear;
     exitproc := old_exitproc;
end; { Fnt_Exit }

begin
     fnt_init;
     old_exitproc := exitproc;
     exitproc := @fnt_exit;
end. { Fin de l'unit‚ 'U_Fnt'. }
