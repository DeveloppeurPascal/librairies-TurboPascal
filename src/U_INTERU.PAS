Unit U_Interupt;               { Mise … jour le 16 - 02 - 1991 }
{
Auteur: Pr‚martin Patrick.

Cette unit‚ contient une proc‚dure en 8086 (INTERUPT.OBJ) qui permet aux
utilisateurs du Turbo Pascal d'utiliser les interruptions logicielles.

La proc‚dure INTR (qui est aussi fournie avec l'unit‚ DOS) permet d'acceder
aux 256 interruptions (de la 0 … la 255 incluses), mais il est recommand‚ de
connaitre les parametres … leur passer avant de les utiliser.
}
Interface

Const Int_Prt_Scr = $05;
      Int_Clavier = $09;
      Int_Video  = $10;
      Int_Equipement = $11;
      Int_Memoire = $12;
      Int_Disque = $13;
      Int_Port_Serie = $14;
      Int_Clavier_2 = $16;
      Int_Printer = $17;
      Int_Reboot = $19;
      Int_Heure = $1A;
      Int_Fin_Exe = $20;
      Int_Ms_Dos = $21;
      Int_Spooler = $2F;
      Int_Souris = $33;

Type Registres = Record
                   Case Boolean Of
                     False : (Ax, Bx, Cx, Dx, Es, Si, Di : Integer);
                     True  : (Al, Ah, Bl, Bh, Cl, Ch, Dl, Dh : Byte)
                   {endcase}
                 End;

Procedure Intr (Num_Int : Integer; Var Regs : Registres);
          { Cette proc‚dure appelle l'interruption de num‚ro pass‚, et met les
          r‚sultats de cette interruption dans les registres. }

Implementation

{$l interupt.obj}

Procedure Intr (Num_Int : Integer; Var Regs : Registres); External;

End. { Fin de l'unit‚ 'Interupt'. }
