Program Tst_Graph;

Uses Crt,
     U_Graph,
     U_Mouse;

Var X, Y, K : Integer;
    Couleur : T_Graph_Couleur;

Procedure Change_Couleur;
Begin { change_couleur }
  If (Couleur >= 15)
  Then
    Couleur := 0
  Else
    Inc (Couleur)
  {endif};
  Graph_Color (Couleur);
  Repeat
  Until (Mousek = 0)
End; { change_couleur }

Begin
  Graph_Init (6);
  Show_Mouse;
  Repeat
    Mouse_X_Y_K (X, Y, K);
    Case K Of
      1 : Graph_Plot (X, Y);
      2 : Change_Couleur
    End
  Until (Keypressed)
End.
