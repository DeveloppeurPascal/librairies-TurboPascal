Unit U_Ger_Erreurs;         { Mise … jour le 17/07/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 19/05/1991.
      17/07/1991.

But: Gestion des erreurs d'entr‚e/sortie, et DOS.
}
Interface
Uses Crt,
     Dos;

Function Pas_D_Erreur (Intercept : Boolean) : Boolean;
         { Cette fonction est vraie si IORESULT = 0, et DOSERROR = 0.
           Sinon, elle affiche un message significatif … l'ecran dans le
           cas o— intercept est vrai. }

Implementation
Procedure Message_Alerte (Message : String; Keyshot : Boolean);
Var Carac : Char;
Begin { message_alerte }
  Gotoxy (1, 1);
  Insline;
  Write (Message);
  If Keyshot
  Then
    Begin
      While Keypressed Do
        Carac := Readkey
      {endwhile};
      Write (' Press a key.');
      Carac := Readkey
    End
  {endif};
  Delline
End; { message_alerte }

Function Pas_D_Erreur (Intercept : Boolean) : Boolean;
Var Erreur_Io,
    Erreur_Dos : Integer;
    Result     : Boolean;
Begin { pas_d_erreur }
  Erreur_Io := Ioresult;
  Erreur_Dos := Doserror;
  Result := ((Erreur_Io = 0) And (Erreur_Dos = 0));
  If ((Intercept) And Not Result)
  Then
    Begin
      Case Erreur_Io Of
        100 : Message_Alerte ('Disk read error...', True);
        101 : Message_Alerte ('Disk write error...', True);
        102 : Message_Alerte ('File not assigned...', True);
        103 : Message_Alerte ('File not open...', True);
        104 : Message_Alerte ('File not open for input...', True);
        105 : Message_Alerte ('File not open for output...', True);
        106 : Message_Alerte ('Invalid numeric format...', True)
      Else
        Case Doserror Of
          2 : Message_Alerte ('File not found...', True);
          3 : Message_Alerte ('Path not found...', True);
          4 : Message_Alerte ('Too many file open...', True);
          5 : Message_Alerte ('File access denied...', True);
          6 : Message_Alerte ('Invalid file handle...', True);
          12 : Message_Alerte ('Invalid file access code...', True);
          15 : Message_Alerte ('Invalid drive number...', True);
          16 : Message_Alerte ('Cannot remove current directory...', True);
          17 : Message_Alerte ('Cannot rename accross drive...', True)
        Else
          Message_Alerte ('Unknow error...', True)
        End
      End
    End
  {endif}
End; { pas_d_erreur }

End. { Fin de l'unit‚: 'U_GERE_ERREURS'. }
