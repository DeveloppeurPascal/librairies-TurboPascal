unit u_m_util;
{
Auteur: Premartin Patrick
Date: 26/08/1991. 28/08/1991. 29/08/1991. 30/08/1991. 09/09/1991.
      14/11/1991. 26/11/1991. 27/11/1991. 24/06/1992. 25/06/1992.
      28/07/1992. ( Interface Multi-Langue )          29/07/1992.
Langage: Turbo Pascal 6.0
But: Affichage de fenetres et de messages avec choix au clavier ou a la souris.
}
interface
const
     al_nothing = 0;
     al_error = 1;
     al_ok = 2;
     al_cancel = 3;
     al_wait = 4;

type
    ext_str = string [3];

function confirm (ch : string) : boolean;
function get_fich_name (var default : string; ext : ext_str) : string;
procedure alert (ch : string; button : word);
procedure calert (ch : string; button : word; coul : byte);

implementation
uses
    crt,
    dos,
    u_code_clavier,
    u_mouse,
    u_msg,
    u_sai_donnee;

type
    p_tab_cadre = ^tab_cadre;
    tab_cadre = array [1..80] of word;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := ' Oui ';
        2 : ch := ' Non ';
        3 : ch := 'O'; { Oui }
        4 : ch := 'N'; { Non }
        5 : ch := 'Nom du fichier: ';
        6 : ch := ' Erreur ';
        7 : ch := 'E'; { Erreur }
        8 : ch := ' Ok ';
        9 : ch := 'O'; { Ok }
        10 : ch := ' Abandon ';
        11 : ch := 'A'; { Abandon }
        12 : ch := ' Attend ';
        13 : ch := 'A'; { Attend }
        14 : ch := ' Clic ';
        15 : ch := 'C'; { Clic }
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := ' Yes ';
      2 : ch := ' No ';
      3 : ch := 'Y'; { Yes }
      4 : ch := 'N'; { No }
      5 : ch := 'File Name: ';
      6 : ch := ' Error ';
      7 : ch := 'E'; { Error }
      8 : ch := ' Ok ';
      9 : ch := 'O'; { Ok }
      10 : ch := ' Cancel ';
      11 : ch := 'C'; { Cancel }
      12 : ch := ' Waiting ';
      13 : ch := 'W'; { Waiting }
      14 : ch := ' Clic ';
      15 : ch := 'C'; { Clic }
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

var
   pntr : p_tab_cadre;
   nb_col : byte;
   old_x,
   old_y,
   old_attr : byte;

procedure save_cadre;
var
   page,
   video_mode : byte;
   cara_attr : word;
   i : integer;
begin
     old_attr := textattr;
     old_x := wherex;
     old_y := wherey;
     asm
        push ax
        push bx
        mov ah, $0f
        int $10
        mov nb_col, ah
        mov page, bh
        mov video_mode, al
        pop bx
        pop ax
     end;
     if (nb_col > 80)
     then
         nb_col := 80;
     {endif}
     if (not directvideo)
     then
         exit;
     {endif}
     new (pntr);
     if (pntr = nil)
     then
         exit;
     {endif}
     hide_mouse;
     for i := 1 to nb_col do
         begin
              gotoxy (i, 25);
              asm
                 mov ah, 8
                 mov bh, page
                 int 10h
                 mov cara_attr, ax
              end;
              pntr^ [i] := cara_attr;
         end;
     {endfor}
end; { Save_Cadre }

procedure load_cadre;
var
   page,
   video_mode,
   attr : byte;
   cara_attr : word;
   i : integer;
   carac : char;
