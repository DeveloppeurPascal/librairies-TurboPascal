Unit U_Masq;
{
Modifi‚e par Patrick Pr‚martin
le 30/07/1992
pour l'interface multi-langues de Olf Software.
19/09/1993, Borland Pascal 7.0
25/09/1993.
}

Interface
{
       UTILITAIRE DE SAISIE DE DONNEES AVEC MASQUE

  LECTURE des caracteristiques du masque de saisie sur un fichier texte
  une ligne par champ ,les caracteristiques sont separees par des virgules

               _ les deux coordonnees X et Y du debut de la zone
               _ un code  F: zone fixe ( en ecriture seulement )
                          V: zone variable ( en lecture ecriture )
               si zone fixe
               alors
                   _ libelle de la zone
               sinon
                   _ le type de la zone
                         C : caractere
                         M : caractŠre majuscule
                         A : alphabetique (espace compris)
                         N : Num‚rique
                         I : integer
                         R : reel
                   _ longueur de la zone
               finsi

  VALIDATION des caracteristiques du masque ecran

  SAISIE avec positionnement du curseur a l'aide des touches FLECHES et
  VALIDATION des donnees par rapport a leur type
  MEMORISATION des donnees sous la forme de chaines
}
Uses Crt,
     U_Chaine,
     U_Code_Clavier,
     U_Selection;

Const
    Nb_Max_Zone = 50;       { nombre de champs maximum }
    Long_Max    = 50;

Type
    Chaine_Masque = String [Long_Max];
    Chaine80      = String [80];
    Nu_Ligne      = 1..24;
    Nu_Colonne    = 1..80;
    Enreg_Zone    = Record
                      X : Nu_Colonne;
                      Y : Nu_Ligne;
                      Case Code_Es : Char Of
                        'F' : ( Libelle  : Chaine_Masque );
                        'V' : ( Le_Type  : Char;
                                Longueur : 1..Long_Max;
                                Valeur   : Chaine_Masque )
                      {endcase}
                    End;
    Masque        = Record
                      Nb_Zone : Integer;
                      Zone    : Array [1..Nb_Max_Zone] Of Enreg_Zone;
                    End;

Procedure Affiche_Masque (Var Ecran : Masque;
                          Raz       : Boolean);
{ affichage du masque avec remise a zero eventuelle }

Procedure Lire_Masque (Var Ecran   : Masque;
                       Fich_Masque : Chaine20);
{ lecture des caracteristiques du masque de saisie sur un fichier texte
  de nom : FICH_MASQUE.MSQ le format est indique ci-dessus
  il y a validation avec arret a la premiere anomalie detectee }

Procedure Saisir_Masque (Var Ecran   : Masque;
                         Var Raz,
                             Abandon : Boolean);
{ affichage des libelles des zones a saisir avec:
            - remise a blanc des zones a saisir si RAZ
            - re_affichage des anciennes donnees si NON RAZ
   lecture des donnees avec deplacement diriges par les FLECHES
   la saisie est effective apres activation de CR
   ABANDON : vraie si touche ESC activee }

Implementation
uses
    u_sgf,
    u_msg;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Confirmer (O/N) ?';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Confirm (Y/N) ?';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

{
*******************************************************************************
}
Procedure Affiche_Masque (Var Ecran : Masque;
                          Raz       : Boolean);
Var I, K : Integer;
Begin { affiche_masque }
  If Raz
  Then {remplissage des zones variables par des espaces}
    For I := 1 To Ecran.Nb_Zone Do
      With Ecran.Zone [I] Do
        If (Code_Es = 'V')
        Then
          Begin
            Valeur := Chaine_Vide;
            For K := 1 To Longueur Do
              case (le_type) of
                'N' : valeur := valeur + '0';
              else
                Valeur := Valeur + Espace
              end;
            {endfor}
          End;
        {endif}
      {endwith}
    {endfor}
{visualisation des zones}
    video_normale;
    Clrscr;
    For I := 1 To Ecran.Nb_Zone Do
      With Ecran.Zone [I] Do
        Begin
          Gotoxy (X, Y);
          If (Code_Es = 'F')
          Then
            Write (Libelle, ' ')
          Else
            Begin
              Inverse_Video;
              Write (Valeur);
              Video_Normale
            End
          {endif}
        End
      {endwith}
    {endfor}
  {endif}
