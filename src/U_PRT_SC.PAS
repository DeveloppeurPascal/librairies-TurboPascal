Unit U_Prt_Sc;
{
Auteur: Pr‚martin Patrick.
Date: 16/03/1991.
Langage: Turbo Pascal 4.0
Date: 09/09/1991.
Langage: Turbo Pascal 6.0

But: Cette unit‚ permet de connecter ou de d‚connecter l'interruption li‚e au
     Print Screen.
}
Interface

{$l u_prt_sc.obj}

Procedure Print_Screen_On;
          { Mise en marche du Print Screen (par d‚faut). }
Procedure Print_Screen_Off;
          { Arret du Print Screen. }

Implementation

Procedure Print_Screen_On; External;
Procedure Print_Screen_Off; External;
Procedure Init_Print_Screen; External;

var
   old_exitproc : pointer;

{$f+}
procedure prt_scr_exit;
{$f-}
begin
     print_screen_on;
     exitproc := old_exitproc;
end; { Prt_Scr_Exit }

Begin
  Init_Print_Screen;
  Print_Screen_On;
  old_exitproc := exitproc;
  exitproc := @prt_scr_exit;
End. { Fin de l'unit‚ 'U_Prt_Sc'. }
