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
  Forms, Unit1, intoregistro, fmAcerde, translations;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Editor-A-Correos2020-Test';
  Application.Scaled:=True;
  {$IFDEF WINDOWS}
    TranslateUnitResourceStrings('LCLStrConsts', 'lclstrconsts.%s.po','es','');
  {$ENDIF}
  {$IFDEF UNIX}
    TranslateUnitResourceStrings('LCLStrConsts', '/usr/share/locale/es/LC_MESSAGES/lclstrconsts.%s.po','es','');
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmIntroRegistros, fmIntroRegistros);
  Application.CreateForm(TfmAcerca, fmAcerca);
  Application.Run;
end.

