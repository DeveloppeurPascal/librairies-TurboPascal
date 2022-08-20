unit iml_var;
{
Auteur: Patrick Pr‚martin.
Date: 16/09/1992. 17/09/1992. 12/10/1992. 22/11/1992. 23/01/1993.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
const
                 { Constantes concernant les valeurs de retour des
                 fonctions TEST_CLAVIER, TEST_SOURIS, et la zone CMDE des
                 ‚vŠnements. }
     c_no_effect = 0;
     c_cmde_next = 1;
     c_cmde_previous = 2;
     c_cmde_help = 3;
     c_cmde_ok = 4;
     c_cmde_cancel = 5;

                 { Constantes concernant les valeurs des ‚vennements
                 (cf t_event). }
     c_ev_rien = 0;
     c_ev_clavier = 1;
     c_ev_souris = 2;
     c_ev_commande = 3;

type
    t_proc = procedure;
    t_typ_saisie = (input, output, both);
    t_event =
      record
        typ : word;
        case word of
          c_ev_rien : ();
          c_ev_commande : (cmde : word);
          c_ev_clavier :
            ( code_nul : boolean;
              code_carac : char);
          c_ev_souris :
            ( mx,
              my,
              mk : integer);
      end;
    t_date =
      record
        jj : byte; { Jour }
        mm : byte; { Mois }
        aa : word; { Ann‚e }
      end;
    t_time =
      record
        hh : byte; { Heure }
        mm : byte; { Minute }
        ss : byte; { Seconde }
      end;

procedure clochette;
function num2str (n : longint) : string;
function str2num (t : string) : longint;
function flt2str (n : double) : string;
function str2flt (t : string) : double;
function dat2str (n : t_date) : string;
procedure str2dat (t : string; var res : t_date);
function tim2str (n : t_time) : string;
procedure str2tim (t : string; var res : t_time);
function min (a, b : longint) : longint;
function max (a, b : longint) : longint;
procedure tst_date (var date : t_date);
procedure tst_time (var time : t_time);

var
   mode_insert : boolean;

implementation
uses
    crt;

const
     nb_jours : array [1..12] of byte
              = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

procedure clochette;
begin
  sound (500);
  delay (5);
  nosound;
end; { clochette }

function num2str (n : longint) : string;
var
   res : string;
   nb : longint;
begin
  res := '';
  nb := max (-n, n);
  repeat
    res := chr (ord ('0')+(nb mod 10))+res;
    nb := nb div 10;
  until (nb = 0);
  if (n < 0)
  then
    res := '-'+res
  else
    res := '+'+res;
  {endif}
  num2str := res;
end; { num2str }

function str2num (t : string) : longint;
var
   res : longint;
begin
  if (t = '')
  then
    t := '+0';
  {endif}
  while (t [length (t)] = ' ') do
    dec (t [0]);
  {endwhile}
  res := 0;
  while (length (t) > 1) do
    begin
      if (t[2] in ['0'..'9'])
      then
        res := res * 10 + ord (t [2])-ord ('0');
      {endif}
      delete (t, 2, 1);
    end;
  {endwhile}
  if (t [1] = '-')
  then
    res := -res;
  {endif}
  str2num := res;
end; { str2num }

function flt2str (n : double) : string;
var
   res : string;
   nb : longint;
   b : boolean;
begin
  res := '';
  b := (n < 0);
  if b
  then
    n := -n;
  {endif}
  nb := 0;
  while (n >= 1) do
    begin
      inc (nb);
      n := n - 1;
    end;
  {endwhile}
  if b
  then
    nb := -nb;
  {endif}
  res := num2str (nb)+'.';
  while (n > 0) do
    begin
      n := n * 10;
      if (n >= 9)
      then
        nb := 9
      else
        if (n >= 8)
        then
          nb := 8
        else
          if (n >= 7)
          then
            nb := 7
          else
            if (n >= 6)
            then
              nb := 6
            else
              if (n >= 5)
              then
                nb := 5
              else
                if (n >= 4)
                then
                  nb := 4
                else
                  if (n >= 3)
                  then
                    nb := 3
                  else
                    if (n >= 2)
                    then
                      nb := 2
                    else
                      if (n >= 1)
                      then
                        nb := 1
                      else
                        nb := 0;
                      {endif}
                    {endif}
                  {endif}
                {endif}
              {endif}
            {endif}
          {endif}
        {endif}
      {endif}
      res := res + chr (ord ('0')+nb);
      n := n - nb;
    end;
  {endwhile}
  flt2str := res;
end; { flt2str }

function str2flt (t : string) : double;
var
   res : double;
   nb : longint;
   b : boolean;
begin
  res := 0;
  while ((length (t) > 0) and (t [length (t)] <> '.')) do
    begin
      if (t [length (t)] in ['0'..'9'])
      then
        res := res / 10 + ord (t [length (t)]) - ord ('0');
      {endif}
      dec (t [0]);
    end;
  {endwhile}
  res := res / 10;
  dec (t [0]);
  if (t [1] = '-')
  then
    res := -res;
  {endif}
  nb := str2num (t);
  str2flt := res+nb;
end; { str2flt }

function dat2str (n : t_date) : string;
var
   res : string;
   ch : string;
begin
  tst_date (n);
  ch := '00' + copy (num2str (n.jj), 2, 2);
  res := copy (ch, length (ch) - 1, 2)+'/';
  ch := '00' + copy (num2str (n.mm), 2, 2);
  res := res + copy (ch, length (ch) - 1, 2)+'/';
  ch := '0000' + copy (num2str (n.aa), 2, 4);
  res := res + copy (ch, length (ch) - 3, 4);
  dat2str := res;
end; { dat2str }

procedure str2dat (t : string; var res : t_date);
begin
  res.jj := str2num ('+'+copy (t, 1, 2));
  res.mm := str2num ('+'+copy (t, 4, 2));
  res.aa := str2num ('+'+copy (t, 7, 4));
end; { str2dat }

function tim2str (n : t_time) : string;
var
   res : string;
   ch : string;
begin
  tst_time (n);
  ch := '00' + copy (num2str (n.hh), 2, 2);
  res := copy (ch, length (ch)-1, 2) + ':';
  ch := '00' + copy (num2str (n.mm), 2, 2);
  res := res + copy (ch, length (ch)-1, 2) + ':';
  ch := '00' + copy (num2str (n.ss), 2, 2);
  res := res + copy (ch, length (ch)-1, 2);
  tim2str := res;
end; { tim2str }

procedure str2tim (t : string; var res : t_time);
begin
  res.hh := str2num ('+'+copy (t, 1, 2));
  res.mm := str2num ('+'+copy (t, 4, 2));
  res.ss := str2num ('+'+copy (t, 7, 4));
end; { str2tim }

function min (a, b : longint) : longint;
begin
  if (a < b)
  then
    min := a
  else
    min := b;
  {endif}
end; { min }

function max (a, b : longint) : longint;
begin
  if (a > b)
  then
    max := a
  else
    max := b;
  {endif}
end; { max }

procedure tst_date (var date : t_date);
begin
  while (date.aa > 9999) do
    date.aa := date.aa - 10000;
  {endwhile}
  while (date.mm > 12) do
    date.mm := date.mm - 12;
  {endwhile}
  if (date.mm < 1)
  then
    date.mm := 12;
  {endif}
  if (date.mm = 2)
  then
    if (date.aa mod 4 = 0)
    then
      nb_jours [2] := 29
    else
      nb_jours [2] := 28;
    {endif}
  {endif}
  while (date.jj > nb_jours [date.mm]) do
    date.jj := date.jj - nb_jours [date.mm];
  {endwhile}
  if (date.jj < 1)
  then
    date.jj := nb_jours [date.mm];
  {endif}
end; { tst_date }

procedure tst_time (var time : t_time);
begin
  if (time.hh > 23)
  then
    time.hh := 0;
  {endif}
  if (time.mm > 59)
  then
    time.mm := 0;
  {endif}
  if (time.ss > 59)
  then
    time.ss := 0;
  {endif}
end; { tst_time }

begin
  mode_insert := true;
end.
