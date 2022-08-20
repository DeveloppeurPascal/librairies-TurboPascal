Unit U_Aff_Speciaux;
{
Auteur: Pr‚martin Patrick.
Date: 17/07/1991.
Langage: Turbo Pascal 4.0
Date: 09/09/1991.
Langage: Turbo Pascal 6.0

But: Cette unit‚ permet d'afficher des textes de differentes facons.
}

Interface
Procedure Swap_Integer (Var A, B : Integer);
          { ‚change les valeurs de A et de B }

Procedure Clear_Screen;
          { efface le tampon en y mettant des espaces }
Procedure Clear_Bloc (X1, Y1, X2, Y2 : Integer);
          { efface le bloc sp‚cifi‚ du tampon }
Procedure Write_String (X, Y : Integer; Message : String);
          { met la chaine dans le tampon aux coordonn‚es d‚sir‚es }
Procedure Display_Carac (X, Y : Integer);
          { affiche le caractŠre correspondant aux coordonn‚es pass‚es }
Procedure Display_Escargot (X1, Y1, X2, Y2 : Integer);
          { affichage en escargot dans le cadre x1, y1, X2, Y2 }
Procedure Display_Ecran (X1, Y1, X2, Y2 : Integer);
          { affichage du bloc d‚fini par x1, y1, x2, y2 }
Procedure Display_Bloc_Horiz (X1, Y1, X2, Y2 : Integer);
          { affichage du bloc ligne par ligne }
Procedure Display_Bloc_Vert (X1, Y1, X2, Y2 : Integer);
          { affichage du bloc colonne par colonne }

Implementation
Uses
    crt,
    U_Code_Clavier,
    U_Curseur;

type
    p_ecran = ^t_ecran;
    t_ecran = array [1..80, 1..24] of char;

Var
   Matrice_Ecran : p_ecran;
   Rapidite : Boolean;

Procedure Swap_Integer (Var A, B : Integer);
Var
   C : Integer;
Begin
  C := A; A := B; B := C
End; { swap_integer }

Procedure Tst_Verif (Var X, Y : Integer);
Begin
     If ((X < 0) Or (X > 80))
     Then
         X := 1;
     {endif}
     If ((Y < 0) Or (Y > 24))
     Then
         Y := 1;
     {endif}
End; { tst_verif }

Procedure Clear_Screen;
Var
   I,
   J : Integer;
Begin
     For I := 1 To 80 Do
         For J := 1 To 24 Do
             Matrice_Ecran^ [I, J] := ' ';
         {endfor}
     {endfor}
End; { clear_screen }

Procedure Clear_Bloc (X1, Y1, X2, Y2 : Integer);
Var
   I,
   J : Integer;
Begin
     If (X1 > X2)
     Then
         Swap_Integer (X1, X2);
     {endif}
     If (Y1 > Y2)
     Then
         Swap_Integer (Y1, Y2);
     {endif}
     Tst_Verif (X1, Y1);
     Tst_Verif (X2, Y2);
     For I := X1 To X2 Do
         For J := Y1 To Y2 Do
             Matrice_Ecran^ [I, J] := ' ';
         {endfor}
     {endfor}
End; { clear_bloc }

Procedure Write_String (X, Y : Integer; Message : String);
Var
   I : Integer;
Begin
     If ((X >0) And (X < 81) And (Y > 0) And (Y < 26))
     Then
         Begin
              For I := 1 To Length (Message) Do
                  Begin
                       Matrice_Ecran^ [X, Y] := Message [I];
                       Inc (X);
                       If (X > 80)
                       Then
                           Begin
                                Dec (X, 80);
                                Inc (Y);
                           End;
                       {endif}
                       If (Y > 25)
                       Then
                           Y := 0;
                       {endif}
                  End;
              {endfor}
         End;
     {endif}
End; { write_string }

Procedure Display_Carac (X, Y : Integer);
Var
   I : Integer;
   Carac : Char;
