unit mouse;
{
Auteur: Premartin Patrick

Date: 14/01/1992.

Langage: Turbo Pascal (toutes versions … partir de la version 4.0)

But: Regroupement de proc‚dures et de fonctions permettant l'utilisation des
     souris 100% compatibles Microsoft, et gestion des fichiers d'extension
     .MOU cr‚‚s par 'MOUse Maker'.

Cette unit‚ est copyright Olf Software. Elle est utilisable par tous, aucune
contribution n'est demand‚e. Nous vous demandons quand mˆme de vous faire
connaŒtre par nous...Vous pourriez peut-ˆtre avoir besoin de nos logiciels un
jour... 

L'unit‚ est exclusivement distribu‚e par  Distri Soft Club
                                         Route de Champagne
                                           77210 Samoreau
                                               France.
}
interface
Const
     Mouse_Curs : Boolean = False; { True si le curseur de la souris est
                                     visible, False dans le cas contraire. }
     Mouse_On   : Boolean = False; { Indique en permanence si la souris est
                                     pr‚sente ou pas. }
     nb_max_mou = 50; { Indique le nombre maximal de fichiers .MOU
                        simultan‚ment en m‚moire. }
     Left_Button = 1; { Code du bouton gauche. }
     Right_Button = 2; { Code du bouton droit. }
     Middle_Button = 4; { Code du bouton du milieu. }

