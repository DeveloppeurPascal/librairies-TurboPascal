Unit U_Selection;
{
Modifi‚e par Patrick Pr‚martin
Le 28/07/1992.
Pour l'Interface Multi-Langues de Olf Software.
19/09/1993, Borland Pascal 7.0
}

Interface
uses
    u_chaine;

{*****************************************************************************}

Procedure Cadre(X1,Y1,X2,Y2: Integer; Titre:Chaine80);
{ Visualisation d'un cadre }

Procedure Entete(Ch:Chaine80);
{ visualisation de l entete encadree }

Procedure Inverse_Video;
Procedure Video_Normale;
Procedure Video_Clignotante;

Function Oui(Question:String):Boolean;
{ redemande de la question jusqu a saisie de o ou n }

Procedure Menu_Ligne(Y:Integer; Menu:Chaine80; Var Reponse:Char);

Procedure Selection
        (X1,Y1,X2,Y2:Integer; {coordonnees de la fenetre}
        Var Liste:Vecteur_Chaine;Nb_Liste:Integer; { ensemble des donnees a traiter }
        Depart:Integer; { position de depart du curseur }
        Efface:Boolean; { effacement de la fenetre }
        Var Position:Integer { rang de l element dans la liste
                              POSITION=0 SI non selection } );

Procedure Selec_Menu
        (X1,Y1,X2,Y2:Integer; {coordonnees de la fenetre}
        Var Liste:Vecteur_Chaine;Nb_Liste:Integer; { ensemble des commandes a traiter }
        Depart:Integer; { position de depart du curseur }
        Efface:Boolean; { effacement de la fenetre }
        Var Position:Integer { rang de l element dans la liste
                              POSITION=0 SI non selection } );

Procedure Saisir_Entier(Inf,Sup:Integer;Var Entier:Integer);
{ saisie d un entier compris entre INF et SUP }

Procedure Visu_Attente(Ch:String);
{ visualisation sur la derniere ligne }

Procedure Vidange_Tampon_Clavier;
{ Vide le buffer du clavier, et enlŠve tous les caractŠres en attente. }

Implementation
{************}

Uses
    Crt,
    u_msg,
    U_Code_Clavier;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'O'; { Oui }
        2 : ch := 'N'; { Non }
        3 : ch := 'Pressez une touche...';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Y'; { Yes }
      2 : ch := 'N'; { No }
      3 : ch := 'Press a key...';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

Procedure Vidange_Tampon_Clavier;
Var Carac : Char;
Begin { vidange_tampon_clavier }
  While Keypressed Do
    Carac := Readkey
  {endwhile}
End; { vidange_tampon_clavier }

{*****************************************************************************}

Procedure Cadre (X1, Y1, X2, Y2: Integer; Titre : Chaine80);
Const
    Vertical   = #186;
    Horizontal = #205;
    Coin_No    = #201;
    Coin_So    = #200;
    Coin_Ne    = #187;
    Coin_Se    = #188;
Var
    K, I, J : Integer;
Begin { cadre }
  Gotoxy (X1, Y1);
  For I := X1 To X2 Do
    Write (Horizontal)
  {endfor};
  For J := Y1 + 1 To Y2 - 1 Do
    Begin
      Gotoxy (X1, J);
      Write (Vertical);
      Gotoxy (X2, J);
      Write (Vertical)
    End
  {endfor};
  Gotoxy (X1, Y2);
  For I:=X1 To X2 Do
    Write(Horizontal)
  {endfor};
  Gotoxy (X1, Y1);
  Write (Coin_No);
  Gotoxy (X2, Y1);
  Write (Coin_Ne);
  Gotoxy (X1, Y2);
  Write (Coin_So);
  Gotoxy (X2, Y2);
  Write (Coin_Se);
  If (Titre <> Chaine_Vide)
  Then
    Begin
      If (Length (Titre) > X2 - X1 - 1)
      Then
        Titre:= Copy (Titre, 1, X2 - X1 - 1)
      {endif};
      K := X1 + (X2 - X1 + 1 - Length (Titre)) Div 2;
      Gotoxy (K, Y1);
      Write (Titre)
    End
  {endif}
End; { cadre }

{*****************************************************************************}

Procedure Entete;
Var X : Integer;
Begin { entete }
  X := (80 - Length (Ch)) Div 2;
  Gotoxy (X, 1);
  Write (Trait ('*', Length (Ch) + 4));
  Gotoxy (X, 2);
  Write ('* ', Ch, ' *');
  Gotoxy (X, 3);
  Writeln (Trait ('*',Length (Ch) + 4));
  Writeln
End; { entete }

{*****************************************************************************}

Procedure Video_Normale;
Begin { video_normale }
  Textattr := $7
End; { video_normale }

{*****************************************************************************}

Procedure Inverse_Video;
Begin { inverse_video }
  Textattr := $70
End; { inverse_video }

{*****************************************************************************}

Procedure Video_Clignotante;
Begin { video_clignotante }
  Textattr := $F0
End; { video_clignotante }

{*****************************************************************************}

Procedure Menu_Ligne (Y : Integer; Menu : Chaine80; Var Reponse : Char);
Begin { menu_ligne }
  Gotoxy (1, Y);
  Write (Menu);
  Readln (Reponse)
End; { menu_ligne }

{*****************************************************************************}

Procedure Selection;
  Var C:Char;
      Max_Ligne_Fenetre,Largeur:Integer;

  Procedure Fenetre;
  {****************}
  Begin
      Largeur:=X2-X1;
      Max_Ligne_Fenetre:=Y2-Y1+1;
      Window(X1,Y1,X2,Y2);
  End;

  Procedure Ecran;
  {**************}
  Begin
      Window(1,1,80,25)
  End;

  Procedure Affichage(I:Integer);
  {****************************************}
  Var X,Y,Nb:Integer;
  Begin
      X:=Wherex;Y:=Wherey;
      Clrscr;
      Nb:=1;
      While Not((Nb=Max_Ligne_Fenetre) Or (I>Nb_Liste))Do
      Begin
          Writeln(Copy(Liste[I],1,Largeur));
          I:=I+1;
          Nb:=Nb+1
      End;
      If I<= Nb_Liste Then Write(Copy(Liste[I],1,Largeur));
      Gotoxy(X,Y)
  End;

  Procedure Visu;
  {*************}
  Begin
      Inverse_Video;
      Write(Copy(Liste[Position],1,Largeur));
      Write(Carac_Cr);
      Video_Normale
  End;

  Procedure Saisir;
  {***************}
  Begin
      C:=Readkey;
      If C=Carac_Nul Then C:=Readkey
  End;

  Procedure Ligne_Dessus;
  {*********************}
  Begin
      If Position<>1
      Then Begin
               Write(Copy(Liste[Position],1,Largeur));
               Write(Carac_Cr);
               Position:=Position-1;
               If Wherey<>1
               Then Gotoxy(1,Wherey-1)
               Else Begin
                        Insline;
                        Write(Copy(Liste[Position],1,Largeur));
                        Write(Carac_Cr)
                    End
           End
 End;

 Procedure Ligne_Dessous;
 {**********************}
 Var Y:Integer;
 Begin
     If Position<Nb_Liste
     Then Begin
              Write(Copy(Liste[Position],1,Largeur));
              Write(Carac_Cr);
              Position:=Position+1;
              If Wherey=Max_Ligne_Fenetre
              Then Begin
                       Y:=Wherey;
                       Gotoxy(1,1);
                       Delline;
                       Gotoxy(1,Y);
                       Write(Copy(Liste[Position],1,Largeur));
                       Write(Carac_Cr)
                   End
              Else Write(Carac_Lf)
           End
 End;

 Procedure Page_Dessus;
 {********************}
 Var Debut_Page:Integer;
 Begin
     Debut_Page:=Position+1-Wherey-Max_Ligne_Fenetre;
     If Debut_Page >= 1
     Then Begin
              Affichage(Debut_Page);
              Position:=Position-Max_Ligne_Fenetre
          End
     Else Begin
              Position:=Wherey;
              Affichage(1)
          End;
 End;

 Procedure Page_Dessous;
 {*********************}
 Var Debut_Page:Integer;
 Begin
     Debut_Page:=Position+1+Max_Ligne_Fenetre-Wherey;
     If Debut_Page <= Nb_Liste
     Then Begin
              Affichage(Debut_Page);
              Position:=Position+Max_Ligne_Fenetre;
              If Position>Nb_Liste
              Then Begin
                       Position:=Debut_Page;
                       Gotoxy(1,1)
                   End
          End
 End;

 Procedure Debut_Liste;
 {********************}
 Begin
     Gotoxy(1,1);
     Affichage(1);
     Position:=1
 End;

 Procedure Fin_Liste;
 {******************}
 Begin
     If Nb_Liste < Max_Ligne_Fenetre
     Then Begin
              Gotoxy(1,Nb_Liste);
              Affichage(1)
          End
     Else Begin
              Gotoxy(1,Max_Ligne_Fenetre);
              Affichage(Nb_Liste+1-Max_Ligne_Fenetre)
          End;
     Position:=Nb_Liste
 End;

Begin {de la procedure selection}

    If Nb_Liste = 0
    Then Begin
             Position := 0;
             Exit
         End;
    Fenetre;
    Position:=Depart;
    Affichage(Position);
    Visu;
    Saisir;
    While Not((C=Touche_Return) Or (C=Touche_Escape)) Do
    Begin
        Case C Of
             Touche_Haut:Ligne_Dessus;
             Touche_Bas:Ligne_Dessous;
             Touche_Page_Up:Page_Dessus;
             Touche_Page_Dn:Page_Dessous;
             Touche_Home:Debut_Liste;
             Touche_End:Fin_Liste;
        End;
        Visu;
        Saisir
    End;
    If C=Touche_Escape Then Position:=0;
    If Efface Then Clrscr;
    Ecran
End;

{*****************************************************************************}

Procedure Selec_Menu;
  Var C:Char;
      Max_Ligne_Fenetre,Largeur:Integer;

  Procedure Fenetre;
  {****************}
  Begin
      Largeur:=X2-X1;
      Max_Ligne_Fenetre:=Y2-Y1+1;
      Window(X1,Y1,X2,Y2);
  End;

  Procedure Ecran;
  {**************}
  Begin
      Window(1,1,80,25)
  End;

  Procedure Affichage(I:Integer);
  {****************************************}
  Var X,Y,Nb:Integer;
  Begin
      X:=Wherex;Y:=Wherey;
      Clrscr;
      Nb:=1;
      While Not((Nb=Max_Ligne_Fenetre) Or (I>Nb_Liste))Do
      Begin
          Writeln(Copy(Liste[I],1,Largeur));
          I:=I+1;
          Nb:=Nb+1
      End;
      If I<= Nb_Liste Then Write(Copy(Liste[I],1,Largeur));
      Gotoxy(X,Y)
  End;

  Procedure Visu;
  {*************}
  Begin
      Inverse_Video;
      Write(Copy(Liste[Position],1,Largeur));
      Write(Carac_Cr);
      Video_Normale
  End;

  Procedure Saisir;
  {***************}
  Begin
      C:=Readkey;
      If C=Carac_Nul Then C:=Readkey
  End;

  Procedure Ligne_Dessus;
  {*********************}
  Begin
      If Position<>1
      Then Begin
               Write(Copy(Liste[Position],1,Largeur));
               Write(Carac_Cr);
               Position:=Position-1;
               If Wherey<>1
               Then Gotoxy(1,Wherey-1)
               Else Begin
                        Insline;
                        Write(Copy(Liste[Position],1,Largeur));
                        Write(Carac_Cr)
                    End
           End
 End;

 Procedure Ligne_Dessous;
 {**********************}
 Var Y:Integer;
 Begin
     If Position<Nb_Liste
     Then Begin
              Write(Copy(Liste[Position],1,Largeur));
              Write(Carac_Cr);
              Position:=Position+1;
              If Wherey=Max_Ligne_Fenetre
              Then Begin
                       Y:=Wherey;
                       Gotoxy(1,1);
                       Delline;
                       Gotoxy(1,Y);
                       Write(Copy(Liste[Position],1,Largeur));
                       Write(Carac_Cr)
                   End
              Else Write(Carac_Lf)
           End
 End;

 Procedure Page_Dessus;
 {********************}
 Var Debut_Page:Integer;
 Begin
     Debut_Page:=Position+1-Wherey-Max_Ligne_Fenetre;
     If Debut_Page >= 1
     Then Begin
              Affichage(Debut_Page);
              Position:=Position-Max_Ligne_Fenetre
          End
     Else Begin
              Position:=Wherey;
              Affichage(1)
          End;
 End;

 Procedure Page_Dessous;
 {*********************}
 Var Debut_Page:Integer;
 Begin
     Debut_Page:=Position+1+Max_Ligne_Fenetre-Wherey;
     If Debut_Page <= Nb_Liste
     Then Begin
              Affichage(Debut_Page);
              Position:=Position+Max_Ligne_Fenetre;
              If Position>Nb_Liste
              Then Begin
                       Position:=Debut_Page;
                       Gotoxy(1,1)
                   End
          End
 End;

 Procedure Debut_Liste;
 {********************}
 Begin
     Gotoxy(1,1);
     Affichage(1);
     Position:=1
 End;

 Procedure Fin_Liste;
 {******************}
 Begin
     If Nb_Liste < Max_Ligne_Fenetre
     Then Begin
              Gotoxy(1,Nb_Liste);
              Affichage(1)
          End
     Else Begin
              Gotoxy(1,Max_Ligne_Fenetre);
              Affichage(Nb_Liste+1-Max_Ligne_Fenetre)
          End;
     Position:=Nb_Liste
 End;

Begin {de la procedure selection}
    Vidange_Tampon_Clavier;
    Fenetre;
    Position:=Depart;
    Affichage(Position);
    Visu;
    Saisir;
    While Not((C=Touche_Return) Or (C=Touche_Escape)) Do
    Begin
        Case C Of
             Touche_Haut:Ligne_Dessus;
             Touche_Bas:Ligne_Dessous;
             Touche_Page_Up:Page_Dessus;
             Touche_Page_Dn:Page_Dessous;
             Touche_Home:Debut_Liste;
             Touche_End:Fin_Liste;
        End;
        Visu;
        Saisir
    End;
    If C=Touche_Escape Then Position:=0;
    If Efface Then Clrscr;
    Vidange_Tampon_Clavier;
    Ecran
End;

{*****************************************************************************}

Function Oui;
Var Reponse : Char;
    X, Y    : Integer;
    Non     : Boolean;
Begin { oui }
  X := Wherex;
  Y := Wherey;
  Repeat
    Gotoxy (X,Y);
    Write (Question, ' ');
    Vidange_Tampon_Clavier;
    Reponse := Upcase (Readkey);
    Write (Reponse)
  Until (Reponse = msg_ch (1)) Or (Reponse = msg_ch (2));
  Vidange_Tampon_Clavier;
  Oui := (Reponse = msg_ch (1))
End;

{*****************************************************************************}

Procedure Saisir_Entier;
Var X, Y, Code : Integer;
    Ch         : String [10];
Begin { saisir_entier }
  X := Wherex;
  Y := Wherey;
  Repeat
    Gotoxy (X, Y);
    Readln (Ch);
    Val (Ch, Entier, Code)
  Until ((Code = 0) And (Entier >= Inf) And (Entier <= Sup))
End; { saisir_entier }

{*****************************************************************************}

Procedure Visu_Attente;
Var C : Char;
Begin { visu_attente }
  Gotoxy (1, 25);
  Write (Ch, ' ');
  Write (msg_ch (3));
  Vidange_Tampon_Clavier;
  C := Readkey;
  Vidange_Tampon_Clavier;
  Gotoxy (1, 25);
  Clreol
End; { visu_attente }

{*****************************************************************************}

End.
