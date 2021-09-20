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
unit fmAcerde;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLIntf;
  { LCLIntf para lazar url en el programa }
type

  { TfmAcerca }

  TfmAcerca = class(TForm)
    btSalir: TButton;
    btAcerca: TButton;
    ImAcerca: TImage;
    lMailto: TLabel;
    lTexto: TLabel;
    procedure btAcercaClick(Sender: TObject);
    procedure btSalirClick(Sender: TObject);
    procedure lMailtoClick(Sender: TObject);
    procedure lMailtoMouseEnter(Sender: TObject);
    procedure lMailtoMouseLeave(Sender: TObject);

  private

  public

  end;

var
  fmAcerca: TfmAcerca;

implementation
  uses unit1;
{$R *.lfm}

{ TfmAcerca }

procedure TfmAcerca.btSalirClick(Sender: TObject);
begin
  close;
end; { Boton salir }

procedure TfmAcerca.btAcercaClick(Sender: TObject);
var
  ruta : string;
begin
  {$IFDEF WINDOWS}
    ruta := GetCurrentDir;
  {$ENDIF}

  {$IFDEF UNIX}
    ruta := '/usr/share/doc/Correos2020-Test';
  {$ENDIF}
  OpenUrl('file://'+ruta+'/doc_correos2020-test.pdf');
end;

procedure TfmAcerca.lMailtoClick(Sender: TObject);
begin
  OpenURL('mailto:reenbeet78@protonmail.com?subject=:::Programa Correos2020-Test:::');
end; { Etiqueta del email }

procedure TfmAcerca.lMailtoMouseEnter(Sender: TObject);
begin
  lMailto.Cursor:=crHandPoint; // Pone cursor manita
  lMailto.Font.Color := clRed;
  lMailto.Font.Underline := true;
end; { Raton sobre etiqueta del email }

procedure TfmAcerca.lMailtoMouseLeave(Sender: TObject);
begin
  lMailto.Cursor:=clDefault;
  lMailto.Font.Color := clOlive;
  lMailto.Font.Underline := false;
end; { Se pierde el foco sobre la etiqueta del email }


end.

