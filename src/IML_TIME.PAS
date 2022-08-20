unit iml_time;
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
  p_zone_time = ^o_zone_time;
  o_zone_time =
    object (o_zone)
      time : t_time;
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

constructor o_zone_time.init (its : t_typ_saisie;
                              ict, icf, ix, iy : byte; ihelpctx : word);
begin
  time.hh := 0;
  time.mm := 0;
  time.ss := 0;
  t := tim2str (time);
  o_zone.init (ict, icf, ix, iy, 8, ihelpctx, its);
end; { init }

constructor o_zone_time.load (var f : file);
begin
  o_zone.load (f);
end; { load }

destructor o_zone_time.done;
begin
  o_zone.done;
end; { done }

procedure o_zone_time.save (var f : file);
begin
  o_zone.save (f);
end; { save }

procedure o_zone_time.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, time, datasize);
      t := tim2str (time);
    end
  else
    t := '';
  {endif}
  t := t+trait (' ', lx-length (t));
end; { setdata }

procedure o_zone_time.getdata (var r);
begin
  move (time, r, datasize);
end; { getdata }

function o_zone_time.datasize : word;
begin
  datasize := sizeof (time);
end; { datasize }

procedure o_zone_time.display;
var
   ot : byte;
begin
  str2tim (t, time);
  tst_time (time);
  t := tim2str (time);
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (t);
  textattr := ot;
end; { display }

procedure o_zone_time.run (var event : t_event);
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
              if (t [succ (cx)] = ':')
              then
                b := move_cursor (-1);
              {endif}
              event.typ := c_ev_rien;
            end;
          touche_droite :
            begin
              b := move_cursor (1);
              if (t [succ (cx)] = ':')
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
              str2tim (t, time);
              case cx of
                0..1 : inc (time.hh);
                3..4 : inc (time.mm);
                6..7 : inc (time.ss);
              end;
              tst_time (time);
              t := tim2str (time);
              display;
            end;
          touche_page_dn :
            begin
              str2tim (t, time);
              case cx of
                0..1 :
                  if (time.hh > 0)
                  then
                    dec (time.hh)
                  else
                    time.hh := 23;
                  {endif}
                3..4 :
                  if (time.mm > 0)
                  then
                    dec (time.mm)
                  else
                    time.mm := 59;
                  {endif}
                6..7 :
                  if (time.ss > 0)
                  then
                    dec (time.ss)
                  else
                    time.ss := 59;
                  {endif}
              end;
              tst_time (time);
              t := tim2str (time);
              display;
            end;
        end;
      false :
        case event.code_carac of
          '0'..'9' :
            begin
              t [succ (cx)] := event.code_carac;
              b := move_cursor (1);
              if (t [succ (cx)] = ':')
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
                if (t [succ (cx)] = ':')
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
  str2tim (t, time);
  tst_time (time);
end; { run }

function o_zone_time.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

end.
