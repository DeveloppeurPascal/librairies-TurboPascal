unit u_joystick;
{
Auteur: Patrick Pr‚martin.
Date: 21/07/1992
      28/07/1992. (Interface Multi-Langues)
      30/07/1992.
      13/12/1992. (Acc‚l‚ration du tratement)
Langage: Turbo Pascal 6.0
But: Gestion des Joysticks reli‚s … un ordinateur AT.
}

interface
const
     stick_a = 0; { Num‚ro du Joystick A. }
     stick_b = 1; { Num‚ro du Joystick B. }

     strig_a_1 = 32; { Bouton 1 du Joystick A. }
     strig_a_2 = 16; { Bouton 2 du Joystick A. }
     strig_b_1 = 128; { Bouton 1 du Joystick B }
     strig_b_2 = 64; { Bouton 2 du Joystick B. }

     { Variables permettant le calibrage des Joysticks analogiques: }
     minx_0 : word = 65535;
     miny_0 : word = 65535;
     maxx_0 : word = 0;
     maxy_0 : word = 0;
     minx_1 : word = 65535;
     miny_1 : word = 65535;
     maxx_1 : word = 0;
     maxy_1 : word = 0;

     vx_0 : word = (65535 div 3);
     vy_0 : word = (65535 div 3);
     vx_1 : word = (65535 div 3);
     vy_1 : word = (65535 div 3);

function test_joystick : byte;
{ Donne des renseignements sur les Joysticks connect‚s:
          0 - Pas de carte, ou Joystick absent.
          1 - Joystick A connect‚.
          2 - Joystick B connect‚.
          3 - Joysticks A et B connect‚s. }

