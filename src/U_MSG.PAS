unit u_msg;
{
Auteur: Patrick Pr‚martin.
Date: 21/07/1992. 24/07/1992. 27/07/1992. 28/07/1992. 29/07/1992. 30/07/1992.
      05/08/1992. 03/07/1993.
Langage: Turbo Pascal 6.0
      19/09/1993, Borland Pascal 7.0
But: Gestion des fichiers d'extension MSG contenant les textes multi-lingues
     pour les nouveaux logiciels Olf Software.

     La langue par d‚faut est le Fran‡ais.
}

interface
const
     header_msg = #8'Olf Software Multi-Language Interface.'#10#13#26#0;

     msg_f = 1; { Messages en Fran‡ais. }
     msg_gb = 2; { Messages en Anglais. }
     msg_d = 4; { Messages en Allemand. }
     msg_i = 8; { Messages en Italien. }

     nom_fich_msg : string = '';
     langue_autorisee : longint = 0;
     langue_utilisee : longint = msg_f;
     langue_par_defaut : longint = msg_f;

procedure init_msg (name : string);
{ Chargement du fichier des messages, et s‚lection de la langue en cours. }

function get_msg (num : word) : string;
{ Renvoie la chaŒne contenant le message NUM. }

function set_langue (num : longint) : boolean;
{ Chargement de la langue par le programme, retourne TRUE si fichier de messages
contient cette langue. }

function get_nb_msg : word;
{ Renvoie le nombre de messages stock‚s. }

implementation
uses
    u_sgf,
    u_parametre;

const
     msg_buf : pointer = nil;
     taille_msg : word = 0;
     nb_msg : word = 0;

procedure init_msg (name : string);
var
   n : longint;
   f : file;
   ch : string;
begin
     if (msg_buf <> nil)
     then
         freemem (msg_buf, taille_msg);
     {endif}
     msg_buf := nil;
     taille_msg := 0;
     nb_msg := 0;
     langue_autorisee := 0;
     if (langue_utilisee = 0)
     then
         langue_utilisee := langue_par_defaut;
     {endif}
     if (get_nom_fichier2 (name) = '')
     then
         exit;
     {endif}
     met_extension (name, 'MSG', name);
     nom_fich_msg := name;
     assign (f, name);
     {$i-}
     reset (f, 1);
     {$i+}
     if (ioresult <> 0)
     then
         begin
              writeln ('I cannot read the MSG Interface...');
              erreur (ioresult);
              halt (1);
         end;
     {endif}
{ Lecture du header... }
     blockread (f, ch [0], sizeof (char));
     blockread (f, ch [1], length (ch));
{ Lecture des diff‚rentes langues accept‚es... }
     blockread (f, langue_autorisee, sizeof (langue_autorisee));
     if ((langue_autorisee and langue_utilisee) = 0)
     then
         begin
              nb_msg := 0;
              repeat
                    langue_utilisee := 1 shl nb_msg;
                    inc (nb_msg);
              until ((langue_utilisee and langue_autorisee) > 0);
         end;
     {endif}
{ Lecture des messages correspondants … la langue actuelle. }
     repeat
           if (msg_buf <> nil)
           then
               freemem (msg_buf, taille_msg);
           {endif}
           blockread (f, n, sizeof (n)); { Langue du bloc courant. }
           blockread (f, taille_msg, sizeof (taille_msg)); { Nb_Octets avant le
                                                             prochain bloc. }
           blockread (f, nb_msg, sizeof (nb_msg)); { Nb Messages. }
           getmem (msg_buf, taille_msg);
           if (msg_buf = nil)
           then
               begin
                    writeln ('Not enough memory to load MSG Interface...');
                    halt (1);
               end;
           {endif}
           blockread (f, msg_buf^, taille_msg);
     until (langue_utilisee = n);
     close (f);
end; { init_msg }

function get_msg (num : word) : string;
var
   ch : string;
   i : word;
   j : byte;
begin
     if ((num > nb_msg) or (msg_buf = nil) or (num = 0))
     then
         ch := ''
     else
         begin
              i := 0;
              j := 1;
              while (j < num) do
                    begin
                         inc (j);
                         i := i+succ (byte (ptr (seg (msg_buf^), i+ofs (msg_buf^))^));
                    end;
              {endwhile}
              for j := 0 to byte (ptr (seg (msg_buf^), i+ofs (msg_buf^))^) do
                  ch [j] := char (ptr (seg (msg_buf^), j+i+ofs (msg_buf^))^);
              {endfor}
         end;
     {endif}
     get_msg := ch;
end; { get_msg }

function set_langue (num : longint) : boolean;
begin
     if (((langue_autorisee and num) > 0) or (langue_autorisee = 0))
     then
         if (num = langue_utilisee)
         then
             set_langue := true
         else
             begin
                  langue_utilisee := num;
                  init_msg (nom_fich_msg);
                  set_langue := (langue_utilisee = num);
             end
         {endif}
     else
         set_langue := false;
     {endif}
end; { set_langue }

function get_nb_msg : word;
begin
     get_nb_msg := nb_msg;
end; { get_nb_msg }

var
   old_exitproc : pointer;

procedure msg_exit; far;
begin
     if (msg_buf <> nil)
     then
         freemem (msg_buf, taille_msg);
     {endif}
     msg_buf := nil;
     exitproc := old_exitproc;
end; { msg_exit }

begin
     old_exitproc := exitproc;
     exitproc := @msg_exit;
     if (param_del ('/FRANCAIS'))
     then
         langue_utilisee := msg_f
     else
         if (param_del ('/ENGLISH'))
         then
             langue_utilisee := msg_gb
         else
             if (param_del ('/DEUTSCH'))
             then
                 langue_utilisee := msg_d
             else
                 if (param_del ('/ITALIAN'))
                 then
                     langue_utilisee := msg_i;
                 {endif}
             {endif}
         {endif}
     {endif}
end.
