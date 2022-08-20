Unit U_Mouse;
{
Auteur: Pr‚martin Patrick.
Date: 26/01/1991. 30/01/1991. 10/02/1991. 15/02/1991. 28/02/1991. 23/03/1991.
Langage: Turbo Pascal 4.0
      15/08/1991. 19/08/1991. 26/08/1991. 27/11/1991.
Langage: Turbo Pascal 6.0

But: Utilisation de la souris … partir du Turbo Pascal.
}

Interface
Const Mouse_Curs : Boolean = False; { True si le curseur de la souris est
                                      visible, False dans le cas contraire. }
      Mouse_On   : Boolean = False; { Indique en permanence si la souris est
                                      pr‚sente ou pas. }

{
Fonctions et proc‚dures diverses.
}
Function Mouse_Test : Boolean;
         { est vraie si la souris est install‚e et reconnue }
Function Mouse_Nb_Button : Integer;
         { renvoie le nombre de boutons de la souris }
Procedure Hide_Mouse;
          { cache le curseur de la souris et met Mouse_Curs … FALSE }
Procedure Show_Mouse;
          { montre le curseur de la souris et met Mouse_Curs … TRUE }
Function Mousek : Integer;
         { renvoie l'‚tat des boutons de la souris }

{
Fonctions et proc‚dures pour les modes graphiques.
}
Function Mousex : Integer;
         { renvoie l'abscisse de la souris }
Function Mousey : Integer;
         { renvoie l'ordonn‚e de la souris }
Procedure Mouse_X_Y (Var X, Y : Integer);
          { renvoie les coordonn‚es de la souris }
Procedure Mouse_X_Y_K (Var X, Y, K : Integer);
          { renvoie les coordonn‚es et l'‚tat des boutons de la souris }
Procedure Setmouse (X, Y : Integer);
          { positionne la souris en (X, Y) }
Procedure Mouse_Cadre (X_Min, Y_Min, X_Max, Y_Max : Integer);
          { empŠche la souris de sortir du cadre sp‚cifi‚ }
Procedure Mouse_Cadre_Horiz (X_Min, X_Max : Integer);
          { empŠche la souris de sortir de la bande d‚finie par les colonnes }
Procedure Mouse_Cadre_Vert (Y_Min, Y_Max : Integer);
          { empeche la souris de sortir de la bande d‚finie par les lignes }

{
Fonctions et proc‚dures pour les modes textes.
}
Function Mousex_Txt : Integer;
         { renvoie l'abscisse de la souris en mode texte }
Function Mousey_Txt : Integer;
         { renvoie l'ordonn‚e de la souris en mode texte }
Procedure Mouse_X_Y_Txt (Var X, Y : Integer);
          { renvoie les coordonn‚es de la souris en mode texte }
Procedure Mouse_X_Y_K_Txt (Var X, Y, K : Integer);
          { renvoie les coordonn‚es et l'‚tat des boutons de la souris en mode
            texte }
Procedure Setmouse_Txt (X, Y : Integer);
          { positionne la souris en (X, Y) en mode texte }
Procedure Mouse_Cadre_Txt (X_Min, Y_Min, X_Max, Y_Max : Integer);
          { empŠche la souris de sortir du cadre sp‚cifi‚ en mode texte }
Procedure Mouse_Cadre_Horiz_Txt (X_Min, X_Max : Integer);
          { empŠche la souris de sortir de la bande d‚finie par les colonnes en
            mode texte }
Procedure Mouse_Cadre_Vert_Txt (Y_Min, Y_Max : Integer);
          { empeche la souris de sortir de la bande d‚finie par les lignes en
            mode texte }

Implementation
Function Mousex : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousex := X;
End; { mousex }

Function Mousey : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousey := Y;
End; { mousey }

Function Mousek : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousek := K;
End; { mousek }

Function Mouse_Test : Boolean;
var
   res : integer;
Begin
     asm
        mov ax, 0
        int $33
        mov res, ax
     end;
     mouse_on := (res <> 0);
     Mouse_Test := Mouse_On
End; { mouse_test }

Function Mouse_Nb_Button : Integer;
var
   res : integer;
Begin
     If (Mouse_On)
     Then
         asm
            mov ax, 0
            int $33
            mov res, bx
         end
     Else
         res := 0;
     {endif}
     mouse_nb_button := res;
End; { mouse_nb_button }

Procedure Hide_Mouse;
Begin
     If (Mouse_On)
     Then
         asm
            mov ax, 2
            int $33
         end;
     {endif};
     Mouse_Curs := False;
End; { hide_mouse }

Procedure Show_Mouse;
Begin
     If (Mouse_On)
     Then
         begin
              asm
                 mov ax, 1
                 int $33
                 mov ax, 1
                 int $33
                 mov ax, 1
                 int $33
                 mov ax, 1
                 int $33
                 mov ax, 1
                 int $33
              end;
              Mouse_Curs := True;
         end;
     {endif}
End; { show_mouse }

Procedure Mouse_X_Y (Var X, Y : Integer);
Var
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
End; { mouse_x_y }

procedure Mouse_X_Y_K (Var X, Y, K : Integer);
var
   rx,
   ry,
   rk : integer;
Begin
     If (Mouse_On)
     Then
         asm
            mov ax, 3
            int $33
            mov rx, cx
            mov ry, dx
            mov rk, bx
         End
     Else
         Begin
              rX := 0;
              rY := 0;
              rK := 0;
         End;
     {endif}
     x := rx;
     y := ry;
     k := rk;
End; { mouse_x_y_k }

Procedure Setmouse (X, Y : Integer);
Begin
     If (Mouse_On)
     Then
         asm
            mov ax, 4
            mov cx, x
            mov dx, y
            int $33
         End;
     {endif}
End; { setmouse }

Procedure Mouse_Cadre_Horiz (X_Min, X_Max : Integer);
var
   c,
   d : integer;
Begin
     If (X_Min > X_Max)
     Then
         Begin
              D := X_Min;
              C := X_Max;
         End
     Else
         Begin
              C := X_Min;
              D := X_Max;
         End;
     {endif}
     asm
        mov ax, 7
        mov cx, c
        mov dx, d
        int $33
     End;
End; { mouse_cadre_horiz }

Procedure Mouse_Cadre_Vert (Y_Min, Y_Max : Integer);
var
   c,
   d : integer;
Begin
     If (Y_Min > Y_Max)
     Then
         Begin
              D := Y_Min;
              C := Y_Max;
         End
     Else
         Begin
              C := Y_Min;
              D := Y_Max;
         End;
     {endif}
     asm
        mov ax, 8
        mov cx, c
        mov dx, d
        int $33
     end;
End; { mouse_cadre_vert }

Procedure Mouse_Cadre (X_Min, Y_Min, X_Max, Y_Max : Integer);
Begin
     If (Mouse_On)
     Then
         Begin
              Mouse_Cadre_Horiz (X_Min, X_Max);
              Mouse_Cadre_Vert (Y_Min, Y_Max);
         End;
     {endif}
End; { mouse_cadre }

Function Mousex_Txt : Integer;
Begin
     Mousex_Txt := succ ((Mousex div (80 div mem [$40:$4a])) Div 8);
End; { mousex_txt }

Function Mousey_Txt : Integer;
Begin
     Mousey_Txt := (Mousey Div 8);
End; { mousey_txt }

Procedure Mouse_X_Y_Txt (Var X, Y : Integer);
Begin
     Mouse_X_Y (X, Y);
     X := succ ((X div (80 div mem [$40:$4a])) Div 8);
     Y := succ (Y Div 8);
End; { mouse_x_y_txt }

Procedure Mouse_X_Y_K_Txt (Var X, Y, K : Integer);
Begin
     Mouse_X_Y_K (X, Y, K);
     X := succ ((X div (80 div mem [$40:$4a])) Div 8);
     Y := succ (Y Div 8);
End; { mouse_x_y_k }

Procedure Setmouse_Txt (X, Y : Integer);
Begin
     Setmouse ((X * 8 * (80 div mem [$40:$4a])) + 4, (Y * 8) + 4);
End; { setmouse_txt }

Procedure Mouse_Cadre_Txt (X_Min, Y_Min, X_Max, Y_Max : Integer);
Begin
     Mouse_Cadre (X_Min * 8 * (80 div mem [$40:$4a]) + 4, Y_Min * 8 + 4,
                  X_Max * 8 * (80 div mem [$40:$4a]) + 4, Y_Max * 8 + 4);
End; { mouse_cadre_txt }

Procedure Mouse_Cadre_Horiz_Txt (X_Min, X_Max : Integer);
Begin
     Mouse_Cadre_Horiz (X_Min * 8 * (80 div mem [$40:$4a]) + 4, X_Max * 8 + 4);
End; { mouse_cadre_horiz_txt }

Procedure Mouse_Cadre_Vert_Txt (Y_Min, Y_Max : Integer);
Begin
     Mouse_Cadre_Vert (Y_Min * 8 + 4, Y_Max * 8 + 4);
End; { mouse_cadre_vert_txt }

Begin
     If (Mouse_Test)
     Then
         Begin
              Hide_Mouse;
              Setmouse (0, 0);
         End;
     {endif}
End. { Fin de l'unit‚ 'U_Mouse'. }
