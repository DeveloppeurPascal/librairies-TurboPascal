unit u_mou;
{
Auteur: Premartin Patrick
Date: 21/11/1991.
Langage: Turbo Pascal 6.0
But: Procedures et fonctions de changement de la forme de la souris en mode
     graphique.
}
interface
const
     nb_max_mou = 50;

type
    t_mat = array [1..16] of word;
    p_mou = ^t_mou;
    t_mou = record
                  mask : t_mat;
                  form : t_mat;
                  act_x : word;
                  act_y : word;
    end;
    t_mou_regs = byte;

function mou_load (nom_fich : string) : p_mou;
{ Charge une souris de la disquette vers la m‚moire et retourne l'adresse de
cette souris. }
         { Codes de retour: - pointeur vers la souris charg‚e;
                            - NIL si erreur (pas assez de m‚moire, nom de
                            fichier incorrect ...).
         }
function mou_save (nom_fich : string; number : t_mou_regs) : byte;
{ Sauve la souris de numero Number. }
         { Codes de retour: - 0 si aucune erreur;
                            - 1 si erreur de sauvegarde;
                            - 2 si NUMBER n'est pas valide;
                            - 3 si ce num‚ro n'est pas affect‚.
         }
function mou_register (mou : p_mou; number : t_mou_regs) : byte;
{ Affecte le numero Number a une souris pointee par Mou. }
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si mou = NIL;
                            - 2 si NUMBER n'est pas valide (autre que dans
                            1..NB_MAX_mou).
         }
function mou_select (number : t_mou_regs) : byte;
{ Choisit le curseur de num‚ro Number s'il existe. }
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si NUMBER non valide (autre que dans
                            0..NB_MAX_mou);
                            - 2 si la souris correspondante n'a pas ‚t‚
                            enregistr‚e par Mou_Register.
         }
function mou_erase (number : t_mou_regs) : byte;
{ Supprime une souris de la liste. }
         { Codes de retour: - 0 si pas d'erreur;
                            - 1 si NUMBER non valide (autre que dans
                            0..NB_MAX_mou);
                            - 2 si la souris correspondante n'existe pas.
         }
procedure mou_clear;
{ Efface toutes les souris de la m‚moire et remet la souris par d‚faut. }

implementation
uses
    dos;

const
     default_mouse : t_mou =
                   (mask : ($3fff, $1fff, $fff, $7ff, $3ff, $1ff, $ff, $7f,
                            $3f, $1f, $1ff, $10ff, $30ff, $f87f, $f87f, $fc3f);
                    form : ($0, $4000, $6000, $7000, $7800, $7c00, $7e00, $7f00,
                            $7f80, $7fc0, $7c00, $4600, $600, $300, $300, $0);
                    act_x : 0;
                    act_y : 0);

type
    t_mou_table = array [0..nb_max_mou] of p_mou;

var
   mou_table : t_mou_table;
   mou_current : t_mou_regs;

procedure mou_init;
var
   i : integer;
begin
     for i := 0 to nb_max_mou do
         mou_table [i] := nil;
     {endfor}
     mou_table [0] := @default_mouse;
     mou_current := 0;
end; { mou_Init }

function mou_load (nom_fich : string) : p_mou;
var
   fich : file of t_mou;
   mou : p_mou;
   dir : dirstr;
   name : namestr;
   ext : extstr;
begin
     new (mou);
     if (mou <> nil)
     then
         begin
              fsplit (fexpand (nom_fich), dir, name, ext);
              assign (fich, dir+name+'.mou');
              {$i-}
              reset (fich);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       dispose (mou);
                       mou := nil;
                  end
              else
                  begin
                       {$i-}
                       read (fich, mou^);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           begin
                                dispose (mou);
                                mou := nil;
                           end;
                       {endif}
                       close (fich);
                  end;
              {endif}
         end;
     {endif}
     mou_load := mou;
end; { mou_Load }

function mou_save (nom_fich : string; number : t_mou_regs) : byte;
var
   fich : file of t_mou;
   mou : p_mou;
   dir : dirstr;
   name : namestr;
   ext : extstr;
   result : byte;
begin
     result := 0;
     if ((number > nb_max_mou) or (number < 1))
     then
         result := 2
     else
         begin
              mou := mou_table [number];
              if (mou = nil)
              then
                  result := 3
              else
                  begin
                       fsplit (fexpand (nom_fich), dir, name, ext);
                       assign (fich, dir+name+'.mou');
                       {$i-}
                       rewrite (fich);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           result := 1
                       else
                           begin
                                {$i-}
                                write (fich, mou^);
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
     mou_save := result;
end; { mou_Save }

function mou_register (mou : p_mou; number : t_mou_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if ((number < 1) or (number > nb_max_mou))
     then
         result := 2
     else
         if (mou = nil)
         then
             result := 1
         else
             begin
                  if (mou_table [number] <> nil)
                  then
                      result := mou_erase (number);
                  {endif}
                  mou_table [number] := mou;
             end;
         {endif}
     {endif}
     mou_register := result;
end; { mou_Register }

function mou_select (number : t_mou_regs) : byte;
var
   result : byte;
   i,
   j : word;
   x,
   y : word;
begin
     result := 0;
     if ((number < 0) or (number > nb_max_mou))
     then
         result := 1
     else
         if (mou_table [number] = nil)
         then
             result := 2
         else
             if (mou_current <> number)
             then
                 begin
                      i := seg (mou_table [number]^);
                      j := ofs (mou_table [number]^);
                      x := mou_table [number]^.act_x;
                      y := mou_table [number]^.act_y;
                      asm
                         push ax
                         push bx
                         push cx
                         push dx
                         push es
                         mov ax, 9
                         mov bx, x
                         mov cx, y
                         mov es, i
                         mov dx, j
                         int $33
                         pop es
                         pop dx
                         pop cx
                         pop bx
                         pop ax
                      end;
                      mou_current := number;
                 end;
             {endif}
         {endif}
     {endif}
     mou_select := result;
end; { mou_Select }

function mou_erase (number : t_mou_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if (mou_current = number)
     then
         result := mou_select (0);
     {endif}
     if ((number < 1) or (number > nb_max_mou))
     then
         result := 1
     else
         if (mou_table [number] = nil)
         then
             result := 2
         else
             begin
                  dispose (mou_table [number]);
                  mou_table [number] := nil;
             end;
         {endif}
     {endif}
     mou_erase := result;
end; { mou_Erase }

procedure mou_clear;
var
   err : byte;
   i : integer;
begin
     if (mou_select (0) = 0)
     then
         for i := 1 to nb_max_mou do
             err := mou_erase (i);
         {endfor}
     {endif}
end; { mou_Clear }

var
   old_exitproc : pointer;

{$f+}
procedure mou_exit;
begin
     mou_clear;
     exitproc := old_exitproc;
end; { mou_Exit }

begin
     mou_init;
     old_exitproc := exitproc;
     exitproc := @mou_exit;
end. { Fin de l'unit‚ 'U_Mou'. }