Begin
     Tst_Verif (X, Y);
     If (Keypressed)
     Then
         Begin
              Carac := Readkey;
              Rapidite := (Carac = Touche_Escape);
         End;
     {endif}
     If Not Rapidite
     Then
         For I := 1 To 5 Do
             Begin
                  Curseur_Pave;
                  Gotoxy (X, Y);
                  Write (Matrice_Ecran^ [X, Y]);
                  Curseur_On;
             End
         {endfor}
     Else
         Begin
              Gotoxy (X, Y);
              Write (Matrice_Ecran^ [X, Y]);
         End;
     {endif}
End; { display_carac }

Procedure Display_Escargot (X1, Y1, X2, Y2 : Integer);
Var
   I : Integer;
Begin
     Tst_Verif (X1, Y1);
     Tst_Verif (X2, Y2);
     If (X1 > X2)
     Then
         Swap_Integer (X1, X2);
     {endif}
     If (Y1 > Y2)
     Then
         Swap_Integer (Y1, Y2);
     {endif}
     For I := X1 To X2 Do
         Display_Carac (I, Y1);
     {endfor}
     For I := Succ (Y1) To Y2 Do
         Display_Carac (X2, I);
     {endfor}
     For I := Pred (X2) Downto X1 Do
         Display_Carac (I, Y2);
     {endfor}
     For I := Pred (Y2) Downto Succ (Y1) Do
         Display_Carac (X1, I);
     {endfor}
     If ((X1 <> X2) And (Y1 <> Y2))
     Then
         Begin
              If (X1 < X2)
              Then
                  Inc (X1);
              {endif}
              If (Y1 < Y2)
              Then
                  Inc (Y1);
              {endif}
              If (X1 < X2)
              Then
                  Dec (X2);
              {endif}
              If (Y1 < Y2)
              Then
                  Dec (Y2);
              {endif}
              Display_Escargot (X1, Y1, X2, Y2);
         End;
     {endif}
End; { display_escargot }

Procedure Display_Ecran (X1, Y1, X2, Y2 : Integer);
Var
   I,
   J : Integer;
Begin
     Tst_Verif (X1, Y1);
     Tst_Verif (X2, Y2);
     For I := X1 To X2 Do
         For J := Y1 To Y2 Do
             Begin
                  Gotoxy (I, J);
                  Write (Matrice_Ecran^ [I, J]);
             End;
         {endfor}
     {endfor}
End; { display_ecran }

Procedure Display_Bloc_Horiz (X1, Y1, X2, Y2 : Integer);
Var
   I,
   J : Integer;
Begin
     Tst_Verif (X1, Y1);
     Tst_Verif (X2, Y2);
     For J := Y1 To Y2 Do
         For I := X1 To X2 Do
             Display_Carac (I, J);
         {endfor}
     {endfor}
End; { display_bloc_horiz }

Procedure Display_Bloc_Vert (X1, Y1, X2, Y2 : Integer);
Var
   I,
   J : Integer;
Begin
     Tst_Verif (X1, Y1);
     Tst_Verif (X2, Y2);
     For I := X1 To X2 Do
         For J := Y1 To Y2 Do
             Display_Carac (I, J);
         {endfor}
     {endfor}
End; { display_bloc_vert }

var
   old_exitproc : pointer;

{$f+}
procedure aff_sp_exit;
{$f-}
begin
     dispose (matrice_ecran);
     matrice_ecran := nil;
     exitproc := old_exitproc;
end; { Aff_Sp_Exit }

Begin
  Rapidite := False;
  Clear_Screen;
  new (matrice_ecran);
  if (matrice_ecran = nil)
  then
      begin
           writeln ('Not enough memory to run with Screens FX...');
           halt (1);
      end;
  {endif}
  old_exitproc := exitproc;
  exitproc := @aff_sp_exit;
End. { Fin de l'unit‚: 'U_Aff_Speciaux'. }
