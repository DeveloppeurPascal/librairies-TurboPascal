unit olf_software;
{
Auteur: Pr‚martin Patrick.
Date: 15/08/1991. 19/08/1991. 22/08/1991. 23/08/1991. 25/08/1991. 26/08/1991.
      27/08/1991. 09/09/1991. 13/11/1991. 27/12/1991. 26/04/1992. 27/07/1992.
      28/07/1992. (Interface Multi-Langues)           30/07/1992. 05/08/1992.
      22/11/1992. 13/12/1992. 30/12/1992. 01/01/1993. 02/01/1993. 22/03/1993.
Langage: Turbo Pascal 6.0
      23/03/1995.
Langage: Borland Pascal 7.0
But: Pr‚sentation des logiciels sous le label Olf_Software.
}
interface
const
     olf_soft_header_1 = #8'Olf Software program: ';{ Ins‚rer le code du
                                                      programme. }
     olf_soft_header_2 = #10#13#10'Never change this file, otherwise, the '
                       + 'program will not run...'#10#13#26#0;

     nb_max_util = 25; { Nombre maximal d'utilisations d'un programme non
                       enregistr‚. }

     mess_nothing = 0;
     mess_freeware = 1;
     mess_shareware = 2;
     mess_careware = 3;
     mess_demo = 4;

     num_dist : longint = 0;
     num_util : longint = 0;
     mess_num : integer = 0;
     editeur : string = '';
     utilisateur : string = '';
     code_prog : string [8] = '        ';
     code_licence : string [8] = '        ';

procedure shareware_careware;
procedure init_licence (ch : string);
procedure init_olf_message (numero : integer);
procedure init_olf_software (soft_name : string; copyright : string);
procedure init_ligne_olf_software (soft_name : string; copyright : string);
procedure aff_olf_message;

implementation
uses
    u_setup,
    crt,
    u_temporisation,
    u_sgf,
    u_code_clavier,
    u_curseur,
    u_msg,
    u_mouse,
    u_parametre,
    u_codage,
    u_scroll;

const
     compteur : longint = 100;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Ce programme est en FREEWARE, copiez le librement...';
        2 : ch := 'Refusez de l''acheter et ne le vendez pas !';
        3 : ch := 'Ce programme est en SHAREWARE, vous pouvez le copier,';
        4 : ch := 'mais si vous l''utilisez, vous devez poss‚der la licence.';
        5 : ch := 'Ce programme est en CAREWARE, vous devez poss‚der la licence d''utilisateur.';
        6 : ch := 'L''argent sera revers‚ … des associations humanitaires...';
        7 : ch := 'Ce programme est une d‚mo, veuillez le distribuer autour de vous...';
        8 : ch := 'Contactez Olf Software pour plus d''informations.';
        9 : ch := 'A l''invite du DOS, tapez READ OLF_F.DOC';
        10 : ch := 'N''oubliez pas de demander la licence pour ce logiciel...';
        11 : ch := 'Distributeur:';
        12 : ch := 'Appuyez sur une touche, S.V.P.';
        13 : ch := 'pr‚sente';
        14 : ch := 'Ce programme est diffus‚ en FREEWARE.';
        15 : ch := 'Ce programme est diffus‚ en SHAREWARE.';
        16 : ch := 'Ce programme est diffus‚ en CAREWARE.';
        17 : ch := 'Ce programme est une d‚mo.';
        18 : ch := 'Ne peut pas lire OLF_SOFT.DAT';
        19 : ch := 'Programme abandonn‚ !!!';
        20 : ch := 'Nombre d''utilisations restantes:';
        21 : ch := 'Ne peut pas ‚crire OLF_SOFT.DAT';
        22 : ch := 'Mauvais fichier OLF_SOFT.DAT';
        23 : ch := 'Fichier trouv‚: ';
        24 : ch := 'Fichier demand‚: ';
        25 : ch := 'Licence utilisateur pour:';
        26 : ch := 'Plus de 25 utilisations sans licence, veuillez y penser...';
        27 : ch := 'Programme non enregistr‚: ';
        28 : ch := 'Ne peut plus fonctionner...';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'This program is FREEWARE, you are authorized to copy it...';
      2 : ch := 'Refuse to buy or sell it !';
      3 : ch := 'This program if SHAREWARE, you can copy it,';
      4 : ch := 'but if you use it, you need the user licence.';
      5 : ch := 'This program is CAREWARE, you need the user licence.';
      6 : ch := 'Money will be given to humanitarian association...';
      7 : ch := 'This is a demo, please distribute it arround you...';
      8 : ch := 'Contact Olf Software for information.';
      9 : ch := 'At the DOS prompt, type READ OLF_GB.DOC';
      10 : ch := 'Do not forget to register this program...';
      11 : ch := 'Dealer:';
      12 : ch := 'Please, press a key...';
      13 : ch := 'presents';
      14 : ch := 'This program is FREEWARE.';
      15 : ch := 'This program is SHAREWARE.';
      16 : ch := 'This program is CAREWARE.';
      17 : ch := 'This program is a DEMO.';
      18 : ch := 'Can not read OLF_SOFT.DAT';
      19 : ch := 'Program aborted !!!';
      20 : ch := 'Run number:';
      21 : ch := 'Can not write OLF_SOFT.DAT';
      22 : ch := 'Bad file OLF_SOFT.DAT';
      23 : ch := 'File found: ';
      24 : ch := 'File asked: ';
      25 : ch := 'User licence to:';
      26 : ch := 'You used this program more than 25 time. Please register...';
      27 : ch := 'Non registred program: ';
      28 : ch := 'Can not run anymore...';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

