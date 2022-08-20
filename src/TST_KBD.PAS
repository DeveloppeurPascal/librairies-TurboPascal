uses
    crt;

var
   c : char;

begin
  repeat
    c := readkey;
    writeln (ord (c));
  until (c = #27)
end.
