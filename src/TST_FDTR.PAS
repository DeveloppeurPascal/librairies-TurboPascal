program tst_fdtree;
uses
    crt,
    dos,
    u_fdtree;

type
    p_fdtree2 = ^o_fdtree2;
    o_fdtree2 = object (o_fdtree)
                       function treat_file (nom_fich : searchrec) : boolean; virtual;
                       function treat_directory (nom_fich : searchrec) : boolean; virtual;
    end;

function o_fdtree2.treat_file (nom_fich : searchrec) : boolean;
var
   path : pathstr;
begin
     getdir (0, path);
     if (path [length (path)] <> '\')
     then
         writeln (path+'\'+nom_fich.name)
     else
         writeln (path+nom_fich.name);
     {endif}
     treat_file := true;
end; { O_Fdtree2.Treat_file }

function o_fdtree2.treat_directory (nom_fich : searchrec) : boolean;
var
   path : pathstr;
begin
     getdir (0, path);
     writeln ('Directory: '+ path);
     treat_directory := true;
end; { O_Fdtree2.Treat_directory }

var
   ptr : p_fdtree2;

begin
     clrscr;
     ptr := new (p_fdtree2, init);
     ptr^.set_start_directory ('c:\olf_soft\');
     ptr^.set_file_mask ('*.*');
     ptr^.set_fdtree_sens (prefixe);
     ptr^.run;
     dispose (ptr, done);
end.
