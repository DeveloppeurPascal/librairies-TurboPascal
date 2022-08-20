Unit U_Ger_Ecran;
{
Auteur: Pr‚martin Patrick.
Date: 17/07/1991.
Langage: Turbo Pascal 4.0
Date: 09/09/1991.
Langage: Turbo Pascal 6.0

But: Cette unit‚ contient diverses procedures et fonctions permettant de
     connaitre diverses choses au sujet des caracteristiques de l'ecran
     utilis‚: largeur, hauteur, coordonnees de la fenetre actuelle...
}

Interface
Function Nombre_De_Colonnes : Byte;
         { renvoie le nombre de colonnes de la fenetre active. }
Function Nombre_De_Lignes : Byte;
         { renvoie le nombre de lignes de la fenetre active. }

Procedure Coordonnees_Fenetre (Var X1, Y1, X2, Y2 : Byte);
          { retourne les coordonnees de la fenetre active. }

Implementation
uses
    crt;

Function Nombre_De_Colonnes : Byte;
Var
   X,
   Y,
   Nb : Byte;
Begin
  X := Wherex;
  Y := Wherey;
  Nb := 0;
  Gotoxy (1, Y);
  While Not (Wherex = Nb) Do
    Begin
      Nb := Wherex;
      Gotoxy (Succ (Nb), Y)
    End
  {endwhile};
  Gotoxy (X, Y);
  Nombre_De_Colonnes := Nb
End; { nombre_de_colonnes }

Function Nombre_De_Lignes : Byte;
Var X, Y, Nb : Byte;
Begin
  X := Wherex;
  Y := Wherey;
  Nb := 0;
  Gotoxy (Wherex, 1);
  While Not (Wherey = Nb) Do
    Begin
      Nb := Wherey;
      Gotoxy (X, Succ (Nb))
    End
  {endwhile};
  Gotoxy (X, Y);
  Nombre_De_Lignes := Nb
End; { nombre_de_lignes }

Procedure Coordonnees_Fenetre (Var X1, Y1, X2, Y2 : Byte);
Begin
  X1 := Lo (Windmin);
  Y1 := Hi (Windmin);
  X2 := Lo (Windmax);
  Y2 := Hi (Windmax)
End; { coordonnees_fenetre }

End. { Fin de l'unit‚ 'Gestion_Ecran'. }
