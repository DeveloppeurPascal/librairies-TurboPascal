program tst_fnt;
uses
    u_fnt;

var
   i,
   j : integer;
begin
     for j := 0 to nb_max_fnt do
         if (fnt_select (j) = 0)
         then
             for i := 128 to 255 do
                 write (chr (i));
             {endfor}
         {endfor}
     {endfor}
     writeln;
     for j := nb_max_fnt downto 0 do
         if (fnt_select (j) = 0)
         then
             for i := 128 to 255 do
                 write (chr (i));
             {endfor}
         {endif}
     {endfor}
     writeln;
end.
