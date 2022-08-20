unit u_keyboard;
{
Auteur: Patrick Pr┌martin.
Date: 06/09/1992
Langage: Turbo Pascal 6.0
But: Choix du clavier en fonction du pays (scan code <-> touche, ou ASCII).
}
interface

const
     max_keyboard_type = 3;
     keyboard_type : byte = 0; { Type de clavier utilis┌:
                                      0 = 101/102 touches,
                                      1 = PC AT,
                                      2 = PC Portatif,
                                      3 = PC XT.
     }

procedure affiche_clavier (n : byte);

implementation
uses
    crt;

procedure affiche_clavier (n : byte);
begin
  gotoxy (10, 6);
  case n of
    0 :
      begin
        write ('101/102 keys');
        clreol;
        writeln;
        writeln ('зд© здбдбдбд©здбдбдбд©здбдбдбд© здбдбд©          ');
        writeln ('Ё Ё Ё Ё Ё Ё ЁЁ Ё Ё Ё ЁЁ Ё Ё Ё Ё Ё Ё Ё Ё          ');
        writeln ('юды юдадададыюдадададыюдададады юдадады          ');
        writeln ('здбдбдбдбдбдбдбдбдбдбдбдбдбддд© здбдбд© здбдбдбд©');
        writeln ('Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё   Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё');
        writeln ('цдабабабабабабабабабабабабабдд╢ цдедед╢ цдедедед╢');
        writeln ('Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё');
        writeln ('цддабабабабабабабабабабабаба© Ё юдадады цдедед╢ Ё');
        writeln ('Ё   Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё         Ё Ё Ё Ё Ё');
        writeln ('цддбабабабабабабабабабабабадад╢   зд©   цдедедед╢');
        writeln ('Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё    Ё   Ё Ё   Ё Ё Ё Ё Ё');
        writeln ('цддедедабададададададабадедбдд╢ здедед© цдадед╢ Ё');
        writeln ('Ё  Ё Ё  Ё             Ё  Ё Ё  Ё Ё Ё Ё Ё Ё   Ё Ё Ё');
        writeln ('юдды юддадддддддддддддадды юдды юдадады юдддадады');
      end;
    1 :
      begin
        write ('PC AT');
        clreol;
        writeln;
        writeln ('здбд© здбдбдбдбдбдбдбдбдбдбдбдбдбдбдбд© здбдбдбд©');
        writeln ('Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё');
        writeln ('цдед╢ цдабабабабабабабабабабабабабабад╢ цдедедед╢');
        writeln ('Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё');
        writeln ('цдед╢ цддабабабабабабабабабабабабабы  Ё цдедедед╢');
        writeln ('Ё Ё Ё Ё   Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё   Ё Ё Ё Ё Ё Ё');
        writeln ('цдед╢ цдддабабабабабабабабабабабабаддд╢ цдедедед╢');
        writeln ('Ё Ё Ё Ё    Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё    Ё Ё Ё Ё Ё Ё');
        writeln ('цдед╢ цддбдабадададададададададабадбдд╢ цдадед╢ Ё');
        writeln ('Ё Ё Ё Ё  Ё  Ё                   Ё  Ё  Ё Ё   Ё Ё Ё');
        writeln ('юдады юдды  юддддддддддддддддддды  юдды юдддадады');
        clreol; writeln;
        clreol; writeln;
        clreol; writeln;
      end;
    2 :
      begin
        write ('Notebook');
        clreol;
        writeln;
        writeln ('                  здбдбдбдбдбдбдбдбдбдбдбдбдбддд©');
        writeln ('                  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё   Ё');
        writeln ('                  цдабабабабабабабабабабабабабдд╢');
        writeln ('                  Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё');
        writeln ('                  цддабабабабабабабабабабабаба© Ё');
        writeln ('                  Ё   Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё');
        writeln ('                  цддбабабабабабабабабабабабадед╢');
        writeln ('                  Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё Ё');
        writeln ('                  цддедабадедадададададабадеддады');
        writeln ('                  Ё  Ё  Ё  Ё            Ё  Ё     ');
        writeln ('                  юдды  юддаддддддддддддадды     ');
        clreol; writeln;
        clreol; writeln;
        clreol; writeln;
      end;
    3 :
      begin
        write ('PC XT');
        clreol;
        writeln;
        writeln ('    здбд© здбдбдбдбдбдбдбдбдбдбдбдбдбдддбдддбддд©');
        writeln ('    Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё   Ё   Ё   Ё');
        writeln ('    цдед╢ цдабабабабабабабабабабабабадбдедбдедбд╢');
        writeln ('    Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё');
        writeln ('    цдед╢ цддабабабабабабабабабабабабд╢ цдедедед╢');
        writeln ('    Ё Ё Ё Ё   Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё');
        writeln ('    цдед╢ цддбабабабабабабабабабабабадедедедед╢ Ё');
        writeln ('    Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё Ё  Ё Ё Ё Ё Ё Ё');
        writeln ('    цдед╢ цддабадададададададададабаддедадедад╢ Ё');
        writeln ('    Ё Ё Ё Ё   Ё                   Ё   Ё   Ё   Ё Ё');
        writeln ('    юдады юдддадддддддддддддддддддадддадддадддады');
        clreol; writeln;
        clreol; writeln;
        clreol; writeln;
      end;
  end;
end; { affiche_clavier }

end.
