Unit U_Score;
{
Auteur: Pr‚martin Patrick.
Date: 23/03/1991.
      10/05/1991.
Langage: Turbo Pascal 4.0
Date: 27/08/1991.
      09/09/1991.
      28/07/1992. (Interface Multi-Langues)
      06/09/1992.
Langage: Turbo Pascal 6.0

But: Gestion de scores pour divers jeux.
}
Interface
Procedure Init_Score (Nom_Fich : String);
          { Chargement du tableau de scores, ou initialisation de celui-ci. }
Procedure Sauve_Score (Nom_Fich : String);
          { Sauvegarde du tableau des scores. }
Procedure Nouveau_Score (Score, Max_Score : Integer);
          { Saisie du nom du joueur si le score est dans le tableau. }
Procedure Affichage_Score;
          { Affichage du tableau des scores. }

Implementation
Uses
    crt,
    u_msg,
    u_m_util,
    U_Sai_Donnee,
    u_sgf;

Const
     C_Nb_Max_Car_Chaine = 30;
     C_Nb_Score = 15;

Type
    T_Ch_Score = String [C_Nb_Max_Car_Chaine];
    T_Score = Record
                    Nom : T_Ch_Score;
                    Score : Integer;
                    Max_Score : Integer;
    End;
    p_score_lst = ^t_score_lst;
    T_Score_Lst = Array [1..C_Nb_Score] Of T_Score;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Quel est votre nom ?';
        2 : ch := 'Les meilleurs joueurs sont:';
        3 : ch := 'Votre score:';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'What is your name ?';
      2 : ch := 'Best players are:';
      3 : ch := 'Your score:';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

Var
   Score_Liste : p_Score_Lst;
   actual : t_score;

Procedure Set_Nom (Var Enreg : T_Score; Nom : T_Ch_Score);
Begin
     Enreg.Nom := Nom
End; { set_nom }

Function Get_Nom (Enreg : T_Score) : T_Ch_Score;
Begin
     Get_Nom := Enreg.Nom
End; { get_nom }

Procedure Set_Score (Var Enreg : T_Score; Score : Integer);
Begin
     Enreg.Score := Score
End; { set_score }

Function Get_Score (Enreg : T_Score) : Integer;
Begin
     Get_Score := Enreg.Score
End; { get_score }

Procedure Set_Max_Score (Var Enreg : T_Score; Max_Score : Integer);
Begin
     Enreg.Max_Score := Max_Score
End; { set_max_score }

Function Get_Max_Score (Enreg : T_Score) : Integer;
Begin
     Get_Max_Score := Enreg.Max_Score
End; { get_max_score }

Function N_Carac (Nb : Integer; Carac : Char) : String;
Var
   Chaine : String;
   I : Integer;
Begin
     Chaine := '';
     For I := 1 To Nb Do
         Chaine := Concat (Chaine, Carac);
     {endfor}
     N_Carac := Chaine;
End; { n_carac }

Procedure Init_Score (Nom_Fich : String);
Var
   I : Integer;

  Procedure Load_Score;
  Var
     Fich : File Of T_Score;
     J : Integer;
  Begin
       I := 0;
       {$i-}
       Assign (Fich, Nom_Fich);
       Reset (Fich);
       While Not ((Eof (Fich)) Or (I = C_Nb_Score)) Do
             Begin
                  Inc (I);
                  Read (Fich, Score_Liste^ [I]);
             End;
       {endwhile}
       Close (Fich);
       {$i+}
       If (Ioresult <> 0)
       Then
           I := 0;
       {endif}
       For J := Succ (I) To C_Nb_Score Do
           Begin
                Set_Nom (Score_Liste^ [I], '');
                Set_Score (Score_Liste^ [I], 0);
                Set_Max_Score (Score_Liste^ [I], -1);
           End;
       {endfor}
  End; { load_score }

Begin
     Met_Extension (Nom_Fich, '.SCR', Nom_Fich);
     If Exist (Nom_Fich)
     Then
         Load_Score
     Else
         For I := 1 To C_Nb_Score Do
             Begin
                  Set_Nom (Score_Liste^ [I], '');
                  Set_Score (Score_Liste^ [I], 0);
                  Set_Max_Score (Score_Liste^ [I], -1);
             End;
         {endfor}
     {endif}
     set_nom (actual, '');
