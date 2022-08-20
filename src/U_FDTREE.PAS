unit u_fdtree;
{
Auteur: Premartin Patrick
Date: 30/08/1991.
      31/08/1991.
      01/09/1991.
      06/11/1991.
Langage: Turbo Pascal 6.0
But: Objet permettant le parcours d'une arborescence et les op‚rations diverses
     … d‚finir sur chaque ‚l‚ment de cette arborescence de fichiers.
}
interface
uses
    dos;

type
    t_fdtree_sens = (prefixe, postfixe);
    p_fdtree = ^o_fdtree;
    o_fdtree = object
                     constructor init;
                               { Initialise les donn‚es priv‚es. }
                     destructor done;
                     procedure run;
                               { R‚alise le parcours et appelle:
                                         - Treat_File pour chaque fichier;
                                         - Treat_Directory pour chaque r‚pertoire;
                                         - Stop_Run pour l'appuit sur une touche.
                               }

                     function treat_file (f : searchrec) : boolean; virtual;
                              { R‚alise le traitement du fichier correspondant. }
                     function treat_directory (d : searchrec) : boolean; virtual;
                              { R‚alise le traitement du r‚pertoire pass‚. }
                     function stop_run : boolean; virtual;
                              { R‚alise le traitement de l'appuit sur une
                              touche. Renvoie True si l'op‚ration doit s'arr‚ter
                              (et par d‚faut). }

                     procedure set_file_mask (mask : string);
                               { D‚fini le masque de recherche des fichiers. }
                     function get_file_mask : string;
                              { Renvoie le masque de recherche des fichiers. }
                     procedure set_directory_mask (mask : string);
                               { D‚fini le masque de recherche des r‚pertoires. }
                     function get_directory_mask : string;
                              { Renvoie le masque des r‚pertoires. }
                     procedure set_start_directory (st_dir : string);
                               { D‚fini le r‚pertoire racine de l'arborescence
                               … parcourir. }
                     function get_start_directory : string;
                              { Renvoie le r‚pertoire racine de l'arborescence. }
                     procedure set_fdtree_sens (sens : t_fdtree_sens);
                               { Fixe le sens de parcours de l'arbre:
                                         - PreFixe : Fichiers avant r‚pertoires.
                                         - Postfix‚ : R‚pertoires avant fichiers. }
                     function get_fdtree_sens : t_fdtree_sens;
                              { Renvoie le sens de parcours de l'arbre. }
               private
                      f_mask,
                      d_mask,
                      start_path : string;
                      fdtree_sens : t_fdtree_sens;
               end;

implementation
uses
    crt;
{
Objet: O_Fdtree.
}
constructor o_fdtree.init;
begin
     set_file_mask ('*.*');
     set_directory_mask ('*.*');
     set_start_directory ('');
     set_fdtree_sens (prefixe);
end; { O_Fdtree.Init }

destructor o_fdtree.done;
begin
end; { O_Fdtree.Done }

procedure o_fdtree.run;
var
   fin : boolean;
   old_path : pathstr;
   i : byte;

  procedure research_f (pathenv : pathstr);
  var
     nom_fich_f : searchrec;

  begin
       findfirst (pathenv+'\'+f_mask, archive+sysfile, nom_fich_f);
       while ((doserror = 0) and not fin) do
             begin
                  if keypressed
                  then
                      fin := fin or stop_run
                  else
                      fin := fin or not treat_file (nom_fich_f);
                  {endif}
                  findnext (nom_fich_f);
             end;
       {endwhile}
  end; { Research_f }

  procedure research_d (pathenv : pathstr);
  var
     nom_fich_d : searchrec;

  begin
       chdir (pathenv);
       findfirst (pathenv, directory, nom_fich_d);
       if (fdtree_sens = prefixe)
       then
           research_f (pathenv)
       else
           fin := fin or not treat_directory (nom_fich_d);
       {endif}
       findfirst (pathenv+'\'+d_mask, directory, nom_fich_d);
       while ((doserror = 0) and not fin) do
             begin
                  if (nom_fich_d.attr and directory <> 0)
                  then
                      begin
                           if ((nom_fich_d.name <> '..') and (nom_fich_d.name <> '.'))
                           then
                               begin
                                    chdir (pathenv + '\'+ nom_fich_d.name);
                                    research_d (pathenv+'\'+nom_fich_d.name);
                                    chdir (pathenv);
                               end;
                           {endif}
                           if keypressed
                           then
                               fin := fin or stop_run;
                           {endif}
                      end;
                  {endif}
                  findnext (nom_fich_d);
             end;
       {endwhile}
       chdir (pathenv);
       findfirst (pathenv, directory, nom_fich_d);
       if (fdtree_sens = postfixe)
       then
           research_f (pathenv)
       else
           fin := fin or not treat_directory (nom_fich_d);
       {endif}
  end; { Research_d }

begin
     getdir (0, old_path);
     fin := false;
     chdir (start_path);
     if (start_path [length (start_path)] = '\')
     then
         i := 1
     else
         i := 0;
     {endif}
     research_d (copy (start_path, 1, length (start_path) -i));
     chdir (old_path);
end; { O_Fdtree.Run }

function o_fdtree.treat_file (f : searchrec) : boolean;
begin
     treat_File := true;
end; { O_Fdtree.Treat_File }

function o_fdtree.treat_directory (d : searchrec) : boolean;
begin
     treat_directory := true;
end; { O_Fdtree.Treat_Directory }

function o_fdtree.stop_run : boolean;
begin
     stop_run := true;
end; { O_Fdtree.Stop_Run }
 
procedure o_fdtree.set_file_mask (mask : string);
var
   i : integer;
begin
     i := pos ('\', mask);
     while (i > 0) do
           begin
                mask := copy (mask, i, length (mask));
                i := pos ('\', mask);
           end;
     {endwhile}
     f_mask := mask;
end; { O_Fdtree.Set_File_Mask }

function o_fdtree.get_file_mask : string;
begin
     get_file_mask := f_mask;
end; { O_Fdtree.Get_File_Mask }

procedure o_fdtree.set_directory_mask (mask : string);
var
   i : integer;
begin
     i := pos ('\', mask);
     while (i > 0) do
           begin
                mask := copy (mask, i, length (mask));
                i := pos ('\', mask);
           end;
     {endwhile}
     d_mask := mask;
end; { O_Fdtree.Set_Directory_Mask }

function o_fdtree.get_directory_mask : string;
begin
     get_directory_mask := d_mask;
end; { O_Fdtree.Get_Directory_Mask }

procedure o_fdtree.set_start_directory (st_dir : string);
begin
     st_dir := fexpand (st_dir+'\');
     while (st_dir [length (st_dir)] = '\') do
           delete (st_dir, length (st_dir), 1);
     {endwhile}
(*     if (st_dir [length (st_dir)] = ':')
     then
         st_dir := st_dir + '\';
     {endif}*)
     start_path := st_dir;
end; { O_Fdtree.Set_Start_Directory }

function o_fdtree.get_start_directory : string;
begin
     get_start_directory := start_path;
end; { O_Fdtree.Get_Start_Directory }

procedure o_fdtree.set_fdtree_sens (sens : t_fdtree_sens);
begin
     fdtree_sens := sens;
end; { O_Fdtree.Set_Fdtree_Sens }

function o_fdtree.get_fdtree_sens : t_fdtree_sens;
begin
     get_fdtree_sens := fdtree_sens;
end; { O_Fdtree.Get_Fdtree_Sens }

end. { Fin de l'unit‚ 'U_Fdtree'. }