End; { affiche_masque }
{
*******************************************************************************
}
Procedure Lire_Masque (Var Ecran   : Masque;
                       Fich_Masque : Chaine20);
  Var Ligne,
      Aux               : String;
      X, Y,
      Coderreur         : Integer;
      Erreur,
      Une_Zone_Variable : Boolean;
      Fich              : Text;
      ch : string;

  Procedure Traiter_Erreur;
  Begin { traiter_erreur }
    If Erreur
    Then
      Begin
        Gotoxy (1, 23);
        writeln ('MASQUE: ', ch);
        Writeln ('ERREUR DANS LA LIGNE ', Ecran.Nb_Zone, ' DU FICHIER MASQUE');
        Writeln ('ARRET DU PROGRAMME');
        Halt
      End
    {endif}
  End; { traiter_erreur }

  Procedure Extraire;
  Var I : Integer;
  Begin { extraire }
    I := Pos (',', Ligne);
    Aux := Copy (Ligne, 1, I-1);
    Delete (Ligne, 1, I)
  End; { extraire }

Begin { lire_masque }
  Clrscr;
  met_extension (fich_masque, 'MSQ', ch);
  ch := get_file_name (ch);
  Assign (Fich, ch);
  {$i-}
  Reset (Fich);
  {$i+}
  if (ioresult <> 0)
  then
    halt (ioresult);
  {endif}
  Une_Zone_Variable := False;

  With Ecran Do
    Begin
      Nb_Zone := 0;
      While Not Eof (Fich) Do
        Begin
          Readln (Fich, Ligne);
          Erreur := (Nb_Zone = Nb_Max_Zone);
          If Erreur
          Then
            Begin
              Gotoxy (1, 23);
              writeln ('MASQUE: ', ch);
              Writeln ('LE NOMBRE DE CHAMPS DU MASQUE EST TROP GRAND');
              Writeln ('ARRET DU PROGRAMME');
              Halt
            End
          Else
            Begin
              Nb_Zone := Nb_Zone + 1;
              With Zone [Nb_Zone] Do
                Begin
                  Extraire;
                  Val (Aux, X, Coderreur);
                  Erreur := ((Coderreur <> 0) Or (X < 1) Or (X > 80));
                  Traiter_Erreur;
                  Extraire;
                  Val (Aux, Y, Coderreur);
                  Erreur := ((Coderreur <> 0) Or (Y < 1) Or (Y > 24));
                  Traiter_Erreur;
                  Extraire;
                  Code_Es := Aux [1];
                  Erreur := ((Code_Es <> 'F') And (Code_Es <> 'V'));
                  Traiter_Erreur;
                  If (Code_Es = 'F')
                  Then
                    Begin
                      Libelle := Ligne;
                      Erreur := (Libelle = Chaine_Vide);
                      Traiter_Erreur;
                    End
                  Else
                    Begin
                      Une_Zone_Variable := True;
                      Extraire;
                      Le_Type := Aux [1];
                      erreur := not (le_type in ['A', 'C', 'I', 'R', 'N', 'M']);
                      Traiter_Erreur;
                      Val (Ligne, Longueur, Coderreur);
                      Erreur:=((Coderreur <> 0) Or (Longueur < 1) Or
                               (Longueur > Long_Max));
                      Traiter_Erreur
                    End
                  {endif}
                End
              {endwith}
            End
          {endif}
        End
      {endwhile}
    End
  {endwith};
  If Not Une_Zone_Variable
  Then
    Begin
      Gotoxy (1, 23);
      writeln ('MASQUE: ', ch);
      Writeln ('IL FAUT AU MOINS UNE ZONE VARIABLE');
      Writeln ('ARRET DU PROGRAMME');
      Halt
    End
  {endif};
  Close(Fich)
End; { lire_masque }
{
*******************************************************************************
}
Procedure Saisir_Masque (Var Ecran   : Masque;
                         Var Raz,
                             Abandon : Boolean);
