Unit U_Ger_Chaine;          { mise … jour : 17/07/1991. }
{
Cette unit‚ contient des proc‚dures et fonctions utiles pour la gestion de
chaines.
}
Interface
{ Partie des fonctions. }
Function Len (Chaine: String): Byte;
         { renvoie la longueur de la chaine }
Function Upcase (Carac: Char): Char;
         { renvoie le caractŠre en majuscule ou lui-meme }
Function Downcase (Carac: Char): Char;
         { renvoie le caractŠre en minuscule ou lui-meme }
Function Set_Maj_Chaine (Chaine : String): String;
         { met la chaine en majuscules. }
Function Set_Min_Chaine (Chaine : String): String;
         { met la chaine en minuscules. }

{ Partie des procedures de traitement de chaines. }
Procedure Maj_Chaine (Chaine1: String; Var Chaine2: String);
          { met Chaine1 en majuscules dans Chaine2 }
Procedure Min_Chaine (Chaine1: String; Var Chaine2: String);
          { met Chaine1 en minuscules dans Chaine2 }

{ Fin de l'interface. }

Implementation
Function Len (Chaine: String): Byte;
Begin { len }
 Len := Ord (Chaine [0])
End; { len }

Function Upcase (Carac: Char): Char;
Begin { upcase }
 If ((Carac >= 'a') And (Carac <= 'z'))
 Then
   Upcase := Chr (Ord (Carac)+Ord ('A')-Ord ('a'))
 Else
   Upcase := Carac
 {endif}
End; { upcase }

Function Downcase (Carac: Char): Char;
Begin { downcase }
 If ((Carac >= 'A') And (Carac <= 'Z'))
 Then
   Downcase := Chr (Ord (Carac)+Ord ('a')-Ord ('A'))
 Else
   Downcase := Carac
 {endif}
End; { downcase }

Function Set_Maj_Chaine (Chaine : String): String;
Var Chaine2 : String;
Begin { set_maj_chaine }
  Maj_Chaine (Chaine, Chaine2);
  Set_Maj_Chaine := Chaine2
End; { set_maj_chaine }

Function Set_Min_Chaine (Chaine : String): String;
Var Chaine2 : String;
Begin { set_min_chaine }
  Min_Chaine (Chaine, Chaine2);
  Set_Min_Chaine := Chaine2
End; { set_min_chaine }

Procedure Maj_Chaine (Chaine1: String; Var Chaine2: String);
Var I : Byte;
Begin { max_chaine }
 Chaine2 [0] := Chaine1 [0];
 For I := 1 To Len (Chaine1) Do
   Chaine2 [I] := Upcase (Chaine1 [I])
 {endfor}
End; { max_chaine }

Procedure Min_Chaine (Chaine1: String; Var Chaine2: String);
Var I : Byte;
Begin { min_chaine }
 Chaine2 [0] := Chaine1 [0];
 For I := 1 To Len (Chaine1) Do
   Chaine2 [I] := Downcase (Chaine1 [I])
 {endfor}
End; { min_chaine }

End. { Gere_chaine }
