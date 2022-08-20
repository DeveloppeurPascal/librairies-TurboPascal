unit iml_integer;
{
Auteur: Patrick Pr‚martin.
Date: 17/09/1992. 12/10/1992.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    iml_var,
    iml_zone;

type
  p_zone_numeric = ^o_zone_numeric;
  o_zone_numeric =
    object (o_zone)
      n, vmin, vmax : longint;
      constructor init (imin, imax : longint; its : t_typ_saisie;
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

constructor o_zone_numeric.init (imin, imax : longint; its : t_typ_saisie;
                                 ict, icf, ix, iy : byte; ihelpctx : word);
begin
  vmin := min (imin, imax);
  vmax := max (imin, imax);
  t := num2str (vmin);
  o_zone.init (ict, icf, ix, iy, max (length (num2str (vmin)),
                                      length (num2str (vmax))), ihelpctx, its);
end; { init }

constructor o_zone_numeric.load (var f : file);
begin
  o_zone.load (f);
  blockread (f, n, sizeof (n));
  blockread (f, vmin, sizeof (vmin));
  blockread (f, vmax, sizeof (vmax));
end; { load }

destructor o_zone_numeric.done;
begin
  o_zone.done;
end; { done }

procedure o_zone_numeric.save (var f : file);
begin
  o_zone.save (f);
  blockwrite (f, n, sizeof (n));
  blockwrite (f, vmin, sizeof (vmin));
  blockwrite (f, vmax, sizeof (vmax));
end; { save }

procedure o_zone_numeric.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, n, datasize);
      if (n > vmax)
      then
        t := num2str (vmax)
      else
        if (n < vmin)
        then
          t := num2str (vmin)
        else
          t := num2str (n);
        {endif}
      {endif}
    end
  else
    t := '';
  {endif}
  t := t+trait (' ', lx-length (t));
end; { setdata }

procedure o_zone_numeric.getdata (var r);
begin
  move (n, r, datasize);
end; { getdata }

function o_zone_numeric.datasize : word;
begin
  datasize := sizeof (n);
end; { datasize }

procedure o_zone_numeric.display;
var
   ot : byte;
begin
  t := t+trait (' ', lx-length (t));
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (t);
  textattr := ot;
end; { display }

procedure o_zone_numeric.run (var event : t_event);
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
              delete (t, succ (cx), 1);
              t := t + ' ';
              display;
              event.typ := c_ev_rien;
            end;
          touche_page_up :
            begin
              n := str2num (t);
              if (n < vmax)
              then
                inc (n);
              {endif}
              t := num2str (n);
              display;
            end;
          touche_page_dn :
            begin
              n := str2num (t);
              if (n > vmin)
              then
                dec (n);
              {endif}
              t := num2str (n);
              display;
            end;
        end;
      false :
        case event.code_carac of
          '+' :
            begin
              t [1] := '+';
              display;
            end;
          '-' :
            begin
              t [1] := '-';
              display;
            end;
          '0'..'9' :
            begin
              if not mode_insert
              then
                begin
                  t [succ (cx)] := event.code_carac;
                  b := move_cursor (1);
                  display;
                end
              else
                if (t [lx] = ' ')
                then
                  begin
                    delete (t, lx, 1);
                    insert (event.code_carac, t, succ (cx));
                    b := move_cursor (1);
                    display;
                  end
                else
                  clochette;
                {endif}
              {endif}
              event.typ := c_ev_rien;
            end;
          touche_backspace :
            if ((cx > 1) and (move_cursor (-1)))
            then
              begin
                delete (t, succ (cx), 1);
                t := t + ' ';
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
  n := str2num (t);
end; { run }

function o_zone_numeric.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

begin
  mode_insert := true;
end.
