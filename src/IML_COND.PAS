unit iml_condition;
{
Auteur: Patrick Pr‚martin.
Date: 23/01/1993.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    u_msg,
    iml_var,
    iml_zone;

type
  p_condition = ^o_condition;
  o_condition =
    object
      n : p_condition; { Condition suivante }
      c : char; { Abr‚g‚ de la condition }
      t : string; { Libell‚ de la condition }

      constructor init (ic : char; it : string; i_n : p_condition);
      constructor load (var f : file);
      destructor done;
      procedure save (var f : file);
      function test_condition (cond : char) : boolean;
      function get_texte (cond : char) : string;
      function pred (cond : char) : char;
      function succ (cond : char) : char;
    end;

  p_zone_condition = ^o_zone_condition;
  o_zone_condition =
    object (o_zone)
      lst_condition : p_condition;
      top_libelle : boolean;
      ctl, cfl, xl, yl, lxl : byte;
      c : char;

      constructor init (itop : boolean; ictl, icfl, ixl, iyl, ilxl : byte;
                        its : t_typ_saisie; ict, icf, ix, iy : byte;
                        ihelpctx : word);
      constructor load (var f : file);
      destructor done;
      procedure save (var f : file);
      procedure setdata (var r); virtual;
      procedure getdata (var r); virtual;
      function datasize : word; virtual;
      procedure display; virtual;
      procedure run (var event : t_event); virtual;
      function valid : boolean; virtual;
    end;

  p_condition_iml = ^o_condition_iml;
  o_condition_iml =
    object
      n : p_condition_iml; { Condition suivante }
      num_c : longint; { Abr‚g‚ de la condition }
      num_t : longint; { Libell‚ de la condition }

      constructor init (inum_c, inum_t : longint; i_n : p_condition_iml);
      constructor load (var f : file);
      destructor done;
      procedure save (var f : file);
      function test_condition (cond : string) : boolean;
      function get_texte (cond : string) : string;
      function pred (cond : string) : string;
      function succ (cond : string) : string;
    end;

  p_zone_condition_iml = ^o_zone_condition_iml;
  o_zone_condition_iml =
    object (o_zone)
      lst_condition : p_condition_iml;
      top_libelle : boolean;
      ctl, cfl, xl, yl, lxl : byte;
      c : string;

      constructor init (itop : boolean; ictl, icfl, ixl, iyl, ilxl : byte;
                        its : t_typ_saisie; ict, icf, ix, iy : byte;
                        ihelpctx : word);
      constructor load (var f : file);
      destructor done;
      procedure save (var f : file);
      procedure setdata (var r); virtual;
      procedure getdata (var r); virtual;
      function datasize : word; virtual;
      procedure display; virtual;
      procedure run (var event : t_event); virtual;
      function valid : boolean; virtual;
    end;

implementation
uses
    crt,
    u_chaine,
    u_code_clavier;

{******************************************************************************}

constructor o_condition.init (ic : char; it : string; i_n : p_condition);
begin
  c := ic;
  t := it;
  n := i_n;
end; { init }

constructor o_condition.load (var f : file);
begin
  blockread (f, c, sizeof (c));
  blockread (f, t [0], sizeof (t [0]));
  blockread (f, t [1], length (t));
  blockread (f, n, sizeof (n));
  if (n <> nil)
  then
    n := new (p_condition, load (f));
  {endif}
end; { load }

destructor o_condition.done;
begin
  if (n <> nil)
  then
    dispose (n, done);
  {endif}
  n := nil;
end; { done }

procedure o_condition.save (var f : file);
begin
  blockwrite (f, c, sizeof (c));
  blockwrite (f, t [0], length (t)+1);
  blockwrite (f, n, sizeof (n));
  if (n <> nil)
  then
    n^.save (f);
  {endif}
end; { save }

function o_condition.test_condition (cond : char) : boolean;
begin
  if (c = cond)
  then
    test_condition := true
  else
    if (n = nil)
    then
      test_condition := false
    else
      test_condition := n^.test_condition (cond);
    {endif}
  {endif}
end; { test_condition }

function o_condition.get_texte (cond : char) : string;
begin
  if (c = cond)
  then
    get_texte := t
  else
    if (n = nil)
    then
      get_texte := ''
    else
      get_texte := n^.get_texte (cond);
    {endif}
  {endif}
end; { get_texte}

function o_condition.pred (cond : char) : char;
begin
  if (cond = ' ')
  then
    pred := ' '
  else
    if (n^.c = cond)
    then
      pred := c
    else
      pred := n^.pred (cond);
    {endif}
  {endif}
end; { pred }

function o_condition.succ (cond : char) : char;
begin
  if (cond = ' ')
  then
    succ := ' '
  else
    if (c = cond)
    then
      if (n <> nil)
      then
        succ := n^.c
      else
        succ := c
      {endif}
    else
      succ := n^.succ (cond);
    {endif}
  {endif}
end; { succ }

{******************************************************************************}

constructor o_zone_condition.init (itop : boolean; ictl, icfl, ixl, iyl, ilxl :
                                   byte; its : t_typ_saisie; ict, icf, ix, iy :
                                   byte; ihelpctx : word);
begin
  top_libelle := itop;
  lxl := ilxl;
  ctl := ictl;
  cfl := icfl;
  xl := ixl;
  yl := iyl;
  lst_condition := nil;
  o_zone.init (ict, icf, ix, iy, 1, ihelpctx, its);
end; { init }

constructor o_zone_condition.load (var f : file);
var
   cond : o_condition;
begin
  o_zone.load (f);
  blockread (f, top_libelle, sizeof (top_libelle));
  blockread (f, lxl, sizeof (lxl));
  blockread (f, cfl, sizeof (cfl));
  blockread (f, ctl, sizeof (ctl));
  blockread (f, xl, sizeof (xl));
  blockread (f, yl, sizeof (yl));
  blockread (f, lst_condition, sizeof (lst_condition));
  if (lst_condition <> nil)
  then
    lst_condition := new (p_condition, load (f));
  {endif}
end; { load }

destructor o_zone_condition.done;
begin
  if (lst_condition <> nil)
  then
    dispose (lst_condition, done);
  {endif}
  o_zone.done;
end; { done }

procedure o_zone_condition.save (var f : file);
begin
  o_zone.save (f);
  blockwrite (f, top_libelle, sizeof (top_libelle));
  blockwrite (f, lxl, sizeof (lxl));
  blockwrite (f, cfl, sizeof (cfl));
  blockwrite (f, ctl, sizeof (ctl));
  blockwrite (f, xl, sizeof (xl));
  blockwrite (f, yl, sizeof (yl));
  blockwrite (f, lst_condition, sizeof (lst_condition));
  if (lst_condition <> nil)
  then
    lst_condition^.save (f);
  {endif}
end; { save }

procedure o_zone_condition.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, c, datasize);
      if ((lst_condition <> nil) and (not lst_condition^.test_condition (c)))
      then
        c := ' ';
      {endif}
    end
  else
    c := ' ';
  {endif}
