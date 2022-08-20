program tst_scroll;
{
05/08/1991.
06/08/1991.
08/08/1991.

Ce programme est d‚stin‚ … tester l'unit‚ U_SCROLL.
}
uses
    crt,
    u_scroll;

var
   i, j, k : integer;
   erreur : integer;

procedure inverse_video;
var
   txt_col, txt_bck : byte;
begin
     txt_bck := (textattr and $0f) shl 4;
     txt_col := (textattr and $f0) shr 4;
     textattr := txt_bck + txt_col;
end; { Inverse_Video }

begin
     clrscr;
     directvideo := false;
     textcolor (lightgray);
     textbackground (black);
     for i := 1 to 80 do
         begin
              gotoxy (i, 1);
              write ('#');
              gotoxy (i, 24);
              write ('#');
         end;
     {endfor}
     for j := 1 to 24 do
         begin
              gotoxy (1, j);
              write ('#');
              gotoxy (80, j);
              write ('#');
         end;
     {endfor}
     inverse_video;
     for i := 1 to 50 do
         begin
              gotoxy (random(78)+2, random (22)+2);
              write ('*');
         end;
     {endfor}
     inverse_video;
     erreur := 0;
     repeat
           erreur := scroll_txt (2, 2, 78, 22, 10);
     until (keypressed or (erreur <> 0));
     clrscr;
     writeln ('Erreur num‚ro:', erreur);
     asm
        mov ah, $0f
        int $10
        mov erreur, ax
     end;
     writeln ('Nb de caractŠres:', hi (erreur));
     writeln ('Mode courant:', lo (erreur));
     readln;
end.
