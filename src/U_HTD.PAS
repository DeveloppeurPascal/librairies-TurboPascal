unit u_htd;
{
Auteur: Patrick Premartin
Date: 27/12/1991. 28/12/1991. 06/01/1992. 26/06/1992.
      28/07/1992. (Interface Multi-Langues)           03/08/1992. 05/08/1992.
      10/01/1993. 23/01/1993.
Langage: Turbo Pascal 6.0
But: Gestion des fichiers .HTD (donn‚es de 'Hyper Text Maker').
}
interface
uses
    u_htp;

const
     max_ecran = 1000;
     c_ch_header = #8'Hyper Text Maker 1.0'#10#13#155' Patrick Pr‚martin 12/1991.'#26;

type
    t_str8 = string [8];

    t_effet = record
                    go_to : word;
    end;

    p_bouton = ^o_bouton;
    o_bouton = object
                     x, y, l : word;
                     effet : t_effet;
                     go_to_name : t_str8; { Renseign‚ uniquement si EFFET.GO_TO = 0 }
                     next : p_bouton;

                     constructor init;
                     constructor load (fich : integer);
                     destructor done;
                     procedure save (fich : integer);
                     procedure active; virtual;
                     procedure unactive; virtual;
                     procedure unactive_all;
                     function suivant : p_bouton;
    end;

    p_txt = ^o_txt;
    o_txt = object
                  ecran : p_page;
                  fich_name : t_str8;

                  constructor init;
                  constructor load (fich : integer);
                  destructor done;
                  procedure save (fich : integer);
                  procedure draw;
    end;

    p_ecran = ^o_ecran;
    o_ecran = object
                    liste_bouton : p_bouton;
                    txt : p_txt;
                    couleur : byte;

                    constructor init;
                    constructor load (fich : integer);
                    destructor done;
                    procedure save (fich : integer);
                    procedure draw;
                    function run (num : word) : word;
                    procedure help_screen;
    end;

    p_lst_ecran = ^t_lst_ecran;
    t_lst_ecran = array [1..max_ecran] of p_ecran;

    p_hyper_text = ^o_hyper_text;
    o_hyper_text = object
                         ht : t_lst_ecran;
                         debut : word;
                         ch : string;

                         constructor init;
                         constructor load (nom_fich : string);
                         destructor done;
                         procedure save (nom_fich : string);
                         procedure run;
                         function test : boolean;
                         function rech_num_name : word;
    end;

var
   label_ht : t_str8;

implementation
uses
    crt,
    u_codage,
    u_code_clavier,
    u_m_util,
    u_m_zone,
    u_pack,
    u_pile,
    u_msg,
    u_cache_disk,
    u_sgf;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Plus assez de m‚moire...';
        2 : ch := 'Programme plant‚ !';
        3 : ch := 'Imprimer cet ‚cran ?';
        4 : ch := 'Voulez-vous quitter ?';
        5 : ch := 'Ecran d''aide.';
        6 : ch := 'affiche cet ‚cran.';
        7 : ch := 'pour imprimer l''‚cran.';
        8 : ch := 'retourne … l''‚cran pr‚c‚dent.';
        9 : ch := 'quitte l''Hyper Texte.';
        10 : ch := 'change de zone.';
        11 : ch := 'valide la s‚lection.';
        12 : ch := 'positionne sur la premiŠre zone.';
        13 : ch := 'positionne sur la derniŠre zone.';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Out of memory...';
      2 : ch := 'I can not continue !';
      3 : ch := 'Print this screen ?';
      4 : ch := 'Do you want to quit ?';
      5 : ch := 'Help Screen.';
      6 : ch := 'display this screen.';
      7 : ch := 'to print the screen.';
      8 : ch := 'back to previous screen.';
      9 : ch := 'exit the Hyper Text.';
      10 : ch := 'change selected field.';
      11 : ch := 'confirm selection.';
      12 : ch := 'select first field.';
      13 : ch := 'select last field.';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

var
   ht_couleur : byte;
   ht_user : boolean;
   pile : p_pile;
   zone : p_m_zone;

procedure out_of_memory;
begin
     alert (msg_ch (1), al_error);
     alert (msg_ch (2), al_error);
     halt (1);
end; { Out_Of_Memory }

{****************************************************************************}

{ Objet : O_Bouton }
constructor o_bouton.init;
begin
     x := 1;
     y := 1;
     l := 0;
     effet.go_to := 0;
     go_to_name := '        ';
     next := nil;
end; { O_Bouton.Init }

