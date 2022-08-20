Unit U_Reset;                { mise … jour le 18/07/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 01/03/1991.
      18/07/1991.

Cette unite permet aux programmes qui l'utilisent de rebooter l'ordinateur
avec ou sans test de la memoire.
}
Interface

procedure reset (tst_memoire : boolean);

implementation

procedure reset (tst_memoire : boolean);
begin
     if tst_memoire
     then
         memw [$0000:$0473] := $1234
     else
         memw [$0000:$0473] := $0000;
     {endif}
     asm
        int 19h
     end;
end; { reset }

End. { Fin de l'unit‚ 'U_Reset'. }
