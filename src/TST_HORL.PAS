program tst_horloge;

uses
    app,
    dialogs,
    drivers,
    menus,
    objects,
    stddlg,
    u_horloge,
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
     register_horloge;
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

          procedure Horloge_box;
          var
             horloge : p_horloge_window;
             result : word;
             r : trect;
          begin
               r.assign (10, 10, 30, 20);
               horloge := new (p_horloge_window, init);
               if (validview (horloge) <> nil)
               then
                   begin
                        result := desktop^.execview (horloge);
                        dispose (horloge);
                   end;
               {endif}
          end; { Horloge_box }

begin
     tapplication.handleevent (event);
     if event.what = evcommand
     then
         case event.command of
              cmopen : Horloge_box;
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
