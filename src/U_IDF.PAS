unit u_idf;
{
Auteur: Premartin Patrick
Date: 14/09/1991. 16/09/1991. 23/09/1991. 25/06/1992. 14/03/1993.
Langage: Turbo Pascal 6.0

But: Lectures et ecritures sur des fichiers .IDF
}
interface
const
     nb_max_champs = 8;

type
    t_champ = record
                    taille : byte;
                    typ : byte;
                    offset : word;
    end;
    t_tab_champ = array [1..nb_max_champs] of t_champ;

procedure init_idf (var fich : file; var nb_champs : byte; var champs : t_tab_champ);
procedure save_idf_header (var fich : file; var nb_champs : byte; var champs : t_tab_champ);
procedure read_idf (var fich : file; nb_champs : byte; champs : t_tab_champ; enreg : pointer);
procedure write_idf (var fich : file; nb_champs : byte; champs : t_tab_champ; enreg : pointer);
function init_idf_enreg (nb_champs : byte; champs : t_tab_champ) : pointer;
procedure del_idf_enreg (nb_champs : byte; champs : t_tab_champ; var enreg : pointer);
function get_idf_champ (num, nb_champs : byte; champs : t_tab_champ; enreg : pointer) : string;
procedure set_idf_champ (num, nb_champs : byte; champs : t_tab_champ; enreg : pointer; ch : string);

implementation
procedure init_idf (var fich : file; var nb_champs : byte; var champs : t_tab_champ);
begin
     {$i-}
     reset (fich, 1);
     {$i+}
     if (ioresult = 0)
     then
         begin
              {$i-}
              blockread (fich, nb_champs, sizeof (nb_champs));
              blockread (fich, champs, sizeof (t_champ)*nb_champs);
              {$i+}
         end
     else
         nb_champs := 0;
     {endif}
end; { Init_Idf }

procedure save_idf_header (var fich : file; var nb_champs : byte; var champs : t_tab_champ);
var
   nb : word;
begin
     {$i-}
     rewrite (fich, 1);
     {$i+}
     if (ioresult = 0)
     then
         begin
              {$i-}
              blockwrite (fich, nb_champs, sizeof (nb_champs), nb);
              blockwrite (fich, champs, sizeof (t_champ)*nb_champs, nb);
              {$i+}
         end;
     {endif}
end; { Save_Idf_Header }

procedure read_idf (var fich : file; nb_champs : byte; champs : t_tab_champ; enreg : pointer);
var
   i : byte;
   pt : pointer;
begin
     if (enreg <> nil)
     then
         for i := 1 to nb_champs do
             begin
                  pt := ptr (seg (enreg^), ofs (enreg^) + champs [i].offset);
                  {$i-}
                  blockread (fich, pt^, champs [i].taille);
                  {$i+}
             end;
         {endfor}
     {endif}
end; { Read_Idf }

procedure write_idf (var fich : file; nb_champs : byte; champs : t_tab_champ; enreg : pointer);
var
   i : byte;
   pt : pointer;
begin
     if (enreg <> nil)
     then
         for i := 1 to nb_champs do
             begin
                  pt := ptr (seg (enreg^), ofs (enreg^) + champs [i].offset);
                  {$i-}
                  blockwrite (fich, pt^, champs [i].taille);
                  {$i+}
             end;
         {endfor}
     {endif}
end; { Write_Idf }

function init_idf_enreg (nb_champs : byte; champs : t_tab_champ) : pointer;
var
   taille : word;
   i : byte;
   ptr : pointer;
begin
     taille := 0;
     for i := 1 to nb_champs do
         taille := taille + (champs [i].taille);
     {endfor}
     if (maxavail > taille)
     then
         getmem (ptr, taille)
     else
         ptr := nil;
     {endif}
     if (ptr <> nil)
     then
         for i := 1 to nb_champs do
             set_idf_champ (i, nb_champs, champs, ptr, '');
         {endfor}
     {endif}
     init_idf_enreg := ptr;
end; { Init_Idf_Enreg }

procedure del_idf_enreg (nb_champs : byte; champs : t_tab_champ; var enreg : pointer);
var
   taille : word;
   i : byte;
begin
     taille := 0;
     for i := 1 to nb_champs do
         taille := taille + (champs [i].taille);
     {endfor}
     if (enreg <> nil)
     then
         freemem (enreg, taille);
     {endif}
     enreg := nil;
end; { Del_Idf_Enreg }

function get_idf_champ (num, nb_champs : byte; champs : t_tab_champ; enreg : pointer) : string;
var
   i : byte;
   ch : string;
begin
     ch := '';
     if ((enreg <> nil) and (num > 0) and (num <= nb_champs))
     then
         begin
              for i := 0 to champs [num].taille do
                  ch [i] := chr (mem [seg (enreg^): ofs (enreg^)+champs [num].offset+i]);
              {endfor}
         end;
     {endif}
     get_idf_champ := ch;
end; { Get_Idf_Champ }

procedure set_idf_champ (num, nb_champs : byte; champs : t_tab_champ; enreg : pointer; ch : string);
var
   i : byte;
begin
     if ((enreg <> nil) and (num > 0) and (num <= nb_champs))
     then
         begin
              for i := 0 to champs [num].taille do
                  mem [seg (enreg^): ofs (enreg^)+champs [num].offset+i] := ord (ch [i]);
              {endfor}
         end;
     {endif}
end; { Set_Idf_Champ }

end. { Fin de l'unit‚ 'U_Idf'. }
