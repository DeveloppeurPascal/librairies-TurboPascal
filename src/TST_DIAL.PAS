program tst_dialogs;

uses
    app,
    dialogs,
    drivers,
    menus,
    objects,
    stddlg,
    u_dialogs,
    views;

const
     cmopen = 1000;

type
    p_prg = ^t_prg;
    t_prg = object (tapplication)
                   constructor init;
                   procedure initstatusline; virtual;
                   procedure handleevent (var event : tevent); virtual;
    end;

constructor t_prg.init;
begin
     registerapp;
     registerdialogs;
     registermenus;
     registerobjects;
     registerstddlg;
     register_dialogs;
     registerviews;
     tapplication.init;
end; { t_prg.init }

procedure t_prg.initstatusline;
var
   r : trect;
begin
  getextent (r);
  r.a.y := r.b.y-1;
  statusline := new (pstatusline, init (r,
    newstatusdef (0, $ffff,
      newstatuskey ('~F3~ Open', kbf3, cmOpen,
      newstatuskey ('~Alt-X~ Quit', kbaltx, cmquit,
      nil)),
    nil)
  ));
end; { T_Prg.InitStatusLine }

var
   entier : longint;

procedure t_prg.handleevent (var event : tevent);

          procedure dialog_box;
          var
             boite : pdialog;
             ligne : p_input_number;
             r : trect;
             boite_data : record
                                valeur : longint;
             end;
          begin
               boite_data.valeur := entier;

               r.assign (5, 5, 75, 20);
               boite := new (pdialog, init (r, 'Test de U_DIALOGS.'));
               with boite^ do
                    begin
                         r.assign (2, 2, size.x-2, 3);
                         ligne := new (p_input_number, init (r, 50, -30));
                         insert (ligne);
                         r.assign (2, 1, size.x-2, 2);
                         insert (new (plabel, init (r, '~E~nter a number between -30 and 50.', ligne)));
                         r.assign (size.x-13, size.y-3, size.x-3, size.y-1);
                         insert (new (pbutton, init (r, '~C~ancel', cmcancel, bfnormal)));
                         r.assign (size.x-20, size.y-3, size.x-14, size.y-1);
                         insert (new (pbutton, init (r, '~O~K', cmOk, bfdefault)));
                    end;
               {endwith}
               if (validview (boite) <> nil)
               then
                   begin
                        boite^.setdata (boite_data);
                        if (desktop^.execview (boite) <> cmCancel)
                        then
                            begin
                                 boite^.getdata (boite_data);
                                 entier := boite_data.valeur;
                            end;
                        {endif}
                        dispose (boite);
                   end;
               {endif}
               end; { dialog_box }

begin
     tapplication.handleevent (event);
     if event.what = evcommand
     then
         case event.command of
              cmopen : dialog_box;
              cmquit : endmodal (cmquit);
         end;
     {endif}
end; { T_Prg.HandleEvent }

var
   prg : t_prg;

begin
     entier :=0;
     prg.init;
     prg.run;
     prg.done;
end.
