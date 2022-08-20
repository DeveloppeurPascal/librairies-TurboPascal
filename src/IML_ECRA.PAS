unit iml_ecran;
{
Auteur: Patrick Pr‚martin.
Date: 23/01/1993.
Langage: Turbo Pascal 6.0
But: Morceau de l'Interface Multi-Langues (IML) de Olf Software.
}
interface
uses
    iml_var,
    iml_zone,
    iml_constante,
    iml_touche,
    iml_condition,
    iml_date,
    iml_time,
    iml_integer,
    iml_real,
    iml_string;

type
    p_lst_zone = ^t_lst_zone;
    t_lst_zone =
      record
        next : p_lst_zone;
        zone : p_zone;
      end;

    p_lst_constante = ^t_lst_constante;
    t_lst_constante =
      record
        next : p_lst_constante;
        constante : p_constante;
      end;

    p_lst_touche = ^t_lst_touche;
    t_lst_touche =
      record
        next : p_lst_touche;
        touche : p_touche;
      end;

    p_lst_constante_iml = ^t_lst_constante_iml;
    t_lst_constante_iml =
      record
        next : p_lst_constante_iml;
        constante : p_constante_iml;
      end;

    p_lst_touche_iml = ^t_lst_touche_iml;
    t_lst_touche_iml =
      record
        next : p_lst_touche_iml;
        touche : p_touche_iml;
      end;

    p_crn = ^o_crn;
    o_crn =
      object
        lst_touche : p_lst_touche;
        lst_touche_iml : p_lst_touche_iml;
        lst_constante : p_lst_constante;
        lst_constante_iml : p_lst_constante_iml;
        lst_zone : p_lst_zone;

        constructor init;
        destructor done;
        procedure save (var f : file); virtual;
        constructor load (var f : file);
        procedure setdata (var r); virtual;
        procedure getdata (var r); virtual;
        procedure display; virtual;
        procedure run (event : t_event); virtual;
      end;

implementation
constructor o_crn.init;
begin
  lst_touche := nil;
  lst_touche_iml := nil;
  lst_constante := nil;
  lst_constante_iml := nil;
  lst_zone := nil;
end; { init }

destructor o_crn.done;
begin
end; { done }

procedure o_crn.save (var f : file); virtual;
begin
end; { save }
  
constructor o_crn.load (var f : file);
begin
end; { load }

procedure o_crn.setdata (var r); virtual;
begin
end; { setdata }

procedure o_crn.getdata (var r); virtual;
begin
end; { getdata }

procedure o_crn.display; virtual;
begin
end; { display }

procedure o_crn.run (event : t_event); virtual;
begin
end; { run }

end.
