unit iml_date;
{
Auteur: Patrick Pr‚martin.
Date: 22/11/1992.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    iml_var,
    iml_zone;

type
  p_zone_date = ^o_zone_date;
  o_zone_date =
    object (o_zone)
      date : t_date;
      constructor init (its : t_typ_saisie;
                        ict, icf, ix, iy : byte; ihelpctx : word);
      constructor load (var f : file);
      destructor done;
      procedure save (var f : file);
      procedure setdata (var r); virtual;
      procedure getdata (var r); virtual;
      function datasize : word; virtual;
      procedure display; virtual;
      procedure run (var event : t_event); virtual;
      function valid : boolean; virtual;
    private
      t : string;
    end;

implementation
uses
    crt,
    u_chaine,
    u_code_clavier;

constructor o_zone_date.init (its : t_typ_saisie;
                              ict, icf, ix, iy : byte; ihelpctx : word);
begin
  date.jj := 0;
  date.mm := 0;
  date.aa := 0;
  t := dat2str (date);
  o_zone.init (ict, icf, ix, iy, 10, ihelpctx, its);
end; { init }

constructor o_zone_date.load (var f : file);
begin
  o_zone.load (f);
end; { load }

destructor o_zone_date.done;
begin
  o_zone.done;
end; { done }

procedure o_zone_date.save (var f : file);
begin
  o_zone.save (f);
end; { save }

procedure o_zone_date.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, date, datasize);
      t := dat2str (date);
    end
  else
    t := '';
  {endif}
  t := t+trait (' ', lx-length (t));
end; { setdata }

procedure o_zone_date.getdata (var r);
begin
  move (date, r, datasize);
end; { getdata }

function o_zone_date.datasize : word;
begin
  datasize := sizeof (date);
end; { datasize }

procedure o_zone_date.display;
var
   ot : byte;
begin
  str2dat (t, date);
  t := dat2str (date);
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (t);
  textattr := ot;
end; { display }

procedure o_zone_date.run (var event : t_event);
var
   b : boolean;
begin
  if (cx < 0)
  then
    b := move_cursor (-cx);
  {endif}
  o_zone.run (event);
  if (event.typ = c_ev_clavier)
  then
    case event.code_nul of
      true :
        case event.code_carac of
          touche_home :
            begin
              b := move_cursor (-cx);
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
              if (t [succ (cx)] = '/')
              then
                b := move_cursor (-1);
              {endif}
              event.typ := c_ev_rien;
            end;
          touche_droite :
            begin
              b := move_cursor (1);
              if (t [succ (cx)] = '/')
              then
                b := move_cursor (1);
              {endif}
              event.typ := c_ev_rien;
            end;
          touche_del :
            begin
              t [succ (cx)] := '0';
              display;
              event.typ := c_ev_rien;
            end;
          touche_page_up :
            begin
              str2dat (t, date);
              case cx of
                0..1 : inc (date.jj);
                3..4 : inc (date.mm);
                6..9 : inc (date.aa);
              end;
              tst_date (date);
              t := dat2str (date);
              display;
            end;
          touche_page_dn :
            begin
              str2dat (t, date);
              case cx of
                0..1 : dec (date.jj);
                3..4 : dec (date.mm);
                6..9 : dec (date.aa);
              end;
              tst_date (date);
              t := dat2str (date);
              display;
            end;
        end;
      false :
        case event.code_carac of
          '0'..'9' :
            begin
              t [succ (cx)] := event.code_carac;
              b := move_cursor (1);
              if (t [succ (cx)] = '/')
              then
                b := move_cursor (1);
              {endif}
              display;
              event.typ := c_ev_rien;
            end;
          touche_backspace :
            if ((cx > 0) and (move_cursor (-1)))
            then
              begin
                if (t [succ (cx)] = '/')
                then
                  b := move_cursor (-1);
                {endif}
                t [succ (cx)] := '0';
                display;
                event.typ := c_ev_rien;
              end
            else
              begin
                event.typ := c_ev_rien;
                clochette;
              end;
            {endif}
        end;
    end;
  {endif}
  str2dat (t, date);
  tst_date (date);
end; { run }

function o_zone_date.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

end.
