Unit U_Graph;                { mise … jour le 09/03/1991. }
{
Auteur: Pr‚martin Patrick.
Date: 09/03/1991.

But: Utilisation des capacit‚s graphiques des PC sans avoir la lourdeur de
     l'unit‚ GRAPH du Turbo Pascal 4.0 de Borland.
}
Interface

{$l u_graph.obj}

Type
    T_Graph_Mode = 0..19;
{
mode      r‚solution      couleurs   texte/graphique   CGA PCjr EGA MCGA VGA MDA
 0  : 40*25 demi-teinte :    16    :      texte      :  *   *    *    *   *
 1  : 40*25             :    16    :      texte      :  *   *    *    *   *
 2  : 80*25 demi-teinte :    16    :      texte      :  *   *    *    *   *
 3  : 80*25             :    16    :      texte      :  *   *    *    *   *
 4  : 320*200           :     4    :    graphique    :  *   *    *    *   *
 5  : 320*200 demi-tein :     4    :    graphique    :  *   *    *    *   *
 6  : 640*200           :     2    :    graphique    :  *   *    *    *   *
 7  : 80*25             :     2*   :      texte      :           *        *   *
 8  : 160*200           :    16    :    graphique    :      *
 9  : 320*200           :    16    :    graphique    :      *
 10 : 640*200           :     4    :    graphique    :      *
 11 : r‚serv‚           :          :                 :
 12 : r‚serv‚           :          :                 :
 13 : 320*200           :    16    :    graphique    :           *        *
 14 : 640*200           :    16    :    graphique    :           *        *
 15 : 640*350           :     2*   :    graphique    :           *        *
 16 : 640*350           :     4    :    graphique    :           *+
 16 : 640*350           :    16    :    graphique    :           *-       *
 17 : 640*480           :     2    :    graphique    :                *   *
 18 : 640*480           :    16    :    graphique    :                    *
 19 : 320*200           :   256    :    graphique    :                *   *

* Avec les moniteurs monochromes.
+ EGA avec 64 Ko de m‚moire.
- EGA avec au moins 128 Ko de m‚moire.
}
    T_Graph_Couleur = 0..15;
{
0  : noir                              8  : gris
1  : bleu                              9  : bleu clair
2  : vert                              10 : vert clair
3  : cyan                              11 : cyan clair
4  : rouge                             12 : rouge clair
5  : magenta                           13 : magenta clair
6  : brun                              14 : jaune
7  : blanc                             15 : blanc intense
}

Procedure Graph_Init (Mode : T_Graph_Mode);
          { Met la carte graphique dans le mode voulu. }
Procedure Graph_Clear;
          { Remet la carte graphique en mode texte 80*25. }
Procedure Graph_Plot (X, Y : Integer);
          { Met un point dans la couleur courante aux coordonn‚es (X, Y). }
Procedure Graph_Pset (X, Y : Integer; Couleur : T_Graph_Couleur);
          { Met un point aux coordonn‚es (X, Y) dans la couleur sp‚cifi‚e. }
Procedure Graph_Color (Couleur : T_Graph_Couleur);
          { Change la couleur par d‚faut. }

Function Graph_Point (X, Y : Integer) : T_Graph_Couleur;
         { Renvoie la couleur du point situ‚ aux coordonn‚es (X, Y). }

Implementation

Procedure Graph_Init (Mode : T_Graph_Mode); External;
Procedure Graph_Clear; External;
Procedure Graph_Plot (X, Y : Integer); External;
Procedure Graph_Pset (X, Y : Integer; Couleur : T_Graph_Couleur); External;
Procedure Graph_Color (Couleur : T_Graph_Couleur); External;
Function Graph_Point (X, Y : Integer) : T_Graph_Couleur; External;

End. { Fin de l'unit‚ 'U_Graph'. }
