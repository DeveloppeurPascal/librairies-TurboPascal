Unit U_Fenetre;              { date de mise … jour : 07/05/1991 }
{
Auteur: Pr‚martin Patrick.
Date: ??/??/????.
      13/01/1991.
      28/02/1991.
      07/05/1991.

But: Rajout de fenˆtres et de cadres … l'unit‚ 'Crt' du Turbo Pascal 4.0.
}
Interface
Uses Crt;
Var Type_Cadre : Byte;
{
    Cette variable permet de choisir le cadre:
    -type_cadre=1   -type_cadre=2   -type_cadre=3   -type_cadre=4
        ÚÄÄÄ¿           ÉÍÍÍ»           ÖÄÄÄ·           ÕÍÍÍ¸
        ³   ³           º   º           º   º           ³   ³
        ÀÄÄÄÙ           ÈÍÍÍ¼           ÓÄÄÄ½           ÔÍÍÍ¾
    -type_cadre=5   -type_cadre=6   -type_cadre=7   -type_cadre=8
        °°°°°           ±±±±±           ²²²²²           ÛÛÛÛÛ
        °   °           ±   ±           ²   ²           Û   Û
        °°°°°           ±±±±±           ²²²²²           ÛÛÛÛÛ
    -type_cadre=9   -type_cadre=10
        #####           *****
        #   #           *   *
        #####           *****
}

Procedure Swap_Byte (Var A, B : Byte);
          { echange les valeurs de A et de B. }

Procedure Reset_Screen;
          { mise … zero de tous les parametres de fenetres. }
