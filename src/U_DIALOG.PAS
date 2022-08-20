unit u_dialogs;
{
Auteur: Pr‚martin Patrick.
Date: 07/08/1991. 13/08/1991. 02/09/1991. 11/09/1992.
Langage: Turbo Pascal 6.0

But: Red‚finition d'objets de DIALOGS (Turbo Vision).
}
interface

uses
    dialogs,
    drivers,
    objects,
    views;

type
    P_Input_Number = ^T_Input_Number;
    T_Input_Number = object (tinputline)
                          constructor init (var bounds : trect; min_val, max_val : longint);
                          constructor load (var s : tstream);
                          function datasize : word; virtual;
                          procedure getdata (var rec); virtual;
                          procedure setdata (var rec); virtual;
                          procedure store (var s : tstream);
                          function valid (command : word) : boolean; virtual;
                          procedure handleevent (var event : tevent); virtual;
                   private
                          min : longint;
                          max : longint;
                          old_data : pstring;
                          function num2str (number : longint) : string;
                          function str2num (ch : string) : longint;
                          function num_max (a, b : longint) : longint;
                          function num_min (a, b : longint) : longint;
    end;

const
     R_Input_Number : tstreamrec = (
                               ObjType : 10300;
                               vmtlink : ofs (typeof (T_Input_Number)^);
                               load : @T_Input_Number.load;
                               store : @T_Input_Number.store);

procedure register_dialogs;

implementation

{ Objet: T_Input_Number. }

constructor T_Input_Number.init (var bounds : trect; min_val, max_val : longint);
begin
     tinputline.init (bounds, num_max (length (num2str (max_val)), length (num2str (min_val))));
     min := num_min (min_val, max_val);
     max := num_max (min_val, max_val);
     data^ := num2str (min);
     new (old_data)
end; { T_Input_Number.Init }

constructor T_Input_Number.load (var s : tstream);
begin
     tinputline.load (s);
     s.read (min, sizeof (min));
     s.read (max, sizeof (max));
end; { T_Input_Number.Load }

function T_Input_Number.datasize : word;
begin
     datasize := sizeof (longint);
end; { T_Input_Number.DataSize }

procedure T_Input_Number.getdata (var rec);
var
   ptr_longint : ^longint;
begin
     new (ptr_longint);
     ptr_longint^ := str2num (data^);
     move (ptr_longint^, rec, datasize);
     dispose (ptr_longint);
     ptr_longint := nil;
end; { T_Input_Number.GetData }

procedure T_Input_Number.setdata (var rec);
var
   ptr_longint : ^longint;
begin
     new (ptr_longint);
     move (rec, ptr_longint^, datasize);
     if (ptr_longint^ < min)
     then
       ptr_longint^ := min
     else
       if (ptr_longint^ > max)
       then
         ptr_longint^ := max;
       {endif}
     {endif}
     data^ := num2str (ptr_longint^);
     dispose (ptr_longint);
     ptr_longint := nil;
end; { T_Input_Number.SetData }

procedure T_Input_Number.store (var s : tstream);
begin
     tinputline.store (s);
     s.write (min, sizeof (min));
     s.write (max, sizeof (max));
end; { T_Input_Number.Store }

function T_Input_Number.valid (command : word) : boolean;
var
   a : longint;
   erreur : integer;
begin
     val (data^, a, erreur);
     if (erreur = 0)
     then
         if (a < min)
         then
             data^ := num2str (min)
         else
             if (a > max)
             then
                 data^ := num2str (max);
             {endif}
         {endif}
     {endif}
     valid := ((erreur = 0) and tinputline.valid (command));
end; { T_Input_Number.Valid }

function T_Input_Number.num2str (number : longint) : string;
var
   s : string;
begin
     str (number, s);
     num2str := s;
end; { T_Input_Number.Num2Str }

function T_Input_Number.str2num (ch : string) : longint;
var
   nb : longint;
   erreur : integer;
begin
     val (ch, nb, erreur);
     if (erreur = 0)
     then
         str2num := nb
     else
         str2num := maxint;
     {endif}
end; { T_Input_Number.Str2Num }

function T_Input_Number.num_max (a, b : longint) : longint;
begin
     if (a > b)
     then
         num_max := a
     else
         num_max := b;
     {endif}
end; { T_Input_Number.Num_Max }

function T_Input_Number.num_min (a, b : longint) : longint;
begin
     if (a < b)
     then
         num_min := a
     else
         num_min := b;
     {endif}
end; { T_Input_Number.Num_Min }

procedure t_input_number.handleevent (var event : tevent);
var
   old_curs : integer;
   l : longint;
begin
     old_curs := curpos;
     old_data^ := data^;
     tinputline.handleevent (event);
     if (event.what = evkeydown)
     then
         if event.keycode = kbpgup
         then
             data^ := num2str (succ (str2num (data^)))
         else
             if event.keycode = kbpgdn
             then
                 data^ := num2str (pred (str2num (data^)));
             {endif}
         {endif}
     {endif}
     l := str2num (data^);
     if ((l < min) or (l > max))
     then
         begin
              data^ := old_data^;
              curpos := old_curs;
         end;
     {endif}
     drawview;
end; { T_Input_Number.HandleEvent }

procedure register_dialogs;
begin
     registertype (R_Input_Number);
end; { Register_Dialogs }

end. { Fin de l'unit‚ 'U_Dialogs'. }
