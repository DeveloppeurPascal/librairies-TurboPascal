unit u_ppp;
{
Auteur: Patrick Pr‚martin
Date: 24/01/1992. 25/06/1992. 14/02/1993.
Langage: Turbo Pascal 6.0

But: Proc‚dures et fonctions permettant de manipuler les fichiers d'extension
     PPP, ce sont des images compr‚ss‚es en 256 couleurs. Ecrans VGA
     obligatoires.
}
interface
type
    t_rvb_coul = record
                   r : byte;
                   v : byte;
                   b : byte;
    end;

    p_ppp_pal = ^t_ppp_pal;
    t_ppp_pal = array [0..255] of t_rvb_coul;

    p_ppp_imag = ^t_ppp_imag;
    t_ppp_imag = record
                  case boolean of
                    true: (tab : array [0..199, 0..319] of byte);
                    false: (lst : array [0..63999] of byte);
                  end;

    p_ppp = ^t_ppp;
    t_ppp = record
              palette : p_ppp_pal;
              image : p_ppp_imag;
    end;

function ppp_init : p_ppp;
function ppp_load (nom_fich : string) : p_ppp;
procedure ppp_save (nom_fich : string; ppp : p_ppp);
procedure ppp_affiche (ppp : p_ppp);
procedure ppp_set_coul (coul : p_ppp_pal);
function ppp_get_coul : p_ppp_pal;
procedure ppp_done (var ppp : p_ppp);

function get_mode : byte;
function set_mode (num : byte) : boolean;
procedure ppp_pal_init;

implementation
uses
    u_pack,
    u_sgf;

const
     c_ppp_header = #13'PrePatPicture'#10#13#26;

function ppp_init : p_ppp;
var
   i : byte;
   ppp : p_ppp;
begin
     new (ppp);
     if (ppp <> nil)
     then
         begin
              new (ppp^.palette);
              if (ppp^.palette <> nil)
              then
                  begin
                       for i := 0 to 255 do
                           begin
                                ppp^.palette^ [i].r := 0;
                                ppp^.palette^ [i].v := 0;
                                ppp^.palette^ [i].b := 0;
                           end;
                       {endfor}
                       ppp^.image := nil;
                  end
              else
                  begin
                       dispose (ppp);
                       ppp := nil;
                  end;
              {endif}
         end;
     {endif}
     ppp_init := ppp;
end; { ppp_init }

function ppp_load (nom_fich : string) : p_ppp;
var
   fich : file;
   ch : string;
   l : byte;
   ppp : p_ppp;
   b : boolean;
   nb, nb2 : word;
   pt : pointer;
begin
     ppp := ppp_init;
     met_extension (nom_fich, 'PPP', nom_fich);
     assign (fich, nom_fich);
     {$i-}
     reset (fich, 1);
     {$i+}
     if ((ioresult = 0) and (ppp <> nil))
     then
         begin
              blockread (fich, l, sizeof (l));
              reset (fich, 1);
              blockread (fich, ch, succ (l));
              repeat
                    ch [0] := #3;
                    blockread (fich, ch [1], 3);
                    if (ch = 'PAL')
                    then
                        begin
                             blockread (fich, b, sizeof (b));
                             if (b)
                             then
                                 begin
                                      blockread (fich, nb, sizeof (nb));
                                      getmem (pt, nb);
                                      if (pt <> nil)
                                      then
                                          begin
                                               blockread (fich, pt^, nb);
                                               if (ppp^.palette <> nil)
                                               then
                                                   dispose (ppp^.palette);
                                               {endif}
                                               unpack (pt, pointer (ppp^.palette), nb2);
                                               freemem (pt, nb);
                                          end
                                      else
                                          begin
                                               blockread (fich, ppp^.palette^, nb);
                                               dispose (ppp^.palette);
                                               ppp^.palette := ppp_get_coul;
                                          end;
                                      {endif}
                                 end
                             else
                                 blockread (fich, ppp^.palette^, sizeof (ppp^.palette^));
                             {endif}
                        end;
                    {endif}
                    if (ch = 'IMG')
                    then
                        begin
                             new (ppp^.image);
                             blockread (fich, b, sizeof (b));
                             if (b)
                             then
                                 begin
                                      blockread (fich, nb, sizeof (nb));
                                      getmem (pt, nb);
                                      if (pt <> nil)
                                      then
                                          begin
                                               blockread (fich, pt^, nb);
                                               if (ppp^.image <> nil)
                                               then
                                                   dispose (ppp^.image);
                                               {endif}
                                               unpack (pt, pointer (ppp^.image), nb2);
                                               freemem (pt, nb);
                                          end
                                      else
                                          begin
                                               blockread (fich, ppp^.image^, nb);
                                               dispose (ppp^.image);
                                               ppp^.image := nil;
                                          end;
                                      {endif}
                                 end
                             else
                                 blockread (fich, ppp^.image^, sizeof (ppp^.image^));
                             {endif}
                        end;
                    {endif}

              until eof (fich);
              close (fich);
         end
     else
         if (ppp <> nil)
         then
             ppp_done (ppp);
         {endif}
     {endif}
     ppp_load := ppp;
end; { ppp_load }

procedure ppp_save (nom_fich : string; ppp : p_ppp);
var
   fich : file;
   ch : string;
   b : boolean;
   pt : pointer;
   nb : word;
