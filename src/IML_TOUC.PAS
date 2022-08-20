unit iml_touche;
{
Auteur: Patrick Pr‚martin.
Date: 16/09/1992.
Langage: Turbo Pascal 6.0

But: Morceau de l'Interface Multi-Langues (IML) de Olf SOftware.
}
interface
uses
    iml_var,
    iml_constante;

type
    p_zone_touche = ^o_zone_touche;
    o_zone_touche =
      object (o_constante)
        cn : boolean; { Code Nul ? }
        cc : char;    { Code CaractŠre }
        effet : word; { Code retour de la zone. }
        constructor init (icn : boolean; icc : char; ieffet : word;
                          it : string; ict, icf, ix, iy, ilx : byte);
        constructor load (var f : file);
        destructor done;
        procedure save (var f : file);
        procedure display; virtual;
        function test_clavier (tcn : boolean; tcc : char) : word; virtual;
        function test_souris (mx, my : word) : word; virtual;
      end;

    p_zone_touche_iml = ^o_zone_touche_iml;
    o_zone_touche_iml =
      object (o_constante_iml)
        cn : boolean; { Code Nul ? }
        cc : char;    { Code CaractŠre }
        effet : word; { Code retour de la zone. }
        constructor init (icn : boolean; icc : char; ieffet : word;
                          i_n : longint; ict, icf, ix, iy, ilx : byte);
        constructor load (var f : file);
        destructor done;
        procedure save (var f : file);
        procedure display; virtual;
        function test_clavier (tcn : boolean; tcc : char) : word; virtual;
        function test_souris (mx, my : word) : word; virtual;
      end;

implementation
constructor o_zone_touche.init (icn : boolean; icc : char; ieffet : word;
                  it : string; ict, icf, ix, iy, ilx : byte);
begin
  cn := icn;
  cc := icc;
  effet := ieffet;
  o_constante.init (it, ict, icf, ix, iy, ilx);
end; { init }

constructor o_zone_touche.load (var f : file);
begin
  blockread (f, cn, sizeof (cn));
  blockread (f, cc, sizeof (cc));
  blockread (f, effet, sizeof (effet));
  o_constante.load (f);
end; { load }

destructor o_zone_touche.done;
begin
  o_constante.done;
end; { done }

procedure o_zone_touche.save (var f : file);
begin
  blockwrite (f, cn, sizeof (cn));
  blockwrite (f, cc, sizeof (cc));
  blockwrite (f, effet, sizeof (effet));
  o_constante.save (f);
end; { save }

procedure o_zone_touche.display;
begin
  o_constante.display;
end; { display }

function o_zone_touche.test_clavier (tcn : boolean; tcc : char) : word;
begin
  if ((tcn = cn) and (tcc = cc))
  then
    test_clavier := effet
  else
    test_clavier := c_no_effect;
  {endif}
end; { test_clavier }

function o_zone_touche.test_souris (mx, my : word) : word;
begin
  if ((mx >= x) and (mx < x+lx) and (my = y))
  then
    test_souris := effet
  else
    test_souris := c_no_effect;
  {endif}
end; { test_souris }

constructor o_zone_touche_iml.init (icn : boolean; icc : char; ieffet : word;
                  i_n : longint; ict, icf, ix, iy, ilx : byte);
begin
  cn := icn;
  cc := icc;
  effet := ieffet;
  o_constante_iml.init (i_n, ict, icf, ix, iy, ilx);
end; { init }

constructor o_zone_touche_iml.load (var f : file);
begin
  blockread (f, cn, sizeof (cn));
  blockread (f, cc, sizeof (cc));
  blockread (f, effet, sizeof (effet));
  o_constante_iml.load (f);
end; { load }

destructor o_zone_touche_iml.done;
begin
  o_constante_iml.done;
end; { done }

procedure o_zone_touche_iml.save (var f : file);
begin
  blockwrite (f, cn, sizeof (cn));
  blockwrite (f, cc, sizeof (cc));
  blockwrite (f, effet, sizeof (effet));
  o_constante_iml.save (f);
end; { save }

procedure o_zone_touche_iml.display;
begin
  o_constante_iml.display;
end; { display }

function o_zone_touche_iml.test_clavier (tcn : boolean; tcc : char) : word;
begin
  if ((tcn = cn) and (tcc = cc))
  then
    test_clavier := effet
  else
    test_clavier := c_no_effect;
  {endif}
end; { test_clavier }

function o_zone_touche_iml.test_souris (mx, my : word) : word;
begin
  if ((mx >= x) and (mx < x+lx) and (my = y))
  then
    test_souris := effet
  else
    test_souris := c_no_effect;
  {endif}
end; { test_souris }

end.