End; { init_score }

Procedure Sauve_Score (Nom_Fich : String);
Var
   Fich : File Of T_Score;
   I : Integer;
Begin
     Met_Extension (Nom_Fich, '.SCR', Nom_Fich);
     {$i-}
     Assign (Fich, Nom_Fich);
     Rewrite (Fich);
     For I := 1 To C_Nb_Score Do
         Write (Fich, Score_Liste^ [I]);
     {endfor}
     Close (Fich);
     {$i+}
End; { sauve_score }

Procedure Nouveau_Score (Score, Max_Score : Integer);
Var
   Nom : String;
   I,
   J : Integer;
Begin
     textcolor (white);
     textbackground (black);
     Write (msg_ch (1));
     nom := '';
     textcolor (black);
     textbackground (lightgray);
     Saisie_Texte (N_Carac (C_Nb_Max_Car_Chaine, 'X'), Nom);
     set_nom (actual, nom);
     set_score (actual, score);
     set_max_score (actual, max_score);
     I := 1;
     While Not ((I = C_Nb_Score) Or (Score >= Get_Score (Score_Liste^ [I]))) Do
           Inc (I);
     {endwhile}
     If (Score >= Get_Score (Score_Liste^ [I]))
     Then
         Begin
              For J := C_Nb_Score Downto Succ (I) Do
                  Score_Liste^ [J] := Score_Liste^ [Pred (J)];
              {endfor}
              Set_Nom (Score_Liste^ [I], Nom);
              Set_Score (Score_Liste^ [I], Score);
              Set_Max_Score (Score_Liste^ [I] , Max_Score);
         End;
     {endif}
End; { nouveau_score }

Procedure Affichage_Score;
Var
   I,
   j : Integer;
Begin
     textcolor (lightgray);
     textbackground (black);
     clrscr;
     Writeln (msg_ch (2));
     Writeln;
     j := 0;
     i := 1;
     while ((j = 0) and (i <= c_nb_score)) do
       begin
         if ((get_nom (score_liste^ [i]) = get_nom (actual))
            and (get_score (score_liste^ [i]) = get_score (actual))
            and (get_max_score (score_liste^ [i]) = get_max_score (actual)))
         then
           j := i;
         {endif}
         inc (i);
       end;
     {endwhile}
     For I := 1 To C_Nb_Score Do
         Begin
              if (i = j)
              then
                textattr := (255-textattr) and 127;
              {endif}
              Write (I : 3, ' ', Get_Nom (Score_Liste^ [I]) : 30, ' ', Get_Score (Score_Liste^ [I]) : 6);
              If (Get_Max_Score (Score_Liste^ [I]) > -1)
              Then
                  Writeln (' / ', Get_Max_Score (Score_Liste^ [I]))
              Else
                  Writeln;
              {endif}
              if (i = j)
              then
                textattr := (255-textattr) and 127;
              {endif}
         End;
     {endfor};
     writeln;
     if (j = 0)
     then
       begin
         writeln(msg_ch (3));
         writeln;
         Write ('    ', Get_Nom (actual) : 30, ' ', Get_Score (actual) : 6);
         If (Get_Max_Score (actual) > -1)
         Then
             Writeln (' / ', Get_Max_Score (actual))
         Else
             Writeln;
         {endif}
       end;
     {endif}
     alert ('', al_wait);
End; { affichage_score }

var
   old_exitproc : pointer;

{$f+}
procedure score_exit;
{$f-}
begin
     dispose (score_liste);
     score_liste := nil;
     exitproc := old_exitproc;
end; { Score_Exit }

begin
     new (score_liste);
     if (score_liste = nil)
     then
         begin
              writeln ('Not enough memory to use a Score List...');
              halt (1);
         end;
     {endif}
     old_exitproc := exitproc;
     exitproc := @score_exit;
End. { Fin de l'unit‚ 'U_Score'. }