end; { setdata }

procedure o_zone_condition.getdata (var r);
begin
  move (c, r, datasize);
end; { getdata }

function o_zone_condition.datasize : word;
begin
  datasize := sizeof (c);
end; { datasize }

procedure o_zone_condition.display;
var
   ot : byte;
begin
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (c);
  if ((top_libelle) and (lst_condition <> nil))
  then
    begin
      gotoxy (xl, yl);
      textcolor (ctl);
      textbackground (cfl);
      write (copy (copy (lst_condition^.get_texte (c), 1, lxl)+
                   trait (' ', lxl), 1, lxl));
    end;
  {endif}
  textattr := ot;
end; { display }

procedure o_zone_condition.run (var event : t_event);
var
   b : boolean;
begin
  if (cx < 1)
  then
    b := move_cursor (1-cx);
  {endif}
  o_zone.run (event);
  if (event.typ = c_ev_clavier)
  then
    case event.code_nul of
      true :
        case event.code_carac of
          touche_home :
            begin
              b := move_cursor (-cx+1);
              event.typ := c_ev_rien;
            end;
          touche_end :
            begin
              b := move_cursor (lx);
              event.typ := c_ev_rien;
            end;
          touche_gauche :
            begin
              b := move_cursor (-1);
              event.typ := c_ev_rien;
            end;
          touche_droite :
            begin
              b := move_cursor (1);
              event.typ := c_ev_rien;
            end;
          touche_del :
            begin
              c := ' ';
              display;
              event.typ := c_ev_rien;
            end;
          touche_page_up :
            begin
              if (lst_condition <> nil)
              then
                c := lst_condition^.pred (c);
              {endif}
              display;
            end;
          touche_page_dn :
            begin
              if (lst_condition <> nil)
              then
                c := lst_condition^.succ (c);
              {endif}
              display;
            end;
        end;
      false :
        case event.code_carac of
          '0'..'9', 'A'..'Z', 'a'..'z' :
            begin
              if ((lst_condition <> nil) and (lst_condition^.test_condition
                 (upcase (event.code_carac))))
              then
                begin
                  c := upcase (event.code_carac);
                  display;
                end
              else
                clochette;
              {endif}
              event.typ := c_ev_rien;
            end;
          ' ' :
            begin
              c := ' ';
              display;
            end;
        end;
    end;
  {endif}
