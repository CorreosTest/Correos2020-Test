(********************************************************)
(*                                                      *)
(*  Correos2020-Test                                    *)
(*                                                      *)
(*  Correos2020-Test <reenbeet78@protonmail.com>        *)
(*                                                      *)
(*  Publicado bajo la licencia copyleft                 *)
(*                                                      *)
(*  Última modificación Septiembre 2021                 *)
(*                                                      *)
(********************************************************)

program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2, uAcercaDe, translations
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Correos2020-Test';
  Application.Scaled:=True;
  {$IFDEF WINDOWS}
    TranslateUnitResourceStrings('LCLStrConsts', 'lclstrconsts.%s.po','es','');
  {$ENDIF}
  {$IFDEF UNIX}
    TranslateUnitResourceStrings('LCLStrConsts', '/usr/share/locale/es/LC_MESSAGES/lclstrconsts.%s.po','es','');
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmAcercaDe, fmAcercaDe);
  Application.Run;
end.

