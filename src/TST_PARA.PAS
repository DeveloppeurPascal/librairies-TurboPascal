program tst_parametre;
uses
    olf_software,
    u_parametre;

var
   i : integer;

begin
     writeln (param_nb);
     for i := 1 to param_nb do
         writeln (param_ch (i));
     {endfor}
     writeln;
     init_ligne_olf_software ('Coucou', 'Parametre');
     writeln;
     writeln (param_nb);
     for i := 1 to param_nb do
         writeln (param_ch (i));
     {endfor}
end.
