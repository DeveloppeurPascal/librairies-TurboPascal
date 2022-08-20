unit u_spr;
{
Auteur: Patrick Pr‚martin.
Date: 04/08/1992. 05/08/1992. 06/08/1992. 12/08/1992. 22/11/1992. 29/11/1992.
      06/11/1992.
Langage: Turbo Pascal 6.0
But: Utilisation simplifi‚e des fichiers SPR (sprites en 256 couleurs pour le
     mode graphique 19).
}

interface

const
     spr_header = #8'Sprite Maker'#10#13'(c) Olf Software'#10#13#26#0;

type
    p_spr = ^o_spr;
    o_spr =
      object
        numero,
        largeur,
        hauteur : word;
        forme : pointer;

        constructor init;
        destructor done;
        constructor load (var fich : file);
        procedure save (var fich : file);
        procedure put (x, y : word);
      end;

    p_sprite = ^o_sprite;
    o_sprite =
      object
        numero : word;
        tampon : pointer;
        spr_x, spr_y,
        larg, haut : word;

        constructor init (num : word);
        destructor done;
        procedure affiche (x, y : word);
        procedure met_sprite (x, y : word);
        procedure set_spr (x, y : word);
        procedure efface;
      private
        on,
        lt, ht : word;
        procedure transfert (t1, t2 : pointer);
      end;

    p_spr_lst = ^o_spr_lst;
    o_spr_lst =
      object (o_spr)
        next : p_spr_lst;
        spr : p_spr;

        constructor init (n : p_spr);
        destructor done;
        constructor load (var fich : file);
        procedure save (var fich : file);
        procedure affiche (n, x, y : word);
        procedure get_taille (n : word; var larg, haut : word);
        function get_forme (n : word) : pointer;
        function get_sprite (n : word) : p_spr;
        function tst_num (n : word) : boolean;
      end;

var
   liste_sprite : p_spr_lst;
   nb_max_sprite : word;

function register_sprite (nom : string) : word;
procedure remove_sprite;
procedure save_sprite_liste (nom : string);

implementation
uses
    u_sgf;

var
   fin : boolean;
   l, h : word;

function max (a, b : word) : word;
begin
  if (a > b)
  then
    max := a
  else
    max := b;
  {endif}
end; { max }

constructor o_spr.init;
begin
  numero := 0;
  largeur := 0;
  hauteur := 0;
  forme := nil;
end; { o_spr.init }

destructor o_spr.done;
begin
  if ((forme <> nil) and (largeur > 0) and (hauteur > 0))
  then
    freemem (forme, largeur*hauteur);
  {endif}
  forme := nil;
end; { o_spr.done }

constructor o_spr.load (var fich : file);
begin
  blockread (fich, largeur, sizeof (word));
  blockread (fich, hauteur, sizeof (word));
  if ((largeur > 0) and (hauteur > 0))
  then
    getmem (forme, largeur*hauteur)
  else
    forme := nil;
  {endif}
  if (forme <> nil)
  then
    blockread (fich, forme^, hauteur*largeur);
  {endif}
end; { o_spr.load }

procedure o_spr.save (var fich : file);
begin
  blockwrite (fich, largeur, sizeof (word));
  blockwrite (fich, hauteur, sizeof (word));
  if (forme <> nil)
  then
    blockwrite (fich, forme^, hauteur*largeur);
  {endif}
end; { o_spr.save }

procedure o_spr.put (x, y : word);
var
   i, j : word;
   c : byte;
begin
  if (forme <> nil)
  then
    for j := 0 to pred (hauteur) do
      for i := 0 to pred (largeur) do
        begin
          c := mem [seg (forme^) : ofs (forme^)+i+j*largeur];
          if (c <> 0)
          then
            mem [$a000:(x+i)+(y+j)*320] := c;
          {endif}
        end;
      {endfor}
    {endfor}
  {endif}
end; { o_spr.put }

constructor o_sprite.init (num : word);
begin
  spr_x := 0;
  spr_y := 0;
  tampon := nil;
  if (liste_sprite^.tst_num (num))
  then
    numero := num
  else
    numero := 0;
  {endif}
  on := numero;
  liste_sprite^.get_taille (num, larg, haut);
  lt := larg;
  ht := haut;
end; { o_sprite.init }

destructor o_sprite.done;
begin
  if ((tampon <> nil) and (lt > 0) and (ht > 0))
  then
    freemem (tampon, lt*ht);
  {endif}
  tampon := nil;
end; { o_sprite.done }

procedure o_sprite.set_spr (x, y : word);
begin
  spr_x := x;
  spr_y := y;
end; { o_sprite.set_spr }

procedure o_sprite.affiche (x, y : word);
begin
  efface;
  met_sprite (x, y);
end; { o_sprite.affiche }

procedure o_sprite.met_sprite (x, y : word);
begin
  if (on <> numero)
  then
    begin
      on := numero;
      liste_sprite^.get_taille (numero, l, h);
      haut := h;
      larg := l;
      if ((l > lt) or (h > ht))
      then
        begin
          if ((tampon <> nil) and (ht > 0) and (lt > 0))
          then
            freemem (tampon, ht*lt);
          {endif}
          tampon := nil;
          lt := max (l, lt);
          ht := max (h, ht);
        end;
      {endif}
    end;
  {endif}
  if ((tampon = nil) and (lt > 0) and (ht > 0))
  then
    getmem (tampon, lt*ht);
  {endif}
  spr_x := x;
  spr_y := y;
  transfert (ptr ($a000, spr_x+spr_y*320), tampon);
  liste_sprite^.affiche (numero, x, y);
end; { o_sprite.met_sprite }

