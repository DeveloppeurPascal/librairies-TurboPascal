unit u_parametre;
{
Auteur: Pr‚martin Patrick
Date: 25/08/1991.
      27/08/1991.
Langage: Turbo Pascal 6.0
But Suppression de certains parametres dans le PSP.
}
interface
function param_nb : integer;
function param_ch (num : integer) : string;
function param_del (ch : string) : boolean;

implementation
var
   ch_param : string [128];
   i : integer;

procedure param_compress;
var
   j : integer;
begin
     j := 0;
     for i := 1 to length (ch_param) do
         begin
              if not (ch_param [i] in [' ', '/', '\'])
              then
                  begin
                       inc (j);
                       ch_param [j] := ch_param [i];
                  end
              else
                  if ((j > 0) and (ch_param [j] <> ' '))
                  then
                      begin
                           inc (j);
                           ch_param [j] := ' ';
                      end;
                  {endif}
              {endif}
         end;
     {endfor}
     ch_param [0] := chr (j);
     ch_param := ch_param + ' ';
     j := 1;
     for i := 2 to length (ch_param) do
         if ((ch_param [i] <> ' ') or (ch_param [pred (i)] <> ' '))
         then
             begin
                  inc (j);
                  ch_param [j] := ch_param [i];
             end;
         {endif}
     {endfor}
     ch_param [0] := chr (j);
end; { Param_Compress }

procedure param_init;
begin
     ch_param := '';
     for i := 1 to mem [PrefixSeg:$80] do
         ch_param := ch_param + upcase (chr (mem [PrefixSeg:$80+i]));
     {endfor}
     param_compress;
end; { Param_Init }

function param_nb : integer;
var
   nb : integer;
begin
     nb := 0;
     for i := 1 to length (ch_param) do
         if (ch_param [i] = ' ')
         then
             inc (nb);
         {endif}
     {endfor}
     param_nb := nb;
end; { Param_Nb }

function param_ch (num : integer) : string;
var
   j : integer;
   ch : string;
begin
     ch := '';
     if ((num > 0) and (num <= param_nb))
     then
         begin
              i := 1;
              j := 1;
              while ((i < num) and (j < length (ch_param))) do
                    begin
                         while (ch_param [j] <> ' ') do
                               inc (j);
                         {endwhile}
                         inc (j);
                         inc (i);
                    end;
              {endwhile}
              while (ch_param [j] <> ' ') do
                    begin
                         ch := ch + ch_param [j];
                         inc (j);
                    end;
              {endwhile}
         end;
     {endif}
     param_ch := ch;
end; { Param_Ch }

function param_del (ch : string) : boolean;
var
   j,
   k : integer;
   ok : boolean;
begin
     ok := false;
     if ((ch <> '') and (param_nb > 0))
     then
         begin
              k := 0;
              j := 1;
              i := 1;
              while ((not ok) and (i <= mem [PrefixSeg:$80])) do
                  begin
                       if (upcase (chr (mem [PrefixSeg:$80+i])) = upcase (ch [j]))
                       then
                           begin
                                if (j = 1)
                                then
                                    k := i;
                                {endif}
                                ok := (j = length (ch));
                                inc (j);
                           end
                       else
                           j := 1;
                       {endif}
                       inc (i);
                  end;
              {endwhile}
              if ok
              then
                  begin
                       if (k > 1)
                       then
                           dec (k);
                       {endif}
                       for j := succ (i) to mem [PrefixSeg:$80] do
                           begin
                                mem [PrefixSeg:$80+k] := mem [PrefixSeg:$80+j];
                                inc (k);
                           end;
                       {endfor}
                       mem [PrefixSeg:$80] := pred (k);
                  end;
              {endif}
              param_init;
         end;
     {endif}
     param_del := ok;
end; { Param_Del }

begin
     param_init;
end. { Fin de l'unit‚ 'U_Parametre }
