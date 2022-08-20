unit iml_real;
{
Auteur: Patrick Pr‚martin.
Date: 12/10/1992.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    iml_var,
    iml_zone;

type
  p_zone_real = ^o_zone_real;
  o_zone_real =
    object (o_zone)
      vmin, vmax, n : double;
      nb_int, nb_dec : byte;
      constructor init (imin, imax : double; inb_int, inb_dec : byte;
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
    private
      t : string;
    end;

implementation
uses
    crt,
    u_chaine,
    u_code_clavier;

constructor o_zone_real.init (imin, imax : double; inb_int, inb_dec : byte;
                  its : t_typ_saisie; ict, icf, ix, iy : byte;
                  ihelpctx : word);
begin
  vmin := imin;
  vmax := imax;
  nb_int := inb_int;
  nb_dec := inb_dec;
  o_zone.init (ict, icf, ix, iy, 1+nb_int+1+nb_dec, ihelpctx, its);
  t := copy (flt2str (vmin), 1, lx);
end; { init }

constructor o_zone_real.load (var f : file);
begin
  o_zone.load (f);
  blockread (f, n, sizeof (n));
  blockread (f, vmin, sizeof (vmin));
  blockread (f, vmax, sizeof (vmax));
  blockread (f, nb_int, sizeof (nb_int));
  blockread (f, nb_dec, sizeof (nb_dec));
end; { load }

destructor o_zone_real.done;
begin
  o_zone.done;
end; { done }

procedure o_zone_real.save (var f : file);
begin
  o_zone.save (f);
  blockwrite (f, n, sizeof (n));
  blockwrite (f, vmin, sizeof (vmin));
  blockwrite (f, vmax, sizeof (vmax));
  blockwrite (f, nb_int, sizeof (nb_int));
  blockwrite (f, nb_dec, sizeof (nb_dec));
end; { save }

procedure o_zone_real.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, n, datasize);
      if (n > vmax)
      then
        t := copy (flt2str (vmax), 1, lx)
      else
        if (n < vmin)
        then
          t := copy (flt2str (vmin), 1, lx)
        else
          t := copy (flt2str (n), 1, lx);
        {endif}
      {endif}
    end
  else
    t := '';
  {endif}
  t := t+trait (' ', lx-length (t));
end; { setdata }

procedure o_zone_real.getdata (var r);
begin
  move (n, r, datasize);
end; { setdata }

function o_zone_real.datasize : word;
begin
  datasize := sizeof (n);
end; { datasize }

procedure o_zone_real.display;
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

procedure o_zone_real.run (var event : t_event);
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
              if (pos (' ', t) > 0)
              then
                b := move_cursor (-cx+pos (' ', t)+1)
              else
                b := move_cursor (lx-cx);
              {endif}
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
            if (t [succ (cx)] <> '.')
            then
              begin
                delete (t, succ (cx), 1);
                t := t + ' ';
                display;
                event.typ := c_ev_rien;
              end;
            {endif}
          touche_page_up :
            begin
              n := str2flt (t);
              if (n <= vmax-1)
              then
                n := n +1;
              {endif}
              t := copy (flt2str (n), 1, lx);
              display;
            end;
          touche_page_dn :
            begin
              n := str2flt (t);
              if (n >= vmin+1)
              then
                n := n - 1;
              {endif}
              t := copy (flt2str (n), 1, lx);
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
          '.' :
            b := move_cursor (-cx-1+pos ('.', t));
          '0'..'9' :
            begin
              if ((not mode_insert) and (t [succ (cx)] <> '.'))
              then
                begin
                  t [succ (cx)] := event.code_carac;
                  b := move_cursor (1);
                  if (t [succ (cx)] = '.')
                  then
                    b := move_cursor (1);
                  {endif}
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
            if (t [cx] <> '.')
            then
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
            {endif}
        end;
    end;
  {endif}
  n := str2flt (t);
end; { run }

function o_zone_real.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

begin
  mode_insert := true;
end.