begin
     hide_mouse;
     repeat
     until (mousek = 0);
     while keypressed do
           carac := readkey;
     {endwhile}
     asm
        push ax
        push bx
        mov ah, $0f
        int $10
        mov nb_col, ah
        mov page, bh
        mov video_mode, al
        pop bx
        pop ax
     end;
     if (nb_col > 80)
     then
         nb_col := 80;
     {endif}
     for i := 1 to nb_col do
         begin
              gotoxy (i, 25);
              if (pntr = nil)
              then
                  cara_attr := $0720
              else
                  cara_attr := pntr^ [i];
              {endif}
              asm
                 push ax
                 push bx
                 push cx
                 mov ah, 9
                 mov bx, cara_attr
                 mov al, bl
                 mov bl, bh
                 mov bh, page
                 mov cx, 1
                 int 10h
                 pop cx
                 pop bx
                 pop ax
              end;
         end;
     {endfor}
     if (pntr <> nil)
     then
         dispose (pntr);
     {endif}
     pntr := nil;
     textattr := old_attr;
     gotoxy (old_x, old_y);
end; { Load_Cadre }

function confirm (ch : string) : boolean;
var
   c : char;
   sortie,
   ok : boolean;
   mx,
   my,
   mk : integer;
begin
     save_cadre;
     gotoxy (1, 25);
     textcolor (lightgray);
     textbackground (black);
     while (wherex < nb_col) do
           write (' ');
     {endwhile}
     gotoxy (1, 25);
     write (copy (ch, 1, nb_col-12));
     gotoxy (nb_col-11, 25);
     textcolor (white);
     if (directvideo)
     then
         textbackground (lightgray)
     else
         textbackground (black);
     {endif}
     write (msg_ch (1));
     gotoxy (nb_col-5, 25);
     write (msg_ch (2));
     show_mouse;
     while (mousek <> 0) do;
     repeat
           repeat
                 mouse_x_y_k_txt (mx, my, mk);
           until (keypressed or (mk > 0));
           if keypressed
           then
               begin
                    c := upcase (readkey);
                    if ((c = touche_return) or (c = msg_ch (3)))
                    then
                        begin
                             ok := true;
                             sortie := true;
                        end
                    else
                        if ((c = touche_escape) or (c = msg_ch (4)))
                        then
                            begin
                                 ok := false;
                                 sortie := true;
                            end
                        else
                            sortie := false;
                        {endif}
                    {endif}
               end
           else
               if (mk > 0)
               then
                   if ((my = 25) and (mx >= nb_col-11) and (mx <= nb_col-7))
                   then
                       begin
                            ok := true;
                            sortie := true;
                       end
                   else
                       if ((my = 25) and (mx >= nb_col-5) and (mx <= nb_col-2))
                       then
                           begin
                                ok := false;
                                sortie := true;
                           end
                       else
                           sortie := false
                       {endif}
                   {endif}
               else
                   sortie := false;
               {endif}
           {endif}
     until sortie;
     hide_mouse;
     load_cadre;
     confirm := ok;
end; { Confirm }

function get_fich_name (var default : string; ext : ext_str) : string;
var
   result : string;
   dir : dirstr;
   name : namestr;
   ext_2 : extstr;
begin
     fsplit (fexpand (default), dir, name, ext_2);
     default := name;
     save_cadre;
     textcolor (lightgray);
     textbackground (black);
     gotoxy (1, 25);
     write (msg_ch (5));
     result := default;
     textcolor (white);
     if (directvideo)
     then
         textbackground (lightgray)
     else
         textbackground (black);
     {endif}
     saisie_texte ('FFFFFFFF', result);
     load_cadre;
     get_fich_name := dir+ result+ '.'+ ext;
end; { Get_Fich_Name }

procedure alert (ch : string; button : word);
var
   sortie : boolean;
   mx_0,
   mx_1,
   mx,
   my,
   mk : integer;
   carac : char;
   touche : string;