end; { run }

function o_zone_condition.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

{******************************************************************************}

constructor o_condition_iml.init (inum_c, inum_t : longint;
                                  i_n : p_condition_iml);
begin
  num_c := inum_c;
  num_t := inum_t;
  n := i_n;
end; { init }

constructor o_condition_iml.load (var f : file);
begin
  blockread (f, num_c, sizeof (num_c));
  blockread (f, num_t, sizeof(num_t));
  blockread (f, n, sizeof (n));
  if (n <> nil)
  then
    n := new (p_condition_iml, load (f));
  {endif}
end; { load }

destructor o_condition_iml.done;
begin
  if (n <> nil)
  then
    dispose (n, done);
  {endif}
  n := nil;
end; { done }

procedure o_condition_iml.save (var f : file);
begin
  blockwrite (f, num_c, sizeof (num_c));
  blockwrite (f, num_t, sizeof (num_t));
  blockwrite (f, n, sizeof (n));
  if (n <> nil)
  then
    n^.save (f);
  {endif}
end; { save }

function o_condition_iml.test_condition (cond : string) : boolean;
begin
  if (get_msg (num_c) = cond)
  then
    test_condition := true
  else
    if (n = nil)
    then
      test_condition := false
    else
      test_condition := n^.test_condition (cond);
    {endif}
  {endif}
end; { test_condition }

function o_condition_iml.get_texte (cond : string) : string;
begin
  if (get_msg (num_c) = cond)
  then
    get_texte := get_msg (num_t)
  else
    if (n = nil)
    then
      get_texte := ''
    else
      get_texte := n^.get_texte (cond);
    {endif}
  {endif}
end; { get_texte}

function o_condition_iml.pred (cond : string) : string;
begin
  if (cond = ' ')
  then
    pred := ' '
  else
    if (get_msg (n^.num_c) = cond)
    then
      pred := get_msg (num_c)
    else
      pred := n^.pred (cond);
    {endif}
  {endif}
end; { pred }

function o_condition_iml.succ (cond : string) : string;
begin
  if (cond = ' ')
  then
    succ := ' '
  else
    if (get_msg (num_c) = cond)
    then
      if (n <> nil)
      then
        succ := get_msg (n^.num_c)
      else
        succ := get_msg (num_c)
      {endif}
    else
      succ := n^.succ (cond);
    {endif}
  {endif}
end; { succ }

{******************************************************************************}

constructor o_zone_condition_iml.init (itop : boolean; ictl, icfl, ixl, iyl,
                                       ilxl : byte; its : t_typ_saisie; ict,
                                       icf, ix, iy : byte; ihelpctx : word);
begin
  top_libelle := itop;
  lxl := ilxl;
  ctl := ictl;
  cfl := icfl;
  xl := ixl;
  yl := iyl;
  lst_condition := nil;
  o_zone.init (ict, icf, ix, iy, 1, ihelpctx, its);
end; { init }

