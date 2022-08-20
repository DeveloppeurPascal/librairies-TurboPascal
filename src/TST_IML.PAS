program iml_test;

uses
    crt,
    iml_var,
    iml_condition;

var
   z : p_zone_time;
   event : t_event;

begin
  clrscr;
  write ('Heure: ');
  readln (time.hh);
  write ('Minute: ');
  readln (time.mm);
  write ('Seconde: ');
  readln (time.ss);
  new (z, init (both, 0, 7, 10, 10, 0));
  z^.setdata (time);
  z^.display;
  repeat
    z^.run (event);
  until ((event.typ = c_ev_commande) and ((event.cmde = c_cmde_ok) or (event.cmde = c_cmde_cancel)));
  z^.getdata (time);
  clrscr;
  writeln (time.hh, ':', time.mm, ':', time.ss);
  dispose (z, done);
  delay (500);
end.
