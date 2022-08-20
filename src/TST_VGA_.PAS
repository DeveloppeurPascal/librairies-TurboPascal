program tst_vga_graph;

uses
    u_vga_graph,
    u_int10h;

begin
  repeat
  until (set_mode (19) or true);
  dessin_fleche (1, 6, 5, 15, 1, 2, gauche);
  dessin_fleche (36, 6, 5, 15, 3, 4, droite);
  dessin_fleche (6, 1, 15, 5, 5, 6, haut);
  dessin_fleche (6, 21, 15, 5, 7, 8, bas);
  readln;
  repeat
  until set_mode (3) or true;
end.
