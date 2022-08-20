unit u_vga_graph;
{
Auteur: Patrick Pr‚martin.
Date: 10/08/1992. 11/08/1992. 12/08/1992.
Langage: Turbo Pascal 6.0
But: Routines permettant de g‚rer divers objets et dessins habituels pour une
     interface graphique. Ne doit ˆtre utilis‚e qu'en mode VGA (19).
}
interface
uses
    u_m_zone;

type
    t_sens_fleche = (gauche, droite, haut, bas);

procedure pset (x, y : word; c : byte);
  { Met un point aux coordonn‚es (X,Y) de la couleur C. }

procedure remplace_couleur (x1, y1, x2, y2 : word; old_c, new_c : byte);
  { Remplace la couleur OLD_C par la couleur NEW_C dans le cadre d‚fini. }

procedure line (x1, y1, x2, y2 : word; c : byte);
  { Dessine un trait (horizontal ou vertical de couleur C entre les points
    (X1,Y1) et (X2,Y2). }

procedure box (x1, y1, x2, y2 : word; c : byte);
  { Dessine un cadre de couleur C. }

procedure boxf (x1, y1, x2, y2 : word; c : byte);
  { Dessine un cadre plein de couleur C. }

procedure dessin_fleche (x, y, lx, ly : word; coul_fleche, coul_fond : byte;
                         sens : t_sens_fleche);
  { Fait le dessin d'une flŠche de couleur COUL_FLECHE sur fond COUL_FOND. }

procedure dessin_fleche_zone (x, y, lx, ly : word;coul_fleche, coul_fond : byte;
                              sens : t_sens_fleche; zone : p_m_zone;
                              code_nul : boolean; code_carac : char);
  { Fait le dessin d'une flŠche de couleur COUL_FLECHE sur fond COUL_FOND et
    rajoute la zone correspondante … la liste ZONE. }

procedure dessin_cadre (x1, y1, x2, y2 : word; coul_gauche, coul_bas,
                        coul_fond, new_coul_fond : byte);
  { Dessine un cadre /ÛÛÛÛ
                     /___/ }

implementation
procedure pset (x, y : word; c : byte);
begin
  if ((x >= 0) and (y >= 0) and (x < 320) and (y < 200))
  then
    {$r-}
    mem [$a000:x+y*320] := c;
    {$r+}
  {endif}
end; { pset }

procedure remplace_couleur (x1, y1, x2, y2 : word; old_c, new_c : byte);
var
   i,
   j : word;
begin
  if (y1 > y2)
  then
    begin
      i := y1;
      y1 := y2;
      y2 := i;
    end;
  {endif}
  if (x1 > x2)
  then
    begin
      i := x1;
      x1 := x2;
      x2 := i;
    end;
  {endif}
  if (x2 > 319)
  then
    x2 := 319;
  {endif}
  if (y2 > 199)
  then
    y2 := 199;
  {endif}
  {$r-}
  for i := x1 to x2 do
    for j := y1 to y2 do
      if (mem [$a000:i+j*320] = old_c)
      then
        mem [$a000:i+j*320] := new_c;
      {endif}
    {endfor}
  {endfor}
  {$r+}
end; { remplace_couleur }

procedure line (x1, y1, x2, y2 : word; c : byte);
begin
  repeat
    pset (x1, y1, c);
    if (x1 < x2)
    then
      inc (x1)
    else
      if (x1 > x2)
      then
        dec (x1);
      {endif}
    {endif}
    if (y1 < y2)
    then
      inc (y1)
    else
      if (y1 > y2)
      then
        dec (y1);
      {endif}
    {endif}
    pset (x2, y2, c);
    if (x2 < x1)
    then
      inc (x2)
    else
      if (x2 > x1)
      then
        dec (x2);
      {endif}
    {endif}
    if (y2 < y1)
    then
      inc (y2)
    else
      if (y2 > y1)
      then
        dec (y2);
      {endif}
    {endif}
  until ((x1 = x2) and (y1 = y2));
  pset (x2, y2, c);
end; { line }

procedure box (x1, y1, x2, y2 : word; c : byte);
begin
  line (x1, y1, x1, y2, c);
  line (x1, y2, x2, y2, c);
  line (x2, y2, x2, y1, c);
  line (x2, y1, x1, y1, c);
end; { box }

procedure boxf (x1, y1, x2, y2 : word; c : byte);
var
   i : word;
begin
  if (y1 > y2)
  then
    begin
     i := y1;
     y1 := y2;
     y2 := i;
    end;
  {endif}
  for i := y1 to y2 do
    line (x1, i, x2, i, c);
  {endfor}
end; { boxf }

procedure dessin_fleche (x, y, lx, ly : word; coul_fleche, coul_fond : byte;
                         sens : t_sens_fleche);
var
   i,
   mx, my,
   rx, ry : word;
begin
  x := pred (x) * 8;
  y := pred (y) * 8;
  lx := lx * 8;
  ly := ly * 8;
  boxf (x, y, pred (x+lx), pred (y+ly), coul_fond);
  inc (x);
  inc (y);
  dec (lx, 2);
  dec (ly, 2);
  rx := lx div (ly*2);
  if (rx = 0)
  then
    rx := 1;
  {endif}
  ry := ly div (lx*2);
  if (ry = 0)
  then
    ry := 1;
  {endif}
  mx := x+lx div 2;
  my := y+ly div 2;
  case sens of
    haut :
      for i := 0 to ly-2 do
        line (mx-i*rx, y+i, mx+i*rx, y+i, coul_fleche);
      {endfor}
    bas :
      for i := 0 to ly-2 do
        line (mx-i*rx, pred (y+ly)-i, mx+i*rx, pred (y+ly)-i, coul_fleche);
      {endfor}
    gauche :
      for i := 0 to lx-2 do
        line (x+i, my-i*ry, x+i, my+i*ry, coul_fleche);
      {endfor}
    droite :
      for i := 0 to lx-2 do
        line (pred (x+lx)-i, my-i*ry, pred (x+lx)-i, my+i*ry, coul_fleche);
      {endfor}
  end;
end; { dessin_fleche }

procedure dessin_fleche_zone (x, y, lx, ly : word; coul_fleche, coul_fond : byte;
                              sens : t_sens_fleche; zone : p_m_zone;
                              code_nul : boolean; code_carac : char);
begin
  if (zone <> nil)
  then
    zone^.add_zone3 (x, y, lx, ly, code_nul, code_carac);
  {endif}
  dessin_fleche (x, y, lx, ly, coul_fleche, coul_fond, sens);
end; { dessin_fleche }

procedure dessin_cadre (x1, y1, x2, y2 : word; coul_gauche, coul_bas,
                        coul_fond, new_coul_fond : byte);
var
   i : byte;
begin
  x1 := pred (x1) * 8;
  y1 := pred (y1) * 8;
  x2 := pred (x2) * 8;
  y2 := pred (y2) * 8;
  for i := 0 to 4 do
    begin
      line (x1+7-i, y1+i, x1+7-i, y2+i, coul_gauche);
      line (x1+7-i, y2+i, x2+7-i, y2+i, coul_bas);
    end;
  {endfor}
  remplace_couleur (x1+8, y1, x2+7, pred (y2), coul_fond, new_coul_fond);
end; { dessin_cadre }

end.
