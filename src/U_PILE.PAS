unit u_pile;
{
Auteur: Patrick Pr‚martin
Date: 30/12/1992.
      26/06/1992.
      27/07/1992.
Langage: Turbo Pascal 6.0
But: Pile contenant uniquement des entiers.
}
interface
type
    t_int = word;

    p_elem = ^t_elem;
    t_elem = record
             nb : t_int;
             next : p_elem;
    end;

    p_pile = ^o_pile;
    o_pile = object
                   elem : p_elem;

                   constructor init;
                   destructor done;
                   procedure reset;
                   procedure push (n : t_int);
                   function pop : t_int;
    end;

    p_elem2 = ^t_elem2;
    t_elem2 = record
              nb : string;
              previous,
              next : p_elem2;
    end;

    p_file = ^o_file;
    o_file = object
                   first,
                   last : p_elem2;

                   constructor init;
                   destructor done;
                   procedure reset;
                   procedure add (ch : string);
                   function suppr : string;
    end;

implementation
constructor o_pile.init;
begin
     elem := nil;
end; { o_pile.init }

destructor o_pile.done;
var
   e : p_elem;
begin
     while (elem <> nil) do
           begin
                e := elem;
                elem := elem^.next;
                dispose (e);
           end;
     {endwhile}
end; { o_pile.done }

procedure o_pile.reset;
var
   e : p_elem;
begin
     while (elem <> nil) do
           begin
                e := elem;
                elem := elem^.next;
                dispose (e);
           end;
     {endwhile}
end; { o_pile.reset }

procedure o_pile.push (n : t_int);
var
   e : p_elem;
begin
     new (e);
     if (e <> nil)
     then
         begin
              e^.nb := n;
              e^.next := elem;
              elem := e;
         end;
     {endif}
end; { o_pile.push }

function o_pile.pop : t_int;
var
   res : t_int;
   e : p_elem;
begin
     if (elem = nil)
     then
         res := maxint
     else
         begin
              res := elem^.nb;
              e := elem;
              elem := elem^.next;
              dispose (e);
         end;
     {endif}
     pop := res;
end; { o_pile.pop }

constructor o_file.init;
begin
     first := nil;
     last := nil;
end; { o_file.init }

destructor o_file.done;
var
   e : p_elem2;
begin
     reset
end; { o_file.done }

procedure o_file.reset;
var
   e : p_elem2;
begin
     e := first;
     while (e <> nil) do
           begin
                first := e;
                e := e^.next;
                dispose (first);
           end;
     {endwhile}
     first := nil;
     last := nil;
end; { o_file.reset }

procedure o_file.add (ch : string);
var
   e : p_elem2;
begin
     new (e);
     if (e <> nil)
     then
         if (last = nil)
         then
             begin
                  last := e;
                  first := e;
                  e^.next := nil;
                  e^.previous := nil;
                  e^.nb := ch;
             end
         else
             begin
                  last^.next := e;
                  e^.previous := last;
                  e^.next := nil;
                  last := e;
                  e^.nb := ch;
             end;
         {endif}
     {endif}
end; { o_file.add }

function o_file.suppr : string;
var
   ch : string;
   e : p_elem2;
begin
     if (first = nil)
     then
         ch := ''
     else
         if (first = last)
         then
             begin
                  ch := first^.nb;
                  last := nil;
                  dispose (first);
                  first := nil;
             end
         else
             begin
                  e := first;
                  first := e^.next;
                  ch := e^.nb;
                  dispose (e);
             end;
         {endif}
     {endif}
     suppr := ch;
end; { o_file.suppr }

end. { u_pile }
