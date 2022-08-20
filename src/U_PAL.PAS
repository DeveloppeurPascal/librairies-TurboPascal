unit u_pal;
{
Auteur: Patrick Pr‚martin.
Date: 21/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion des fichiers d'extension .PAL (palettes de 256 nuances RVB)
}

interface
uses
    u_int10h;

type
    p_pal = ^t_pal;
    t_pal = t_tab_rvb;

    pal_file = file of t_pal;

function load_pal (name : string) : p_pal;
{ Chargement d'une palette (fichier d'extension .PAL) }

procedure save_pal (name : string; pal : p_pal);
{ Sauvegarde d'une palette de couleurs. }

procedure use_pal (pal : p_pal);
{ Utilisation d'une palette de couleurs. }

implementation
uses
    u_sgf;

function load_pal (name : string) : p_pal;
var
   f : pal_file;
   res : p_pal;
begin
     new (res);
     if (res <> nil)
     then
         begin
              met_extension (name, 'PAL', name);
              assign (f, name);
              {$i-}
              reset (f);
              {$i+}
              if (ioresult <> 0)
              then
                  begin
                       dispose (res);
                       res := nil;
                  end
              else
                  begin
                       read (f, res^);
                       close (f);
                  end;
              {endif}
         end;
     {endif}
     load_pal := res;
end; { load_pal }

procedure save_pal (name : string; pal : p_pal);
var
   f : pal_file;
begin
     if (pal <> nil)
     then
         begin
              met_extension (name, 'PAL', name);
              assign (f, name);
              {$i-}
              rewrite (f);
              {$i+}
              if (ioresult = 0)
              then
                  begin
                       write (f, pal^);
                       close (f);
                  end;
              {endif}
         end;
     {endif}
end; { save_pal }

procedure use_pal (pal : p_pal);
begin
     if (pal <> nil)
     then
         set_blk_cna_reg (0, 256, pal^);
     {endif}
end; { use_pal }

end.