begin
     save_cadre;
     textcolor (lightgray);
     textbackground (black);
     gotoxy (1, 25);
     while (wherex < nb_col) do
           write (' ');
     {endwhile}
     gotoxy (1, 25);
     write (copy (ch, 1, nb_col-10));
     gotoxy (nb_col-9, 25);
     textcolor (white);
     if (directvideo)
     then
         textbackground (lightgray)
     else
         textbackground (black);
     {endif}
     mx_0 := nb_col -9;
     while (mousek <> 0) do;
     case button of
          al_error : begin
                          write (msg_ch (6));
                          mx_1 := nb_col + 10 - length (msg_ch (6));
                          touche := msg_ch (7);
          end;
          al_ok : begin
                       write (msg_ch (8));
                       mx_1 := nb_col + 10 - length (msg_ch (8));
                       touche := msg_ch (9);
          end;
          al_cancel : begin
                           write (msg_ch (10));
                           mx_1 := nb_col + 10 - length (msg_ch (10));
                           touche := msg_ch (11);
          end;
          al_wait : begin
                         write (msg_ch (12));
                         mx_1 := nb_col + 10 - length (msg_ch (12));
                         touche := msg_ch (13);
          end;
     else
         button := al_nothing;
         write (msg_ch (14));
         mx_1 := nb_col + 10 - length (msg_ch (14));
         touche := msg_ch (15);
     end;
     show_mouse;
     repeat
           repeat
                 mouse_x_y_k_txt (mx, my, mk);
           until (keypressed or (mk > 0));
           if keypressed
           then
               begin
                    carac := readkey;
                    sortie := ((button = al_nothing) or (upcase (carac) = touche)
                              or (carac in [touche_escape, touche_return, ' ']));
               end
           else
               sortie := ((button = al_nothing) or ((mk > 0) and (mx >= mx_0) and (mx <= mx_1) and (my = 25)));
           {endif}
     until sortie;
     hide_mouse;
     load_cadre;
end; { Alert }

procedure calert (ch : string; button : word; coul : byte);
var
   sortie : boolean;
   mx_0,
   mx_1,
   mx,
   my,
   mk : integer;
   carac : char;
   touche : string;
begin
     save_cadre;
     textattr := coul;
     gotoxy (1, 25);
     while (wherex < nb_col) do
           write (' ');
     {endwhile}
     gotoxy (1, 25);
     write (copy (ch, 1, nb_col-10));
     gotoxy (nb_col-9, 25);
     textcolor (white);
     if (directvideo)
     then
         textbackground (lightgray)
     else
         textbackground (black);
     {endif}
     mx_0 := nb_col -9;
     while (mousek <> 0) do;
     case button of
          al_error : begin
                          write (msg_ch (6));
                          mx_1 := nb_col + 10 - length (msg_ch (6));
                          touche := msg_ch (7);
          end;
          al_ok : begin
                       write (msg_ch (8));
                       mx_1 := nb_col + 10 - length (msg_ch (8));
                       touche := msg_ch (9);
          end;
          al_cancel : begin
                           write (msg_ch (10));
                           mx_1 := nb_col + 10 - length (msg_ch (10));
                           touche := msg_ch (11);
          end;
          al_wait : begin
                         write (msg_ch (12));
                         mx_1 := nb_col + 10 - length (msg_ch (12));
                         touche := msg_ch (13);
          end;
     else
         button := al_nothing;
         write (msg_ch (14));
         mx_1 := nb_col + 10 - length (msg_ch (14));
         touche := msg_ch (15);
     end;
     show_mouse;
     repeat
           repeat
                 mouse_x_y_k_txt (mx, my, mk);
           until (keypressed or (mk > 0));
           if keypressed
           then
               begin
                    carac := readkey;
                    sortie := ((button = al_nothing) or (upcase (carac) = touche)
                              or (carac in [touche_escape, touche_return, ' ']));
               end
           else
               sortie := ((button = al_nothing) or ((mk > 0) and (mx >= mx_0) and (mx <= mx_1) and (my = 25)));
           {endif}
     until sortie;
     hide_mouse;
     load_cadre;
end; { Calert }

begin
     pntr := nil;
end. { Fin de l'unit‚ 'U_M_Util'. }
