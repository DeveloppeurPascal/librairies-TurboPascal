UNIT u_Calendar;
{
Auteur: Pr‚martin Patrick.
Date: 02/08/1991.
      28/07/1992. (Mise au point de l'interface multi-lingue de Olf Software)

But: Choix d'une date dans un calendrier avec les flŠches ou la souris.
}

{$F+,O+,X+,S-,D-}

INTERFACE

USES
    Drivers,
    Objects,
    App,
    Views,
    Dos,
    Dialogs;

CONST
     DaysInMonth : array[1..12] of Byte =
                   (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

TYPE
    P_Calendar_View = ^T_Calendar_View;
    T_Calendar_View = object (TView)
                             Year, Month, Days : Word;
                             CurYear, CurMonth, CurDay : Word;
                             modif_day : word;
                             constructor Init (Bounds: TRect);
                             constructor Load (var S: TStream);
                             procedure HandleEvent (var Event: TEvent); virtual;
                             procedure Draw; virtual;
                             procedure Store (var S: TStream);
    end;

    p_Calendar_Window = ^T_Calendar_Window;
    T_Calendar_Window = object (TWindow)
                               constructor Init;
    end;

CONST
     R_Calendar_View: TStreamRec = (
                                   ObjType : 10200;
                                   VmtLink : Ofs (TypeOf (T_Calendar_View)^);
                                   Load :    @T_Calendar_View.Load;
                                   Store :   @T_Calendar_View.Store);
     R_Calendar_Window: TStreamRec = (
                                     ObjType : 10201;
                                     VmtLink : Ofs (TypeOf (T_Calendar_Window)^);
                                     Load :    @T_Calendar_Window.Load;
                                     Store :   @T_Calendar_Window.Store);

procedure Register_Calendar;

IMPLEMENTATION
uses
    u_msg;

function msg_ch (num : word) : string;
var
   ch : string;
begin
  case langue_utilisee of
    msg_f :
      case num of
        1 : ch := 'Janvier   ';
        2 : ch := 'F‚vrier   ';
        3 : ch := 'Mars      ';
        4 : ch := 'Avril     ';
        5 : ch := 'Mai       ';
        6 : ch := 'Juin      ';
        7 : ch := 'Juillet   ';
        8 : ch := 'Ao–t      ';
        9 : ch := 'Septembre ';
        10 : ch := 'Octobre   ';
        11 : ch := 'Novembre  ';
        12 : ch := 'D‚cembre  ';
        13 : ch := 'Calendrier';
        14 : ch := 'Di Lu Ma Me Je Ve Sa';
      else
        ch := '';
      end;
  else
    case num of
      1 : ch := 'January   ';
      2 : ch := 'February  ';
      3 : ch := 'March     ';
      4 : ch := 'April     ';
      5 : ch := 'May       ';
      6 : ch := 'June      ';
      7 : ch := 'July      ';
      8 : ch := 'August    ';
      9 : ch := 'September ';
      10 : ch := 'October   ';
      11 : ch := 'November  ';
      12 : ch := 'December  ';
      13 : ch := 'Calendar';
      14 : ch := 'Su Mo Tu We Th Fr Sa';
    else
      ch := '';
    end;
  end;
  msg_ch := ch;
end; { msg_ch }

{ T_Calendar_Window }
constructor T_Calendar_Window.Init;
var
   R : TRect;
begin
     R.Assign (1, 1, 23, 11);
     TWindow.Init (R, msg_ch (13), 0);
     Flags := Flags and not (wfZoom + wfGrow);    { Not resizeable }
     GrowMode :=0;
     options := options or ofcentered;
     Palette := wpCyanWindow;

     GetExtent (R);
     R.Grow (-1, -1);
     Insert (New (P_Calendar_View, Init (R)));
end; { T_Calendar_Window.Init }

{ T_Calendar_View }
constructor T_Calendar_View.Init (Bounds : TRect);
var
   H: Word;
begin
     TView.Init (Bounds);
     Options := Options or ofSelectable;
     EventMask := EventMask or evMouseAuto;
     GetDate (CurYear, CurMonth, CurDay, H);
     Year := CurYear;
     Month := CurMonth;
     modif_day := curday;
     DrawView;
end; { t_calendar_view.init }

constructor T_Calendar_View.Load (var S : TStream);
var
   H: Word;
begin
     TView.Load (S);
     GetDate (CurYear, CurMonth, CurDay, H);
     S.Read (Year, SizeOf (Year));
     S.Read (Month, SizeOf (Month));
     s.read (days, sizeof (days));
     s.read (modif_day, sizeof (modif_day));
end; { t_calendar_view.load }

function DayOfWeek (Day, Month, Year : Integer) : Integer;
var
   century, yr, dw: Integer;
begin
     if (Month < 3)
     then
         begin
              Inc (Month, 10);
              Dec (Year);
         end
     else
         Dec (Month, 2);
     {endif}
     century := Year div 100;
     yr := year mod 100;
     dw := (((26 * month - 2) div 10) + day + yr + (yr div 4) +
           (century div 4) - (2 * century)) mod 7;
     if (dw < 0)
     then
         DayOfWeek := dw + 7
     else
         DayOfWeek := dw;
     {endif}
end; { DayOfWeek }

procedure T_Calendar_View.Draw;
const
     Width = 20;
var
   i, j, DayOf, CurDays : Integer;
   S : String;
   B : array [0..Width] of Word;
   Color, actual_day_Color, new_day_Color : Byte;

  function Num2Str (I : Integer) : String;
  var
     S : String;
  begin
       Str(i:2, S);
       Num2Str := S;
  end; { Num2Str }

begin
     Color := GetColor (6);
     actual_day_Color := GetColor (7);
     new_day_Color := GetColor (5);
     DayOf := DayOfWeek (1, Month, Year);
     Days := DaysInMonth [Month] + Byte ((Year mod 4 = 0) and (Month = 2));
     Str (Year:4, S);
     MoveChar (B, ' ', Color, Width);
     MoveStr (B, msg_ch (month) + S+' '#30'  '#31, Color);
     WriteLine (0, 0, Width, 1, B);
     MoveChar (B, ' ', Color, Width);
     MoveStr (B, msg_ch (14), Color);
     WriteLine (0, 1, Width, 1, B);
     CurDays := 1 - DayOf;
     for i := 1 to 6 do
         begin
              MoveChar (B, ' ', Color, Width);
              for j := 0 to 6 do
                  begin
                       if ((CurDays < 1) or (CurDays > Days))
                       then
                           MoveStr (B [J * 3], '   ', Color)
                       else
                           if (CurDays = modif_Day)
                           then
                               MoveStr (B [J * 3], Num2Str (CurDays), New_day_Color)
                           else
                               if ((Year = CurYear) and (Month = CurMonth) and
                                   (CurDays = CurDay))
                               then
                                   MoveStr (B [J * 3], Num2Str (CurDays), actual_day_Color)
                               else
                                   MoveStr (B [J * 3], Num2Str (CurDays), Color);
                               {endif}
                           {endif}
                       {endif}
                       Inc (CurDays);
                  end;
              {endfor}
              WriteLine (0, i + 1, Width, 1, B);
         end;
     {endfor}
end; { T_Calendar_View.Draw }

procedure T_Calendar_View.HandleEvent (var Event: TEvent);
var
   Point : TPoint;
   SelectDay : Word;
begin
     TView.HandleEvent (Event);
     if (event.what = evcommand)
     then
         if (event.command = cmclose)
         then
             endmodal(cmquit);
         {endif}
     {endif}
     if (State and sfSelected <> 0)
     then
         begin
              if (Event.What and (evMouseDown + evMouseAuto) <> 0)
              then
                  begin
                       MakeLocal (Event.Where, Point);
                       if ((Point.X = 15) and (Point.Y = 0))
                       then
                           begin
                                Inc (Month);
                                if (Month > 12)
                                then
                                    begin
                                         Inc (Year);
                                         Month := 1;
                                    end;
                                {endif}
                           end;
                       {endif}
                       if ((Point.X = 18) and (Point.Y = 0))
                       then
                           begin
                                Dec (Month);
                                if (Month < 1)
                                then
                                    begin
                                         Dec (Year);
                                         Month := 12;
                                    end;
                                {endif}
                           end;
                       {endif}
                       if ((point.y > 1) and (point.y < 9))
                       then
                           begin
                                modif_day := (point.y -3)*7 + (point.x div 3) + dayofweek (1, month, year);
                                if (modif_day > days)
                                then
                                    modif_day := days;
                                {endif}
                                if (event.double)
                                then
                                    begin
                                         setdate (year, month, modif_day);
                                         endmodal (cmquit);
                                    end;
                                {endif}
                           end;
                       {endif}
                       drawview;
                  end
              else
                  if (Event.What = evKeyDown)
                  then
                      begin
                           case event.keycode of
                                kbup : if (modif_day > 7)
                                       then
                                           dec (modif_day, 7);
                                       {endif}
                                kbdown : if (modif_day < succ (days-7))
                                         then
                                             inc (modif_day, 7);
                                         {endif}
                                kbleft : if (modif_day > 1)
                                         then
                                             dec (modif_day);
                                         {endif}
                                kbright : if (modif_day < days)
                                          then
                                              inc (modif_day);
                                          {endif}
                                kbpgup : begin
                                              Dec (Month);
                                              if (Month < 1)
                                              then
                                                  begin
                                                       Dec (Year);
                                                       Month := 12;
                                                  end;
                                              {endif}
                                end;
                                kbpgdn : begin
                                              Inc (Month);
                                              if (Month > 12)
                                              then
                                                  begin
                                                       Inc (Year);
                                                       Month := 1;
                                                  end;
                                              {endif}
                                end;
                                kbenter : begin
                                               setdate (year, month, modif_day);
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
end; { T_Calendar_View.HandleEvent }

procedure T_Calendar_View.Store (var S: TStream);
begin
     TView.Store (S);
     S.Write (Year, SizeOf (Year));
     S.Write (Month, SizeOf (Month));
     s.write (days, sizeof (days));
     s.write (modif_day, sizeof (modif_day));
end; { T_Calendar_View.Store }

procedure Register_Calendar;
begin
  RegisterType (R_Calendar_View);
  RegisterType (R_Calendar_Window);
end; { Register_Calendar }

end.
