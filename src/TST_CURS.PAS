Program Tst_Curseur;

Uses Crt,
     U_Curseur,
     U_Code_Clavier;

Var I, J : Integer;
    Carac : Char;

Begin
  I := 1;
  J := 1;
  While Keypressed Do Carac := Readkey;
  Repeat
    Clrscr;
    Curseur_Locate (I, J);
    Write (Curseur_X : 4, Curseur_Y : 4);
    Carac := Readkey;
    Case Carac Of
      Carac_Nul : Case Readkey Of
                    Touche_Haut   : Dec (J);
                    Touche_Bas    : Inc (J);
                    Touche_Gauche : Dec (I);
                    Touche_Droite : Inc (I);
                  End;
      '1'       : Curseur_Off;
      '2'       : Curseur_On;
      '3'       : Curseur_Haut;
      '4'       : Curseur_Pave;
      '5'       : Curseur_Milieu;
      '6'       : Curseur_Bas
    Else
      Write (Carac_Bell)
    End
  Until (Carac = Touche_Escape)
End.
