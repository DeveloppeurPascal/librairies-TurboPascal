unit u_horloge;
{
Auteur: Pr‚martin Patrick.
Date: 02/08/1991.
      05/08/1991.
      28/07/1992. ( Interface Multi-Langue )

But: S‚lection de l'heure … l'aide du clavier, ou de la souris.
}

interface

USES
    Drivers,
    Objects,
    App,
    Views,
    Dos,
    Dialogs;

TYPE
    P_horloge_View = ^T_horloge_View;
    T_horloge_View = object (TView)
                             hh, mm, ss : Word;
                             cur_hh, cur_mm, cur_ss : Word;
                             activ_curs : byte;
                             constructor Init (r : TRect);
                             constructor Load (var S : TStream);
                             procedure HandleEvent (var Event : TEvent); virtual;
                             procedure Draw; virtual;
                             procedure Store (var S : TStream);
    end;

    p_horloge_Window = ^T_horloge_Window;
    T_horloge_Window = object (tdialog)
                               constructor Init;
    end;

CONST
     R_horloge_View: TStreamRec = (
                                   ObjType : 10100;
                                   VmtLink : Ofs (TypeOf (T_horloge_View)^);
                                   Load :    @T_horloge_View.Load;
                                   Store :   @T_horloge_View.Store);
     R_horloge_Window: TStreamRec = (
                                     ObjType : 10101;
                                     VmtLink : Ofs (TypeOf (T_horloge_Window)^);
                                     Load :    @T_horloge_Window.Load;
                                     Store :   @T_horloge_Window.Store);

procedure Register_horloge;

implementation
uses
    u_msg;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Heure';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'Clock';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

{ T_horloge_Window }
constructor T_horloge_Window.Init;
var
   R : TRect;
   control : pbutton;
begin
     R.Assign (1, 1, 17, 6);
     tdialog.Init (R, msg_ch (1));
     Flags := Flags and not (wfZoom + wfGrow);    { Not resizeable }
     GrowMode :=0;
     options := options or ofcentered;
     Palette := wpCyanWindow;

     r.assign (1, 1, 11, 4);
     Insert (New (P_horloge_View, Init (R)));
end; { T_horloge_Window.Init }

{ T_horloge_View }
constructor T_horloge_View.Init (r : TRect);
var
   H: Word;
begin
     TView.Init (r);
     Options := Options or (ofSelectable + ofCenterX);
     EventMask := EventMask or evMouseAuto;
     Gettime (cur_hh, cur_mm, cur_ss, H);
     hh := cur_hh;
     mm := cur_mm;
     ss := cur_ss;
     activ_curs := 1;
     DrawView;
end; { t_horloge_view.init }

constructor T_horloge_View.Load (var S : TStream);
var
   H: Word;
begin
     TView.Load (S);
     GetDate (cur_hh, cur_mm, cur_ss, H);
     S.Read (hh, SizeOf (hh));
     S.Read (mm, SizeOf (mm));
     s.read (ss, sizeof (ss));
end; { t_horloge_view.load }

procedure T_horloge_View.Draw;
const
     Width = 10;
var
   i, j : Integer;
   a, B : array [0..Width] of Word;
   Color, activ_color : Byte;

  function Num2Str (I : Integer) : String;
  var
     S : String;
  begin
       Str (i:2, S);
       Num2Str := S;
  end; { Num2Str }

