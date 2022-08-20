unit iml_string;
{
Auteur: Patrick Pr‚martin.
Date: 16/09/1992. 17/09/1992.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues de Olf Software.
}
interface
uses
    iml_var,
    iml_zone;

type
  p_zone_texte = ^o_zone_texte;
  o_zone_texte =
    object (o_zone)
      t : string;
      constructor init (its : t_typ_saisie; ict, icf, ix, iy, ilx : byte;
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

constructor o_zone_texte.init (its : t_typ_saisie; ict, icf, ix, iy, ilx : byte;
                               ihelpctx : word);
begin
  o_zone.init (ict, icf, ix, iy, ilx, ihelpctx, its);
end; { init }

constructor o_zone_texte.load (var f : file);
begin
  o_zone.load (f);
  blockread (f, t [0], succ (lx));
end; { load }

destructor o_zone_texte.done;
begin
  o_zone.done;
end; { done }

procedure o_zone_texte.save (var f : file);
begin
  o_zone.save (f);
  blockwrite (f, t [0], succ (lx));
end; { save }

procedure o_zone_texte.setdata (var r);
begin
  if (typ_saisie in [output, both])
  then
    begin
      move (r, t [0], datasize);
      if (length (t) > lx)
      then
        t := copy (t, 1, lx)
      else
        if (length (t) < lx)
        then
          t := t + trait (' ', lx-length (t));
        {endif}
      {endif}
    end;
  {endif}
end; { setdata }

procedure o_zone_texte.getdata (var r);
var
   ch : string;
begin
  ch := justifier_droite (t);
  move (ch [0], r, datasize);
end; { getdata }

function o_zone_texte.datasize : word;
begin
  datasize := succ (lx);
end; { datasize }

procedure o_zone_texte.display;
var
   ot : byte;
begin
  ot := textattr;
  gotoxy (x, y);
  textcolor (ct);
  textbackground (cf);
  write (t);
  textattr := ot;
end; { display }

procedure o_zone_texte.run (var event : t_event);
var
   b : boolean;
begin
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
        end;
      false :
        case event.code_carac of
          #32..#255 :
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
            if (move_cursor (-1))
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
end; { run }

function o_zone_texte.valid : boolean;
begin
  valid := o_zone.valid;
end; { valid }

begin
  mode_insert := true;
end.