constructor o_zone_condition_iml.load (var f : file);
var
   cond : o_condition_iml;
begin
  o_zone.load (f);
  blockread (f, top_libelle, sizeof (top_libelle));
  blockread (f, lxl, sizeof (lxl));
  blockread (f, cfl, sizeof (cfl));
  blockread (f, ctl, sizeof (ctl));
  blockread (f, xl, sizeof (xl));
  blockread (f, yl, sizeof (yl));
  blockread (f, lst_condition, sizeof (lst_condition));
  if (lst_condition <> nil)
  then
    lst_condition := new (p_condition_iml, load (f));
  {endif}
end; { load }

destructor o_zone_condition_iml.done;
begin
  if (lst_condition <> nil)
  then
    dispose (lst_condition, done);
  {endif}
  o_zone.done;
end; { done }

procedure o_zone_condition_iml.save (var f : file);
begin
  o_zone.save (f);
  blockwrite (f, top_libelle, sizeof (top_libelle));
  blockwrite (f, lxl, sizeof (lxl));
  blockwrite (f, cfl, sizeof (cfl));
  blockwrite (f, ctl, sizeof (ctl));
  blockwrite (f, xl, sizeof (xl));
  blockwrite (f, yl, sizeof (yl));
  blockwrite (f, lst_condition, sizeof (lst_condition));
  if (lst_condition <> nil)
  then
    lst_condition^.save (f);
  {endif}
end; { save }

procedure o_zone_condition_iml.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, c, datasize);
      if ((lst_condition <> nil) and (not lst_condition^.test_condition (c)))
      then
        c := ' ';
      {endif}
    end
  else
    c := ' ';
  {endif}
end; { setdata }

procedure o_zone_condition_iml.getdata (var r);
begin
  move (c, r, datasize);
end; { getdata }

function o_zone_condition_iml.datasize : word;
begin
  datasize := sizeof (c);
end; { datasize }

procedure o_zone_condition_iml.display;
var
   ot : byte;
begin
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (c);
  if ((top_libelle) and (lst_condition <> nil))
  then
    begin
      gotoxy (xl, yl);
      textcolor (ctl);
      textbackground (cfl);
      write (copy (copy (lst_condition^.get_texte (c), 1, lxl)+
                   trait (' ', lxl), 1, lxl));
    end;
  {endif}
  textattr := ot;
end; { display }

procedure o_zone_condition_iml.run (var event : t_event);
var
   b : boolean;
begin
  if (cx < 1)
  then
    b := move_cursor (1-cx);
  {endif}
  o_zone.run (event);
  if (event.typ = c_ev_clavier)
  then
    case event.code_nul of
      true :
        case event.code_carac of
          touche_home :
            begin
              b := move_cursor (-cx+1);
              event.typ := c_ev_rien;
            end;
          touche_end :
            begin
              b := move_cursor (lx);
              event.typ := c_ev_rien;
            end;
          touche_gauche :
            begin
              b := move_cursor (-1);
              event.typ := c_ev_rien;
            end;
          touche_droite :
            begin
              b := move_cursor (1);
              event.typ := c_ev_rien;
            end;
          touche_del :
            begin
              c := ' ';
              display;
              event.typ := c_ev_rien;
            end;
          touche_page_up :
            begin
              if (lst_condition <> nil)
              then
                c := lst_condition^.pred (c);
              {endif}
              display;
            end;
          touche_page_dn :
            begin
              if (lst_condition <> nil)
              then
                c := lst_condition^.succ (c);
              {endif}
              display;
            end;
        end;
      false :
        case event.code_carac of
          '0'..'9', 'A'..'Z', 'a'..'z' :
            begin
              if ((lst_condition <> nil) and (lst_condition^.test_condition
                 (upcase (event.code_carac))))
              then
                begin
                  c := upcase (event.code_carac);
                  display;
                end
              else
                clochette;
              {endif}
              event.typ := c_ev_rien;
            end;
          ' ' :
            begin
              c := ' ';
              display;
            end;
        end;
    end;
  {endif}
end; { run }

function o_zone_condition_iml.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

begin
  mode_insert := true;
end.
