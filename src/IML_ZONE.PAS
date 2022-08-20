unit iml_zone;
{
Auteur: Patrick Pr‚martin.
Date: 16/09/1992. 17/09/1992. 23/01/1993.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    iml_var;

type
    p_zone = ^o_zone;
    o_zone =
      object
        x, y, lx,       { Coordonn‚es (x, y) et largeur (lx) de la zone. }
        ct, cf,         { Couleurs du texte (ct) et du fond (cf). }
        cx : byte;      { Position du curseur sur la ligne en cours. }
        helpctx : word; { Contexte d'aide. }
        typ_saisie : t_typ_saisie;
        constructor init (ict, icf, ix, iy, ilx : byte; ihelpctx : word;
                          its : t_typ_saisie);
        constructor load (var f : file);
        destructor done;
        procedure save (var f : file);
        function move_cursor (dir : integer) : boolean;
        procedure display; virtual;
        procedure run (var event : t_event); virtual; { Ne jamais oublier de
                                                      faire appel au RUN des
                                                      ancˆtres... }
        function valid : boolean; virtual;
        procedure set_idle (adr_proc_far : t_proc);
      private
        idle : t_proc;
      end;

implementation
uses
    crt,
    u_mouse,
    u_curseur,
    u_code_clavier;

procedure default_idle; far;
begin
end; { default_idle }

constructor o_zone.init (ict, icf, ix, iy, ilx : byte; ihelpctx : word;
                         its : t_typ_saisie);
begin
  ct := ict;
  cf := icf;
  x := ix;
  y := iy;
  lx := ilx;
  helpctx := ihelpctx;
  typ_saisie := its;
  cx := 0;
  idle := default_idle;
end; { init }

constructor o_zone.load (var f : file);
begin
  blockread (f, ct, sizeof (ct));
  blockread (f, cf, sizeof (cf));
  blockread (f, x, sizeof (x));
  blockread (f, y, sizeof (y));
  blockread (f, lx, sizeof (lx));
  blockread (f, helpctx, sizeof (helpctx));
  blockread (f, typ_saisie, sizeof (typ_saisie));
  cx := 0;
  idle := default_idle;
end; { load }

destructor o_zone.done;
begin
end; { done }

procedure o_zone.save (var f : file);
begin
  blockwrite (f, ct, sizeof (ct));
  blockwrite (f, cf, sizeof (cf));
  blockwrite (f, x, sizeof (x));
  blockwrite (f, y, sizeof (y));
  blockwrite (f, lx, sizeof (lx));
  blockwrite (f, helpctx, sizeof (helpctx));
  blockwrite (f, typ_saisie, sizeof (typ_saisie));
end; { save }

function o_zone.move_cursor (dir : integer) : boolean;
var
   ocx : byte;
begin
  ocx := cx;
  if (dir+cx < 1)
  then
    cx := 0
  else
    if (dir+cx >= lx)
    then
      cx := pred (lx)
    else
      cx := dir+cx;
    {endif}
  {endif}
  move_cursor := (ocx <> cx);
end; { move_cursor }

procedure o_zone.display;
begin
end; { display }

procedure o_zone.run (var event : t_event);
var
   fin : boolean;
begin
  if mode_insert
  then
    curseur_milieu
  else
    curseur_pave;
  {endif}
  curseur_locate (cx+x, y);
  fin := false;
  repeat
    mouse_x_y_k_txt (event.mx, event.my, event.mk);
    if (event.mk > 0)
    then
      begin
        fin := true;
        event.typ := c_ev_souris;
      end;
    {endif}
    if (keypressed)
    then
      begin
        fin := true;
        event.typ := c_ev_clavier;
        event.code_carac := readkey;
        if (event.code_carac <> carac_nul)
        then
          event.code_nul := false
        else
          begin
            event.code_nul := true;
            event.code_carac := readkey;
          end;
        {endif}
      end;
    {endif}
    idle;
  until fin;
  if (event.typ = c_ev_clavier)
  then
    case event.code_nul of
      true :
        case event.code_carac of
          touche_haut :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_previous;
            end;
          touche_bas :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_next;
            end;
          touche_ins : mode_insert := not mode_insert;
          touche_f1 :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_help;
            end;
          touche_shift_tab :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_previous;
            end;
        end;
      false :
        case event.code_carac of
          touche_return :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_ok;
            end;
          touche_escape :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_cancel;
            end;
          touche_tab :
            begin
              event.typ := c_ev_commande;
              event.cmde := c_cmde_next;
            end;
        end;
    end;
  {endif}
end; { run }

function o_zone.valid : boolean;
begin
  valid := true;
end; { valid }

procedure o_zone.set_idle (adr_proc_far : t_proc);
begin
  idle := adr_proc_far;
end; { set_idle }

end.
