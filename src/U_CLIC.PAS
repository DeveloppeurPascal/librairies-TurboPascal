unit u_clic;
{
Auteur: Pr‚martin Patrick.
Date: 09/09/1991.
      14/11/1991.
      29/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion des d‚placements de la souris, et des touches du clavier.
}
interface
procedure clic_init (depl_x, depl_y, max_larg, max_haut : integer);
procedure clic_mouse (var x_curs, y_curs, x, y : integer);
procedure clic_clavier (var x_curs, y_curs : integer; var touche : char);
procedure clic_joystick (var x_curs, y_curs : integer; var touche : char);

implementation
uses
    crt,
    u_code_clavier,
    u_joystick,
    u_curseur,
    u_mouse;

var
   dx,
   dy,
   lx,
   ly : integer;

procedure clic_init (depl_x, depl_y, max_larg, max_haut : integer);
begin
     dx := depl_x;
     dy := depl_y;
     lx := max_larg;
     ly := max_haut;
end; { Clic_Init }

procedure clic_mouse (var x_curs, y_curs, x, y : integer);
var
   mx, my, mk : integer;
begin
     show_mouse;
     mouse_x_y_k_txt (mx, my, mk);
     if (mk > 0)
     then
         begin
              if ((mx >= dx) and (my >= dy) and (mx < dx+lx) and (my < dy+ly))
              then
                  begin
                       x_curs := succ (mx-dx);
                       y_curs := succ (my-dy);
                  end;
              {endif}
              x := mx;
              y := my;
         end
     else
         begin
              x := 0;
              y := 0;
         end;
     {endif}
end; { Clic_Mouse }

procedure clic_clavier (var x_curs, y_curs : integer; var touche : char);
begin
     if (directvideo)
     then
         curseur_milieu;
     {endif}
     if not keypressed
     then
         touche := carac_nul
     else
         begin
              touche := readkey;
              if (touche = carac_nul)
              then
                  begin
                       touche := readkey;
                       case touche of
                            touche_haut : begin
                                               touche := carac_nul;
                                               if (y_curs > 1)
                                               then
                                                   dec (y_curs);
                                               {endif}
                            end;
                            touche_bas : begin
                                              touche := carac_nul;
                                              if (y_curs < ly)
                                              then
                                                  inc (y_curs);
                                              {endif}
                            end;
                            touche_gauche : begin
                                                 touche := carac_nul;
                                                 if (x_curs > 1)
                                                 then
                                                     dec (x_curs);
                                                 {endif}
                            end;
                            touche_droite : begin
                                                 touche := carac_nul;
                                                 if (x_curs < lx)
                                                 then
                                                     inc (x_curs);
                                                 {endif}
                            end;
                       end;
                  end;
              {endif}
         end;
     {endif}
end; { Clic_Clavier }

procedure clic_joystick (var x_curs, y_curs : integer; var touche : char);
begin
  case stick (stick_a) of
    1 :
      begin
        inc (x_curs);
        dec (y_curs);
      end;
    2 :
      begin
        inc (x_curs);
      end;
    3 :
      begin
        inc (x_curs);
        inc (y_curs);
      end;
    4 :
      begin
        inc (y_curs);
      end;
    5 :
      begin
        dec (x_curs);
        inc (y_curs);
      end;
    6 :
      begin
        dec (x_curs);
      end;
    7 :
      begin
        dec (x_curs);
        dec (y_curs);
      end;
    8 :
      begin
        dec (y_curs);
      end;
  end;
  if (x_curs < 1)
  then
    x_curs := 1;
  {endif}
  if (y_curs < 1)
  then
    y_curs := 1;
  {endif}
  if (x_curs > lx)
  then
    x_curs := lx;
  {endif}
  if (y_curs > ly)
  then
    y_curs := ly;
  {endif}
  if (directvideo)
  then
    curseur_pave;
  {endif}
  if ((strig and (strig_a_1+strig_a_2)) > 0)
  then
      touche := ' '
  else
      touche := carac_nul;
  {endif}
  curseur_locate (pred (x_curs+dx), pred (y_curs+dy));
end; { clic_joystick }

begin
     clic_init (0, 0, 0, 0);
end. { Fin de l'unit‚ 'U_CLic'. }