constructor o_bouton.load (fich : integer);
begin
     lit_bloc (fich, x, sizeof (x));
     lit_bloc (fich, y, sizeof (y));
     lit_bloc (fich, l, sizeof (l));
     lit_bloc (fich, effet, sizeof (effet));
     if (effet.go_to = 0)
     then
       lit_bloc (fich, go_to_name, sizeof (go_to_name));
     {endif}
     lit_bloc (fich, next, sizeof (next));
     if (next <> nil)
     then
         next := new (p_bouton, load (fich));
     {endif}
end; { O_Bouton.Load }

destructor o_bouton.done;
begin
     if (next <> nil)
     then
         dispose (next, done);
     {endif}
end; { O_Bouton.Done }

procedure o_bouton.save (fich : integer);
begin
     ecrit_bloc (fich, x, sizeof (x));
     ecrit_bloc (fich, y, sizeof (y));
     ecrit_bloc (fich, l, sizeof (l));
     ecrit_bloc (fich, effet, sizeof (effet));
     if (effet.go_to = 0)
     then
       ecrit_bloc (fich, go_to_name, sizeof (go_to_name));
     {endif}
     ecrit_bloc (fich, next, sizeof (next));
     if (next <> nil)
     then
         next^.save (fich);
     {endif}
end; { O_Bouton.Save }

procedure o_bouton.active;
var
   nx, ny : byte;
   nc : char;
   i : word;
begin
     nx := x;
     ny := y;
     if ht_user
     then
         inc (ny, 2);
     {endif}
     for i := 1 to l do
         begin
              gotoxy (nx, ny);
              asm
                 push ax
                 push bx
                 push dx
                 mov ah, 08h
                 mov bh, 0
                 int 10h
                 mov nc, al
                 pop dx
                 pop bx
                 pop ax
              end;
              textattr := ((ht_couleur and $0f) shl 4) + ((ht_couleur and $f0) shr 4); { Inverse video }
              gotoxy (nx, ny);
              write (nc);
              inc (nx);
              if (nx > max_col)
              then
                  begin
                       nx := 1;
                       inc (ny);
                       if (ny > max_lig)
                       then
                           ny := 1;
                       {endif}
                  end;
              {endif}
         end;
     {endfor}
end; { O_Bouton.Active }

procedure o_bouton.unactive;
var
   nx, ny : byte;
   nc : char;
   i : word;
begin
     nx := x;
     ny := y;
     if (ht_user)
     then
         inc (ny, 2);
     {endif}
     for i := 1 to l do
         begin
              gotoxy (nx, ny);
              asm
                 push ax
                 push bx
                 push dx
                 mov ah, 08h
                 mov bh, 0
                 int 10h
                 mov nc, al
                 pop dx
                 pop bx
                 pop ax
              end;
              textattr := ht_couleur xor $08; { Mise en surbrillance }
              gotoxy (nx, ny);
              write (nc);
              inc (nx);
              if (nx > max_col)
              then
                  begin
                       nx := 1;
                       inc (ny);
                       if (ny > max_lig)
                       then
                           ny := 1;
                       {endif}
                  end;
              {endif}
         end;
     {endfor}
end; { O_Bouton.Unactive }

procedure o_bouton.unactive_all;
begin
     unactive;
     if (next <> nil)
     then
       next^.unactive_all
     else
       if (zone <> nil)
       then
         begin
           dispose (zone, done);
           zone := new (p_m_zone, init);
         end;
       {endif}
     {endif}
     if (zone <> nil)
     then
       if (ht_user)
       then
         zone^.add_zone2 (x, y+2, l, true, carac_nul)
       else
         zone^.add_zone2 (x, y, l, true, carac_nul);
       {endif}
     {endif}
end; { O_Bouton.Unactive_All }

function o_bouton.suivant : p_bouton;
begin
     unactive;
     suivant := next;
end; { O_Bouton.Suivant }

{****************************************************************************}

{ Objet: O_Txt }
constructor o_txt.init;
begin
     ecran := nil;
end; { O_Txt.Init }

constructor o_txt.load (fich : integer);
var
   nb_txt,
   nb_res : word;
   res : pointer;
begin
     lit_bloc (fich, fich_name, sizeof (fich_name));
     lit_bloc (fich, nb_res, sizeof (nb_res));
     getmem (res, nb_res);
     if (res = nil)
     then
         out_of_memory;
     {endif}
     lit_bloc (fich, res^, nb_res);
     c_codage_1 := $07;
     c_codage_2 := $70;
     ptr_decoder (res, nb_res);
     if (nb_res < sizeof (t_page))
     then
         begin
              unpack (res, pointer (ecran), nb_txt);
              freemem (res, nb_res);
         end
     else
         ecran := res;
     {endif}
