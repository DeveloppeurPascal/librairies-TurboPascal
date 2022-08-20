unit u_file;
{
Auteur: Pr‚martin Patrick
Date: 01/09/1991.
      09/09/1991.
Langage: Turbo Pascal 6.0
But: Proc‚dures et fonctions diverses de traitement des fichiers.
}
interface
function copy_file (f_source, f_dest : string) : boolean;
function move_file (f_source, f_dest : string) : boolean;

implementation
function copy_file (f_source, f_dest : string) : boolean;
var
   sf,
   df : file;
   nb_read,
   nb_write : word;
   nb_free : longint;
   buffer : pointer;
   result : boolean;
begin
     nb_free := maxavail;
     if (nb_free > 65000)
     then
         nb_free := 65000;
     {endif}
     getmem (buffer, nb_free);
     assign (sf, f_source);
     {$i-}
     Reset (sf, 1);
     {$i+}
     result := (ioresult = 0);
     if (result)
     then
         begin
              Assign (df, f_dest);
              {$i-}
              Rewrite (df, 1);
              {$i+}
              result := (ioresult = 0);
              if (result)
              then
                  begin
                       repeat
                             BlockRead (sf, buffer^, nb_free, nb_read);
                             BlockWrite (df, buffer^, nb_read, nb_write);
                       until ((nb_read = 0) OR (nb_read <> nb_write));
                       result := (nb_read = 0);
                       Close (df);
                       if not result
                       then
                           erase (df);
                       {endif}
                  end;
              {endif}
              Close (sf);
         end;
     {endif}
     freemem (buffer, nb_free);
     copy_file := result;
end; { Copy_File }

function move_file (f_source, f_dest : string) : boolean;
var
   result : boolean;
   fs : file;
begin
     result := copy_file (f_source, f_dest);
     if result
     then
         begin
              assign (fs, f_source);
              {$i-}
              erase (fs);
              {$i+}
              result := (ioresult = 0);
         end;
     {endif}
     move_file := result;
end; { Move_File }

end. { Fin de l'unit‚ 'U_File'. }
