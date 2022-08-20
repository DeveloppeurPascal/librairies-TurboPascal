unit u_scroll;
{
Auteur: Pr‚martin Patrick.
Date: 05/08/1991.
      06/08/1991. (Scroll_Txt, modes pr‚vus: $00, $01, $02, $03, $07, $54,
                                             $55, $56, $57)
      08/08/1991. (Scroll_Graph, modes pr‚vus: $04, $05, $06, $0d, $0e, $0f,
                                               $10, $11, $12, $13, $58, $59,
                                               $5e, $5f)
      16/08/1991. (Mode graphique $13)
But: Scrollings dans tous les modes (textes et graphiques) … partir de deux
     fonctions.
}
interface

const
        {
        Toutes les combinaisons de ces constantes est accept‚e pour la
        variable Sens des fonctions de scrolling.
        }
     scr_left  = $01; { Scrolling vers la gauche. }
     scr_right = $02; { Scrolling vers la droite. }
     scr_up    = $04; { Scrolling vers le haut.   }
     scr_down  = $08; { Scrolling vers le bas.    }

{
Voici les codes d'erreur retourn‚s par les fonctions de scrolling: (je vous
recommande d'en tenir compte)
                 0 = Scrolling r‚ussi.
                 1 = X infŠrieur … 1.
                 2 = Y infŠrieur … 1.
                 3 = Larg infŠrieur … 1.
                 4 = Haut infŠrieur … 1.
                 5 = X + Larg-1 supŠrieur … la largeur de l'‚cran.
                 6 = Y + Haut-1 supŠrieur … la derniŠre ligne de l'‚cran.
                 7 = Mode vid‚o inconnu ou inadapt‚.
                 8 = Mode vid‚o pr‚vu mais pas encore trait‚.

Utilisation des paramŠtres:
                 X = abscisse du coin haut gauche du cadre … scroller.
                 Y = ordonn‚e du coin haut gauche du cadre … scroller.
                 Larg = largeur du cadre … scroller.
                 Haut = hauteur du cadre … scroller.
                 Sens = sens du scrolling (voir les constantes Scr_*)
}

FUNCTION Scroll_Txt (X, Y, Larg, Haut, Sens : Integer) : Integer;
         { Scrolling en mode texte. }

FUNCTION Scroll_Graph (X, Y, Larg, Haut, Sens : Integer) : Integer;
         { Scrolling en mode graphique. }

implementation

{$L U_SCROLL.OBJ} { Fichier contenant le code des scrollings en 80x86. }
FUNCTION Scroll_Txt (X, Y, Larg, Haut, Sens : Integer) : Integer; external;
FUNCTION Scroll_Graph (X, Y, Larg, Haut, Sens : Integer) : Integer; external;

end. { Fin de l'unit‚ 'U_Scroll'. }
