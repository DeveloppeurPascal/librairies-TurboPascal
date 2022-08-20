Unit U_Sgf;
{
Turbo Pascal 4.0: 18/07/1991.
Turbo Pascal 6.0: 25/06/1992. 21/07/1992. 24/07/1992. 03/08/1992. 04/08/1992.
                  05/08/1992. 01/01/1993.

But: Contient des fonctions permettant de traiter les fichiers plus facilement.
     Les fonctions renvoient TRUE si aucun problŠme n'a eu lieu, sinon FALSE.
}
Interface
uses crt,
     dos,
     u_curseur;

const
     C_EXE_Name: string = '';

Function Exist (Nom_Fic: String): Boolean;
         { teste l'‚xistence d'un fichier }
Function Renomme (Nom1,Nom2: String): Boolean;
         { renomme le fichier NOM1 en NOM2 si NOM1 existe et que NOM2
         n'existe pas. }
Function Efface (Nom_Fic: String): Boolean;
         { efface le fichier sp‚cifi‚ }
Function Change_Dir (Repertoire: String): Boolean;
         { change le chemin courant (lecteur inclus) }
Function Make_Dir (Repertoire: String): Boolean;
         { cr‚e le sous-r‚pertoire }
Function Remove_Dir (Repertoire: String): Boolean;
         { efface le sous-repertoire sp‚cifi‚ }
Function Get_Extension (Nom_Fich : String): String;
         { renvoie l'extension du fichier sp‚cifi‚ s'il y en a une.
         ( le point est inclus dans l'extension)                   }
Function Get_Nom_Fichier (Nom_Fich : String): String;
         { renvoie le nom du fichier ‚pur‚ de son chemin d'accŠs (mais avec
           extension). }
function get_nom_fichier2 (nom_fich : string) : string;
         { Renvoie le nom du fichier sans extension. }
Function Get_Chemin_Fichier (Nom_Fich : String) : String;
         { renvoie le chemin d'accŠs contenu dans Nom_Fich. }

Procedure Met_Extension (Nom_Fic, Extension : String; Var Result : String);
          { met l'extension pr‚cis‚e au fichier sp‚cifi‚. }
Procedure Cree_Bak (Nom_Fic: String);
          { cree le fichier .BAK correspondant au fichier nomm‚ }
procedure erreur (code_io : integer);

function get_file_name (nom_fic : pathstr) : pathstr;
         { Renvoie le chemin d'accŠs complet dans lequel se trouve le programme
         recherch‚. }

Implementation
Function Exist (Nom_Fic: String): Boolean;
Var s : searchrec;
Begin { exist }
  findfirst (nom_fic, anyfile, s);
  Exist := (doserror=0)
End; { exist }

Function Renomme (Nom1, Nom2: String): Boolean;
Var Fichier: File;
Begin { renomme }
  If Exist (Nom1)
  Then
    If Not Exist (Nom2)
    Then
      Begin
        Assign (Fichier, Nom1);
        Rename (Fichier, Nom2);
        Renomme := True
      End
    Else
      Renomme := False
    {endif}
  Else
    Renomme := False
  {endif}
End; { renomme }

Function Efface (Nom_Fic: String): Boolean;
Var Fichier: File;
Begin { efface }
  If Exist (Nom_Fic)
  Then
    Begin
      Assign (Fichier, Nom_Fic);
      Erase (Fichier);
      Efface := True
    End
  Else
    Efface := False
  {endif}
End; { efface }

Function Change_Dir (Repertoire: String): Boolean;
Begin { change_dir }
  {$i-}
  Chdir (Repertoire);
  {$i+}
  Change_Dir := (Ioresult=0)
End; { change_dir }

Function Make_Dir (Repertoire: String): Boolean;
Begin { make_dir }
  {$i-}
  Mkdir (Repertoire);
  {$i+}
  Make_Dir := (Ioresult=0)
End; { make_dir }

Function Remove_Dir (Repertoire: String): Boolean;
Begin { remove_dir }
  {$i-}
  Rmdir (Repertoire);
  {$i+}
  Remove_Dir := (Ioresult=0)
End; { remove_dir }

Function Get_Extension (Nom_Fich : String): String;
Var I : Integer;
Begin { get_extension }
  Nom_Fich := Get_Nom_Fichier (Nom_Fich);
  I := Pos ('.', Nom_Fich);
  If (I = 0)
  Then
    Get_Extension := ''
  Else
    Get_Extension := Copy (Nom_Fich, I, succ (length (nom_fich)-i))
  {endif}
End; { get_extension }

Function Get_Nom_Fichier (Nom_Fich : String): String;
Var I : Integer;
Begin { get_nom_fichier }
  I := Pos (':', Nom_Fich);
  If (I > 0)
  Then
    Delete (Nom_Fich, 1, I)
  {endif};
  I := Pos ('\', Nom_Fich);
  While Not (I = 0) Do
    Begin
      Delete (Nom_Fich, 1, I);
      I := Pos ('\', Nom_Fich)
    End
  {endwhile};
  Get_Nom_Fichier := Nom_Fich
End; { get_nom_fichier }

function get_nom_fichier2 (nom_fich : string) : string;
var
   n : byte;
begin
     nom_fich := get_nom_fichier (nom_fich);
     n := pos ('.', nom_fich);
     if (n = 0)
     then
         get_nom_fichier2 := nom_fich
     else
         get_nom_fichier2 := copy (nom_fich, 1, pred (n));
     {endif}
end; { get_nom_fichier2 }

Function Get_Chemin_Fichier (Nom_Fich : String) : String;
Var I, J : Integer;
Begin { get_chemin_fichier }
  I := Length (Nom_Fich);
  J := Length (Get_Nom_Fichier (Nom_Fich));
  Delete (Nom_Fich, Succ (I-J), J);
  I := Length (Nom_Fich);
  If (Nom_Fich [I] <> '\')
  Then
    Nom_Fich := Concat (Nom_Fich, '\');
  {endif};
  Get_Chemin_Fichier := Nom_Fich
End; { get_chemin_fichier }

Procedure Met_Extension (Nom_Fic, Extension : String; Var Result : String);
Var I, Posit1, Posit2 : Integer;
Begin { met_extension }
  I := Length (Nom_Fic);
  Posit1 := 0;
  Posit2 := 0;
  While Not (I < 1) Do
    Begin
      If ((Nom_Fic [I] = '.') And (Posit1 = 0))
      Then
        Posit1 := I
      {endif};
      If ((Nom_Fic [I] = '\') And (Posit2 = 0))
      Then
        Posit2 := I
      {endif};
      Dec (I)
    End
  {endwhile};
  If (Posit1 <= Posit2)
  Then
    Result := Nom_Fic
  Else
    Result := Copy (Nom_Fic, 1, Pred(Posit1))
  {endif};
  If (Pos ('.', Extension) <> 0)
  Then
    Result := Concat (Result, Copy (Extension, 1, 4))
  Else
    Result := Concat (Concat (Result, '.'), Copy (Extension, 1, 3))
  {endif}
End; { met_extension }

Procedure Cree_Bak (Nom_Fic: String);
Var Nom_Bak : String;
    Result  : Boolean;
Begin { cree_bak }
  If Exist (Nom_Fic)
  Then
    Begin
      Met_Extension (Nom_Fic, '.BAK', Nom_Bak);
      Result := Efface (Nom_Bak);
      Result := Renomme (Nom_Fic, Nom_Bak);
    End
  {endif}
End; { cree_bak }

procedure erreur (code_io : integer);
var
   carac : char;
   ox, oy : byte;
begin
     ox := curseur_x;
     oy := curseur_y;
     curseur_locate (1, 25);
     textattr := not textattr;
     case code_io of
          100 : write ('Disk read error');
          101 : write ('Disk write error ');
          102 : write ('File not assigned');
          103 : write ('File not open');
          104 : write ('File not open for input');
          105 : write ('File not open for output');
          106 : write ('Invalid numeric format');
          150 : write ('Disk is write protected');
          151 : write ('Unknow unit');
          152 : write ('Drive not ready');
          153 : write ('Unknow command');
          154 : write ('CRC error in data');
          155 : write ('Bad drive request structure length');
          156 : write ('Disk seek error');
          157 : write ('Unknow media type');
          158 : write ('Sector not found');
          159 : write ('Printer out of paper');
          160 : write ('Device write fault');
          161 : write ('Device read fault');
          162 : write ('Hardware failure');
     else
         write ('Input / Output error. Operation aborted...');
     end;
     while keypressed do
           carac := readkey;
     {endwhile}
     carac := readkey;
     while keypressed do
           carac := readkey;
     {endwhile}
     curseur_locate (1, 25);
     textattr := not textattr;
     clreol;
     curseur_locate (ox, oy);
end; { erreur }

function get_file_name (nom_fic : pathstr) : pathstr;
var
   s : searchrec;
   res,
   EXEName : PathStr;
   Dir : DirStr;
   Name : NameStr;
   Ext : ExtStr;
begin
     res := '';
     if (Lo (DosVersion) >= 3)
     then
         EXEName := ParamStr(0)
     else
         if (c_exe_name = '')
         then
             EXEName := FSearch(nom_fic, GetEnv('PATH'))
         else
             EXEName := FSearch(C_EXE_Name, GetEnv('PATH'));
         {endif}
     {endif}
     FSplit (EXEName, Dir, Name, Ext);
     if Dir[Length(Dir)] = '\'
     then
         Dec(Dir[0]);
     {endif}
     if (res = '')
     then
       begin
         findfirst (dir+'\'+nom_fic, anyfile-directory, s);
         if (doserror = 0)
         then
           res := dir+'\'+nom_fic;
         {endif}
       end;
     {endif}
     if (res = '')
     then
       res := FSearch(nom_fic, getenv ('PATH'));
     {endif}
     if (res = '')
     then
       res := nom_fic;
     {endif}
     Get_File_Name := res;
end; { get_file_name }

End. { Fin de l'unit‚ 'Sgf'. }
