program tst_calendar;

uses
    app,
    dialogs,
    drivers,
    menus,
    objects,
    stddlg,
    u_calendar,
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
     register_calendar;
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

          procedure Calendar_box;
          var
             calend : p_calendar_window;
             result : word;
             r : trect;
          begin
               r.assign (10, 10, 30, 20);
               calend := new (p_calendar_window, init);
               if (validview (calend) <> nil)
               then
                   begin
                        result := desktop^.execview (calend);
                        dispose (calend);
                   end;
               {endif}
          end; { Calendar_box }

begin
     tapplication.handleevent (event);
     if event.what = evcommand
     then
         case event.command of
              cmopen : Calendar_box;
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
