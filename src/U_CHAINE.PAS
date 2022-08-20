Unit U_Chaine;
{
Modifi‚e par Pr‚martin Patrick
19/09/1993, Borland Pascal 7.0
}

Interface

Const
    Chaine_Vide = '';
    Espace      = ' ';

Type
    Chaine10 = String [10];
    Chaine20 = String [20];
    Chaine40 = String [40];
    Chaine80 = String [80];

    Vecteur_Chaine_20_10   = Array [1..10]   Of Chaine20;
    Vecteur_Chaine_20_100  = Array [1..100]  Of Chaine20;
    Vecteur_Chaine_20_1000 = Array [1..1000] Of Chaine20;

    Vecteur_Chaine = Vecteur_Chaine_20_100;
{
********************************************************************************
}
Procedure Copie_Milieu (Origine         : String;
                        Var Destination : String);
{ Recopie Origine dans Destination en cadrant la chaine, si la chaine de
d‚part est trop longue, on se contente d'en copier le d‚but. }

Function Lettre (C : Char) : Boolean;
{ Renvoie TRUE si le caractŠre pass‚ est bien une lettre (majuscule ou
minuscule). }

Function Lettre_Espace (C : Char) : Boolean;
{ Renvoie TRUE si le caractŠre pass‚ est une lettre ou un espace. }

Function Alphabetique (Ch : String) : Boolean;
{ Est TRUE si la chaine pass‚e est compos‚e uniquement d'espaces ou de
lettres. }

Function Numerique (Ch : String) : Boolean;
{ Est TRUE si la chaine pass‚e est compos‚e uniquement de chiffres. }

Procedure Complementer_Chaine (Var Ch : String; Longeur : Integer);
{ Compl‚mente la chaine par des espaces. }

Function Trait (C : Char; Longeur : Integer) : String;
{ Met Longueur caractŠres C dans la chaine r‚sultante. }

Function Justifier_gauche (Ch : String) : String;
{ Suppression des espaces au d‚but de la chaine. }

Function Justifier_Droite (Ch : String) : String;
{ Suppression des espaces … la fin de la chaine. }

Function Cadrer_Gauche (Ch : String) : String;
{ Cadrage de la chaine … gauche. }

Function Cadrer_Droite (Ch : String) : String;
{ Cadrage de la chaine … droite. }

Implementation
{
********************************************************************************
}
Procedure Copie_Milieu;
Var Debut, I : Integer;
Begin { copie_milieu }
  Debut := (Length (Destination) - Length (Origine)) Div 2;
  If (Debut < 1)
  Then
    Destination := Copy (Origine, 1, Length (Destination))
  Else
    For I := 1 To Length (Origine) Do
      Destination [Debut + I - 1] := Origine [I]
    {endfor}
  {endif}
End; { copie_milieu }
{
********************************************************************************
}
Function Lettre;
Begin { lettre }
  Lettre := ((Upcase (C) >= 'A') And (Upcase (C) <= 'Z'))
End; { lettre }
{
********************************************************************************
}
Function Lettre_Espace;
Begin { lettre_espace }
  Lettre_Espace := (Lettre (C) Or (C = ' '))
End; { lettre_espace }
{
********************************************************************************
}
Function Alphabetique;
Var I : Integer;
Begin { alphabetique }
  If (Ch = Chaine_Vide)
  Then
    Alphabetique := False
  Else
    Begin
      I := 1;
      While ((Lettre_Espace (Ch [I])) And (I < Length (Ch))) Do
        Inc (I)
      {endwhile};
      Alphabetique := Lettre_Espace (Ch [I])
    End
  {endif}
End; { alphabetique }
{
********************************************************************************
}
Function numerique;
Var I : Integer;
Begin { numerique }
  If (Ch = Chaine_Vide)
  Then
    numerique := False
  Else
    Begin
      I := 1;
      While ((ch [i] in ['0'..'9']) And (I < Length (Ch))) Do
        Inc (I)
      {endwhile};
      numerique := (Ch [I] in ['0'..'9'])
    End
  {endif}
End; { numerique }
{
********************************************************************************
}
Procedure Complementer_Chaine;
Begin { complementer_chaine }
  While (Length (Ch) < Longeur) Do
    Ch := Ch + ' '
  {endwhile}
End; { complementer_chaine }
{
********************************************************************************
}
Function Trait;
Var Aux : String;
    I   : Integer;
Begin { trait }
  Aux := '';
  For I := 1 To Longeur Do
    Aux := Aux + C
  {endfor};
  Trait := Aux
End; { trait }
{
********************************************************************************
}
Function Justifier_gauche;
Var I : Integer;
Begin { justifier_gauche }
  If (Length (Ch) <> 0)
  Then
    Begin
      I := 1;
      While ((Ch [I] = Espace) And (I < length (ch))) Do
        inc (I)
      {endwhile};
      If (Ch [I] = Espace)
      Then
        Justifier_gauche := Chaine_Vide
      Else
        Justifier_gauche := Copy (Ch, I, succ (length (ch)-i))
      {endif}
    End
  Else
    Justifier_gauche := Chaine_Vide
  {endif}
End; { justifier_gauche }
{
********************************************************************************
}
Function Justifier_Droite;
Var I : Integer;
Begin { justifier_droite }
  If (Length (Ch) <> 0)
  Then
    Begin
      I := Length (Ch);
      While ((Ch [I] = Espace) And (I > 1)) Do
        Dec (I)
      {endwhile};
      If (Ch [I] = Espace)
      Then
        Justifier_Droite := Chaine_Vide
      Else
        Justifier_Droite := Copy (Ch, 1, I)
      {endif}
    End
  Else
    Justifier_Droite := Chaine_Vide
  {endif}
End; { justifier_droite }
{
********************************************************************************
}
Function Cadrer_Gauche (Ch : String) : String;
Var Chaine : String;
    I      : Integer;
Begin { cadrer_gauche }
  I := 1;
  Chaine := Ch;
  While Not ((I = Length (Ch)) Or (Ch [I] <> ' ')) Do
    Begin
      Delete (Chaine, 1, 1);
      Chaine := Concat (Chaine, ' ');
      Inc (I)
    End
  {endwhile};
  Cadrer_Gauche := Chaine
End; { cadrer_gauche }
{
********************************************************************************
}
Function Cadrer_Droite (Ch : String) : String;
Var Chaine : String;
    I      : Integer;
Begin { cadrer_droite }
  I := Length (Ch);
  Chaine := Ch;
  While Not ((I < 2) Or (Ch [I] <> ' ')) Do
    Begin
      Delete (Chaine, Length (Chaine), 1);
      Chaine := Concat (' ', Chaine);
      Dec (I)
    End
  {endwhile};
  Cadrer_Droite := Chaine
End; { cadrer_droite }

End.