function upcase_str (ch : string) : string;
var
   i : integer;
begin
     for i := 1 to length (ch) do
         ch [i] := upcase (ch [i]);
     {endfor}
     upcase_str := ch;
end; { Upcase_Str }

procedure shareware_careware;
var
   f : file;
   ch : string;
   n : longint;
   fin : boolean;
begin
  if (code_prog <> code_licence)
  then
    if (code_prog = '31415926')
    then
      fin := true
    else
      begin
        writeln;
        writeln (msg_ch (22));
        writeln (msg_ch (23), code_prog);
        writeln (msg_ch (24), code_licence);
        writeln;
        writeln (msg_ch (19));
        writeln;
        halt (1);
      end
    {endif}
  else
    fin := false;
  {endif}
  if ((num_util = 0) and not fin)
  then
    begin
      writeln;
      writeln (msg_ch (10));
      inc (compteur);
      if (compteur < nb_max_util)
      then
        writeln (msg_ch (20), nb_max_util - compteur)
      else
        compteur := nb_max_util;
      {endif}
      assign (f, get_file_name ('OLF_SOFT.DAT'));
      {$i-}
      rewrite (f, 1);
      {$i+}
      if (ioresult <> 0)
      then
        begin
          writeln;
          writeln (msg_ch (21));
          writeln (msg_ch (19));
          writeln;
          halt (1);
        end;
      {endif}
{ Header }
      ch := olf_soft_header_1+code_prog+olf_soft_header_2;
      blockwrite (f, ch, succ (length (ch)));
{ Num‚ro du distributeur. }
      blockwrite (f, num_dist, sizeof (num_dist));
{ Num‚ro de l'utilisateur. }
      blockwrite (f, num_util, sizeof (num_util));
{ Nom de l'utilisateur. }
      ch := ch_coder (utilisateur);
      blockwrite (f, ch, succ (length (ch)));
{ Compteur. }
      n := meml [$3141:$9265];
      n := (n and $e7fccfcf) + ((compteur and $c0) shl 21)
                             + ((compteur and $30) shl 12)
                             + ((compteur and $c) shl 10)
                             + ((compteur and $3) shl 4);
      blockwrite (f, n, sizeof (n));
{ Code du programme. }
      blockwrite (f, code_prog, 9);
{ Nom de l'‚diteur. }
      ch := ch_coder (editeur);
      blockwrite (f, ch, succ (length (ch)));
      close (f);
    end
  else
    begin
      writeln;
      writeln (msg_ch (25), utilisateur);
    end;
  {endif}
end; { shareware_careware }

procedure traite_param;
begin
  if (param_del ('/BW80'))
  then
      textmode (bw80)
  else
      if (param_del ('/CO80'))
      then
          textmode (co80);
      {endif}
  {endif}
end; { Traite_Param }

procedure init_licence (ch : string);
begin
  code_licence := upcase_str (ch);
end; { Init_Licence }

procedure init_olf_message (numero : integer);
begin
  mess_num := numero;
end; { Init_Olf_Message }

procedure wait_press;
var
   carac : char;
begin
  repeat
  until (mousek = 0);
  while keypressed do
    carac := readkey;
  {endwhile}
  repeat
  until (keypressed or (mousek > 0));
  repeat
  until (mousek = 0);
  while keypressed do
    carac := readkey;
  {endwhile}
end; { Wait_Press }

procedure aff_olf_message;
begin
  textcolor (lightgray);
  textbackground (black);
  clrscr;
  case mess_num of
     mess_freeware : begin
                          writeln (msg_ch (1));
                          writeln (msg_ch (2));
     end;
     mess_shareware : begin
                           writeln (msg_ch (3));
                           writeln (msg_ch (4));
     end;
     mess_careware : begin
                          writeln (msg_ch (5));
                          writeln (msg_ch (6));
     end;
     mess_demo : begin
                      writeln (msg_ch (7));
                      writeln (msg_ch (8));
     end;
  end;
  writeln (msg_ch (9));
  if ((mess_num = mess_shareware) or (mess_num = mess_careware))
  then
    shareware_careware;
  {endif}
  if (length (editeur) > 0)
  then
    begin
         writeln;
         writeln;
         writeln (msg_ch (11), editeur);
    end;
  {endif}
  writeln;
  writeln (msg_ch (12));
  wait_press;
end; { Aff_Olf_Message }

procedure init_olf_software (soft_name : string; copyright : string);
var
   res : word;
   ch : string;
   i,
   j : integer;
   sortie : boolean;
   sens : integer;
   licence : boolean;
   carac : char;
   chaine : string;

procedure aff_licence_number;
var
   ch1,
   ch2 : string;
begin
  if (licence)
  then
    begin
         gotoxy (2, 1);
         clreol;
         gotoxy (succ ((80-length (ch)) div 2), 1);
         write (ch);
    end
  else
    begin
         gotoxy (2, 1);
         clreol;
         str (num_dist, ch2);
         ch1 := concat ('Licence: ', ch2, code_prog);
         str (num_util, ch2);
         ch1 := concat (ch1, ch2);
         gotoxy (succ ((80-length (ch1)) div 2), 1);
         write (ch1);
    end;
  {endif}
  licence := not (licence);
  sortie := false;
end; { aff_licence_number }

begin
  licence := not (param_del ('/LICENCE'));
  curseur_off;
  hide_mouse;
  ch := '   *#* Olf Software *#*   ';
  textcolor (lightgray);
  textbackground (black);
  clrscr;
  aff_licence_number;
  gotoxy (35, 10);
  writeln ('Olf Software');
  gotoxy (37, 12);
  writeln (msg_ch (13));
  textcolor (lightgray + blink);
  gotoxy (succ ((80-length (soft_name)) div 2), 15);
  writeln (Soft_Name);
  textcolor (lightgray);
  if (length (editeur) > 0)
  then
    begin
         chaine := concat (msg_ch (11), editeur);
         gotoxy (succ ((80-length (chaine)) div 2), 5);
         writeln (chaine);
    end;
  {endif}
  gotoxy (succ ((80-length (copyright)) div 2), 22);
  writeln (copyright);
  res := 0;
  i := 1;
  j := 0;
  sortie := false;
  sens := scr_left;
  temporisation_init;
  while not (sortie or (mousek > 0) or (res <> 0)) do
      begin
           inc (j);
           if (j = 3)
           then
               begin
                    j := 0;
                    res := scroll_txt (2, 1, 78, 1, sens);
               end;
           {endif}
           res := res + scroll_txt (1, 1, 1, 10, scr_down);
           delay (5);
           res := res + scroll_txt (1, 10, 20, 1, scr_right);
           delay (5);
           res := res + scroll_txt (20, 10, 1, 11, scr_down);
           delay (5);
           res := res + scroll_txt (1, 20, 20, 1, scr_left);
           delay (5);
           res := res + scroll_txt (1, 20, 1, 5, scr_down);
           delay (5);
           res := res + scroll_txt (1, 24, 80, 1, scr_right);
           delay (5);
           res := res + scroll_txt (80, 20, 1, 5, scr_up);
           delay (5);
           res := res + scroll_txt (61, 20, 20, 1, scr_left);
           delay (5);
           res := res + scroll_txt (61, 10, 1, 11, scr_up);
           delay (5);
           res := res + scroll_txt (61, 10, 20, 1, scr_right);
           delay (5);
           res := res + scroll_txt (80, 1, 1, 10, scr_up);
           delay (5);
           gotoxy (1, 1);
           write (ch [i]);
           if (i < length (ch))
           then
               inc (i)
           else
               begin
                    i := 1;
                    case sens of
                         scr_left : sens := scr_right;
                         scr_right : sens := scr_left;
                    end;
               end;
           {endif}
           sortie := keypressed;
           if (sortie)
           then
               if (readkey = carac_nul)
               then
                   if (readkey = touche_f10)
                   then
                       aff_licence_number;
                   {endif}
               {endif}
           {endif}
           temporisation;
      end;
  {endwhile}
  aff_olf_message;
  clrscr;
  curseur_on;
  show_mouse;
end; { Init_Olf_Software }

procedure init_ligne_olf_software (soft_name : string; copyright : string);
var
   carac : char;
begin
  curseur_off;
  hide_mouse;
  textcolor (lightgray);
  textbackground (black);
  writeln ('Olf Software ', msg_ch (13), ' ', soft_name);
  writeln (copyright);
  case mess_num of
     mess_freeware : writeln (msg_ch (14));
     mess_shareware : writeln (msg_ch (15));
     mess_careware : writeln (msg_ch (16));
     mess_demo : writeln (msg_ch (17));
  end;
  writeln;
  if (length (editeur) > 0)
  then
    begin
         writeln (msg_ch (11), editeur);
         writeln;
    end;
  {endif}
  if ((mess_num = mess_shareware) or (mess_num = mess_careware))
  then
    shareware_careware;
  {endif}
  if (param_del ('/LICENCE'))
  then
    begin
         writeln ('Licence: ', num_dist, code_prog, num_util);
         writeln (msg_ch (12));
         wait_press;
         gotoxy (1, wherey-2);
         clreol;
         writeln;
         clreol;
         gotoxy (1, pred (wherey));
    end;
  {endif}
  curseur_on;
  show_mouse;
end; { Init_Ligne_Olf_Software }

procedure load_olf_soft_dat;
var
   f : file;
   ch : string;
   n : longint;
begin
  ch := get_file_name('OLF_SOFT.DAT');
  assign (f, ch);
  {$i-}
  reset (f, 1);
  {$i+}
  if (ioresult <> 0)
  then
    begin
      writeln;
      writeln (msg_ch (18));
      writeln (msg_ch (19));
      writeln;
      halt (1);
    end;
  {endif}
{ Header. }
  blockread (f, ch [0], 1);
  if (ord (ch [0]) > 0)
  then
    blockread (f, ch [1], ord (ch [0]));
  {endif}
{ Num‚ro du distributeur. }
  blockread (f, num_dist, sizeof (num_dist));
{ Num‚ro de l'utilisateur enregistr‚. }
  blockread (f, num_util, sizeof (num_util));
{ Nom de l'utilisateur. }
  blockread (f, ch [0], 1);
  if (ord (ch [0]) > 0)
  then
    blockread (f, ch [1], ord (ch [0]));
  {endif}
  utilisateur := ch_decoder (ch);
{ Compteur. }
  blockread (f, n, sizeof (n));
  compteur := ((n and $18000000) shr 21) + ((n and $30000) shr 12)
            + ((n and $3000) shr 10) + ((n and $30) shr 4);
{ Code du programme. }
  blockread (f, code_prog, 9);
{ Nom du distributeur. }
  blockread (f, ch [0], 1);
  if (ord (ch [0]) > 0)
  then
    blockread (f, ch [1], ord (ch [0]));
  {endif}
  editeur := ch_decoder (ch);
  close (f);
  if (compteur > nb_max_util)
  then
    begin
      writeln (msg_ch (27), code_prog);
      writeln (msg_ch (28));
      writeln (msg_ch (10));
      writeln;
      halt (1);
    end;
  {endif}
end; { load_olf_soft_dat }

begin
     checkbreak := false;
     c_codage_1 := 246;
     c_codage_2 := $16;
     load_olf_soft_dat;
     traite_param;
end.
