unit u_vga_jeux;
{
Auteur: Patrick Pr‚martin.
Date: 21/03/1993.
Langage: Turbo Pascal 6.0
But: Permettre de simplifier la programmation de certaines taches r‚p‚titives
     dans les jeux r‚alis‚s en VGA.
}

interface
function saisie_texte (len : byte; nom_jeu, sous_titre, texte : string) : string;

implementation
uses
    u_mouse,
    u_int10h,
    u_vga_graph,
    u_code_clavier,
    crt;

var
   pal : t_tab_rvb;

procedure add_char (c : char; len : byte; var i : word; var ch : string);
var
   j : word;
begin
  if (i < len)
  then
    begin
      ch := ch + c;
      inc (i);
      textattr := 256-i;
      j := succ ((40-len) div 2) + i;
      gotoxy (j, 14);
      writeln (c);
      remplace_couleur (j*8-8, 14*8-8, j*8-1, 14*8-1, 0, 128-i);
    end;
  {endif}
end; { add_char }

procedure rmv_char (len : byte; var i : word; var ch : string);
var
   j : word;
begin
  if (i > 0)
  then
    begin
      textattr := 256-i;
      j := succ ((40-len) div 2) + i;
      gotoxy (j, 14);
      write ('.');
      remplace_couleur (j*8-8, 14*8-8, j*8-1, 14*8-1, 0, 128-i);
      dec (i);
      ch := copy (ch, 1, i);
    end;
  {endif}
end; { rmv_char }

function saisie_texte (len : byte; nom_jeu, sous_titre, texte : string) : string;
var
   ch : string;
   x, y, k : integer;
   i, j : word;
   c : char;
   om : boolean;
begin
  om := mouse_curs;
  hide_mouse;
  ch := '';
  if (len > 40)
  then
    len := 40;
  {endif}
  nom_jeu := copy (nom_jeu, 1, 40);
  sous_titre := copy (sous_titre, 1, 40);
  texte := copy (texte, 1, 40);

{ Mode VGA couleur }
  directvideo := false;
  repeat
  until (set_mode(19) or true);

{ Palette de couleurs }
  for i := 0 to 63 do
    begin
      { D‚grad‚s de gris }
      pal [i].v := i; pal [i].b := i; pal [i].r := i;
      { D‚grad‚s de rouges }
      pal [64+i].v := 0; pal [64+i].b := 0; pal [64+i].r := i;
      { D‚grad‚s de verts}
      pal [128+i].v := i; pal [128+i].b := 0; pal [128+i].r := 0;
      { D‚grad‚s de bleus }
      pal [192+i].v := 0; pal [192+i].b := i; pal [192+i].r := 0;
    end;
  {endfor}
  set_blk_cna_reg (0, 256, pal);

{ Dessin de l'‚cran }
  textattr := 63;
  gotoxy (1+(40-length (nom_jeu)) div 2, 1);
  write (nom_jeu);
  textattr := 127;
  gotoxy (1+(40-length (sous_titre)) div 2, 2);
  write (sous_titre);
  textattr := 191;
  gotoxy (1+(40-length (texte)) div 2, 12);
  write (texte);
  textattr := 127;
  gotoxy (8, 5);
  write ('A B C D E F G H I J K L M');
  gotoxy (8, 7);
  write ('N O P Q R S T U V W X Y Z');
  gotoxy (8, 9);
  write ('0 1 2 3 4 5 6 7 8 9   '#27' '#29);
  i := 8*8-11;
  j := 5*8-11;
  k := 0;
  repeat
    remplace_couleur (i, j, i+12, j+12, 0, 63-k);
    inc (k);
    inc (i, 16);
    if ((k = 13) or (k = 26))
    then
      begin
        i := 8*8-11;
        inc (j, 16);
      end;
    {endif}
  until (k = 39);

  i := 0;
  j := 321;
  repeat
    if ((mem [$a000:j] > 0) and (mem [$a000:i] = 0))
    then
      mem [$a000:i] := mem [$a000:j]-10;
    {endif}
    inc (i);
    inc (j);
  until (j >= 319+199*320);

  i := len;
  repeat
    rmv_char (len, i, ch);
  until (i = 0);

{ Traitement des entr‚es (clavier et souris }
  i := 0;
  show_mouse;
  repeat
    c := carac_nul;
    repeat
      mouse_x_y_k (x, y, k);
      x := x div 2;
      if ((k > 0) and (y > 29) and (y < 61+13) and (x > 52) and (x < 261+13))
      then
        begin
          dec (x, 53);
          dec (y, 29);
          j := x div 16 + (y div 16) * 13;
          case j of
            0..25 : c := chr (ord ('A')+j);
            26..35 : c := chr (ord ('0')+j-26);
            36 : c := ' ';
            37 : c := touche_backspace;
            38 : c := touche_return;
          end;
          repeat
          until (mousek = 0);
        end
      else
        if (keypressed)
        then
          c := readkey;
        {endif}
      {endif}
    until (c <> carac_nul);
    case c of
      ' ',
      '0'..'9',
      'A'..'Z' : add_char (c, len, i, ch);
      'a'..'z' : add_char (upcase (c), len, i, ch);
      touche_backspace : rmv_char (len, i, ch);
      touche_escape :
        repeat
          rmv_char (len, i, ch);
        until (i = 0);
    end;
  until (c = touche_return);
  if not om
  then
    hide_mouse;
  {endif}
  saisie_texte := ch;
end; { saisie_texte }

end.
