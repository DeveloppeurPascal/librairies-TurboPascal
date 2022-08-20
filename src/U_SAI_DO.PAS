Unit U_Sai_Donnee;

{
Auteur: PrÇmartin Patrick.
Date: 28/12/1991.
      23/03/1991.
      07/05/1991.
      17/07/1991.
Langage: Turbo Pascal 4.0
Date: 26/08/1991.
      14/11/1991.
      21/07/1992.
      27/07/1992.
Langage: Turbo Pascal 6.0

But: Saisie de chaines selon un masque prÇcis.
}

Interface
Procedure Saisie_Texte (Masque : String; Var Result : String);
{
          attente d'un message au clavier, et retour du resultat.
               valeurs du masque:
                       - '9' : caractäres numeriques.
                               ('0'..'9')
                       - 'V' : point.
                               ('.')
                       - 'X' : caractäres quelconques.
                       - 'A' : caractäres alphabÇtiques.
                               ('A'..'Z', 'a'..'z')
                       - 'F' : caractäres des noms de fichier.
                               ('A'..'Z', '0'..'9', '_')
          Le nombre de caractäres du masque est une limite maximum Ö la
          longueur de Result.
          Vous pouvez passer une valeur par dÇfaut pour Result.
}

Implementation
Uses
    Crt,
    U_Code_Clavier,
    u_curseur;

Procedure Saisie_Texte (Masque : String; Var Result : String);
Var
   Carac : Char;
   X,
   Y,
   Long_Masque,
   i,
   k,
   j : Integer;
   ch : string;

  function valid : boolean;
  var
     ok : boolean;
  begin
       ok := false;
       Case (Masque [I]) Of
            '9' : ok := (carac in ['0'..'9']);
            'V' : ok := (Carac = '.');
            'X' : ok := true;
            'A' : ok := (upcase (carac) in ['A'..'Z']);
            'F' : if (upcase (carac) in ['A'..'Z', '0'..'9', '_'])
                  then
                      begin
                           carac := upcase (carac);
                           ok := true;
                      end;
                  {endif}
       End;
       valid := ok;
  end; { Valid }

  Procedure Valide_Carac_Saisie_Texte;
  Begin
       If (I <= Long_Masque)
       Then
           Begin
                Result [I] := Carac;
                if (i < long_masque)
                then
                    inc (i);
                {endif}
                inc (k);
           End;
       {endif}
  End; { valide_carac_saisie_texte }

  Procedure Choix_Dans_Saisie_Texte;
  Var
     J : Integer;
  Begin
       Case Carac Of
            Carac_Nul : case readkey of
                             Touche_Gauche : if (I > 1)
                                             Then
                                                 Dec (I);
                                             {endif}
                             touche_droite : begin
                                                  carac := result [i];
                                                  choix_dans_saisie_texte;
                             end;
                             touche_del : begin
                                               delete (result, i, 1);
                                               result := result + ' ';
                             end;
                             touche_ins : begin
                                               carac := ' ';
                                               if valid
                                               then
                                                   begin
                                                        insert (' ', result, i);
                                                        result := copy (result, 1, pred (long_masque));
                                                   end;
                                               {endif}
                             end;
            end;
            Touche_Backspace : If (I > 1)
                               Then
                                   Begin
                                        dec (i);
                                        delete (result, i, 1);
                                        Result := result + ' ';
                                   End;
                               {endif}
            Touche_Escape : Begin
                                 For J := 1 To Long_Masque Do
                                     Result [J] := ' ';
                                 {endfor}
                                 I := 1;
            End;
            Touche_Return : { Rien Ö faire car sortie de la procÇdure. }
       Else
           if valid
           then
               valide_carac_saisie_texte;
           {endif}
       End;
  End; { choix_dans_saisie_texte }

Begin
     ch := result;
     result := '';
     X := Wherex;
     Y := Wherey;
     j := 1;
     i := 1;
     k := 0;
     masque := masque;
     Long_Masque := Length (Masque);
     while not (j > long_masque) do
           Begin
                Masque [j] := Upcase (Masque [j]);
                If Not (Masque [j] In ['9', 'X', 'A', 'V', 'F', chr (0)])
                Then
                    Begin
                         Writeln ('Erreur dans le masque de saisie: ', Masque);
                         Writeln ('Le caractäre ', Masque [I], ' n''est pas autorisÇ.');
                         Halt;
                    End;
                {endif}
                if (j <= length (ch))
                then
                    carac := ch [j]
                else
                    carac := ' ';
                {endif}
                choix_dans_saisie_texte;
                inc (j);
           End;
     {endwhilel}
     for j := succ (k) to long_masque do
         result [j] := ' ';
     {endfor}
     result [0] := chr (long_masque);
     If (Long_Masque < 1)
     Then
         Result := ''
     Else
         begin
              i := 1;
              Repeat
                    curseur_off;
                    Gotoxy (X, Y);
                    Write (Result);
                    curseur_pave;
                    gotoxy (pred (x+i), y);
                    Carac := Readkey;
                    Choix_Dans_Saisie_Texte;
              Until (Carac = Touche_Return);
              curseur_on;
         end;
     {endif}
     result := copy (result, 1, long_masque);
     i := length (result);
     while ((i > 0) and (result [i] = ' ')) do
           dec (i);
     {endwhile}
     result [0] := chr (i);
End; { saisie_texte }

End. { Fin de l'unite 'U_Saisie_Donnee'. }
