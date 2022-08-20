unit u_bgichr;
{
Auteur: Patrick Pr‚martin.
Date: 24/07/1992.
Langage: Turbo Pascal 6.0
But: Utilisation simplifi‚e des fontes vectorielles de Borland (inclues toutes
     seules dans le systŠme BGI). Il ne reste qu'… utiliser SETTEXTSTYLE.
}

interface

const
     DefaultFont = 0;
     TriplexFont = 1;
     SmallFont = 2;
     SansSerifFont = 3;
     GothicFont = 4;
     EuroStyleFont : integer = 0;
     ComplexFont : integer = 0;
     ScriptFont : integer = 0;
     SimpleFont : integer = 0;
     TriplexSimpleFont : integer = 0;

implementation
uses
    graph;

procedure GothicFontProc; external;
{$l goth.obj}

procedure SmallFontProc; external;
{$l litt.obj}

procedure SansSerifFontProc; external;
{$l sans.obj}

procedure TriplexFontProc; external;
{$l trip.obj}

var
   i : integer;

begin
     EuroStyleFont := installuserfont ('EURO');
     ComplexFont := installuserfont ('COMP');
     ScriptFont := installuserfont ('SCRI');
     SimpleFont := installuserfont ('SIMP');
     TriplexSimpleFont := installuserfont ('TSCR');
     i := registerbgifont (@GothicFontProc);
     i := registerbgifont (@SansSerifFontProc);
     i := registerbgifont (@SmallFontProc);
     i := registerbgifont (@TriplexFontProc);
end.