procedure o_sprite.efface;
begin
  transfert (tampon, ptr ($a000, spr_x+spr_y*320));
end; { o_sprite.efface }

procedure o_sprite.transfert (t1, t2 : pointer);
var
   i, j : word;
begin
  if ((t1 <> nil) and (t2 <> nil) and (ht > 0) and (lt > 0))
  then
    for j := 0 to pred (ht) do
      for i := 0 to pred (lt) do
        mem [seg(t2^):ofs(t2^)+i+j*320] := mem [seg(t1^):ofs(t1^)+i+j*320];
      {endfor}
    {endfor}
  {endif}
end; { o_sprite.transfert }

constructor o_spr_lst.init (n : p_spr);
begin
  spr := n;
  next := nil;
end; { o_spr_lst.init }

destructor o_spr_lst.done;
begin
  if (spr <> nil)
  then
    dispose (spr, done);
  {endif}
  spr := nil;
  if (next <> nil)
  then
    dispose (next, done);
  {endif}
  next := nil;
end; { o_spr_lst.done }

constructor o_spr_lst.load (var fich : file);
begin
  spr := new (p_spr, load (fich));
  if (spr <> nil)
  then
    spr^.numero := nb_max_sprite;
  {endif}
  inc (nb_max_sprite);
  if (eof (fich))
  then
    next := nil
  else
    next := new (p_spr_lst, load (fich));
  {endif}
end; { o_spr_lst.load }

procedure o_spr_lst.save (var fich : file);
begin
  if (spr <> nil)
  then
    spr^.save (fich);
  {endif}
  if (next <> nil)
  then
    next^.save (fich);
  {endif}
end; { o_spr_lst.save }

procedure o_spr_lst.affiche (n, x, y : word);
begin
  fin := false;
  if (spr <> nil)
  then
    if (n = spr^.numero)
    then
      begin
        fin := true;
        spr^.put (x, y);
      end;
    {endif}
  {endif}
  if ((not fin) and (next <> nil))
  then
    next^.affiche (n, x, y);
  {endif}
end; { o_spr_lst.affiche }

procedure o_spr_lst.get_taille (n : word; var larg, haut : word);
begin
  fin := false;
  if (spr <> nil)
  then
    if (n = spr^.numero)
    then
      begin
        larg := spr^.largeur;
        haut := spr^.hauteur;
        fin := true;
      end;
    {endif}
  {endif}
  if ((not fin) and (next <> nil))
  then
    next^.get_taille (n, larg, haut);
  {endif}
end; { o_spr_lst.get_taille }

function o_spr_lst.get_forme (n : word) : pointer;
var
   res : pointer;
begin
  res := nil;
  if (spr <> nil)
  then
    if (spr^.numero = n)
    then
      res := spr^.forme;
    {endif}
  {endif}
  if ((res = nil) and (next <> nil))
  then
    res := next^.get_forme (n);
  {endif}
  get_forme := res;
end; { o_spr_lst.get_forme }

function o_spr_lst.get_sprite (n : word) : p_spr;
var
   res : p_spr;
begin
  res := nil;
  if (spr <> nil)
  then
    if (spr^.numero = n)
    then
      res := spr;
    {endif}
  {endif}
  if ((res = nil) and (next <> nil))
  then
    res := next^.get_sprite (n);
  {endif}
  get_sprite := res;
end; { get_sprite }

function o_spr_lst.tst_num (n : word) : boolean;
begin
  fin := false;
  if (spr <> nil)
  then
    fin := (n = spr^.numero);
  {endif}
  if (fin or (next = nil))
  then
    tst_num := fin
  else
    tst_num := next^.tst_num (n);
  {endif}
end; { o_spr_lst.tst_num }

function register_sprite (nom : string) : word;
var
   f : file;
   ch : string;
   res,
   nb_sprite : word;
   e,
   l : p_spr_lst;
begin
  res := 0;
  met_extension (nom, 'SPR', nom);
  assign (f, nom);
  {$i-}
  reset (f, 1);
  {$i+}
  if (ioresult = 0)
  then
    begin
      res := nb_max_sprite;
      blockread (f, ch [0], sizeof (char));
      blockread (f, ch [1], ord (ch [0]));
      blockread (f, nb_sprite, sizeof (word));
      e := new (p_spr_lst, load (f));
      close (f);
      if (liste_sprite <> nil)
      then
        begin
          l := liste_sprite;
          while (l^.next <> nil) do
            l := l^.next;
          {endwhile}
          l^.next := e;
        end
      else
        liste_sprite := e;
      {endif}
    end;
  {endif}
  register_sprite := res;
end; { register_sprite }

procedure remove_sprite;
begin
  if (liste_sprite <> nil)
  then
    dispose (liste_sprite, done);
  {endif}
  liste_sprite := nil;
  nb_max_sprite := 0;
end; { remove_sprite }

procedure save_sprite_liste (nom : string);
var
   f : file;
   ch : string;
begin
  met_extension (nom, 'SPR', nom);
  assign (f, nom);
  {$i-}
  rewrite (f, 1);
  {$i+}
  if (ioresult = 0)
  then
    begin
      ch := spr_header;
      blockwrite (f, ch [0], succ (length (ch)));
      blockwrite (f, nb_max_sprite, sizeof (word));
      if (liste_sprite <> nil)
      then
        liste_sprite^.save (f);
      {endif}
      close (f);
    end;
  {endif}
end; { save_sprite_liste }

var
   old_exitproc : pointer;

procedure exit_spr; far;
begin
  remove_sprite;
  exitproc := old_exitproc;
end; { exit_spr }

begin
  liste_sprite := nil;
  nb_max_sprite := 0;
  old_exitproc := exitproc;
  exitproc := @exit_spr;
end.
