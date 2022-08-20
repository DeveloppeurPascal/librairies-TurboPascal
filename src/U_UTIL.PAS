Unit U_Util;                 { Mise … jour le 17/07/1991 }
{
Auteur : Pr‚martin Patrick.
Date :   10-02-1991.
         28-02-1991.
         17-07-1991.
         28/07/1992. (Interface Multi-Langue d'Olf Software)

Cette unit‚ regroupe diverses procedures et fonctions permettant d'am‚liorer
l'interface entre l'utilisateur et l'ordinateur.
}
Interface

Uses U_Code_Clavier,
     U_Fenetre,
     U_Ger_Chaine,
     U_Aff_Chaine,
     U_Sgf,
     Crt;

Const C_Nb_Ligne_Ecran = 20;

Type T_String78    = String [78];
     T_Ecran       = Array [1..C_Nb_Ligne_Ecran] Of T_String78;
     T_Texte_Affic = Record
                       Ecran    : T_Ecran;
                       Nb_Ligne : Integer
                     End;

Procedure Vide_Tampon_Clavier;
          { Cette proc‚dure vide le tampon du clavier. }
Procedure Attente_Appuit_Touche;
          { Cette proc‚dure attend l'appuit d'une touche. }
Procedure Message_Alerte (Chaine : String; Attente_Touche : Boolean);
          { Cette procedure affiche un message et attend eventuellement. }
Procedure Affichage_Ecran (Titre : String; Var Ecran_Aff : T_Texte_Affic);
          { Cette procedure affiche les lignes de l'ecran pass‚. }

Function Changer_Valeur (Titre : String; Borne_Min, Borne_Max, Valeur : Integer) : Integer;
         { Cette fonction permet la saisie d'une valeur … l'aide du clavier. }
Function Ask_Nom_Fichier (Chaine,
                          Nom1,
                          Extension : String;
                          Tst_Exist : Boolean) : String;
         { Cette fonction renvoie le nom du fichier choisi. }
Function Question_Oui_Non (Chaine : String; Defaut : Boolean) : Boolean;
         { Cette fonction est vraie si l'utilisateur a r‚pondu Oui. }
Function Question_Alerte (Chaine : String): Boolean;
         { Cette fonction est vraie si l'utilisateur choisi Oui … la question
         posee. }

Implementation
uses
    u_msg;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Appuyez sur une touche.';
        2 : ch := 'Valeur de d‚part: ';
        3 : ch := 'Valeur actuelle: ';
        4 : ch := 'Ancien nom: ';
        5 : ch := 'Nouveau nom: ';
        6 : ch := 'Oui';
        7 : ch := 'Non';
        8 : ch := 'Votre choix ? ';
        9 : ch := 'Votre choix (Oui/Non) ?';
        10 : ch := 'O'; { OUI }
        11 : ch := 'N'; { NON }
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Press a key.';
      2 : ch := 'First value: ';
      3 : ch := 'User value: ';
      4 : ch := 'Old name: ';
      5 : ch := 'New name: ';
      6 : ch := 'Yes';
      7 : ch := 'No';
      8 : ch := 'Your choice ? ';
      9 : ch := 'Your choice (Yes/No) ?';
      10 : ch := 'Y'; { YES }
      11 : ch := 'N'; { NO }
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

Procedure Vide_Tampon_Clavier;
Var Carac : Char;
Begin { vide_tampon_clavier }
  While (Keypressed) Do
    Carac := Readkey
  {endwhile}
End; { vide_tampon_clavier }

Procedure Attente_Appuit_Touche;
Var Old_Textattr : Byte;
    Carac        : Char;
Begin { attente_appuit }
  Vide_Tampon_Clavier;
  Old_Textattr := Textattr;
  Textcolor (White);
  Textbackground (Black);
  Affic_Center (msg_ch (1));
  Vide_Tampon_Clavier;
  Carac := Readkey;
  Vide_Tampon_Clavier;
  Textattr := Old_Textattr
End; { attente_appuit }

Procedure Message_Alerte (Chaine : String; Attente_Touche : Boolean);
Var Old_Textattr : Integer;
Begin { message_alerte }
  Old_Textattr := Textattr;
  Type_Cadre := 2;
  Window_Cadre_Bis (2, 2, 79, 2, Red, Blue);
  Window_Titre (Chaine, White, Blue);
  Textbackground (Black);
  Clrscr;
  If (Attente_Touche)
  Then
    Begin
      Attente_Appuit_Touche;
      Clear_Window
    End
  {endif};
  Textattr := Old_Textattr
End; { message_alerte }

Procedure Affichage_Ecran (Titre : String; Var Ecran_Aff : T_Texte_Affic);
Var I : Integer;
Begin { affichage_ecran }
  Type_Cadre := 5;
  Window_Fond_Cadre_Bis (2, 2, 78, Succ (Ecran_Aff.Nb_Ligne + 2), Lightgray, Red, Brown);
  Window_Titre (Titre, Black + Blink, Brown);
  Textcolor (Brown);
  Textbackground (Lightgray);
  I := 1;
  With Ecran_Aff Do
    While Not ((I > Nb_Ligne) Or (I > C_Nb_Ligne_Ecran)) Do
      Writeln (Ecran [I])
    {endwhile}
  {endwith};
  Writeln;
  Attente_Appuit_Touche;
  Clear_Window
End; { affichage_ecran }

Function Changer_Valeur (Titre : String; Borne_Min, Borne_Max, Valeur : Integer) : Integer;
Var Old_Valeur : Integer;
    Carac      : Char;
    Chaine     : String;
Begin { changer_valeur }
  Vide_Tampon_Clavier;
  Type_Cadre := 8;
  Window_Cadre (2, 2, 79, 3, Red);
  Window_Titre (Titre, White, Red);
  Textcolor (White);
  Textbackground (Black);
  Clrscr;
  Old_Valeur := Valeur;
  Str (Old_Valeur, Chaine);
  Chaine := Concat (msg_ch (2), Chaine);
  Affic_Center_Y (Chaine, 1);
  Repeat
    Gotoxy (1, 2);
    Clreol;
    Str (Valeur, Chaine);
    Chaine := Concat (msg_ch (3), Chaine);
    Affic_Center_Y (Chaine, 2);
    Carac := Readkey;
    Case (Carac) Of
      Carac_Nul     : Case (Readkey) Of
                        Touche_Haut : If (Valeur < Borne_Max - 4) Then Valeur := Valeur+5;
                        Touche_Bas  : If (Valeur > Borne_Min + 4) Then Valeur := Valeur-5
                      Else
                        Write (Carac_Bell)
                      End;
      '+'           : If (Valeur < Borne_Max) Then Inc (Valeur);
      '-'           : If (Valeur > Borne_Min) Then Dec (Valeur);
      Touche_Escape : Valeur := Old_Valeur;
      Touche_Return :
    Else
      Write (Carac_Bell)
    End
  Until ((Carac = Touche_Escape) Or (Carac = Touche_Return));
  Changer_Valeur := Valeur;
  Clear_Window
End; { changer_valeur }

Function Ask_Nom_Fichier (Chaine,
                          Nom1,
                          Extension : String;
                          Tst_Exist : Boolean) : String;
Var Nom2   : String;
    Sortie : Boolean;
Begin { ask_nom_fichier }
  Vide_Tampon_Clavier;
  Nom1 := Set_Maj_Chaine (Nom1);
  Type_Cadre := 2;
  Window_Fond_Cadre_Bis (2, 2, 79, 3, Red, White, Lightgray);
  Window_Titre (Chaine, Red, Lightgray);
  Textcolor (White);
  Textbackground (Red);
  Repeat
    Clrscr;
    Writeln (msg_ch (4), Nom1);
    Write (msg_ch (5));
    Readln (Nom2);
    Met_Extension (Nom2, Extension, Nom2);
    Nom2 := Set_Maj_Chaine (Nom2);
    If ((Tst_Exist) And (Nom2 <> Extension))
    Then
      Sortie := Exist (Nom2)
    Else
      Sortie := True
    {endif}
  Until (Sortie);
  If (Nom2 <> Extension)
  Then
    Ask_Nom_Fichier := Nom2
  Else
    Ask_Nom_Fichier := Nom1
  {endif};
  Clear_Window
End; { ask_nom_fichier }

Function Question_Oui_Non (Chaine : String; Defaut : Boolean) : Boolean;
Var Carac : Char;
Begin { question_oui_non }
  Type_Cadre := 6;
  Window_Fond_Cadre_Bis (2, 2, 79, 4, Lightgray, Lightred, Blue);
  Window_Titre (Chaine, White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Affic_Center_Ln ('1 - '+msg_ch (6));
  Affic_Center_Ln ('2 - '+msg_ch (7));
  Affic_Center (msg_ch (8));
  If (Defaut)
  Then
    Write ('1')
  Else
    Write ('2')
  {endif};
  Vide_Tampon_Clavier;
  Repeat
    Carac := Readkey
  Until ((Carac = Touche_Return) Or (Carac = '1') Or (Carac = '2'));
  Clear_Window;
  Question_Oui_Non := ((Carac = '1') Or ((Carac = Touche_Return) And Defaut));
  Vide_Tampon_Clavier
End; { question_oui_non }

Function Question_Alerte (Chaine : String): Boolean;
Var Carac : Char;
Begin { question_alerte }
  Vide_Tampon_Clavier;
  Type_Cadre := 2;
  Window_Fond_Cadre_Bis (2, 2, 79, 2, Black, Red, Blue);
  Window_Titre (Chaine, White, Blue);
  Affic_Center (msg_ch (9));
  Repeat
    Carac := Upcase (Readkey);
    Write (Carac);
    Gotoxy (Pred (Wherex), Wherey)
  Until ((Carac = msg_ch (10)) Or (Carac = msg_ch (11)));
  Clear_Window;
  Question_Alerte := (Carac = msg_ch (10));
  Vide_Tampon_Clavier
End; { question_alerte }

End. { Fin de l'unit‚ 'U_Util'. }
