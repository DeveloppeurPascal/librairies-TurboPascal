Unit U_Clavier;              { mise … jour le 01/03/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 01/03/1991.

Cette unit‚ contient des fonctions trŠs utiles pour acc‚der au clavier sans
passer par l'unit‚ CRT.
}
Interface

{$l u_clavier.obj}

Function Readkey : Char;
         { Renvoie un caractŠre contenu dans le tampon clavier, ou attend que
         l'on appuit sur une touche. }
Function Keypressed : Boolean;
         { Est vraie si le tampon clavier contient des caractŠres. }
Function Shiftkey : Byte;
         { Indique l'‚tat des touches sp‚ciales. }

Implementation

Function Readkey : Char; External;
Function Touche_Pressee : Byte; External;
Function Shiftkey : Byte; External;

Function Keypressed : Boolean;
Begin { keypressed }
  Keypressed := (Touche_Pressee <> 0)
End; { keypressed }

End. { Fin de l'unit‚ 'U_Clavier'. }
