unit u_ico;
{
Auteur: Patrick Pr‚martin
Date: 06/08/1992.
Langage: Turbo Pascal 6.0
But: Gestion des icones (fichiers ICO) de 'Icon Maker'.
}
interface

type
    p_ico = ^o_ico;
    o_ico =
      object
        lx, ly : integer;
        forme : pointer;

        constructor init;
        constructor load (nom : string);
        destructor done;
        procedure save (nom : string);
        procedure put (x, y : word);
      end;

implementation
uses
    u_sgf,
    u_int10h;

constructor o_ico.init;
begin
  lx := 0;
  ly := 0;
  forme := nil;
end; { o_ico.init }

constructor o_ico.load (nom : string);
var
   f : file;
begin
  met_extension (nom, 'ICO', nom);
  assign (f, nom);
  {$i-}
  reset (f, 1);
  {$i+}
  if (ioresult = 0)
  then
    begin
      blockread (f, lx, sizeof (lx));
      blockread (f, ly, sizeof (ly));
      getmem (forme, succ (lx)*succ (ly));
      if (forme <> nil)
      then
        blockread (f, forme^, succ (lx)*succ (ly));
      {endif}
      close (f);
    end;
  {endif}
end; { o_ico.load }

destructor o_ico.done;
begin
  if (forme <> nil)
  then
    freemem (forme, succ (lx)*succ (ly));
  {endif}
end; { o_ico.done }

procedure o_ico.save (nom : string);
var
   f : file;
begin
  if (forme <> nil)
  then
    begin
      met_extension (nom, 'ICO', nom);
      assign (f, nom);
      {$i-}
      rewrite (f, 1);
      {$i+}
      if (ioresult = 0)
      then
        begin
          blockwrite (f, lx, sizeof (lx));
          blockwrite (f, ly, sizeof (ly));
          blockwrite (f, forme^, succ (lx)*succ (ly));
          close (f);
        end;
      {endif}
    end;
  {endif}
end; { o_ico.save }

procedure o_ico.put (x, y : word);
var
   i, j : word;
begin
  if (forme <> nil)
  then
    for j := 0 to ly do
      for i := 0 to lx do
        {$r-}
        put_pixel (0, mem [seg (forme^) : ofs (forme^)+i+j*lx], x+i, y+j);
        {$r+}
      {endfor}
    {endfor}
  {endif}
end; { o_ico.put }

end.
