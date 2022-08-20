unit u_icn;
{
Auteur: Patrick Pr‚martin.
Date: 05/08/1992. 10/08/1992. 11/08/1992.
Langage: turbo Pascal 6.0
But: Gestion des icones (fichiers .ICN) cr‚‚es par 'Icon Maker' de Olf Software.

Note: Les coordonn‚es X et Y sont celles du coin haut-gauche du cadre de 24*24
      dans lequel seront affich‚es les icones.
}

interface
const
     icn_header = #8'Icon Maker'#10#13'(c) Olf Software'#10#13#26#0;

type
    t_lig_icn = array [0..7] of byte; { Ligne d'une icone. }
    t_form_icn = array [0..15] of t_lig_icn; { Forme d'une icone. }

    p_icn = ^o_icn;
    o_icn =
      object
        forme : t_form_icn;
        coul_fond,
        coul_gauche,
        coul_bas : byte;

        constructor init (cf, cg, cb : byte);
        destructor done;
        constructor load (nom : string; cf, cg, cb : byte);
        procedure save (nom : string);
        procedure put (x, y : word);
          { Affiche seulement la forme de l'icone. }
        procedure aff_sortie (x, y : word);
          { Affichage normal: /ÛÛ
                              ÝÛÛ
                              /Ü/ }
        procedure aff_enfonce (x, y : word);
          { Affichage lors d'un clic: °°°
                                      ÛÛ°
                                      ÛÛ° }
      end;

var
   decal_couleur : byte;

implementation
uses
    u_int10h,
    u_sgf;

procedure line (x1, y1, x2, y2 : word; c : byte);
begin
  while ((x1 <> x2) or (y1 <> y2)) do
    begin
      put_pixel (0, c, x1, y1);
      if (x1 < x2)
      then
        inc (x1)
      else
        if (x1 > x2)
        then
          dec (x2);
        {endif}
      {endif}
      if (y1 < y2)
      then
        inc (y1)
      else
        if (y1 > y2)
        then
          dec (y2);
        {endif}
      {endif}
    end;
  {endwhile}
end; { line }

constructor o_icn.init (cf, cg, cb : byte);
var
   i, j : byte;
begin
  for j := 0 to 15 do
    for i := 0 to 7 do
      forme [j] [i] := 255;
    {endfor}
  {endfor}
  coul_fond := cf;
  coul_gauche := cg;
  coul_bas := cb;
end; { o_icn.init }

destructor o_icn.done;
begin
end; { o_icn.done }

constructor o_icn.load (nom : string; cf, cg, cb : byte);
var
   f : file;
   ch : string;
   i,
   j : byte;
begin
  met_extension (nom, 'ICN', nom);
  assign (f, nom);
  {$i-}
  reset (f, 1);
  {$i+}
  if (ioresult = 0)
  then
    begin
      blockread (f, ch [0], sizeof (char));
      blockread (f, ch [1], ord (ch [0]));
      blockread (f, forme, sizeof (forme));
      close (f);
    end
  else
    for j := 0 to 15 do
      for i := 0 to 7 do
        forme [j] [i] := 255;
      {endfor}
    {endfor}
  {endif}
  coul_fond := cf;
  coul_gauche := cg;
  coul_bas := cb;
end; { o_icn.load }

procedure o_icn.save (nom : string);
var
   f : file;
   ch : string;
begin
  met_extension (nom, 'ICN', nom);
  assign (f, nom);
  {$i-}
  rewrite (f, 1);
  {$i+}
  if (ioresult = 0)
  then
    begin
      ch := icn_header;
      blockwrite (f, ch, succ (length (ch)));
      blockwrite (f, forme, sizeof (forme));
      close (f);
    end;
  {endif}
end; { o_icn.save}

procedure o_icn.put (x, y : word);
var
   i, j : byte;
begin
  for j := 0 to 15 do
    for i := 0 to 7 do
      begin
        put_pixel (0, decal_couleur+((forme [j][i] and $f0) shr 4), x+i*2, y+j);
        put_pixel (0, decal_couleur+(forme [j][i] and $f), x+i*2+1, y+j);
      end;
    {endfor}
  {endfor}
end; { o_icn.put }

procedure o_icn.aff_sortie (x, y : word);
var
   i : byte;
begin
  for i := 0 to 23 do
    line (x, y+i, x+23, y+i, coul_fond);
  {endfor}
  for i := 0 to 3 do
    begin
      line (x+4+i, y+3-i, x+4+i, y+19-i, coul_gauche); { Barre … gauche. }
      line (x+4+i, y+19-i, x+20+i, y+19-i, coul_bas); { Barre en bas. }
    end;
  {endfor}
  put (x+7, y);
end; { o_icn.aff_sortie }

procedure o_icn.aff_enfonce (x, y : word);
var
   i : byte;
begin
  for i := 0 to 23 do
    line (x, y+i, x+23, y+i, coul_fond);
  {endfor}
  put (x+4, y+4);
end; { o_icn.aff_enfonce }

begin
     decal_couleur := 0;
end.
