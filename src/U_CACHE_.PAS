unit u_cache_disk;
{
Auteur: Patrick Pr‚martin.
Date: 06/08/1992. 14/08/1992. 10/01/1993.
Langage: Turbo Pascal 6.0
But: Acc‚l‚ration des lectures/‚critures r‚alis‚es par BLOCKREAD et BLOCKWRITE
     dans les programmes … l'aide d'un cache disque.
}
interface
const
     nb_fic = 10; { Nombre de fichiers g‚r‚s. }
     tampon_fic = 512; { Taille en octets pour le tampon de chaque fichier. }
     erreur_io : word = 0; { Est <> 0 si une erreur s'est produite. }
       { Codes d'erreur: 0 - aucune erreur.
                         1 - fichier non ouvert. (consulter IORESULT)
                         2 - fin de fichier atteinte.
                         3 - num‚ro de fichier in‚xistant.
                         4 - Tentative de lecture sur fichier en ‚criture.
                         5 - Tentative d'‚criture sur fichier en lecture.
                         6 - Erreur disque (consulter IORESULT).
       }
type
    t_read_write = (lecture, ecriture);

function fich_valide (f : integer) : boolean;
  { Indique si un num‚ro de fichier est utilisable. }

function ouvre (nom : string; read_write : t_read_write) : integer;
  { Ouvre un fichier, et retourne son num‚ro. Un 0 correspond … une erreur. }

procedure lit_bloc (f : integer; var res; taille : word);
  { Transfert TAILLE octet vers RES … partir du fichier F. }

procedure ecrit_bloc (f : integer; var res; taille : word);
  { Transfert TAILLE octets de RES vers le fichier. }

procedure ferme (f : integer);
  { Referme le fichier F. }

function fin_fich (f : integer) : boolean;
  { Indique la fin d'un fichier }

function get_taille (f : integer) : longint;
  { Renvoie la taille d'un fichier. }

implementation
type
    t_tampon = array [1..nb_fic] of array [1..tampon_fic] of byte;
      { Tampon de chaque fichier. }
    t_type_fic = array [1..nb_fic] of t_read_write;
      { Type d'acc‚s aux fichiers. }
    t_utilise = array [1..nb_fic] of boolean;
      { Indique si un canal est ouvert (TRUE) ou ferme (FALSE). }
    t_indice = array [1..nb_fic] of word;
      { Tableau des indices de chaque fichier = pointeurs dans tampon. }
    t_taille = array [1..nb_fic] of longint;
      { Indique la taille de chaque fichier. }
    t_fich = array [1..nb_fic] of file;
      { Tableau des ficheirs DOS. }
    t_lu = array [1..nb_fic] of word;
      { Contient le nombre d'octets dans le tampon. }

var
   tampon : t_tampon;
   type_fic : t_type_fic;
   utilise : t_utilise;
   indice : t_indice;
   taille : t_taille;
   fich : t_fich;
   lu : t_lu;

function fich_valide (f : integer) : boolean;
var
   res : boolean;
begin
  res := (((f > 0) and (f < nb_fic)) and (utilise [f]));
  if res
  then
    erreur_io := 0
  else
    erreur_io := 3;
  {endif}
  fich_valide := res;
end; { fich_valide }

function ouvre (nom : string; read_write : t_read_write) : integer;
var
   i : integer;
begin
  i := 1;
  while ((i < nb_fic) and (utilise [i])) do
    inc (i);
  {endwhile}
  if (utilise [i])
  then
    begin
      i := 0;
      erreur_io := 1;
    end
  else
    begin
      erreur_io := 0;
      assign (fich [i], nom);
      {$i-}
      case (read_write) of
        ecriture : rewrite (fich [i], 1);
      else
        reset (fich [i], 1);
        read_write := lecture;
      end;
      {$i+}
      if (ioresult <> 0)
      then
        begin
          erreur_io := 1;
          i := 0;
        end
      else
        begin
          type_fic [i] := read_write;
          utilise [i] := true;
          indice [i] := 1;
          taille [i] := filesize (fich [i]);
          lu [i] := 0;
        end;
      {endif}
    end;
  {endif}
  ouvre := i;
end; { ouvre }

procedure lit_bloc (f : integer; var res; taille : word);
var
   n : word;
begin
  n := 0;
  if (fich_valide (f))
  then
    if (type_fic [f] <> lecture)
    then
      erreur_io := 4
    else
      while ((n < taille) and (erreur_io <> 2)) do
        begin
          if (indice [f] > lu [f])
          then
            begin
              indice [f] := 1;
              blockread (fich [f], tampon [f], sizeof (tampon [f]), lu [f]);
              if (lu [f] < 1)
              then
                erreur_io := 2;
              {endif}
            end;
          {endif}
          if (erreur_io = 0)
          then
            begin
              {$r-}
              mem [seg (res): ofs (res)+n] := tampon [f] [indice [f]];
              {$r-}
              inc (indice [f]);
              inc (n);
            end;
          {endif}
        end;
      {endwhile}
    {endif}
  {endif}
end; { lit_bloc }

procedure ecrit_bloc (f : integer; var res; taille : word);
var
   n : word;
begin
  n := 0;
  if (fich_valide (f))
  then
    if (type_fic [f] <> ecriture)
    then
      erreur_io := 5
    else
      while ((n < taille) and (erreur_io <> 6)) do
        begin
          if (lu [f] = sizeof (tampon [f]))
          then
            begin
              blockwrite (fich [f], tampon [f], sizeof (tampon [f]), lu [f]);
              if (lu [f] <> sizeof (tampon [f]))
              then
                erreur_io := 6;
              {endif}
              lu [f] := 0;
              indice [f] := 1;
            end;
          {endif}
          if (erreur_io = 0)
          then
            begin
              {$r-}
              tampon [f] [indice [f]] := mem [seg (res): ofs (res)+n];
              {$r-}
              inc (indice [f]);
              inc (lu [f]);
              inc (n);
            end;
          {endif}
        end;
      {endwhile}
    {endif}
  {endif}
end; { ecrit_bloc }

procedure ferme (f : integer);
begin
  if (fich_valide (f))
  then
    begin
      if (type_fic [f] = ecriture)
      then
        if (lu [f] > 0)
        then
          blockwrite (fich [f], tampon [f], lu [f]);
        {endif}
      {endif}
      close (fich [f]);
      utilise [f] := false;
    end;
  {endif}
end; { ferme }

function fin_fich (f : integer) : boolean;
begin
  if (fich_valide (f))
  then
    fin_fich := (indice [f] > lu [f])
  else
    fin_fich := false;
  {endif}
end; { fin_fich }

function get_taille (f : integer) : longint;
begin
  if (fich_valide (f))
  then
    get_taille := taille [f]
  else
    get_taille := 0;
  {endif}
end; { get_taille }

procedure init_cache_disk;
var
   i : integer;
begin
  for i := 1 to nb_fic do
    begin
      type_fic [i] := lecture;
      utilise [i] := false;
      indice [i] := 1;
      taille [i] := 0;
      lu [i] := 0;
    end;
  {endfor}
end; { init_cache_disk }

var
   old_exitproc : pointer;

procedure exit_cache_disk; far;
var
   i : integer;
begin
  for i := 1 to nb_fic do
    ferme (i);
  {endfor}
  exitproc := old_exitproc;
end; { exit_cache_disk }

begin
  init_cache_disk;
  old_exitproc := exitproc;
  exitproc := @exit_cache_disk;
end.
