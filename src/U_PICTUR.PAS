unit u_picture;
{
Auteur: Patrick Premartin.
Date: 19/12/1991.
      24/06/1992.
      25/06/1992.
Langage: Turbo Pascal 6.0

But: Procedures et fonctions de gestion d'images dans differents formats.
     Ne fonctionne qu'en mode 320*200*256 pour les images couleur venant de
     l'Atari.
}
interface
const
     coul_min : word = 0; { Registre de couleur minimal. }

type
    p_palette = ^t_palette;
    t_palette = array [0..15] of word;

    p_image = ^t_image;
    t_image = array [0..31999] of byte;

            { Images Degas Elite: }
                     { PI1: 32034 ou 32066 octets }
    p_anim_pi1 = ^t_anim_pi1;
    t_anim_pi1 = array [0..31] of byte;

    { Images de 32034 octets }
    p_pi1 = ^t_pi1;
    t_pi1 = record
                  resol : word;
                  palette : t_palette;
                  image : t_image;
    end;

    { Images de 32066 octets }
    p_pi1_2 = ^t_pi1_2;
    t_pi1_2 = record
                    resol : word;
                    palette : t_palette;
                    image : t_image;
                    animcoul : t_anim_pi1;
    end;

            { Images Art Director: }
                     { ART: 32512 octets }
    p_code_art = ^t_code_art;
    t_code_art = array [0..479] of byte;

    p_art = ^t_art;
    t_art = record
                  image : t_image;
                  palette : t_palette;
                  codes : t_code_art;
    end;

            { Images Neochrome: }
                     { NEO: 32128 octets }
    p_code_neo = ^t_code_neo;
    t_code_neo = array [0..91] of byte;

    p_neo = ^t_neo;
    t_neo = record
                  resol : word;
                  filler : word;
                  palette : t_palette;
                  codes : t_code_neo;
                  image : t_image;
    end;

            { Images autres: }
                     { RAA: 32032 octets }
    p_raa = ^t_raa;
    t_raa = record
                  palette : t_palette;
                  image : t_image;
    end;

procedure affiche_image (var image : t_image);
procedure palette_adapte (var palette : t_palette);

implementation
uses
    crt,
    u_graph;

procedure affiche_image (var image : t_image);
var
   i, j, k, l, z, mask, coul : integer;
   x, y : word;
begin
     directvideo := false;
     { Passage en VGA 320*200 256 couleurs si pas d‚j… dans ce mode }
     asm
        push ax
        push bx
        mov ah, 0Fh
        int 10h
        cmp al, 19
        je @fin
        { Pas mode 19, mise en place de ce mode... }
        mov ah, 0
        mov al, 19
        int 10h
     @fin:
         pop bx
         pop ax
     end;
     j := 0;
     y := 0;
     for z := 0 to 199 do
         begin
              x := 0;
              for k := 1 to 20 do
                  begin
                       for l := 0 to 1 do
                           for i := 7 downto 0 do
                               begin
                                    mask := (1 shl i);
                                    coul := (image [j+l] and mask) shr i
                                         + ((image [j+l+2] and mask) shr i) shl 1
                                         + ((image [j+l+4] and mask) shr i) shl 2
                                         + ((image [j+l+6] and mask) shr i) shl 3;
                                    {$r-}
                                    mem [$a000:x+y] := (coul and 15) + coul_min;
                                    {$r+}
                                    inc (x);
                               end;
                           {endfor}
                       {endfor}
                       inc (j, 8);
                  end;
              {endfor}
              inc (y, 320);
         end;
     {endfor}
end; { Affiche_Image }

procedure palette_adapte (var palette : t_palette);
var
   i : word;
   r, v, b : byte;
begin
     { Passage en VGA 320*200 256 couleurs si pas d‚j… dans ce mode }
     asm
        push ax
        push bx
        mov ah, 0Fh
        int 10h
        cmp al, 19
        je @fin
        { Pas mode 19, mise en place de ce mode... }
        mov ah, 0
        mov al, 19
        int 10h
     @fin:
         pop bx
         pop ax
     end;
     for i := 0 to 15 do
         begin
              r := ((palette [i] and $0007))*63 div 7;
              v := ((palette [i] and $7000) shr 12)*63 div 7;
              b := ((palette [i] and $0700) shr 8)*63 div 7;
              asm
                 mov ah, 10h
                 mov al, 10h
                 mov bx, coul_min
                 add bx, i
                 mov dh, r
                 mov ch, v
                 mov cl, b
                 int 10h
              end;
         end;
     {endfor}
end; { Palette_Adapte }

end. { Fin de l'unite 'U_Picture'. }
