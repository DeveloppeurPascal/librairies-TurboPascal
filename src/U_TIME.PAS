Unit U_Time;                 { mise … jour le 01/03/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 01/03/1991.

Cette unit‚ permet d'acc‚der … l'heure sans passer par l'unit‚ DOS.
}
Interface

{$l u_time.obj}

Function Get_Time_Chaine : String;
         { Cette fonction renvoie l'heure en clair 'HH:MM:SS'. }
Procedure Get_Time (Var Heure, Minute, Seconde, Sec100 : Byte);
          { Cette proc‚dure renvoie l'heure systŠme. }
Procedure Set_Time (Heure, Minute, Seconde, Sec100 : Byte);
          { Cette proc‚dure change l'heure systŠme. }

Implementation

Procedure Get_Time (Var Heure, Minute, Seconde, Sec100 : Byte); External;
Procedure Set_Time (Heure, Minute, Seconde, Sec100 : Byte); External;

Function Get_Time_Chaine : String;
Var Hh, Mm, Ss, Ss2  : Byte;
    Chaine1, Chaine2 : String;
Begin { get_time_chaine }
  Get_Time (Hh, Mm, Ss, Ss2);
  Str (Hh, Chaine1);
  Str (Mm, Chaine2);
  Chaine1 := Concat (Chaine1, ':', Chaine2);
  Str (Ss, Chaine2);
  Chaine1 := Concat (Chaine1, ':', Chaine2);
  Get_Time_Chaine := Chaine1
End; { get_time_chaine }

End. { Fin de l'unit‚ 'U_Time'. }