begin
     Color := GetColor (8);
     activ_color := GetColor (29);
     movechar (b, ' ', color, width);
     writeline (0, 0, width, 3, b);
     for i := 0 to 2 do
         begin
              if (i = activ_curs)
              then
                  begin
                       movechar (a, #30, activ_color, 1);
                       movechar (b, #31, activ_color, 1);
                  end
              else
                  begin
                       movechar (a, #30, color, 1);
                       movechar (b, #31, color, 1);
                  end;
              {endif}
              writeline (2+i*3, 0, 1, 1, a);
              writeline (2+i*3, 2, 1, 1, b);
         end;
     {endfor}
     movestr (a, num2str (hh)+':'+num2str (mm)+':'+num2str (ss), color);
     writeline (1, 1, 8, 1, a);
     movechar (a, #17, activ_color, 1);
     movechar (b, #16, activ_color, 1);
     writeline (0, 1, 1, 1, a);
     writeline (9, 1, 1, 1, b);
end; { T_horloge_View.Draw }

procedure modif_heure (var hh, mm, ss : word; activ_curs : byte; sens : integer);
begin
     case sens of
          1 : case activ_curs of
                   0 : if (hh < 23)
                       then
                           inc (hh)
                       else
                           hh := 0;
                       {endif}
                   1 : if (mm < 59)
                       then
                           inc (mm)
                       else
                           mm := 0;
                       {endif}
                   2 : if (ss < 59)
                       then
                           inc (ss)
                       else
                           ss := 0;
                       {endif}
          end;
          -1 : case activ_curs of
                    0 : if (hh > 0)
                        then
                            dec (hh)
                        else
                            hh := 23;
                        {endif}
                    1 : if (mm > 0)
                        then
                            dec (mm)
                        else
                            mm := 59;
                        {endif}
                    2 : if (ss > 0)
                        then
                            dec (ss)
                        else
                            ss := 59;
                        {endif}
          end;
     end;
end; { Modif_Heure }

procedure T_horloge_View.HandleEvent (var Event: TEvent);
var
   Point : TPoint;
   SelectDay : Word;
begin
     TView.HandleEvent (Event);
     if (State and sfSelected <> 0)
     then
         begin
              if (Event.What and (evMouseDown + evMouseAuto) <> 0)
              then
                  begin
                       MakeLocal (Event.Where, Point);
                       case (point.y) of
                            0 : case (point.x) of
                                     2 : begin
                                              activ_curs := 0;
                                              modif_heure (hh, mm, ss, activ_curs, 1);
                                     end;
                                     5 : begin
                                              activ_curs := 1;
                                              modif_heure (hh, mm, ss, activ_curs, 1);
                                     end;
                                     8 : begin
                                              activ_curs := 2;
                                              modif_heure (hh, mm, ss, activ_curs, 1);
                                     end;
                            end;
                            1 : case (point.x) of
                                     0 : if (activ_curs > 0)
                                         then
                                             dec (activ_curs)
                                         else
                                             activ_curs := 2;
                                         {endif}
                                     1..8 : if (event.double)
                                            then
                                                begin
                                                     settime (hh, mm, ss, 0);
                                                     endmodal (cmquit);
                                                end;
                                            {endif}
                                     9 : if (activ_curs < 2)
                                          then
                                              inc (activ_curs)
                                          else
                                              activ_curs := 0;
                                          {endif}
                            end;
                            2 : case (point.x) of
                                     2 : begin
                                              activ_curs := 0;
                                              modif_heure (hh, mm, ss, activ_curs, -1);
                                     end;
                                     5 : begin
                                              activ_curs := 1;
                                              modif_heure (hh, mm, ss, activ_curs, -1);
                                     end;
                                     8 : begin
                                              activ_curs := 2;
                                              modif_heure (hh, mm, ss, activ_curs, -1);
                                     end;
                            end;
                       end;
                       drawview;
                  end
              else
                  if (Event.What = evKeyDown)
                  then
                      begin
                           case event.keycode of
                                kbup : modif_heure (hh, mm, ss, activ_curs, 1);
                                kbdown : modif_heure (hh, mm, ss, activ_curs, -1);
                                kbleft : if (activ_curs > 0)
                                         then
                                             dec (activ_curs)
                                         else
                                             activ_curs := 2;
                                         {endif}
                                kbright : if (activ_curs < 2)
                                          then
                                              inc (activ_curs)
                                          else
                                              activ_curs := 0;
                                          {endif}
                                kbenter : begin
                                               settime (hh, mm, ss, 0);
                                               endmodal (cmquit);
                                end;
                                kbesc : endmodal (cmquit);
                           end;
                           DrawView;
                      end;
                  {endif}
              {endif}
         end;
     {endif}
end; { T_horloge_View.HandleEvent }

procedure T_horloge_View.Store (var S: TStream);
begin
     TView.Store (S);
     S.Write (hh, SizeOf (hh));
     S.Write (mm, SizeOf (mm));
     s.write (ss, sizeof (ss));
end; { T_horloge_View.Store }

procedure Register_horloge;
begin
  RegisterType (R_horloge_View);
  RegisterType (R_horloge_Window);
end; { Register_horloge }


end. { Fin de l'unit‚ 'U_Horloge'. }