begin
     ch := c_ppp_header;
     met_extension (nom_fich, 'PPP', nom_fich);
     cree_bak (nom_fich);
     assign (fich, nom_fich);
     {$i-}
     rewrite (fich, 1);
     {$i+}
     if (ioresult = 0)
     then
         begin
              blockwrite (fich, ch, succ (length (ch)));
              if (ppp^.palette <> nil)
              then
                  begin
                       ch := 'PAL';
                       blockwrite (fich, ch [1], 3);
                       pack (ppp^.palette, sizeof (ppp^.palette^), pt, nb);
                       b := (nb < sizeof (ppp^.palette^));
                       blockwrite (fich, b, sizeof (b));
                       if (b)
                       then
                           begin
                                blockwrite (fich, nb, sizeof (nb));
                                blockwrite (fich, pt^, nb);
                                freemem (pt, nb);
                           end
                       else
                           begin
                                blockwrite (fich, ppp^.palette^, sizeof (ppp^.palette^));
                                freemem (pt, sizeof (ppp^.palette^));
                           end;
                       {endif}
                  end;
              {endif}
              if (ppp^.image <> nil)
              then
                  begin
                       ch := 'IMG';
                       blockwrite (fich, ch [1], 3);
                       pack (ppp^.image, sizeof (ppp^.image^), pt, nb);
                       b := (nb < sizeof (ppp^.image^));
                       blockwrite (fich, b, sizeof (b));
                       if (b)
                       then
                           begin
                                blockwrite (fich, nb, sizeof (nb));
                                blockwrite (fich, pt^, nb);
                                freemem (pt, nb);
                           end
                       else
                           begin
                                blockwrite (fich, ppp^.image^, sizeof (ppp^.image^));
                                freemem (pt, sizeof (ppp^.image^));
                           end;
                       {endif}
                  end;
              {endif}
              close (fich);
         end;
     {endif}
end; { ppp_save }

procedure ppp_affiche (ppp : p_ppp);
begin
     if (get_mode <> 19)
     then
         repeat
         until (set_mode (19) or true);
     {endif}
     if (ppp <> nil)
     then
         begin
              if (ppp^.palette <> nil)
              then
                  ppp_set_coul (ppp^.palette);
              {endif}
              if (ppp^.image <> nil)
              then
                  move (ppp^.image^, ptr ($a000, $0000)^, 64000);
              {endif}
         end;
     {endif}
end; { ppp_affiche }

procedure ppp_set_coul (coul : p_ppp_pal);
var
   off,
   sg : word;
begin
     if (coul <> nil)
     then
         begin
              off := ofs (coul^);
              sg := seg (coul^);
              asm
                 push ax
                 push bx
                 push cx
                 push es
                 push dx

                 mov dx, $3da { VSYNC }
              @bcl:
                 in  al, dx
                 and al, 8
                 je  @bcl

                 mov ah, 10h
                 mov al, 12h
                 mov bx, 0
                 mov cx, 256
                 mov es, sg
                 mov dx, off
                 int 10h

                 mov dx, $3da { VSYNC }
              @bcl2:
                 in  al, dx
                 and al, 8
                 je  @bcl2

                 pop dx
                 pop es
                 pop cx
                 pop bx
                 pop ax
              end;
         end;
     {endif}
end; { ppp_set_coul }

function ppp_get_coul : p_ppp_pal;
var
   pal : p_ppp_pal;
   off,
   sg : word;
begin
     new (pal);
     if (pal <> nil)
     then
         begin
              off := ofs (pal^);
              sg := seg (pal^);
              asm
                 push ax
                 push bx
                 push cx
                 push dx
                 push es

                 mov ah, 10h
                 mov al, 17h
                 mov bx, 0
                 mov cx, 256
                 mov es, sg
                 mov dx, off
                 int 10h

                 pop es
                 pop dx
                 pop cx
                 pop bx
                 pop ax
              end;
         end;
     {endif}
     ppp_get_coul := pal;
end; { ppp_get_coul }

procedure ppp_done (var ppp : p_ppp);
begin
     if (ppp <> nil)
     then
         begin
              if (ppp^.palette <> nil)
              then
                  dispose (ppp^.palette);
              {endif}
              if (ppp^.image <> nil)
              then
                  dispose (ppp^.image);
              {endif}
              dispose (ppp);
              ppp := nil;
         end;
     {endif}
end; { ppp_done }

function get_mode : byte;
var
   i : byte;
begin
     asm
        mov ah, 0Fh
        int 10h
        mov i, al
     end;
     get_mode := i;
end; { get_mode }

function set_mode (num : byte) : boolean;
begin
     asm
        mov ah, 0
        mov al, num
        int 10h
     end;
     set_mode := (num = get_mode);
end; { set_mode }

procedure ppp_pal_init;
var
   p : p_ppp_pal;
   i : byte;
begin
     new (p);
     if (p <> nil)
     then
         begin
              for i := 0 to 255 do
                  begin
                       p^ [i].r := 0;
                       p^ [i].v := 0;
                       p^ [i].b := 0;
                  end;
              {endfor}
              ppp_set_coul (p);
              dispose (p);
         end;
     {endif}
end; { palette_init }

var
   old_exitproc : pointer;
   old_pal : p_ppp_pal;
   n : byte;

{$f+}
procedure ppp_exit;
begin
     ppp_set_coul (old_pal);
     exitproc := old_exitproc;
end; { ppp_exit }

begin
     n := get_mode;
     old_pal := ppp_get_coul;
     if (set_mode (19) and set_mode (n))
     then
         begin
              old_exitproc := exitproc;
              exitproc := @ppp_exit;
         end
     else
         begin
              writeln ('This program run only with VGA (or upper) graphic card...');
              halt (1);
         end;
     {endif}
end. { u_ppp }
