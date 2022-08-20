Unit U_Code_Clavier;
{
Auteur: Pr‚martin Patrick.
Date : 10-02-1991, Turbo Pascal 4.0
       28-02-1991.
       10-03-1991.
       07-05-1991.
       27/12/1991, Turbo Pascal 6.0
       19/09/1993, Borland Pascal 7.0

Cette unit‚ contient les codes des touches renvoy‚s par l'appuit sur une touche
test‚ par les interruptions clavier.
}

Interface

Const

{ CaractŠres sp‚ciaux: }
      Carac_Nul  = #0;
      Carac_Bell = #7;
      Carac_Ht   = #9;
      Carac_Lf   = #10;
      Carac_Vt   = #11;
      Carac_Ff   = #12;
      Carac_Cr   = #13;

{ Touches normales: }
      Touche_Backspace      = #8;
      Touche_Tab            = #9;
      Touche_Return         = #13;
      Touche_Escape         = #27;
      Touche_Ctrl_A         = #1;
      Touche_Ctrl_B         = #2;
      Touche_Ctrl_C         = #3;
      Touche_Ctrl_D         = #4;
      Touche_Ctrl_E         = #5;
      Touche_Ctrl_F         = #6;
      Touche_Ctrl_G         = #7;
      Touche_Ctrl_H         = #8;
      Touche_Ctrl_I         = #9;
      Touche_Ctrl_J         = #10;
      Touche_Ctrl_K         = #11;
      Touche_Ctrl_L         = #12;
      Touche_Ctrl_M         = #13;
      Touche_Ctrl_N         = #14;
      Touche_Ctrl_O         = #15;
      Touche_Ctrl_P         = #16;
      Touche_Ctrl_Q         = #17;
      Touche_Ctrl_R         = #18;
      Touche_Ctrl_S         = #19;
      Touche_Ctrl_T         = #20;
      Touche_Ctrl_U         = #21;
      Touche_Ctrl_V         = #22;
      Touche_Ctrl_W         = #23;
      Touche_Ctrl_X         = #24;
      Touche_Ctrl_Y         = #25;
      Touche_Ctrl_Z         = #26;
      Touche_Ctrl_Backspace = #127;
      Touche_Ctrl_return    = #10;

{
  Codes des touches ‚tendues:
         - Carac_Nul
         - Code des touches appuy‚es.
}

{ F1 … F10 : appuit sur la touche correspondante. }
      Touche_F1        = #59;
      Touche_F2        = #60;
      Touche_F3        = #61;
      Touche_F4        = #62;
      Touche_F5        = #63;
      Touche_F6        = #64;
      Touche_F7        = #65;
      Touche_F8        = #66;
      Touche_F9        = #67;
      Touche_F10       = #68;
      Touche_F11       = #133;
      Touche_F12       = #134;

{ F11 … F20 : appuit sur Shift + F1 … F10. }
      Touche_Shift_F1  = #84;
      Touche_Shift_F2  = #85;
      Touche_Shift_F3  = #86;
      Touche_Shift_F4  = #87;
      Touche_Shift_F5  = #88;
      Touche_Shift_F6  = #89;
      Touche_Shift_F7  = #90;
      Touche_Shift_F8  = #91;
      Touche_Shift_F9  = #92;
      Touche_Shift_F10 = #93;
      Touche_Shift_F11 = #135;
      Touche_Shift_F12 = #136;

{ F21 … F30 : appuit sur Ctrl + F1 … F10. }
      Touche_Ctrl_F1   = #94;
      Touche_Ctrl_F2   = #95;
      Touche_Ctrl_F3   = #96;
      Touche_Ctrl_F4   = #97;
      Touche_Ctrl_F5   = #98;
      Touche_Ctrl_F6   = #99;
      Touche_Ctrl_F7   = #100;
      Touche_Ctrl_F8   = #101;
      Touche_Ctrl_F9   = #102;
      Touche_Ctrl_F10  = #103;
      Touche_Ctrl_F11  = #137;
      Touche_Ctrl_F12  = #138;

{ F31 … F40 : appuit sur Alt + F1 … F10. }
      Touche_Alt_F1    = #104;
      Touche_Alt_F2    = #105;
      Touche_Alt_F3    = #106;
      Touche_Alt_F4    = #107;
      Touche_Alt_F5    = #108;
      Touche_Alt_F6    = #109;
      Touche_Alt_F7    = #110;
      Touche_Alt_F8    = #111;
      Touche_Alt_F9    = #112;
      Touche_Alt_F10   = #113;
      Touche_Alt_F11   = #139;
      Touche_Alt_F12   = #140;

{ Touches de d‚placement du pav‚ num‚rique: }
      Touche_Home      = #71;
      Touche_Haut      = #72;
      Touche_Page_Up   = #73;
      Touche_Gauche    = #75;
      Touche_Droite    = #77;
      Touche_End       = #79;
      Touche_Bas       = #80;
      Touche_Page_Dn   = #81;
      Touche_Ins       = #82;
      Touche_Del       = #83;

{ Autres combinaisons de touches: }
      Touche_Shift_Tab    = #15;
      Touche_Ctrl_Prtscr  = #114;

      Touche_Ctrl_Gauche  = #115;
      Touche_Ctrl_Droite  = #116;
      Touche_Ctrl_Home    = #119;
      Touche_Ctrl_End     = #117;
      Touche_Ctrl_Page_Up = #132;
      Touche_Ctrl_Page_Dn = #118;
      Touche_Ctrl_Ins     = #4;
      Touche_Ctrl_Del     = #6;

      Touche_Alt_1        = #120;
      Touche_Alt_2        = #121;
      Touche_Alt_3        = #122;
      Touche_Alt_4        = #123;
      Touche_Alt_5        = #124;
      Touche_Alt_6        = #125;
      Touche_Alt_7        = #126;
      Touche_Alt_8        = #127;
      Touche_Alt_9        = #128;
      Touche_Alt_0        = #129;

      Touche_Alt_A        = #16;
      Touche_Alt_B        = #48;
      Touche_Alt_C        = #46;
      Touche_Alt_D        = #32;
      Touche_Alt_E        = #18;
      Touche_Alt_F        = #33;
      Touche_Alt_G        = #34;
      Touche_Alt_H        = #35;
      Touche_Alt_I        = #23;
      Touche_Alt_J        = #36;
      Touche_Alt_K        = #37;
      Touche_Alt_L        = #38;
      Touche_Alt_M        = #39;
      Touche_Alt_N        = #49;
      Touche_Alt_O        = #24;
      Touche_Alt_P        = #25;
      Touche_Alt_Q        = #30;
      Touche_Alt_R        = #19;
      Touche_Alt_S        = #31;
      Touche_Alt_T        = #20;
      Touche_Alt_U        = #22;
      Touche_Alt_V        = #47;
      Touche_Alt_W        = #44;
      Touche_Alt_X        = #45;
      Touche_Alt_Y        = #21;
      Touche_Alt_Z        = #17;

Implementation
End. { Fin de l'unit‚ 'U_Code_Clavier'. }