end; { O_Txt.Load }

destructor o_txt.done;
begin
     if (ecran <> nil)
     then
         freemem (ecran, sizeof (ecran^));
     {endif}
end; { O_Txt.Done }

procedure o_txt.save (fich : integer);
var
   nb_res : word;
   res : pointer;
begin
     ecrit_bloc (fich, fich_name, sizeof (fich_name));
     pack (ecran, sizeof (ecran^), res, nb_res);
     c_codage_1 := $07;
     c_codage_2 := $70;
     ptr_coder (res, nb_res);
     ecrit_bloc (fich, nb_res, sizeof (nb_res));
     ecrit_bloc (fich, res^, nb_res);
     freemem (res, nb_res);
end; { O_Txt.Save }

procedure o_txt.draw;
var
   i,
   j : byte;
begin
     textattr := ht_couleur;
     clrscr;
     if (ht_user)
     then
       begin
         writeln;
         for i := 1 to max_col do
           write (#31);
         {endfor}
         gotoxy (1, 3);
       end
     else
       gotoxy (1, 1);
     {endif}
     for j := 1 to max_lig do
       for i := 1 to max_col do
         write (ecran^.tab [j, i]);
       {endfor}
     {endfor}
     if (ht_user)
     then
       for i := 1 to max_col do
         write (#30);
       {endfor}
     {endif}
end; { O_Txt.Draw }

{****************************************************************************}

{ Objet: O_Ecran }
constructor o_ecran.init;
begin
     liste_bouton := nil;
     txt := nil;
     couleur := $07;
end; { O_Ecran.Init }

constructor o_ecran.load (fich : integer);
begin
     lit_bloc (fich, couleur, sizeof (couleur));
     txt := new (p_txt, load (fich));
     lit_bloc (fich, liste_bouton, sizeof (liste_bouton));
     if (liste_bouton <> nil)
     then
         liste_bouton:= new (p_bouton, load (fich));
     {endif}
end; { O_Ecran.Load }

destructor o_ecran.done;
begin
     if (txt <> nil)
     then
         dispose (txt);
     {endif}
     if (liste_bouton <> nil)
     then
         dispose (liste_bouton, done);
     {endif}
end; { O_Ecran.Done }

procedure o_ecran.save (fich : integer);
begin
     ecrit_bloc (fich, couleur, sizeof (couleur));
     txt^.save (fich);
     ecrit_bloc (fich, liste_bouton, sizeof (liste_bouton));
     if (liste_bouton <> nil)
     then
         liste_bouton^.save (fich);
     {endif}
end; { O_Ecran.Save }

procedure o_ecran.draw;
var
   i, j : byte;
begin
     ht_couleur := couleur;
     if (txt <> nil)
     then
         txt^.draw;
     {endif}
     if (liste_bouton <> nil)
     then
       begin
         liste_bouton^.unactive_all;
         liste_bouton^.active;
       end;
     {endif}
end; { O_Ecran.Draw }

function o_ecran.run (num : word): word;
var
   b,
   bouton_courant : p_bouton;
   carac : char;
   res : word;
   code_nul,
   quit : boolean;
begin
     draw;
     bouton_courant := liste_bouton;
     quit := false;
     res := 0;
     repeat
       if (zone <> nil)
       then
         zone^.test_souris (code_nul, carac)
       else
         begin
           carac := readkey;
           code_nul := (carac = carac_nul);
           if (code_nul)
           then
             carac := readkey;
           {endif}
         end;
       {endif}
       if (code_nul)
       then
         case carac of
           carac_nul :
             begin
               if (ht_user)
               then
                 dec (pos_m_y, 2);
               {endif}
               b := liste_bouton;
               while ((b <> nil)
                     and ((b^.l+(b^.x-pos_m_x)+((b^.y-pos_m_y)*max_col) > b^.l)
                     or (b^.l+(b^.x-pos_m_x)+((b^.y-pos_m_y)*max_col) < 0))) do
                 b := b^.next;
               {endwhile}
               if (b <> nil)
               then
                 begin
                   res := b^.effet.go_to;
                   if (res = 0)
                   then
                     label_ht := b^.go_to_name;
                   {endif}
                   if (pile <> nil)
                   then
                     pile^.push (num);
                   {endif}
                   quit := true;
                 end;
               {endif}
             end;
           touche_f1 :
             begin
               help_screen;
               draw;
               if (liste_bouton <> nil)
               then
                 begin
                   liste_bouton^.unactive_all;
                   bouton_courant^.active;
                 end;
               {endif}
             end;
           touche_f5 :
             if confirm (msg_ch (3))
             then
               asm
                 int 05h
               end;
             {endif}
           touche_alt_f1 :
             begin
               if (pile <> nil)
               then
                 res := pile^.pop;
               {endif}
               if (res <> maxint)
               then
                 quit := true;
               {endif}
             end;
           touche_home :
             if (liste_bouton <> nil)
             then
               begin
                 bouton_courant^.unactive;
                 bouton_courant := liste_bouton;
                 bouton_courant^.active;
               end;
             {endif}
           touche_end :
             if (liste_bouton <> nil)
             then
               begin
                 bouton_courant^.unactive;
                 while (bouton_courant^.next <> nil) do
                   bouton_courant := bouton_courant^.next;
                 {endwhile}
                 bouton_courant^.active;
               end;
             {endif}
           touche_shift_tab :
             if (bouton_courant <> nil)
             then
               begin
                 bouton_courant^.unactive;
                 if (bouton_courant = liste_bouton)
                 then
                   while (bouton_courant^.next <> nil) do
                     bouton_courant := bouton_courant^.next
                   {endwhile}
                 else
                   begin
                     b := liste_bouton;
                     while (b^.next <> bouton_courant) do
                       b := b^.next;
                     {endwhile}
                     bouton_courant := b;
                   end;
                 {endif}
                 bouton_courant^.active;
               end;
             {endif}
         end
       else
         case carac of
           touche_escape :
             if confirm (msg_ch (4))
             then
               begin
                 res  := 0;
                 quit := true;
               end;
             {endif}
           touche_return :
             begin
               if (bouton_courant <> nil)
               then
                 begin
                   res := bouton_courant^.effet.go_to;
                   if (res = 0)
                   then
                     label_ht := b^.go_to_name;
                   {endif}
                 end
               else
                 res := 0;
               {endif}
               if (pile <> nil)
               then
                 pile^.push (num);
               {endif}
               quit := true;
             end;
           touche_tab :
             if (bouton_courant <> nil)
             then
               begin
                 bouton_courant^.unactive;
                 bouton_courant := bouton_courant^.suivant;
                 if (bouton_courant = nil)
                 then
                   bouton_courant := liste_bouton;
                 {endif}
                 bouton_courant^.active;
               end;
             {endif}
           touche_backspace :
             if (bouton_courant <> nil)
             then
               begin
                 bouton_courant^.unactive;
                 if (bouton_courant = liste_bouton)
                 then
                   while (bouton_courant^.next <> nil) do
                     bouton_courant := bouton_courant^.next
                   {endwhile}
                 else
                   begin
                     b := liste_bouton;
                     while (b^.next <> bouton_courant) do
                       b := b^.next;
                     {endwhile}
                     bouton_courant := b;
                   end;
                 {endif}
                 bouton_courant^.active;
               end;
             {endif}
         end;
       {endif}
     until quit;
     textattr := $07;
     clrscr;
     run := res;
end; { O_Ecran.Run }

procedure o_ecran.help_screen;
begin
  textattr := ht_couleur;
  clrscr;
  textattr := textattr + blink;
  writeln ('                 Hyper Text Maker: ', msg_ch (5));
  textattr := textattr - blink;
  writeln;
  writeln;
  writeln (' F1 ', msg_ch (6));
  writeln (' F5 ', msg_ch (7));
  writeln (' Alt-F1 ', msg_ch (8));
  writeln;
  writeln ('ESC ', msg_ch (9));
  writeln ('TAB, BACKSPACE ', msg_ch (10));
  writeln ('RETURN ', msg_ch (11));
  writeln ('HOME ', msg_ch (12));
  writeln ('END ', msg_ch (13));
  alert ('', al_wait);
end; { o_ecran.help_screen }

{****************************************************************************}

{ Objet: O_Hyper_Text }
constructor o_hyper_text.init;
var
   i : word;
begin
     debut := 0;
     for i := 1 to max_ecran do
         ht [i] := nil;
     {endfor}
end; { O_Hyper_Text.Init }

constructor o_hyper_text.load (nom_fich : string);
var
   i : word;
   fich : integer;
begin
     met_extension (nom_fich, '.HTD', nom_fich);
     fich := ouvre (nom_fich, lecture);
     if (erreur_io <> 0)
     then
         init
     else
         begin
              lit_bloc (fich, ch [0], 1);
              lit_bloc (fich, ch [1], ord (ch [0]));
              lit_bloc (fich, debut, sizeof (debut));
              i := 1;
              while not (i > max_ecran) do
                    begin
                         ht [i] := nil;
                         inc (i);
                    end;
              {endwhile}
              while not (fin_fich (fich)) do
                    begin
                         lit_bloc (fich, i, sizeof (i));
                         ht [i] := new (p_ecran, load (fich));
                    end;
              {endwhile}
              ferme (fich);
         end;
     {endif}
end; { O_Hyper_Text.Load }

destructor o_hyper_text.done;
var
   i : word;
begin
     for i := 1 to max_ecran do
         if (ht [i] <> nil)
         then
             dispose (ht [i], done);
         {endif}
     {endfor}
end; { O_Hyper_Text.Done }

procedure o_hyper_text.save (nom_fich : string);
var
   i : word;
   fich : integer;
begin
     ch := c_ch_header;
     met_extension (nom_fich, '.HTD', nom_fich);
     cree_bak (nom_fich);
     fich := ouvre (nom_fich, ecriture);
     if (erreur_io = 0)
     then
         begin
              ecrit_bloc (fich, ch, succ (length (ch)));
              ecrit_bloc (fich, debut, sizeof (debut));
              for i := 1 to max_ecran do
                  if (ht [i] <> nil)
                  then
                      begin
                           ecrit_bloc (fich, i, sizeof (i));
                           ht [i]^.save (fich);
                      end;
                  {endif}
              {endfor}
              ferme (fich);
         end;
     {endif}
end; { O_Hyper_Text.Save }

procedure o_hyper_text.run;
var
   ecran_courant : word;
begin
     ht_user := true;
     ecran_courant := debut;
     if (pile <> nil)
     then
         pile^.reset;
     {endif}
     if (test)
     then
         while ((ecran_courant <> 0) and (ht [ecran_courant] <> nil)) do
           begin
             label_ht := '';
             ecran_courant := ht [ecran_courant]^.run (ecran_courant);
             if (ecran_courant = 0)
             then
               ecran_courant := rech_num_name;
             {endif}
           end;
         {endwhile}
     {endif}
     ht_user := false;
end; { O_Hyper_Text.Run }

function o_hyper_text.test : boolean;
var
   i : word;
   j : word;
   bouton : p_bouton;
   ok : boolean;
begin
     ok := ((debut > 0) and (debut <= max_ecran) and (ht [debut] <> nil));
     for i := 1 to max_ecran do
         if (ht [i] <> nil)
         then
             begin
                  bouton := ht [i]^.liste_bouton;
                  while (bouton <> nil) do
                        begin
                             j := bouton^.effet.go_to;
                             if (j = 0)
                             then
                               begin
                                 label_ht := bouton^.go_to_name;
                                 bouton^.effet.go_to := rech_num_name;
                                 j := bouton^.effet.go_to;
                                 label_ht := '';
                               end;
                             {endif}
                             ok := ok and ((j < max_ecran) and ((j = 0) or (ht [j] <> nil)));
                             bouton := bouton^.next;
                        end;
                  {endwhile}
             end;
         {endif}
     {endfor}
     test := ok;
end; { O_Hyper_Text.Test }

function o_hyper_text.rech_num_name : word;
var
   i, res : word;
begin
  i := 1;
  res := 0;
  while ((res = 0) and (i < max_ecran)) do
    begin
      if ((ht [i] <> nil) and (ht [i]^.txt^.fich_name = label_ht))
      then
        res := i;
      {endif}
      inc (i);
    end;
  {endwhile}
  rech_num_name := res;
end; { o_hyper_text.rech_num_name }

{****************************************************************************}

var
   oldexitproc : pointer;

procedure u_htd_exit; far;
begin
     if (pile <> nil)
     then
         dispose (pile, done);
     {endif}
     if (zone <> nil)
     then
         dispose (zone, done);
     {endif}
     exitproc := oldexitproc;
end; { u_htd_exit }

begin
     oldexitproc := exitproc;
     exitproc := @u_htd_exit;
     ht_couleur := $01;
     ht_user := false;
     label_ht := '';
     pile := new (p_pile, init);
     zone := new (p_m_zone,init);
end. { Fin de l'unit‚ 'U_Htd'. }
