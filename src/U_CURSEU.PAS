Unit U_Curseur;
{
Auteur: Pr‚martin Patrick.
Date : 01/03/1991.
       09/03/1991.
Langage: Turbo Pascal 4.0
Date: 09/09/1991.
Langage: Turbo Pascal 6.0

But: Cette unit‚ contient des proc‚dures et fonctions permettant de g‚rer le
     curseur sans passer par l'unit‚ CRT.
}
Interface

{$l u_curseur.obj}

Procedure Curseur_On;
          { Cette proc‚dure montre le curseur normal (par d‚faut). }
Procedure Curseur_Off;
          { Cette proc‚dure cache le curseur. }
Procedure Curseur_Pave;
          { Cette proc‚dure fabrique un curseur carr‚ prenant la taille d'un
          caractŠre. }
Procedure Curseur_Haut;
          { Cette proc‚dure fabrique un curseur dont le tiret est en haut. }
Procedure Curseur_Milieu;
          { Cette procedure fabrique un curseur dont le tiret est au milieu. }
Procedure Curseur_Bas;
          { Cette procedure fabrique un curseur dont le tiret est en bas. }
Procedure Curseur_Locate (X, Y : Integer);
          { Cette proc‚dure positionne le curseur dans la page 0. }

Function Curseur_X : Integer;
         { Cette fonction renvoie l'abscisse du curseur dans la page 0. }
Function Curseur_Y : Integer;
         { Cette fonction renvoie l'ordonn‚e du curseur dans la page 0. }

Implementation

Procedure Curseur_On;                      External;
Procedure Curseur_Off;                     External;
Procedure Curseur_Pave;                    External;
Procedure Curseur_Haut;                    External;
Procedure Curseur_Milieu;                  External;
Procedure Curseur_Bas;                     External;
Procedure Curseur_Locate (X, Y : Integer); External;
Function Curseur_X : Integer;              External;
Function Curseur_Y : Integer;              External;

var
   old_exitproc : pointer;

{$f+}
procedure curseur_exit;
{$f-}
begin
     curseur_on;
     exitproc := old_exitproc;
end; { Curseur_Exit }

begin
     old_exitproc := exitproc;
     exitproc := @curseur_exit;
End. { Fin de l'unit‚ 'U_Curseur'. }