type
    t_mat = array [1..16] of word; { Matrice utilis‚e pour la forme, et pour le
                                     fond des souris en mode graphique. }
    p_mou = ^t_mou; { Pointeur vers la structure d'un fichier .MOU }
    t_mou = record
                  mask : t_mat; { Matrice du masque de la souris en mode
                                  graphique. }
                  form : t_mat; { Matrice de la forme de la souris en mode
                                  graphique. }
                  act_x : word; { Coordonn‚es du point d'action de la souris:
                                  un appuit sur les boutons de la souris vous
                                  renvoiera les coordonn‚es absolues de ce
                                  point sur l'‚cran. }
                  act_y : word;
    end;
    t_mou_regs = byte; { Type des indices dans le vecteur contenant les souris
                         graphiques. }

{
********************************************************************************
          Routines de gestion des fichiers d'extension .MOU
          Ces fichiers sont cr‚‚s par 'Mouse Maker'.

          Vous ne devez utiliser ces routines que dans les modes graphiques. Les
          modes conseill‚s sont EGA, et VGA (les suivants sont … envisager). Les
          routines fonctionnent sur toutes les cartes, il suffit de poss‚der les
          drivers Microsoft appropri‚s.
********************************************************************************
}
function mou_load (nom_fich : string) : p_mou;
{
Charge le fichier 'nom_fich.MOU' s'il existe.
En cas d'erreur, cette fonction renvoie NIL. Si le chargement s'est effectu‚
sans problŠme, la fonction renvoiera un pointeur sur le fichier voulu.
}

function mou_save (nom_fich : string; number : t_mou_regs) : byte;
{
Stocke la souris de num‚ro 'Number' dans le fichier 'nom_fich.MOU'.
Les codes de retour possibles sont les suivants:
          0 - si l'op‚ration s'est bien pass‚e.
          1 - s'il y a eu une erreur de sauvegarde (accŠs disque...), consultez
            IORESULT.
          2 - si 'Number' n'est pas valide: supŠrieur … 'Nb_Max_Mou'.
          3 - si ce num‚ro n'est pas affect‚ … une souris.
}

function mou_register (mou : p_mou; number : t_mou_regs) : byte;
{
Affecte le num‚ro 'Number' … la souris dont vous passez le pointeur 'Mou'.
Les codes de retour sont les suivants:
          0 - Aucune erreur n'est apparue.
          1 - Si 'Mou' est … NIL. Vous ne pouvez pas affecter ce num‚ro.
          2 - Si 'Number' n'est pas valide.
}

function mou_select (number : t_mou_regs) : byte;
{
Cette fonction vous permet d'activer une souris graphique choisie. Vous devez
en passer le num‚ro, et le changement de forme se fera automatiquement.
Les codes de retour sont les suivants:
          0 - Aucune erreur.
          1 - Si 'Number' est invalide (il doit ˆtre infŠrieur … 'Nb_Max_Mou').
          2 - Si la souris correspondante … 'Number' n'existe pas.
}

function mou_erase (number : t_mou_regs) : byte;
{
Supprime la souris de num‚ro 'Number'.
Les codes de retour sont:
          0 - Souris supprim‚e sans problŠme.
          1 - Si 'Number' est invalide.
          2 - Si la souris de rang 'Number' n'existe pas.
}

procedure mou_clear;
{
Efface toutes les souris stock‚es en m‚moire.
Cette proc‚dure doit ˆtre utilis‚e en fin de traitement...
}

{
********************************************************************************
          Les routines suivantes vous permettront de g‚rer les divers
          traitements … faire avec une souris compatible Microsoft.

          Certains problŠmes nous sont apparus lors des tests sur diff‚rentes
          machines, les souris ne r‚pondaient pas correctement. Veillez donc
          lorsque vous achetez une souris … ce qu'elle soit 100% compatible
          Microsoft, et que le constructeur de votre ordinateur vous la
          conseille...

          Les routines suivantes fonctionnent en mode texte, mais aussi en mode
          graphique, les ‚ventuelles conversions de format sont faites
          automatiquement.
********************************************************************************
}
Function Mouse_Test : Boolean;
{
Cette fonction renvoie TRUE si un driver de souris Microsoft est actif. Elle
modifie 'Mouse_On'. Vous n'aurez g‚n‚ralement pas … appeler cette fonction,
l'unit‚ le fait lors du d‚marrage de votre application.
Il vous suffira de regarder le contenu de la variable bool‚enne 'Mouse_On' qui
contiendra TRUE si un driver est actif.
}

Function Mouse_Nb_Button : Integer;
{
Cette fonction vous renvoie le nombre de boutons utilis‚s par votre souris. Ce
nombre peut varier d'un driver … un autre (avec la mˆme souris). Il n'est donc
qu'indicatif, nous n'avons jamais eu l'occasion de nous en servir.
}

Procedure Hide_Mouse;
{
Cette proc‚dure cache la souris.
}

Procedure Show_Mouse;
{
Cette proc‚dure affiche le surseur de la souris. Certains problŠmes sont apparus
sur les PS/2: il fallait appeler cette proc‚dure plusieurs fois pour que les
effets soient r‚els. Aucun autre problŠme ne nous a ‚t‚ signal‚.
Par d‚faut, en mode texte un rectangle plein sera affich‚, en mode graphique ce
sera une flŠche.
}

{
********************************************************************************
          Les routines suivantes gŠrent les souris Microsoft en mode graphique.
          Aucun test ne sera effectu‚, … vous de savoir quoi utiliser...
********************************************************************************
}
Function Mousek : Integer;
{
Cette fonction renvoie le code des boutons actifs lors de l'appel … cette
fonction. Les codes valides sont: Left_Button, Right_Button, Middle_Button, et
leurs combinaisons.
}

Function Mousex : Integer;
{
Renvoie l'abscisse courante du point d'action de la souris.
}

Function Mousey : Integer;
{
Renvoie l'ordonn‚e courante du point d'action de la souris.
}

Procedure Mouse_X_Y (Var X, Y : Integer);
{
Met dans les variables X, et Y les coordonn‚es du point d'action de la souris. X
correspond … l'abscisse, Y … l'ordonn‚e.
}

Procedure Mouse_X_Y_K (Var X, Y, K : Integer);
{
Renvois dans X, Y et K les coordonn‚es de la souris, et l'‚tat des boutons cod‚s
comme pour la fonction 'Mouse_K'.
}
 
Procedure Setmouse (X, Y : Integer);
{
Positionne la souris aux coordonn‚es X (pour l'abscisse) et Y (pour l'ordonn‚e).
Si la souris est visible, son curseur sera d‚plac‚ automatiquement. Vous ne
devriez pas avoir … l'effacer avant l'appel … cette proc‚dure.
}

Procedure Mouse_Cadre (X_Min, Y_Min, X_Max, Y_Max : Integer);
{
Cr‚e un cadre … l'extŠrieur duquel la souris ne pourra pas se d‚placer. Ses
d‚placements seront limit‚s au rectangle d‚fini par les coordonn‚es pass‚es en
paramŠtres. La souris sera mise dans ce cadre.
}

Procedure Mouse_Cadre_Horiz (X_Min, X_Max : Integer);
{
Limite une bande horizontale hors de laquelle la souris ne pourra pas aller.
}

Procedure Mouse_Cadre_Vert (Y_Min, Y_Max : Integer);
{
Limite les d‚placements de la souris … une bande verticale dont les ordonn‚es
sont pass‚es en paramŠtre.
}

{
********************************************************************************
          Les routines suivantes gŠrent les souris Microsoft en mode texte.
          Aucun test ne sera effectu‚, … vous de savoir quoi utiliser...
********************************************************************************
}
Function Mousex_Txt : Integer;
{
Renvoie l'abscisse courante de la souris. C'est une abscisse caractŠre. Elle
peut aller de 1 … 132 (peut-ˆtre plus suivant la carte que vous poss‚dez).
}

Function Mousey_Txt : Integer;
{
Renvoie l'ordonn‚e comprise entre 1 et 43 pour les modes texte les plus
puissants sur cartes VGA. Plus de 43 pour les prochaines cartes...
}

Procedure Mouse_X_Y_Txt (Var X, Y : Integer);
{
Renvoie les coordonn‚es X et Y de la souris.
}

Procedure Mouse_X_Y_K_Txt (Var X, Y, K : Integer);
{
Renvoie les coordonn‚es de la souris, ainsi que l'‚tat de ses boutons. Voyez
leur codage pour la fonction 'Mouse_K'.
}

Procedure Setmouse_Txt (X, Y : Integer);
{
D‚place la souris aux coordonn‚es absolues sp‚cifiez. Elles doivent absolument
ˆtre dans l'‚cran actuel. Aucun test n'est r‚alis‚ … ce sujet.
}

Procedure Mouse_Cadre_Txt (X_Min, Y_Min, X_Max, Y_Max : Integer);
{
D‚finit un cadre hors duquel la souris ne pourra pas se d‚placer.
}

Procedure Mouse_Cadre_Horiz_Txt (X_Min, X_Max : Integer);
{
Limite les d‚placements de la souris … la bande comprise entre X_Min et X_Max.
}

Procedure Mouse_Cadre_Vert_Txt (Y_Min, Y_Max : Integer);
{
Limite les d‚placements de la souris … une bande verticale de coordonn‚es Y_Min
et Y_Max.
}

implementation
uses
    dos;

const
     default_mouse : t_mou =
                   (mask : ($3fff, $1fff, $fff, $7ff, $3ff, $1ff, $ff, $7f,
                            $3f, $1f, $1ff, $10ff, $30ff, $f87f, $f87f, $fc3f);
                    form : ($0, $4000, $6000, $7000, $7800, $7c00, $7e00, $7f00,
                            $7f80, $7fc0, $7c00, $4600, $600, $300, $300, $0);
                    act_x : 0;
                    act_y : 0);

type
    t_mou_table = array [0..nb_max_mou] of p_mou;

var
   mou_table : t_mou_table;
   mou_current : t_mou_regs;
   regs : registers;

procedure mou_init;
var
   i : integer;
begin
     for i := 0 to nb_max_mou do
         mou_table [i] := nil;
     {endfor}
     mou_table [0] := @default_mouse;
     mou_current := 0;
end; { mou_Init }

function mou_load (nom_fich : string) : p_mou;
var
   fich : file of t_mou;
   mou : p_mou;
   dir : dirstr;
   name : namestr;
   ext : extstr;
begin
     new (mou);
     if (mou <> nil)
     then
         begin
              fsplit (fexpand (nom_fich), dir, name, ext);
              assign (fich, dir+name+'.mou');
              {$i-}
              reset (fich);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       dispose (mou);
                       mou := nil;
                  end
              else
                  begin
                       {$i-}
                       read (fich, mou^);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           begin
                                dispose (mou);
                                mou := nil;
                           end;
                       {endif}
                       close (fich);
                  end;
              {endif}
         end;
     {endif}
     mou_load := mou;
end; { mou_Load }

function mou_save (nom_fich : string; number : t_mou_regs) : byte;
var
   fich : file of t_mou;
   mou : p_mou;
   dir : dirstr;
   name : namestr;
   ext : extstr;
   result : byte;
begin
     result := 0;
     if ((number > nb_max_mou) or (number < 1))
     then
         result := 2
     else
         begin
              mou := mou_table [number];
              if (mou = nil)
              then
                  result := 3
              else
                  begin
                       fsplit (fexpand (nom_fich), dir, name, ext);
                       assign (fich, dir+name+'.mou');
                       {$i-}
                       rewrite (fich);
                       {$i+}
                       if (ioresult <> 0)
                       then
                           result := 1
                       else
                           begin
                                {$i-}
                                write (fich, mou^);
                                {$i+}
                                if (ioresult <> 0)
                                then
                                    result := 1;
                                {endif}
                                close (fich);
                           end;
                       {endif}
                  end;
              {endif}
         end;
     {endif}
     mou_save := result;
end; { mou_Save }

function mou_register (mou : p_mou; number : t_mou_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if ((number < 1) or (number > nb_max_mou))
     then
         result := 2
     else
         if (mou = nil)
         then
             result := 1
         else
             begin
                  if (mou_table [number] <> nil)
                  then
                      result := mou_erase (number);
                  {endif}
                  mou_table [number] := mou;
             end;
         {endif}
     {endif}
     mou_register := result;
end; { mou_Register }

function mou_select (number : t_mou_regs) : byte;
var
   result : byte;
   i,
   j : word;
   x,
   y : word;
begin
     result := 0;
     if ((number < 0) or (number > nb_max_mou))
     then
         result := 1
     else
         if (mou_table [number] = nil)
         then
             result := 2
         else
             if (mou_current <> number)
             then
                 begin
                      i := seg (mou_table [number]^);
                      j := ofs (mou_table [number]^);
                      x := mou_table [number]^.act_x;
                      y := mou_table [number]^.act_y;
                      regs.ax := 9;
                      regs.bx := x;
                      regs.cx := y;
                      regs.es := i;
                      regs.dx := j;
                      intr ($33, regs);
                      mou_current := number;
                 end;
             {endif}
         {endif}
     {endif}
     mou_select := result;
end; { mou_Select }

function mou_erase (number : t_mou_regs) : byte;
var
   result : byte;
begin
     result := 0;
     if (mou_current = number)
     then
         result := mou_select (0);
     {endif}
     if ((number < 1) or (number > nb_max_mou))
     then
         result := 1
     else
         if (mou_table [number] = nil)
         then
             result := 2
         else
             begin
                  dispose (mou_table [number]);
                  mou_table [number] := nil;
             end;
         {endif}
     {endif}
     mou_erase := result;
end; { mou_Erase }

procedure mou_clear;
var
   err : byte;
   i : integer;
begin
     if (mou_select (0) = 0)
     then
         for i := 1 to nb_max_mou do
             err := mou_erase (i);
         {endfor}
     {endif}
end; { mou_Clear }

Function Mousex : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousex := X;
End; { mousex }

Function Mousey : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousey := Y;
End; { mousey }

Function Mousek : Integer;
Var
   X,
   Y,
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
     Mousek := K;
End; { mousek }

Function Mouse_Test : Boolean;
var
   res : integer;
Begin
     regs.ax := 0;
     intr ($33, regs);
     res := regs.ax;
     mouse_on := (res <> 0);
     Mouse_Test := Mouse_On
End; { mouse_test }

Function Mouse_Nb_Button : Integer;
var
   res : integer;
Begin
     If (Mouse_On)
     Then
         begin
              regs.ax := 0;
              intr ($33, regs);
              res := regs.bx;
         end
     Else
         res := 0;
     {endif}
     mouse_nb_button := res;
End; { mouse_nb_button }

Procedure Hide_Mouse;
Begin
     If (Mouse_On)
     Then
         begin
              regs.ax := 2;
              intr ($33, regs);
         end;
     {endif}
     Mouse_Curs := False;
End; { hide_mouse }

Procedure Show_Mouse;
Begin
     If (Mouse_On)
     Then
         begin
              regs.ax := 1;
              intr ($33, regs);
              Mouse_Curs := True;
         end;
     {endif}
End; { show_mouse }

Procedure Mouse_X_Y (Var X, Y : Integer);
Var
   K : Integer;
Begin
     Mouse_X_Y_K (X, Y, K);
End; { mouse_x_y }

procedure Mouse_X_Y_K (Var X, Y, K : Integer);
Begin
     If (Mouse_On)
     Then
         begin
              regs.ax := 3;
              intr ($33, regs);
              x := regs.cx;
              y := regs.dx;
              k := regs.bx;
         end
     Else
         Begin
              X := 0;
              Y := 0;
              K := 0;
         End;
     {endif}
End; { mouse_x_y_k }

Procedure Setmouse (X, Y : Integer);
Begin
     If (Mouse_On)
     Then
         begin
              regs.ax := 4;
              regs.cx := x;
              regs.dx := y;
              intr ($33, regs);
         end;
     {endif}
End; { setmouse }

Procedure Mouse_Cadre_Horiz (X_Min, X_Max : Integer);
var
   c,
   d : integer;
Begin
     If (X_Min > X_Max)
     Then
         Begin
              D := X_Min;
              C := X_Max;
         End
     Else
         Begin
              C := X_Min;
              D := X_Max;
         End;
     {endif}
     regs.ax := 7;
     regs.cx := c;
     regs.dx := d;
     intr ($33, regs);
End; { mouse_cadre_horiz }

Procedure Mouse_Cadre_Vert (Y_Min, Y_Max : Integer);
var
   c,
   d : integer;
Begin
     If (Y_Min > Y_Max)
     Then
         Begin
              D := Y_Min;
              C := Y_Max;
         End
     Else
         Begin
              C := Y_Min;
              D := Y_Max;
         End;
     {endif}
     regs.ax := 8;
     regs.cx := c;
     regs.dx := d;
     intr ($33, regs);
End; { mouse_cadre_vert }

Procedure Mouse_Cadre (X_Min, Y_Min, X_Max, Y_Max : Integer);
Begin
     If (Mouse_On)
     Then
         Begin
              Mouse_Cadre_Horiz (X_Min, X_Max);
              Mouse_Cadre_Vert (Y_Min, Y_Max);
         End;
     {endif}
End; { mouse_cadre }

Function Mousex_Txt : Integer;
Begin
     Mousex_Txt := succ ((Mousex div (80 div mem [$40:$4a])) Div 8);
End; { mousex_txt }

Function Mousey_Txt : Integer;
Begin
     Mousey_Txt := (Mousey Div 8);
End; { mousey_txt }

Procedure Mouse_X_Y_Txt (Var X, Y : Integer);
Begin
     Mouse_X_Y (X, Y);
     X := succ ((X div (80 div mem [$40:$4a])) Div 8);
     Y := succ (Y Div 8);
End; { mouse_x_y_txt }

Procedure Mouse_X_Y_K_Txt (Var X, Y, K : Integer);
Begin
     Mouse_X_Y_K (X, Y, K);
     X := succ ((X div (80 div mem [$40:$4a])) Div 8);
     Y := succ (Y Div 8);
End; { mouse_x_y_k }

Procedure Setmouse_Txt (X, Y : Integer);
Begin
     Setmouse ((X * 8 * (80 div mem [$40:$4a])) + 4, (Y * 8) + 4);
End; { setmouse_txt }

Procedure Mouse_Cadre_Txt (X_Min, Y_Min, X_Max, Y_Max : Integer);
Begin
     Mouse_Cadre (X_Min * 8 * (80 div mem [$40:$4a]) + 4, Y_Min * 8 + 4,
                  X_Max * 8 * (80 div mem [$40:$4a]) + 4, Y_Max * 8 + 4);
End; { mouse_cadre_txt }

Procedure Mouse_Cadre_Horiz_Txt (X_Min, X_Max : Integer);
Begin
     Mouse_Cadre_Horiz (X_Min * 8 * (80 div mem [$40:$4a]) + 4, X_Max * 8 + 4);
End; { mouse_cadre_horiz_txt }

Procedure Mouse_Cadre_Vert_Txt (Y_Min, Y_Max : Integer);
Begin
     Mouse_Cadre_Vert (Y_Min * 8 + 4, Y_Max * 8 + 4);
End; { mouse_cadre_vert_txt }

var
   old_exitproc : pointer;

{$f+}
procedure mou_exit;
begin
     mou_clear;
     exitproc := old_exitproc;
end; { mou_Exit }

begin
     mou_init;
     old_exitproc := exitproc;
     exitproc := @mou_exit;
     If (Mouse_Test)
     Then
         Begin
              Hide_Mouse;
              Setmouse (0, 0);
         End;
     {endif}
End. { Fin de l'unit‚ 'Mouse'. }
{
Pour contacter Patrick Pr‚martin, ou Olf Software, ‚crivez …: Pr‚martin  Patrick
                                                                  (Olf Soft)
                                                              Lot. Le Souleiadou
                                                              13790 Rousset /Arc
                                                                    France
La version Turbo C de ces routines existe, elle doit vous avoir ‚t‚ livr‚e avec
cette unit‚. Si ce n'est pas le cas, veuillez contacter Distri Soft Club, et
demandez leur un catalogue.

Les marques cit‚es sont d‚pos‚es par leurs propri‚taires respectifs...
}
