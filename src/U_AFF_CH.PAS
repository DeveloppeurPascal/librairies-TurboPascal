Unit U_Aff_Chaine;
{
Auteur: Pr‚martin Patrick.
Date: 17/07/1991.
Langage: Turbo Pascal 4.0

Date: 17/08/1992. 30/12/1992. 02/01/1993.
Langage: Turbo Pascal 6.0

Cette unit‚ contient des proc‚dures et fonctions utiles pour l'affichage de
chaines.
}
Interface
{ Partie des functions utiles … l'affichage. }
Function Nombre_Colonnes : word;
         { renvoie le nombre de colonnes de la fenetre courante. }
Function Len (Chaine : String): Byte;
         { renvoie la longueur de la chaine }
Function Non_Pos_Left (Carac : Char; Chaine : String): Byte;
         { cherche la position du premier caractŠre diff‚rent de carac …
         partir de la gauche de la chaine. }
Function Non_Pos_Right (Carac : Char; Chaine : String): Byte;
         { cherche la position du premier caractŠre diff‚rent de carac …
         partir de la droite de la chaine. }

{ Partie des procedures d'affichage. }
Procedure Affic_Debut_Fin (Chaine : String; Debut, Fin : Byte);
          { affiche la chaine … partir de DEBUT jusqu'… FIN }
Procedure Affic_Space (Nombre : Byte);
          { affiche nombre espaces … partir de la position courante }
Procedure Affic (Chaine : String);
          { affiche la chaine normalement }
Procedure Affic_Ln (Chaine : String);
          { affiche chaine puis change de ligne }
Procedure Affic_Xy (Chaine : String; X, Y : Byte);
          { affiche chaine en (X,Y) }
Procedure Affic_Xy_Ln (Chaine : String; X, Y : Byte);
          { affiche chaine en (X,Y) puis change de ligne }
Procedure Affic_Center (Chaine : String);
          { centre la chaine sur la ligne courante et l'affiche }
Procedure Affic_Center_Ln (Chaine : String);
          { centre la chaine, l'affiche, puis change de ligne }
Procedure Affic_Center_Y (Chaine : String; Y : Byte);
          { centre la chaine en ligne Y puis l'affiche }
Procedure Affic_Center_Y_Ln (Chaine : String; Y: Byte);
          { centre la chaine en ligne Y, l'affiche, change de ligne }
Procedure Affic_Left (Chaine : String);
          { cadrage de la chaine … gauche }
Procedure Affic_Left_Ln (Chaine : String);
          { cadrage de la chaine … gauche, puis ligne suivante }
Procedure Affic_Left_Y (Chaine : String; Y : Byte);
          { cadrage … gauche, en ligne Y }
Procedure Affic_Left_Y_Ln (Chaine : String; Y : Byte);
          { cadrage … gauche, en ligne Y, ligne suivante }
Procedure Affic_Right (Chaine : String);
          { cadrage … droite }
Procedure Affic_Right_Ln (Chaine : String);
          { cadrage … droite, ligne suivante }
Procedure Affic_Right_Y (Chaine : String; Y : Byte);
          { cadrage … droite en ligne Y }
Procedure Affic_Right_Y_Ln (Chaine : String; Y : Byte);
          { cadrage … droite en ligne Y, ligne suivante }

{ Fin de l'interface. }

Implementation
uses
    crt,
    u_int10h;

Function Len (Chaine : String): Byte;
Begin { len }
  Len := Ord (Chaine [0])
End; { len }

Function Non_Pos_Left (Carac : Char; Chaine : String): Byte;
Var I, Longueur_Chaine : Byte;
Begin { non_pos_left }
  Longueur_Chaine := Len (Chaine);
  If (Longueur_Chaine > 0)
  Then
    Begin
      I := 1;
      While ((I < Longueur_Chaine) And (Chaine [I] = Carac)) Do Inc (I);
      If (Chaine [I] <> Carac)
      Then
        Non_Pos_Left := I
      Else
        Non_Pos_Left := 0
      {endif}
    End
  Else
    Non_Pos_Left := 0
  {endif}
End; { non_pos_left }

Function Non_Pos_Right (Carac : Char; Chaine : String): Byte;
Var I, Longueur_Chaine : Byte;
Begin { non_pos_right }
  Longueur_Chaine := Len (Chaine);
  If (Longueur_Chaine > 0)
  Then
    Begin
      I := Longueur_Chaine;
      While ((I > 1) And (Chaine [I] = Carac)) Do Dec (I);
      If (Chaine [I] <> Carac)
      Then
        Non_Pos_Right := I
      Else
        Non_Pos_Right := 0
      {endif}
    End
  Else
    Non_Pos_Right := 0
  {endif}
End; { non_pos_right }

Function Nombre_Colonnes : word;
var
   res : word;
Begin { nombre_colonnes }
  case get_mode of
    8 : res := 20;
    0, 1, 4, 5, 9, 13, 19  : res := 40;
    2, 3, 6, 7, 10, 14, 15, 16, 17, 18 : res := 80;
  else
    res := 80;
  end;
  nombre_colonnes := res;
End; { nombre_colonnes }

Procedure Affic_Debut_Fin (Chaine : String; Debut, Fin : Byte);
Var I, Longueur_Chaine : Byte;
Begin { affic_debut_fin }
  Longueur_Chaine := Len (Chaine);
  If (Fin > Longueur_Chaine) Then Fin := Longueur_Chaine;
  If (Debut < 1) Then Debut := 1;
  For I := Debut To Fin Do Write (Chaine [I])
End; { affic_debut_fin }

Procedure Affic_Space (Nombre : Byte);
Var I : Byte;
Begin { affic_space }
  For I := 1 To Nombre Do Write (' ')
End; { affic_space }

Procedure Affic (Chaine : String);
Begin { affic }
  Affic_Debut_Fin (Chaine, 1, Len (Chaine));
End; { affic }

Procedure Affic_Ln (Chaine : String);
Begin { affic_ln }
  Affic (Chaine);
  Writeln
End; { affic_ln }

Procedure Affic_Xy (Chaine : String; X, Y : Byte);
Begin { affic_xy }
  Gotoxy (X, Y);
  Affic (Chaine)
End; { affic_xy }

Procedure Affic_Xy_Ln (Chaine : String; X, Y : Byte);
Begin { affic_xy_ln }
  Affic_Xy (Chaine, X, Y);
  Writeln
End; { affic_xy_ln }

Procedure Affic_Center (Chaine : String);
Var X, Debut, Fin : Byte;
Begin { affic_center }
  Gotoxy (1, Wherey);
  Debut := Non_Pos_Left (' ', Chaine);
  Fin := Non_Pos_Right (' ', Chaine);
  X := ((Nombre_Colonnes-Fin+Debut) Div 2)+1;
  If (X > 0)
  Then
    Gotoxy (X, Wherey)
  {endif};
  Affic_Debut_Fin (Chaine, Debut, Fin)
End; { affic_center }

Procedure Affic_Center_Ln (Chaine : String);
Begin { affic_center_ln }
  Affic_Center (Chaine);
  Writeln
End; { affic_center_ln }

Procedure Affic_Center_Y (Chaine : String; Y : Byte);
Begin { affic_center_y }
  Gotoxy (1, Y);
  Affic_Center (Chaine)
End; { affic_center_y }

Procedure Affic_Center_Y_Ln (Chaine : String; Y : Byte);
Begin { affic_center_y_ln }
  Affic_Center_Y (Chaine, Y);
  Writeln
End; { affic_center_y_ln }

Procedure Affic_Left (Chaine : String);
Var Longueur_Chaine, Debut : Byte;
Begin { affic_left }
  Longueur_Chaine := Len (Chaine);
  Debut := Non_Pos_Left (' ', Chaine);
  Gotoxy (1, Wherey);
  Affic_Debut_Fin (Chaine, Debut, Longueur_Chaine)
End; { affic_left }

Procedure Affic_Left_Ln (Chaine : String);
Begin { affic_left_ln }
  Affic_Left (Chaine);
  Writeln
End; { affic_left_ln }

Procedure Affic_Left_Y (Chaine : String; Y : Byte);
Begin { affic_left_y }
  Gotoxy (1, Y);
  Affic_Left (Chaine)
End; { affic_left_y }

Procedure Affic_Left_Y_Ln (Chaine : String; Y : Byte);
Begin { affic_left_y_ln }
  Affic_Left_Y (Chaine, Y);
  Writeln
End; { affic_left_y_ln }

Procedure Affic_Right (Chaine : String);
Var X, Longueur_Chaine, Fin : Byte;
Begin { affic_right }
  Longueur_Chaine := Len (Chaine);
  Fin := Non_Pos_Right (' ', Chaine);
  X := Nombre_Colonnes-Fin+1;
  If (X > 0)
  Then
    Gotoxy (X, Wherey)
  {endif};
  Affic_Debut_Fin (Chaine, 1, Fin)
End; { affic_right }

Procedure Affic_Right_Ln (Chaine : String);
Begin { affic_right_ln }
  Affic_Right (Chaine);
  Writeln
End; { affic_right_ln }

Procedure Affic_Right_Y (Chaine : String; Y : Byte);
Begin { affic_right_y }
  Gotoxy (1, Y);
  Affic_Right (Chaine)
End; { affic_right_y }

Procedure Affic_Right_Y_Ln (Chaine : String; Y : Byte);
Begin { affic_right_y_ln }
  Affic_Right_Y (Chaine, Y);
  Writeln
End; { affic_right_y_ln }

End. { affic_chaine }
