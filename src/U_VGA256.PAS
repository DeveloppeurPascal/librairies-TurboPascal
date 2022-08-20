unit u_vga256;
{
Auteur: Patrick Pr‚martin.
Date: 24/07/1992.
Langage: Turbo Pascal 6.0
But: Utilisation simple du driver VGA256.BGI de Borland.
}

interface

procedure init_vga256;
{ Mise en place du mode graphique 320 * 200 en 256 couleurs. }

procedure close_vga256;
{ Fin du mode graphique, retour au mode texte de d‚part. }

implementation
uses
    u_sgf,
    graph;

var
   GraphDriver,
   GraphMode : integer;
   old_exitproc : pointer;

function My_Mode : integer; far;
begin
     My_Mode := 0;
end; { My_Mode }

procedure vga256_exit; far;
begin
     closegraph;
     exitproc := old_exitproc;
end; { vga256_exit }

procedure init_vga256;
var
   codeerreur : integer;
begin
     GraphDriver := Detect;
     InitGraph (GraphDriver, GraphMode, get_chemin_fichier (get_file_name ('VGA256.BGI')));
     codeerreur := graphresult;
     if (codeerreur <> GrOk)
     then
         begin
              writeln ('BGI Error: ', grapherrormsg (codeerreur));
              writeln ('Program Aborted...');
              halt (1);
         end;
     {endif}
end; { init_vga256 }

procedure close_vga256;
begin
     closegraph;
end; { close_vga256 }

begin
     GraphMode := InstallUserDriver ('VGA256', @My_Mode);
     old_exitproc := exitproc;
     exitproc := @vga256_exit;
end.
