program tst_environnement;

uses
    u_environnement;

var
   prompt : string;

begin
  writeln ('COMSPEC=', get_env ('comspec'));
  writeln ('PATH=', get_env ('path'));
  writeln ('PROMPT=', get_env ('prompt'));
  prompt := get_env ('PROMPT');
  set_env ('PROMPT', '$d$t');
  writeln ('new PROMPT=', get_env ('prompt'));
  set_env ('PROMPT', prompt);
  writeln ('old PROMPT=', get_env ('prompt'));
end.
