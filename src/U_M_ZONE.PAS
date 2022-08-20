unit u_m_zone;
{
Auteur: Patrick Pr‚martin.
Date: 26/06/1992. 03/08/1992. 10/08/1992. 11/08/1992. 28/03/1993.
Langage: Turbo Pascal 6.0
But: Objet permettant une simplification des interfaces utilisant la souris. Il
     suffit de d‚finir des zones, et les r‚sultats de la souris sont transform‚s
     en codes clavier (plus simples … tester).
}
interface

type
    p_zone = ^o_zone;
    o_zone = object
               pos_x, pos_y, largeur, hauteur : integer;
               code_nul : boolean; { A vrai si caractŠre ‚tendu. }
               code_carac : char;
               next : p_zone;

               constructor init (x, y, l, h : word; cn : boolean; c : char;
                                 n : p_zone);
               destructor done;
    end;

    p_m_zone = ^o_m_zone;
    o_m_zone = object
                 zone : p_zone;

                 constructor init;
                 destructor done;
                 procedure add_zone (text : string;
                                     coul_txt, coul_bkg : byte;
                                     x, y, largeur : byte;
                                     code_nul : boolean;
                                     code_carac : char);
                 procedure add_zone2 (x, y, largeur : byte;
                                      code_nul : boolean;
                                      code_carac : char);
                 procedure add_zone3 (x, y, largeur, hauteur : byte;
                                      code_nul : boolean;
                                      code_carac : char);
                 procedure add_graph (x, y, largeur, hauteur : word;
                                      code_nul : boolean;
                                      code_carac : char);
                 procedure test_souris (var code_nul : boolean;
                                        var code_carac : char);
                 procedure test_graph (var code_nul : boolean;
                                       var code_carac : char);
                 procedure idle; virtual; { Est appel‚e dans boucle de
                                            test_souris. }
    end;

var
   pos_m_x, pos_m_y, pos_m_k : integer;

implementation
uses
    crt,
    u_chaine,
    u_mouse,
    u_code_clavier;

constructor o_zone.init (x, y, l, h : word; cn : boolean; c : char; n : p_zone);
begin
     pos_x := x;
     pos_y := y;
     largeur := l;
     hauteur := h;
     code_nul := cn;
     code_carac := c;
     next := n;
end; { o_zone.init }

destructor o_zone.done;
begin
     if (next <> nil)
     then
         dispose (next, done);
     {endif}
end; { o_zone.done }

constructor o_m_zone.init;
begin
     zone := nil;
end; { o_m_zone.init }

destructor o_m_zone.done;
begin
     if (zone <> nil)
     then
         dispose (zone, done);
     {endif}
end; { o_m_zone.done }

procedure o_m_zone.add_zone (text : string; coul_txt, coul_bkg : byte;
                             x, y, largeur : byte;
                             code_nul : boolean; code_carac : char);
var
   e : p_zone;
   ot, ox, oy : byte;
begin
     ot := textattr;
     ox := wherex;
     oy := wherey;
     if (largeur = 0)
     then
         largeur := length (text);
     {endif}
     e := new (p_zone, init (x, y, largeur, 1, code_nul, code_carac, zone));
     if (e <> nil)
     then
         begin
           zone := e;
           gotoxy (x, y);
           textattr := coul_bkg*16+coul_txt;
           write (copy (text, 1, largeur), trait (' ', largeur-length (text)));
         end;
     {endif}
     textattr := ot;
     gotoxy (ox, oy);
end; { o_m_zone.add_zone }

procedure o_m_zone.add_zone2 (x, y, largeur : byte; code_nul : boolean;
                                                    code_carac : char);
var
   e : p_zone;
begin
     e := new (p_zone, init (x, y, largeur, 1, code_nul, code_carac, zone));
     if (e <> nil)
     then
       zone := e;
     {endif}
end; { o_m_zone.add_zone2 }

procedure o_m_zone.add_zone3 (x, y, largeur, hauteur : byte;
                              code_nul : boolean; code_carac : char);
var
   e : p_zone;
begin
     e := new (p_zone, init (x, y, largeur, hauteur, code_nul, code_carac, zone));
     if (e <> nil)
     then
       zone := e;
     {endif}
end; { add_zone3 }

procedure o_m_zone.add_graph (x, y, largeur, hauteur : word;
                              code_nul : boolean; code_carac : char);
var
   e : p_zone;
begin
     e := new (p_zone, init (x*2, y, largeur*2, hauteur, code_nul, code_carac, zone));
     if (e <> nil)
     then
       zone := e;
     {endif}
end; { o_m_zone.add_graph }

procedure o_m_zone.test_souris (var code_nul : boolean; var code_carac : char);
var
   mx, my, mk : integer;
   c : char;
   e : p_zone;
begin
  show_mouse;
  c := carac_nul;
  code_nul := false;
  repeat
    mk := 0;
    repeat
      mouse_x_y_k_txt (mx, my, mk);
      mouse_x_y (pos_m_x, pos_m_y);
      idle;
    until ((mk > 0) or keypressed);
    e := zone;
    while ((e <> nil) and (mk > 0)) do
      begin
        if ((my >= e^.pos_y) and (my < e^.pos_y+e^.hauteur) and (mx >= e^.pos_x)
                             and (mx < e^.pos_x+e^.largeur))
        then
          begin
            pos_m_k := mk;
            code_nul := e^.code_nul;
            code_carac := e^.code_carac;
            c := code_carac;
          end;
        {endif}
        e := e^.next;
      end;
    {endwhile}
    if (keypressed)
    then
      begin
        c := readkey;
        code_nul := (c = carac_nul);
        if (code_nul)
        then
          code_carac := readkey
        else
          code_carac := c;
        {endif}
        c := code_carac;
      end;
    {endif}
  until ((c <> carac_nul) or (code_nul <> false));
  hide_mouse;
end; { o_m_zone.test_souris }

procedure o_m_zone.test_graph (var code_nul : boolean; var code_carac : char);
var
   mx, my, mk : integer;
   c : char;
   e : p_zone;
begin
  show_mouse;
  c := carac_nul;
  code_nul := false;
  repeat
    mk := 0;
    repeat
      mouse_x_y_k (mx, my, mk);
      pos_m_x := mx;
      pos_m_y := my;
      idle;
    until ((mk > 0) or keypressed);
    e := zone;
    while ((e <> nil) and (mk > 0)) do
      begin
        if ((mx >= e^.pos_x) and (mx <= e^.pos_x+e^.largeur) and
            (my >= e^.pos_y) and (my <= e^.pos_y+e^.hauteur))
        then
          begin
            code_nul := e^.code_nul;
            code_carac := e^.code_carac;
            c := code_carac;
            pos_m_x := mx;
            pos_m_y := my;
            pos_m_k := mk;
          end;
        {endif}
        e := e^.next;
      end;
    {endwhile}
    if (keypressed)
    then
      begin
        c := readkey;
        code_nul := (c = carac_nul);
        if (code_nul)
        then
          code_carac := readkey
        else
          code_carac := c;
        {endif}
        c := code_carac;
      end;
    {endif}
  until ((c <> carac_nul) or (code_nul <> false));
  hide_mouse;
end; { o_m_zone.test_graph }

procedure o_m_zone.idle;
begin
end; { o_m_zone.idle }

begin
     pos_m_x := 0;
     pos_m_y := 0;
     pos_m_k := 0;
end. { u_m_zone }
