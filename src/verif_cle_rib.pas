unit ClRibRib;

interface

Function RIBCorrect(TCodBqe,TCodGuich,TNoCompte,TCle:String;
  Var CleReel : String): Boolean;

Function RIPCorrect(CodBqe,CodGuich,NoCompte,Cle : String;
  Var CleReel : String): Boolean;

implementation


{%--------------------------------------------------------------------------}
{                                                                           }
{       Function    RIBCorrect                                              }
{                                                                           }
{---------------------------------------------------------------------------}
{ Role : Calcule la cle RIB a partir du code guichet,code banque, numero    }
{        compte et compare avec la cle saisie par l'utilisateur             }
{        Renvoie vrai si ce sont les memes (Cle pour les RIB bancaires)     }
{---------------------------------------------------------------------------}
{ Entree :                                                                  }
{   TCodeBqe  : Code Banque (5 car)                                         }
{   TCodGuich : Code Guichet (5 car)                                        }
{   TNoCompte : Numero de compte (11 car)                                   }
{   TCle      : Cle RIB Saisie (2 car)                                      }
{ Sortie :                                                                  }
{   CleReel: Cle RIB calculee                                               }
{--------------------------------------------------------------------------%}

Function RIBCorrect(TCodBqe,TCodGuich,TNoCompte,TCle:String;
  Var CleReel : String): Boolean;

Const
  Modulo = 97;
  Chiffres   : Set of Char = ['0','1','2','3','4','5','6','7','8','9'];
  EnsLettres : String[26] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  EnsNumeros : Array[1..26] Of Char = '12345678912345678923456789';

var
  Code,I  : Integer;
  Numero  : String;
  Num     ,
  RDiv    : Real;
  Quot    : String;
  Position,
  Reste   : Integer;
  DivStr  : String;
  CleCal  : String;
  Bon     : Boolean;

Begin
  CleCal :='';
  While length(TNoCompte) < 11 Do TNoCompte := '0'+TNoCompte;
  For I:=1 To 11 Do Begin
    If (Not (TNoCompte[I] in Chiffres))
    And (Pos(TNoCompte[I],EnsLettres)>0)
    Then TNoCompte[I] := EnsNumeros[Pos(TNoCompte[I],EnsLettres)];
  End;

  Bon := False;
  Quot := '';
  Position := 2;
  Numero := TCodBqe+TCodGuich+TNoCompte;
  Numero := Numero+'00';
  Move(Numero[1],DivStr[1],2);
  DivStr[0] := #2;
  Val(DivStr,RDiv,Code);

  While (Code=0) And (Position<=23) Do Begin
    Reste:=Trunc(RDiv);
    If Reste < Modulo Then Begin
      Quot := Quot+'0';
    End
    Else Begin
      Quot := Quot+Chr((Reste div Modulo)+48);
      Reste := Reste mod Modulo;
    End;
    Str(Reste,DivStr);
    Inc(Position);
    If (Position <= 23) Then DivStr := DivStr+Numero[Position];
    Val(DivStr,RDiv,Code);
  End;

  If (Code = 0) Then Begin
    Reste := Modulo-Reste;
    Str(Reste,CleCal);
    While Length(CleCal) < 2 Do CleCal := '0'+CleCal;
    If (TCle = CleCal) Then Bon := True;
  End;

  CleReel := CleCal;
  RIBCorrect := Bon;
End;

{%--------------------------------------------------------------------------}
{                                                                           }
{       Function    RIPCorrect                                              }
{                                                                           }
{---------------------------------------------------------------------------}
{ Role : Calcule la cle RIP a partir du code guichet,code banque, numero    }
{        compte et compare avec la cle saisie par l'utilisateur             }
{        Renvoie vrai si ce sont les memes (Cle pour les RIP Postaux  )     }
{---------------------------------------------------------------------------}
{ Entree :                                                                  }
{   TCodeBqe  : Code Banque (5 car)                                         }
{   TCodGuich : Code Guichet (5 car)                                        }
{   TNoCompte : Numero de compte (11 car)                                   }
{   TCle      : Cle RIB Saisie (2 car)                                      }
{ Sortie :                                                                  }
{   CleReel: Cle RIP calculee                                               }
{--------------------------------------------------------------------------%}

Function RIPCorrect(CodBqe,CodGuich,NoCompte,Cle : String;
  Var CleReel : String): Boolean;

Const
  EnsCles    : String = 'ABCDEFGHJKLMNPRSTUVWXYZ';
  EnsNum     : Array [1..23] of Byte = (0,1,2,3,4,5,6,7,8,9,10,11,12,
                                       13,14,15,16,17,18,19,20,21,22);

Var
  I         ,
  Reste     ,
  Code      : Integer;
  Dividende ,
  NumCentre ,
  NumCompte : Real;
  Compte    : String;
  Bon,
  Bon2  : Boolean;


Begin
  Bon := Pos(NoCompte[8],EnsCles) > 0;

  { Calcul de la cle de controle Nø de compte }
  If Bon Then Begin
    Val(NoCompte[10]+NoCompte[11],NumCentre,Code);
    If (Code = 0) Then Begin
      Move(NoCompte[1],Compte[1],7);
      Compte[0]:=#7;
      Val(Compte,NumCompte,Code);
    End;
    Bon := Code = 0;
  End;

  If Bon Then Begin
    Dividende := NumCentre*1000000 + NumCompte;
    Reste := Round(Frac(Dividende/23) * 23);
    I := 0;
    While (Reste <> EnsNum[I]) And (I<23) Do Inc(I);
    Bon := NoCompte[8] = EnsCles[I];
  End;

  { Calcul de la cle de controle RIP }
  Bon2 := RIBCorrect(CodBqe,CodGuich,NoCompte,Cle,CleReel);
  RIPCorrect := Bon And Bon2;
End;


end.

