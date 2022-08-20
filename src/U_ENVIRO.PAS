unit u_environnement;
{
Auteur: Patrick Pr‚martin
Date: 12/12/1992.
Langage: Turbo Pascal 6.0
But: Modification et lecture des variables de l'environnement.
}

interface
const
     env_error : byte = 0;
     { 0 = Aucune erreur }
     { 1 = Variable environnement non trouv‚e }
     { 2 = Valeur affect‚e … une zone de l'environnement incorrecte }

function get_env (ch : string) : string;
procedure set_env (ch, valeur : string);
procedure env_erreur;

implementation
uses
    crt,
    u_ger_chaine;

var
   segment,
   offset : word;
   env_var : string;

function get_env (ch : string) : string;
var
   res : string;
   i : word;
   tst : byte;
begin
  env_var := set_maj_chaine (ch);
  res := '';
  i := 0;
  while ((res = '') and (mem [segment:i] <> 0)) do
    begin
      offset := i;
      tst := 1;
      while (mem [segment:i] <> 0) do
        begin
          case tst of
            1 :
              if (i-offset+1 > ord (env_var [0]))
              then
                if (mem [segment:i] = ord ('='))
                then
                  tst := 2
                else
                  tst := 0
                {endif}
              else
                if (mem [segment:i] <> ord (env_var [i-offset+1]))
                then
                  tst := 0;
                {endif}
              {endif}
            2 : res := res + chr (mem [segment:i]);
          end;
          inc (i);
        end;
      {endwhile}
      inc (i);
    end;
  {endwhile}
  if (res = '')
  then
    env_error := 1;
  {endif}
  get_env := res;
end; { get_env }

procedure set_env (ch, valeur : string);
var
   i : word;
begin
  if (length (get_env (ch)) = 0)
  then
    env_error := 1
  else
    if (length (valeur) = 0)
    then
      env_error := 2
    else
      begin
        { On se positionne sur la chaŒne suivante }
        i := offset;
        while (mem [segment:i] <> 0) do
          inc (i);
        {endwhile}
        inc (i);

        { On d‚cale les autres variables de l'environnement }
        while (mem [segment : i] <> 0) do
          begin
            while (mem [segment : i] <> 0) do
              begin
                mem [segment : offset] := mem [segment : i];
                inc (offset);
                inc (i);
              end;
            {endwhile}
            mem [segment : offset] := mem [segment : i];
            inc (offset);
            inc (i);
          end;
        {endwhile}
        mem [segment : offset] := mem [segment : i];

        { On rajoute la nouvelle valeur }
        ch := env_var+'='+set_maj_chaine (valeur);
        for i := 1 to length (ch) do
          mem [segment : offset+i-1] := ord (ch [i]);
        {endfor}
        mem [segment:offset+length (ch)] := 0;
      end;
    {endif}
  {endif}
end; { set_env }

procedure env_erreur;
begin
  gotoxy (1, 25);
  case env_error of
    1 : write (env_var+' is not in Program Environment.');
    2 : write ('Valeur affect‚e incorrecte.');
  end;
end; { env_erreur }

begin
  segment := memw [prefixseg:$2c];
end.