Procedure Clear_Window;
          { effacement de la fenetre active remplac‚e par l'ancienne }

Procedure Window_Fond (X1, Y1, X2, Y2, Fond: Byte);
          { cr‚ation d'une fenˆtre avec couleur de fond choisie }
Procedure Window_Cadre (X1, Y1, X2, Y2, Cadre: Byte);
          { cr‚ation d'une fenˆtre ayant un cadre de couleur sur fond noir }
Procedure Window_Cadre_Bis (X1, Y1, X2, Y2, Cadre1, Cadre2: Byte);
          { cr‚ation de fenˆtre avec cadre de couleur forme/fond }
Procedure Window_Fond_Cadre (X1, Y1, X2, Y2, Fond, Cadre: Byte);
          { cr‚ation d'une fenˆtre avec cadre (forme/noir) et fond de couleur }
Procedure Window_Fond_Cadre_Bis (X1, Y1, X2, Y2, Fond, Cadre1, Cadre2: Byte);
          { cr‚ation d'une fenˆtre avec cadre (forme/fond) et fond de couleur }

Procedure Window_Titre (Titre: String; Forme, Fond: Byte);
          { affiche un titre pour la fenetre active. }

Procedure Dessin_Cadre (X1, Y1, X2, Y2, Trace: Byte);
          { dessin d'un cadre de type trace ou type_cadre (d‚fini plus haut) }
Procedure Dessin_Cadre_Form (X1, Y1, X2, Y2, Form: Byte);
          { dessin du cadre choisi avec couleur du trac‚ du contour }
Procedure Dessin_Cadre_Form_Fond (X1, Y1, X2, Y2, Form, Fond: Byte);
          { dessin du cadre avec les couleurs choisies form/fond }

{ Fin de l'interface. }

Implementation
Var Old_Windmin, Old_Windmax,
    { Contiennent les valeurs de l'ancienne fenetre active. }
    Old_Textattr,
    Min_X_Window, Min_Y_Window,
    Max_X_Window, Max_Y_Window : Integer;
    { Contiennent les coordonn‚es de la fenetre active. }
    Cadre_Eventuel : Byte;
    { indique s'il y a eu un cadre dans la fenetre active. }

Procedure Reset_Screen;
Begin { reset_screen }
  Type_Cadre := 1;
  Window (1, 1, 80, 25);
  Textcolor (Lightgray);
  Textbackground (Black);
  Clrscr;
  Old_Windmin  := Windmin;
  Old_Windmax  := Windmax;
  Old_Textattr := Textattr;
  Min_X_Window := 1;
  Min_Y_Window := 1;
  Max_X_Window := 80;
  Max_Y_Window := 25;
  Cadre_Eventuel := 0
End; { reset_screen }

Procedure Swap_Byte (Var A, B : Byte);
Var C : Byte;
Begin { swap_byte }
  C := A;     A := B;     B := C
End; { swap_byte }

Procedure Clear_Window;
Var A, B, C, D: Integer;
Begin { clear_window }
  A := Min_X_Window;
  B := Min_Y_Window;
  C := Max_X_Window;
  D := Max_Y_Window;
  If (Cadre_Eventuel = 1)
  Then
    Begin
      Cadre_Eventuel := 0;
      If (Min_X_Window > 1) Then Dec (A);
      If (Min_Y_Window > 1) Then Dec (B);
      If (Max_X_Window < 80) Then Inc (C);
      If (Max_Y_Window < 25) Then Inc (D)
    End
  {endif};
  Window (A, B, C, D);
  Textattr := Old_Textattr;
  Clrscr;
  Windmin := Old_Windmin;
  Windmax := Old_Windmax
End; { clear_window }

Procedure Window_Fond (X1, Y1, X2, Y2, Fond: Byte);
Begin { window_fond }
  Old_Windmin  := Windmin;
  Old_Windmax  := Windmax;
  Old_Textattr := Textattr;
  Min_X_Window := X1;
  Min_Y_Window := Y1;
  Max_X_Window := X2;
  Max_Y_Window := Y2;
  Cadre_Eventuel := 0;
  Window (X1, Y1, X2, Y2);
  Textbackground (Fond);
  Clrscr
End; { window_fond }

Procedure Window_Cadre (X1, Y1, X2, Y2, Cadre: Byte);
Begin { window_cadre }
  Window_Cadre_Bis (X1, Y1, X2, Y2, Cadre, Black)
End; { window_cadre }

Procedure Window_Cadre_Bis (X1, Y1, X2, Y2, Cadre1, Cadre2: Byte);
Var Max, A, B, C, D : Byte;
Begin { window_cadre_bis }
  Old_Windmin := Windmin;
  Old_Windmax := Windmax;
  Old_Textattr := Textattr;
  If (X1 > X2)  Then    Swap_Byte (X1, X2);
  If (Y1 > Y2)  Then    Swap_Byte (Y1, Y2);
  If ((Lastmode = Co40) Or (Lastmode = Bw40)) Then Max := 40 Else Max := 80;
  If (X1 < 1)   Then X1 := 1;
  If (Y1 < 1)   Then Y1 := 1;
  If (X2 > Max) Then X2 := Max;
  If (Y2 > 25)  Then Y2 := 25;
  If (X1 = 1)   Then A  := X1   Else A := Pred (X1);
  If (Y1 = 1)   Then B  := Y1   Else B := Pred (Y1);
  If (X2 = Max) Then C  := X2   Else C := Succ (X2);
  If (Y2 = 25)  Then D  := Y2   Else D := Succ (Y2);
{ Dessin du cadre de la fenˆtre. }
  Window (1,1,Max,25);
  Min_X_Window := X1;
  Min_Y_Window := Y1;
  Max_X_Window := X2;
  Max_Y_Window := Y2;
  Cadre_Eventuel := 1;
  Dessin_Cadre_Form_Fond (A, B, C, D, Cadre1, Cadre2);
{ Fin du dessin du cadre. }
  Window (X1, Y1, X2, Y2);
  Clrscr
End; { window_cadre_bis }

Procedure Window_Fond_Cadre (X1, Y1, X2, Y2, Fond, Cadre: Byte);
Begin { window_fond_cadre }
  Window_Fond_Cadre_Bis (X1, Y1, X2, Y2, Fond, Cadre, Black)
End; { window_fond_cadre }

Procedure Window_Fond_Cadre_Bis (X1, Y1, X2, Y2, Fond, Cadre1, Cadre2: Byte);
Begin { window_fond_cadre_bis }
  Window_Cadre_Bis (X1, Y1, X2, Y2, Cadre1, Cadre2);
  Textbackground (Fond);
  Clrscr
End; { window_fond_cadre_bis }

Procedure Window_Titre (Titre: String; Forme, Fond: Byte);
Var Largeur_Fenetre,
    X_Stockage, Y_Stockage : Integer;
Begin { window_titre }
  X_Stockage := Wherex;
  Y_Stockage := Wherey;
  Largeur_Fenetre := Succ (Max_X_Window - Min_X_Window);
  If (Length (Titre) > Largeur_Fenetre)
  Then
    Titre := Copy (Titre, 1, Largeur_Fenetre)
  {endif};
  Window (1, 1, 80, 25);
  Textcolor (Forme);
  Textbackground (Fond);
  If ((Cadre_Eventuel = 1) And (Min_Y_Window = 1))
  Then
    Gotoxy (Min_X_Window + (Largeur_Fenetre - Length (Titre)) Div 2, Min_Y_Window)
  Else
    Gotoxy (Min_X_Window + (Largeur_Fenetre - Length (Titre)) Div 2, Min_Y_Window-Cadre_Eventuel)
  {endif};
  Write (Titre);
  Window (Min_X_Window, Min_Y_Window, Max_X_Window, Max_Y_Window);
  Gotoxy (X_Stockage, Y_Stockage)
End; { window_titre }

Procedure Dessin_Cadre (X1, Y1, X2, Y2, Trace: Byte);
Var Code_Cadre : String [6];
    Max        : Byte;
Begin { dessin_cadre }
  Case Type_Cadre Of
    2:  Code_Cadre := '»ÉÈ¼ºÍ';
    3:  Code_Cadre := '·ÖÓ½ºÄ';
    4:  Code_Cadre := '¸ÕÔ¾³Í';
    5:  Code_Cadre := '°°°°°°'; {176}
    6:  Code_Cadre := '±±±±±±'; {177}
    7:  Code_Cadre := '²²²²²²'; {178}
    8:  Code_Cadre := 'ÛÛÛÛÛÛ'; {219}
    9:  Code_Cadre := '######';
    10: Code_Cadre := '******';
  Else
    Code_Cadre := '¿ÚÀÙ³Ä'
  End;
  If (X1 > X2)  Then    Swap_Byte (X1, X2);
  If (Y1 > Y2)  Then    Swap_Byte (Y1, Y2);
  If ((Lastmode = Co40) Or (Lastmode = Bw40)) Then Max := 40 Else Max := 80;
  If (X1 < 1)   Then X1 := 1;
  If (Y1 < 1)   Then Y1 := 1;
  If (X2 > Max) Then X2 := Max;
  If (Y2 > 25)  Then Y2 := 25;
  For Max := X1 To X2 Do
    Begin
      Gotoxy (Max, Y1);
      Write (Code_Cadre [6]);
      Gotoxy (X2 - (Max - X1), Y2);
      Write (Code_Cadre [6])
    End;
  For Max := Y1 To Y2 Do
    Begin
      Gotoxy (X1, Y2 - (Max - Y1));
      Write (Code_Cadre [5]);
      Gotoxy (X2, Max);
      Write (Code_Cadre [5])
    End;
  Gotoxy (X1, Y1);
  Write (Code_Cadre [2]);
  Gotoxy (X2, Y1);
  Write (Code_Cadre [1]);
  Gotoxy (X1, Y2);
  Write (Code_Cadre [3]);
  Gotoxy (X2, Y2);
  Write (Code_Cadre [4])
End; { dessin_cadre }

Procedure Dessin_Cadre_Form (X1, Y1, X2, Y2, Form: Byte);
Begin { dessin_cadre_form }
  Textcolor (Form);
  Dessin_Cadre (X1, Y1, X2, Y2, Type_Cadre)
End; { dessin_cadre_form }

Procedure Dessin_Cadre_Form_Fond (X1, Y1, X2, Y2, Form, Fond: Byte);
Begin { dessin_cadre_form_fond }
  Textbackground (Fond);
  Dessin_Cadre_Form (X1, Y1, X2, Y2, Form)
End; { dessin_cadre_form_fond }

Begin { fenetre }
  Reset_Screen
End. { fenetre }
