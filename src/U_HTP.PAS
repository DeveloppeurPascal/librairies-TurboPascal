unit u_htp;
{
Auteur: Patrick Premartin
Date: 27/12/1991.
      28/12/1991.
      06/01/1992.
      27/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion d'une page d'‚cran utilis‚e par 'Hyper Text Maker'.
}
interface
const
     max_lig = 20;
     max_col = 80;

type
    t_ecran = array [1..max_lig, 1..max_col] of char;
    t_ecr_list = array [1..max_lig*max_col] of char;
    p_page = ^t_page;
    t_page = record
                   case boolean of
                        true: (tab : t_ecran);
                        false : (list : t_ecr_list);
    end;


function htp_init : p_page;
function htp_load (fich_name : string) : p_page;
procedure htp_save (fich_name : string; page : p_page);

implementation
uses
    u_codage,
    u_pack,
    u_sgf;

function htp_init : p_page;
var
   res : p_page;
   i : word;
begin
     getmem (res, sizeof (t_page));
     if (res <> nil)
     then
         for i := 1 to max_col*max_lig do
             res^.list [i] := ' ';
         {endfor}
     {endif}
     htp_init := res;
end; { Htp_Init }

function htp_load (fich_name : string) : p_page;
var
   res,
   res2 : p_page;
   tampon : p_page;
   fich : file of char;
   j : word;
begin
     c_codage_1 := $07;
     c_codage_2 := $70;
     res := nil;
     met_extension (fich_name, '.HTP', fich_name);
     assign (fich, fich_name);
     {$i-}
     reset (fich);
     {$i+}
     if (ioresult = 0)
     then
         begin
              getmem (tampon, filesize (fich));
              j := 1;
              if (tampon <> nil)
              then
                  begin
                       while not (eof (fich)) do
                             begin
                                  read (fich, tampon^.list [j]);
                                  inc (j);
                             end;
                       {endwhile}
                       ptr_decoder (tampon, pred (j));
                       unpack (tampon, pointer (res), j);
                       new (res2);
                       if (res2 <> nil)
                       then
                           begin
                                move (res^, res2^, sizeof (res2^));
                                dispose (res);
                                new (res);
                                move (res2^, res^, sizeof (res^));
                                dispose (res2);
                           end;
                       {endif}
                  end;
              {endif}
              freemem (tampon, filesize (fich));
              close (fich);
         end
     else
         res := htp_init;
     {endif}
     htp_load := res;
end; { Htp_Load }

procedure htp_save (fich_name : string; page : p_page);
var
   tampon : p_page;
   fich : file of char;
   i, j : word;
begin
     c_codage_1 := $07;
     c_codage_2 := $70;
     if (page <> nil)
     then
         begin
              pack (page, sizeof (t_page), pointer (tampon), j);
              ptr_coder (tampon, succ (j));
              met_extension (fich_name, '.HTP', fich_name);
              assign (fich, fich_name);
              {$i-}
              rewrite (fich);
              {$i+}
              if (ioresult = 0)
              then
                  begin
                       i := 1;
                       while (i <= j) do
                             begin
                                  write (fich, tampon^.list [i]);
                                  inc (i);
                             end;
                       {endwhile}
                       close (fich);
                  end;
              {endif}
              freemem (tampon, j);
         end;
     {endif}
end; { Htp_Save }

end. { Fin de l'unit‚ 'U_Htp' }
