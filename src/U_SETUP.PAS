unit u_setup;
{
Auteur: Patrick Pr‚martin.
Date: 21/07/1992. 28/07/1992. (Interface Multi-Langues)
      03/08/1992. 06/09/1992. 13/12/1992. 01/01/1993.
Langage: Turbo Pascal 6.0
Date: 23/03/1995.
Langage: Borland Pascal 7.0
But: Gestion du fichier SETUP.CFG contenant la configuration du programme Olf
     Software auquel il est joint.
}

interface

procedure save_setup;
{ Sauvegarde la configuration actuelle. }

implementation
uses
    u_sgf,
    u_msg,
    u_keyboard,
    u_joystick;

const
     header = #8'Olf Software configuration file'#10#13#26#0;

type
    p_byte = ^byte;

procedure init_config (buf : p_byte; n : word);
var
   ch : string;
   pt : p_byte;
   i : word;

     procedure load_joystick;
     begin
          minx_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          miny_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          maxx_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          maxy_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          minx_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          miny_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          maxx_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          maxy_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
     end; { load_joystick }

     procedure load_joystick2;
     begin
          vx_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          vy_0 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          vx_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
          vy_1 := word (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 2;
     end; { load_joystick2 }

     procedure load_msg_name;
     var
        j : byte;
     begin
          ch [0] := char (ptr (seg (pt^), i+ofs (pt^))^);
          for j := 1 to length (ch) do
              ch [j] := char (ptr (seg (pt^), j+i+ofs (pt^))^);
          {endfor}
          i := i + succ (length (ch));
          langue_par_defaut := longint (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 4;
          ch := get_file_name (ch);
          init_msg (ch);
     end; { load_msg_name }

     procedure load_keyboard;
     begin
          keyboard_type := byte (ptr (seg (pt^), i+ofs (pt^))^);
          i := i + 1;
     end; { load_keyboard }

begin
     pt := buf;
     i := succ (pt^); { On saute la chaŒne du header... }
     repeat
       ch [0] := chr (4);
       ch [1] := chr (byte (ptr (seg (pt^), i + ofs (pt^))^));
       ch [2] := chr (byte (ptr (seg (pt^), 1+i + ofs (pt^))^));
       ch [3] := chr (byte (ptr (seg (pt^), 2+i + ofs (pt^))^));
       ch [4] := chr (byte (ptr (seg (pt^), 3+i + ofs (pt^))^));
       i := i + 4;
       if (ch = 'JOY'+#0)
       then
         load_joystick
       else
         if (ch = 'MSG'+#0)
         then
           load_msg_name
         else
           if (ch = 'KBD'+#0)
           then
               load_keyboard
           else
             if (ch = 'STK'+#0)
             then
               load_joystick2
             {endif}
         {endif}
       {endif}
     until (i >= n);
end; { init_config }

procedure save_config (var f : file);
var
   ch : string;

     procedure save_joystick;
     begin
          ch := 'JOY'+#0;
          blockwrite (f, ch [1], 4);
          blockwrite (f, minx_0, sizeof (minx_0));
          blockwrite (f, miny_0, sizeof (miny_0));
          blockwrite (f, maxx_0, sizeof (maxx_0));
          blockwrite (f, maxy_0, sizeof (maxy_0));
          blockwrite (f, minx_1, sizeof (minx_1));
          blockwrite (f, miny_1, sizeof (miny_1));
          blockwrite (f, maxx_1, sizeof (maxx_1));
          blockwrite (f, maxy_1, sizeof (maxy_1));
     end; { save_joystick }

     procedure save_joystick2;
     begin
          ch := 'STK'+#0;
          blockwrite (f, ch [1], 4);
          blockwrite (f, vx_0, sizeof (vx_0));
          blockwrite (f, vy_0, sizeof (vy_0));
          blockwrite (f, vx_1, sizeof (vx_1));
          blockwrite (f, vy_1, sizeof (vy_1));
     end; { save_joystick2 }

     procedure save_msg_name;
     begin
          ch := 'MSG'+#0;
          blockwrite (f, ch [1], 4);
          blockwrite (f, nom_fich_msg [0], succ (length (nom_fich_msg)));
          blockwrite (f, langue_par_defaut, sizeof (longint));
     end; { save_msg_name }

     procedure save_keyboard;
     begin
          ch := 'KBD'+#0;
          blockwrite (f, ch [1], 4);
          blockwrite (f, keyboard_type, sizeof (keyboard_type));
     end; { save_keyboard }

begin
     ch := header;
     blockwrite (f, ch [0], succ (length (ch)));
     save_joystick;
     save_joystick2;
     save_msg_name;
     save_keyboard;
end; { save_config }

procedure load_setup;
var
   f : file;
   n : word;
   buf : p_byte;
begin
     assign (f, get_file_name ('SETUP.CFG'));
     {$i-}
     reset (f, 1);
     {$i+}
     if (ioresult <> 0)
     then
         writeln ('SETUP.CFG not found, default config used...')
     else
         begin
              n := filesize (f);
              getmem (buf, n);
              if (buf = nil)
              then
                  begin
                       writeln ('Not enough memory to load config...');
                       halt (1);
                  end;
              {endif}
              blockread (f, buf^, n);
              close (f);
              init_config (buf, n);
              freemem (buf, n);
         end;
     {endif}
end; { load_setup }

procedure save_setup;
var
   f : file;
begin
     assign (f, 'SETUP.CFG');
     {$i-}
     rewrite (f, 1);
     {$i+}
     if (ioresult <> 0)
     then
         erreur (ioresult)
     else
         begin
              save_config (f);
              close (f);
         end;
     {endif}
end; { save_setup }

begin
  load_setup;
end.