Var Confirme,
    Conflit_De_Type : Boolean;
    i               : integer;

  Procedure Lire; { Saisie des diff‚rents champs … l'aide du clavier. }
  Var C                   : Char;
      Zone_Courante,
      Position            : Integer;
      Caractere_Rajoute,
      Caractere_Editable,
      Caractere_Fleche    : Boolean;
      old_value           : string;

    Function Debut_Zone : Integer; { Renvoie l'abscisse du d‚but de la zone. }
    Begin { debut_zone }
      Debut_Zone := Ecran.Zone [Zone_Courante].X
    End; { debut_zone }

    Function Fin_Zone : Integer; { Renvoie l'ordonn‚e du d‚but de la zone. }
    Begin { fin_zone }
      With Ecran.Zone [Zone_Courante] Do
        Fin_Zone := Debut_Zone + Longueur - 1
      {endwith}
    End; { fin_zone }

    Procedure Aller; { Positionnement au d‚but de la Zone_Courante. }
    Begin { aller }
      With Ecran.Zone [Zone_Courante] Do
        Gotoxy (Debut_Zone, Y)
      {endwith};
      Position:=1;
      old_value := ecran.zone [zone_courante].valeur;
    End; { aller }

    Procedure Saisir; { Saisie d'un caractŠre. }
    Begin { saisir }
      Caractere_Editable := False;
      Caractere_Fleche   := False;
      Caractere_Rajoute  := False;
      C := Readkey;
      If (C <> Carac_Nul)
      Then
        Begin
          Caractere_Editable := (C >= Espace);
          Caractere_Rajoute  := (C = Touche_Backspace);
          caractere_fleche := (c in [touche_tab, touche_ctrl_return]);
        End
      Else
        Begin
          C := Readkey;
          Caractere_Fleche  := (C In [Touche_Gauche, Touche_Droite, Touche_Bas,
                               Touche_Haut, touche_shift_tab]);
          Caractere_Rajoute := (C In [Touche_Del, Touche_Home, Touche_End,
                               Touche_Page_Up, Touche_Page_Dn, Touche_Ins])
        End
      {endif}
    End; { saisir }

    procedure remplissage_zone;
    var
       i : byte;
    begin
      for i := position to ecran.zone [zone_courante].longueur do
        ecran.zone [zone_courante].valeur [i] := ' ';
      {endfor}
      position := succ (ecran.zone [zone_courante].longueur);
    end; { remplissage_zone }

    procedure cadrage_zone;
    var
       ch : string;
    begin
      if (zone_courante > 0)
      then
        begin
          if (ecran.zone [zone_courante].le_type = 'N')
          then
            begin
              if (old_value <> ecran.zone [zone_courante].valeur)
              then
                remplissage_zone;
              {endif}
              ch := justifier_droite (justifier_gauche (ecran.zone [zone_courante].valeur));
              ecran.zone [zone_courante].valeur := trait ('0', ecran.zone [zone_courante].longueur - length (ch))+ch;
            end;
          {endif}
          gotoxy (ecran.zone [zone_courante].x, ecran.zone [zone_courante].y);
          write (ecran.zone [zone_courante].valeur);
        end;
      {endif}
    end; { cadrage_zone }

    Procedure Zone_Suivante; { Positionnement sur la zone suivante. }
    Begin { zone_suivante }
      cadrage_zone;
      Repeat
        If (Zone_Courante = Ecran.Nb_Zone)
        Then
          Zone_Courante := 1
        Else
          Inc (Zone_Courante)
        {endif}
      Until (Ecran.Zone [Zone_Courante].Code_Es = 'V');
      Aller
    End; { zone_suivante }

    Procedure Zone_Precedente; { Positionnement sur la zone pr‚c‚dente. }
    Begin { zone_precedente }
      cadrage_zone;
      Repeat
        If (Zone_Courante = 1)
        Then
          Zone_Courante := Ecran.Nb_Zone
        Else
          Dec (Zone_Courante)
        {endif}
      Until (Ecran.Zone [Zone_Courante].Code_Es = 'V');
      Aller
    End; { zone_precedente }

    procedure zone_lig_suivante;
    var
       zc, lig : integer;
    begin
      zc := zone_courante;
      lig := ecran.zone [zc].y;
      zone_suivante;
      while ((zc <> zone_courante) and (lig = ecran.zone [zone_courante].Y)) do
        zone_suivante;
      {endwhile}
    end; { zone_lig_suivante }

    procedure zone_lig_precedente;
    var
       zc, lig : integer;
    begin
      zc := zone_courante;
      lig := ecran.zone [zc].y;
      zone_precedente;
      while ((zc <> zone_courante) and (lig = ecran.zone [zone_courante].Y)) do
        zone_precedente;
      {endwhile}
    end; { zone_lig_precedente }

    Procedure Zone_Finale; { Positionnement sur la derniŠre zone variable. }
    Begin { zone_finale }
      cadrage_zone;
      Zone_Courante := Ecran.Nb_Zone;
      While (Ecran.Zone [Zone_Courante].Code_Es <> 'V') Do
        Dec (Zone_Courante)
      {endwhile};
      Aller
    End; { zone_finale }

    Procedure Zone_De_Depart; { Positionnement sur la premiŠre zone variables. }
    Begin { zone_de_depart }
      cadrage_zone;
      Zone_Courante := 1;
      While (Ecran.Zone [Zone_Courante].Code_Es <> 'V') Do
        Inc (Zone_Courante)
      {endwhile};
      Aller
    End; { zone_de_depart }

    function carac_valide (c : char; t : char) : boolean;
    begin
      carac_valide := ((t in ['C', 'M'])
                      or ((t = 'A') and alphabetique (c))
                      or ((t in ['N', 'I', 'R']) and (c in [' ', '0'..'9'])));
    end; { carac_valide }

  Begin { lire }
    Inverse_Video;
    Zone_Courante := 0;
    Zone_Suivante;
    Saisir;
    While Not ((C = Touche_Return) Or (C = Touche_Escape)) Do
      Begin
{ Curseur … l'intŠrieur de la zone courante, et modification ‚ventuelle. }
        If Caractere_Editable and (carac_valide (c, ecran.zone [zone_courante].le_type))
        Then
          Begin
            if (ecran.zone [zone_courante].le_type = 'M')
            then
              c := upcase (c);
            {endif}
            Ecran.Zone [Zone_Courante].Valeur [Position] := C;
            Position := Position + 1;
            Write (C);
            If (Wherex > Fin_Zone)
            Then
              Zone_Suivante
            {endif}
          End
        Else
          If Caractere_Fleche
          Then
            Case C Of
{ D‚placement du curseur vers la droite (ou en d‚but de la zone suivante. }
              Touche_Droite : Begin
                                Gotoxy (Wherex + 1, Wherey);
                                Position := Position + 1;
                                If (Wherex > Fin_Zone)
                                Then
                                  Zone_Suivante
                                {endif}
                              End;
{ D‚placement du curseur vers la zone suivante. }
              touche_tab : Zone_Suivante;
{ D‚placement vers la zone se trouvant sur une des lignes suivantes. }
              touche_bas : zone_lig_suivante;
              touche_haut : zone_lig_precedente;
{ D‚placement du curseur vers la gauche ou sur la zone pr‚c‚dente. }
              Touche_Gauche : Begin
                                Gotoxy (Wherex - 1, Wherey);
                                Position := Position - 1;
                                If (Wherex < Debut_Zone)
                                Then
                                  Zone_Precedente
                                {endif}
                              End;
{ D‚placement du curseur vers la zone pr‚c‚dente. }
              touche_shift_tab : Zone_Precedente;
{ Effacement de la fin de la zone. }
              touche_ctrl_return : begin
                                     remplissage_zone;
                                     zone_suivante;
                                   end;
            End
          Else
            If Caractere_Rajoute
            Then
              Case C Of
{ Effacement du caractŠre sous le curseur avec d‚calage du reste de la zone. }
                Touche_Del : Begin
                               Delete (Ecran.Zone [Zone_Courante].Valeur, Position, 1);
                               Ecran.Zone [Zone_Courante].Valeur := Concat
                                 (Ecran.Zone [Zone_Courante].Valeur, Espace);
                               Gotoxy (Debut_Zone, Wherey);
                               Write (Ecran.Zone [Zone_Courante].Valeur);
                               Gotoxy (Pred (Debut_Zone + Position), Wherey)
                             End;
{ Effacement du caractŠre … gauche du curseur avec d‚calage de la zone. }
                Touche_Backspace : Begin
                                     If (Position > 1)
                                     Then
                                       Begin
                                         Dec (Position);
                                         Delete (Ecran.Zone [Zone_Courante].Valeur, Position, 1);
                                         Ecran.Zone [Zone_Courante].Valeur := Concat
                                           (Ecran.Zone [Zone_Courante].Valeur, Espace);
                                         Gotoxy (Debut_Zone, Wherey);
                                         Write (Ecran.Zone [Zone_Courante].Valeur);
                                         Gotoxy (Pred (Debut_Zone + Position), Wherey)
                                       End
                                     {endif}
                                   End;
{ Positionnement en d‚but de la zone. }
                Touche_Home : Begin
                                Position := 1;
                                Gotoxy (Debut_Zone, Wherey)
                              End;
{ Positionnement en fin de la zone. }
                Touche_End : Begin
                               Position := Ecran.Zone [Zone_Courante].Longueur;
                               Gotoxy (Fin_Zone, Wherey)
                             End;
{ Positionnement sur la premiŠre zone. }
                Touche_Page_Up : Zone_De_Depart;
{ Positionnement sur la derniŠre zone. }
                Touche_Page_Dn : Zone_Finale;
{ Insertion d'un espace … la position courante du curseur. }
                Touche_Ins : Begin
                               Insert (' ', Ecran.Zone [Zone_Courante].Valeur, Position);
                               Ecran.Zone [Zone_Courante].Valeur := Copy
                                 (Ecran.Zone [Zone_Courante].Valeur, 1,
                                 Ecran.Zone [Zone_Courante].Longueur);
                               Gotoxy (Debut_Zone, Wherey);
                               Write (Ecran.Zone [Zone_Courante].Valeur);
                               Gotoxy (Pred (Debut_Zone + Position), Wherey)
                             End;
              End
            {endif}
          {endif};
        Saisir
      End
    {endwhile};
    Video_Normale;
    Abandon := (C = Touche_Escape)
  End; { lire }

  Procedure Valider; { validation de chaque zone en fonction de son type }
  Var Entier, I,
      Coderreur  : Integer;
      Aux        : Chaine80;
      Reel       : Real;
  Begin { valider }
    Conflit_De_Type := False;
    I := 1;
    While Not ((I > Ecran.Nb_Zone) Or Conflit_De_Type) Do
      Begin
        With Ecran.Zone [I] Do
          begin
            If (Code_Es = 'V')
            Then
              Begin
                Aux := Justifier_Droite (Valeur);
                If (Aux <> Chaine_Vide)
                Then
                  Case Le_Type Of
                    'A': Conflit_De_Type := Not Alphabetique (Aux);
                    'N': Conflit_De_Type := Not Numerique(justifier_gauche(Aux));
                    'I': Begin
                           Val (Aux, Entier, Coderreur);
                           Conflit_De_Type := (Coderreur <> 0)
                         End;
                    'R': Begin
                           Val (Aux, Reel, Coderreur);
                           Conflit_De_Type := (Coderreur <> 0)
                         End
                  End
                {endif}
              End;
            {endif}
            if ((not conflit_de_type) and (le_type = 'N'))
            then
              valeur := trait ('0', longueur - length (aux)) + aux;
            {endif}
          end;
        {endwith}
        I:=I+1
      End;
    {endwhile}
    If Conflit_De_Type
    Then
      Begin
        Str (I - 1 : 3, Aux);
        Video_Clignotante;
        Gotoxy (Ecran.Zone [I-1].X, Ecran.Zone [I-1].Y);
        Write (Ecran.Zone [I-1].Valeur);
        Video_Normale;
        Visu_Attente ('CONFLIT DE TYPE DANS LA ZONE ' + Aux)
      End
    {endif}
  End; { valider }

Begin { saisir_masque }
  Repeat
    Affiche_Masque (Ecran, Raz);
    Raz := False;
    Confirme := False;
    Lire;
    If Not Abandon
    Then
      Begin
        Valider;
        If Not Conflit_De_Type
        Then
          Begin
            i := hi(windmax);
            gotoxy (1, i);
            Confirme := Oui (msg_ch (1));
          End
        {endif}
      End
    {endif}
  Until (Abandon Or Confirme)
End; { saisir_masque }

End.