procedure init_joystick (num_joystick : byte);
{ Permet le calibrage d'un joystick analogique. }

function strig : byte;
{ Renvoie l'‚tat des boutons des deux Joysticks. }

function stick (num_joystick : byte) : byte;
{ Renvoie l'inclinaison du Joystick de num‚ro sp‚cifi‚:

          7 8 1
           \|/
          6-0-2
           /|\
          5 4 3
}

implementation
uses
    crt,
    u_msg,
    u_curseur,
    u_int10h;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Calibre la Manette ';
        2 : ch := 'Bougez le manche en haut … gauche, puis';
        3 : ch := 'en bas … droite.';
        4 : ch := 'Appuyez sur un bouton, or pressez ESC';
        5 : ch := 'pour sortir.';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Calibrate Joystick ';
      2 : ch := 'Move it Top-Left, and then Bottom-Right.';
      3 : ch := 'Push a button or press ESC to quit.';
      4 : ch := '';
      5 : ch := '';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

procedure int15_fct84_sf0 (var ok : boolean; var bouton : byte);
var
   pok : boolean;
   pbouton : byte;
begin
     asm
        push ax
        push dx
        mov ah, 84h
        mov dx, 0
        int 15h
        jc @pas_joystick
        mov pok, 1
        mov pbouton, al
        jmp @fin
     @pas_joystick:
                   mov pok, 0
                   mov pbouton, 0
     @fin:
          pop dx
          pop ax
     end;
     ok := pok;
     bouton := pbouton;
end; { int15_fct84_sf0 }

procedure int15_fct84_sf1 (var ok : boolean; var xa, ya, xb, yb : word);
var
   pok : boolean;
   pxa, pxb, pya, pyb : word;
begin
     asm
        push ax
        push bx
        push cx
        push dx
        mov ah, 84h
        mov dx, 1
        int 15h
        jc @pas_joystick
        mov pok, 1
        mov pxa, ax
        mov pxb, cx
        mov pya, bx
        mov pyb, dx
        jmp @fin
     @pas_joystick:
                   mov pok, 0
                   mov pxa, 0
                   mov pxb, 0
                   mov pya, 0
                   mov pyb, 0
     @fin:
          pop dx
          pop cx
          pop bx
          pop ax
     end;
     ok := pok;
     xa := pxa;
     xb := pxb;
     ya := pya;
     yb := pyb;
end; { int15_fct84_sf1 }

function test_joystick : byte;
var
   b : boolean;
   xa, ya, xb, yb : word;
   res : byte;
begin
     int15_fct84_sf1 (b, xa, ya, xb, yb);
     res := 0;
     if (b)
     then
         begin
              if ((xa <> 0) or (ya <> 0))
              then
                  res := 1;
              {endif}
              if ((xb <> 0) or (yb <> 0))
              then
                  res := res + 2;
              {endif}
         end;
     {endif}
     test_joystick := res;
end; { test_joystick }

function strig : byte;
var
   joystick_present : boolean;
   etat_bouton : byte;
begin
     int15_fct84_sf0 (joystick_present, etat_bouton);
     if (joystick_present)
     then
         strig := (not etat_bouton) and $f0
     else
         strig := 0;
     {endif}
end; { strig }

function return_stick (x, y, vx, vy : word) : byte;
begin
     if (x < vx)
     then
         if (y < vy)
         then
             return_stick := 7
         else
             if (y < 2*vy)
             then
                 return_stick := 6
             else
                 return_stick := 5
             {endif}
         {endif}
     else
         if (x < 2*vx)
         then
             if (y < vy)
             then
                 return_stick := 8
             else
                 if (y < 2*vy)
                 then
                     return_stick := 0
                 else
                     return_stick := 4
                 {endif}
             {endif}
         else
             if (y < vy)
             then
                 return_stick := 1
             else
                 if (y < 2*vy)
                 then
                     return_stick := 2
                 else
                     return_stick := 3
                 {endif}
             {endif}
         {endif}
     {endif}
end; { return_stick }

function stick (num_joystick : byte) : byte;
var
   joystick_present : boolean;
   xa, ya, xb, yb : word;
begin
     int15_fct84_sf1 (joystick_present, xa, ya, xb, yb);
     if (not joystick_present)
     then
         stick := 0
     else
         case num_joystick of
              stick_a : stick := return_stick (xa, ya, vx_0, vy_0);
              stick_b : stick := return_stick (xb, yb, vx_1, vy_1);
         end;
     {endif}
end; { stick }

procedure dessin_cadre;
begin
     gotoxy (7, 7);
     writeln (#218#196#194#196#194#196#191);
     gotoxy (7, 8);
     writeln (#179' '#179' '#179' '#179);
     gotoxy (7, 9);
     writeln (#195#196#197#196#197#196#180);
     gotoxy (7, 10);
     writeln (#179' '#179' '#179' '#179);
     gotoxy (7, 11);
     writeln (#195#196#197#196#197#196#180);
     gotoxy (7, 12);
     writeln (#179' '#179' '#179' '#179);
     gotoxy (7, 13);
     writeln (#192#196#193#196#193#196#217);
end; { dessin_cadre }

procedure init_joystick (num_joystick : byte);
var
   b, fin : boolean;
   xa, ya, xb, yb,
   ox, oy, x, y,
   mix, miy, max, may : word;
   boutons,
   n,
   om : byte;
begin
     om := get_mode;
     repeat
     until (set_mode (0) or true);
     curseur_off;
     case num_joystick of
          stick_a : boutons := strig_a_1+strig_a_2;
          stick_b : boutons := strig_b_1+strig_b_2;
     end;
     textattr := $07;
     mix := 65535;
     miy := 65535;
     max := 0;
     may := 0;
     clrscr;
     writeln (msg_ch (1), chr (65+num_joystick));
     writeln (msg_ch (2));
     writeln (msg_ch (3));
     writeln (msg_ch (4));
     writeln (msg_ch (5));
     dessin_cadre;
     ox := 0;
     oy := 0;
     fin := false;
     repeat
           int15_fct84_sf1 (b, xa, ya, xb, yb);
           case num_joystick of
                stick_a :
                        begin
                             x := xa;
                             y := ya;
                             vx_0 := (mix+max) div 3;
                             vy_0 := (miy+may) div 3;
                        end;
                stick_b :
                        begin
                             x := xb;
                             y := yb;
                             vx_1 := (mix+max) div 3;
                             vy_1 := (miy+may) div 3;
                        end;
           end;
           if (x < mix)
           then
               mix := x;
           {endif}
           if (x > max)
           then
               max := x;
           {endif}
           if (y < miy)
           then
               miy := y;
           {endif}
           if (y > may)
           then
               may := y;
           {endif}
           case num_joystick of
                stick_a :
                        begin
                             n := return_stick (x, y, vx_0, vy_0);
                             minx_0 := mix;
                             miny_0 := miy;
                             maxx_0 := max;
                             maxy_0 := may;
                        end;
                stick_b :
                        begin
                             n := return_stick (x, y, vx_1, vy_1);
                             minx_1 := mix;
                             miny_1 := miy;
                             maxx_1 := max;
                             maxy_1 := may;
                        end;
           end;
           case n of
                7, 6, 5 : x := 8;
                8, 0, 4 : x := 10;
                1, 2, 3 : x := 12;
           end;
           case n of
                7, 8, 1 : y := 8;
                6, 0, 2 : y := 10;
                5, 4, 3 : y := 12;
           end;
           textattr := 0;
           gotoxy (ox, oy);
           write (' ');
           textattr := 7;
           gotoxy (x, y);
           write (#219);
           ox := x;
           oy := y;
           if (keypressed)
           then
               fin := (readkey = #27);
           {endif}
     until (((strig and boutons) <> 0) or fin);
     repeat
     until (set_mode (om) or true);
end; { init_joystick }

end.
