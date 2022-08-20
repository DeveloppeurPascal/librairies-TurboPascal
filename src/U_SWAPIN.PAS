Unit U_Swaping;              { mise … jour : 27 - 12 - 1990 }
{
Cette unite contient diverses procedures qui permettent d'‚changer les valeurs
de deux variables pass‚es en paramŠtres.

Syntaxe:
   swap_[type des variables] (variable_1, variable_2);

   [variable_1 et variable_2 sont de type pr‚cis‚ derriŠre "SWAP_"]
}

Interface
Procedure Swap_Byte (Var A, B : Byte);
Procedure Swap_Integer (Var A, B : Integer);
Procedure Swap_Real (Var A, B : Real);
Procedure Swap_String (Var A, B : String);

Implementation
Procedure Swap_Byte (Var A, B : Byte);
Var C : Byte;
Begin { swap_byte }
  C := A; A := B; B := C
End; { swap_byte }

Procedure Swap_Integer (Var A, B : Integer);
Var C : Integer;
Begin { swap_integer }
  C := A; A := B; B := C
End; { swap_integer }

Procedure Swap_Real (Var A, B : Real);
Var C : Real;
Begin { swap_real }
  C := A; A := B; B := C
End; { swap_real }

Procedure Swap_String (Var A, B : String);
Var C : String;
Begin { swap_string }
  C := A; A := B; B := C
End; { swap_string }

End. { Fin de l'unit‚ 'Swaping'. }
