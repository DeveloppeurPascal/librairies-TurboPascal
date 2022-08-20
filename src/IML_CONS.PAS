unit iml_constante;
{
Auteur: Patrick Pr‚martin.
Date: 16/09/1992.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
type
    p_constante = ^o_constante;
    o_constante =
      object
        t : string;      { Chaine de caractŠres … afficher. }
        ct, cf,          { Couleurs du texte (ct) et du fond (cf). }
        x, y, lx : byte; { Coordonn‚es (x, y) et largeur (lx) de l'affichage }
        constructor init (it : string; ict, icf, ix, iy, ilx : byte);
        constructor load (var f : file);
        destructor done;
        procedure save (var f : file);
        procedure display; virtual;
      end;

    p_constante_iml = ^o_constante_iml;
    o_constante_iml =
      object
        n : longint;     { Num‚ro du texte dans le fichier de messages .MSG }
        ct, cf,          { Couleurs du texte (ct) et du fond (cf). }
        x, y, lx : byte; { Coordonn‚es (x, y) et largeur (lx) de l'affichage }
        constructor init (i_n : longint; ict, icf, ix, iy, ilx : byte);
        constructor load (var f : file);
        destructor done;
        procedure save (var f : file);
        procedure display; virtual;
      end;

implementation
uses
    crt,
    u_msg;

constructor o_constante.init (it : string; ict, icf, ix, iy, ilx : byte);
begin
  ct := ict;
  cf := icf;
  x := ix;
  y := iy;
  lx := ilx;
  t := copy (it, 1, lx);
end; { init }

constructor o_constante.load (var f : file);
begin
  blockread (f, t [0], 1);
  if (length (t) > 0)
  then
    blockread (f, t [1], length (t));
  {endif}
  blockread (f, ct, sizeof (ct));
  blockread (f, cf, sizeof (cf));
  blockread (f, x, sizeof (x));
  blockread (f, y, sizeof (y));
  blockread (f, lx, sizeof (lx));
end; { load }

destructor o_constante.done;
begin
end; { done }

procedure o_constante.save (var f : file);
begin
  blockwrite (f, t [0], succ (length (t)));
  blockwrite (f, ct, sizeof (ct));
  blockwrite (f, cf, sizeof (cf));
  blockwrite (f, x, sizeof (x));
  blockwrite (f, y, sizeof (y));
  blockwrite (f, lx, sizeof (lx));
end; { save }

procedure o_constante.display;
begin
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (t);
end; { display }

constructor o_constante_iml.init (i_n : longint; ict, icf, ix, iy, ilx : byte);
begin
  ct := ict;
  cf := icf;
  x := ix;
  y := iy;
  lx := ilx;
  n := i_n;
end; { init }

constructor o_constante_iml.load (var f : file);
begin
  blockread (f, n, sizeof (n));
  blockread (f, ct, sizeof (ct));
  blockread (f, cf, sizeof (cf));
  blockread (f, x, sizeof (x));
  blockread (f, y, sizeof (y));
  blockread (f, lx, sizeof (lx));
end; { load }

destructor o_constante_iml.done;
begin
end; { done }

procedure o_constante_iml.save (var f : file);
begin
  blockwrite (f, n, sizeof (n));
  blockwrite (f, ct, sizeof (ct));
  blockwrite (f, cf, sizeof (cf));
  blockwrite (f, x, sizeof (x));
  blockwrite (f, y, sizeof (y));
  blockwrite (f, lx, sizeof (lx));
end; { save }

procedure o_constante_iml.display;
begin
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (get_msg (n));
end; { display }

end.
