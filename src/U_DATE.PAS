Unit U_Date;                 { mise … jour le 01/03/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 01/03/1991.
      28/07/1992. ( Interface Multi-Langues )

Cette unit‚ contient des proc‚dures permettant d'acceder … la date sans passer
par l'unit‚ DOS.
}
Interface

{$l u_date.obj}

Function Get_Date_Chaine : String;
         { Cette fonction renvoie la date en clair 'JJ/MM/AA' ou 'MM/JJ/AA' en
         fonction de la langue en cours d'utilisation. }
Procedure Get_Date (Var Jour, Mois, Annee, Jour_Semaine : Word);
          { Cette procedure renvoie la date courante. }
Procedure Set_Date (Jour, Mois, Annee : Word);
          { Cette proc‚dure met … jour la date du systŠme. }

Implementation
uses
    u_msg;

Procedure Get_Date (Var Jour, Mois, Annee, Jour_Semaine : Word); External;
Procedure Set_Date (Jour, Mois, Annee : Word); External;

Function Get_Date_Chaine : String;
Var Jj, Mm, Aa, Jj2  : Word;
    Chaine1, Chaine2 : String;
Begin { get_date_chaine }
  Get_Date (Jj, Mm, Aa, Jj2);
  Str (Jj, Chaine1);
  Str (Mm, Chaine2);
  if (langue_utilisee in [msg_gb])
  then
      Chaine1 := Concat (Chaine2, '/', Chaine1) { MM/JJ/AA }
  else
      Chaine1 := Concat (Chaine1, '/', Chaine2); { JJ/MM/AA }
  {endif}
  Str (Aa, Chaine2);
  Chaine1 := Concat (Chaine1, '/', Chaine2);
  Get_Date_Chaine := Chaine1
End; { get_date_chaine }

End. { Fin de l'unit‚ 'U_Date'. }
