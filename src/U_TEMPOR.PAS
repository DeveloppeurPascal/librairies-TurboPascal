unit u_temporisation;
{
Auteur: Patrick Pr‚martin
Date: 22/11/1992. 29/11/1992. 06/11/1992. 12/12/1992.
Langage: Turbo Pascal 6.0
Date: 23/03/1995. 17/04/1995.
Langage: Borland Pascal 7.0
But: Faire en sorte que les programmes de Olf Software tournent … la mˆme
     vitesse quelque soit la machine...
}

interface

procedure temporisation_init;
{ Initialise le compteur de vitesse pour obtenir 25 images par seconde maxi. }

procedure temporisation;
{ Effectue la temporisation. }

procedure temporisation_vitesse (n : integer);
{ Change la vitesse du programme peut aller de 100 (pour +3) … 14 (pour -3) images par seconde.
Le calcul est le suivant: 100/(4-n) images par secondes. }

implementation
uses
    crt,
    dos;

const
     tempo_t1 : word = 0;
     tempo_t2 : word = 0;

var
   hh, mm, ss, ss1, ss2 : word;

procedure temporisation_init;
begin
  tempo_t1 := 4;
  gettime (hh, mm, ss, ss1);
end; { temporisation_init }

procedure temporisation;
begin
  gettime (hh, mm, ss, ss2);
  if (ss2 <= ss1)
  then
    tempo_t2 := 100+ss2-ss1
  else
    tempo_t2 := ss2-ss1;
  {endif}
  ss1 := ss2;
  if ((tempo_t2 < 0) or (tempo_t2 > tempo_t1))
  then
    tempo_t2 := pred (tempo_t1);
  {endif}
  delay ((tempo_t1-tempo_t2) * 10);
end; { temporisation }

procedure temporisation_vitesse (n : integer);
begin
  tempo_t1 := 4-n;
end; { temporisation_vitesse }

end.

