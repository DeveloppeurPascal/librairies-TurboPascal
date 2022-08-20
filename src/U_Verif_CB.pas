unit U_Verif_CB;

interface

type
    tTypeCarteBancaire = (tcb_CarteInvalide, tcb_VISA, tcb_Amex, tcb_Mastercard, tcb_AutreCarte);

function Verif_CB (c : string) : tTypeCarteBancaire;

implementation

function Verif_CB (c : string) : tTypeCarteBancaire;
var
  card : string[21];
  Vcard : array[0..21] of byte absolute card;
  Xcard : integer;
  Cstr : string[21];
  y, x : integer;
begin
  Cstr := '                ';
  Cstr := '';
  fillchar(Vcard, 22, #0);
  card := c;
  for x := 1 to 20 do
    if (Vcard[x] in [48..57]) then
      Cstr := Cstr + chr(Vcard[x]);
  card := '';
  card := Cstr;
  Xcard := 0;
  if NOT odd(length(card)) then
    for x := (length(card) - 1) downto 1 do
      begin
        if odd(x) then
          y := ((Vcard[x] - 48) * 2)
        else
          y := (Vcard[x] - 48);
        if (y >= 10) then
          y := ((y - 10) + 1);
        Xcard := (Xcard + y)
      end
  else
    for x := (length(card) - 1) downto 1 do
      begin
        if odd(x) then
          y := (Vcard[x] - 48)
        else
          y := ((Vcard[x] - 48) * 2);
        if (y >= 10) then
          y := ((y - 10) + 1);
        Xcard := (Xcard + y)
      end;
  x := (10 - (Xcard mod 10));
  if (x = 10) then
    x := 0;
  if (x = (Vcard[length(card)] - 48)) then
    case Cstr[1] of
      '3' : Result := tcb_Amex;
      '4' : Result := tcb_VISA;
      '5' : Result := tcb_Mastercard;
    else
      Result := tcb_AutreCarte;
    end
  else
    Result := tcb_CarteInvalide;
  {endif}
end;

END.

