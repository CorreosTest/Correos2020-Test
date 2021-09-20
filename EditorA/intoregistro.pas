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

unit intoregistro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBCtrls, StdCtrls,
  db, sqldb;

type

  { TfmIntroRegistros }

  TfmIntroRegistros = class(TForm)
    btInsertar: TButton;
    btCancelar: TButton;
    btBorrarCasillas: TButton;
    BtBorrarRetornoCarro: TButton;
    cbID_TESTauto: TCheckBox;
    cbMantDialog: TCheckBox;
    cmbCorrecta: TComboBox;
    eA: TEdit;
    eB: TEdit;
    eC: TEdit;
    eD: TEdit;
    eID_TEST: TEdit;
    eNOMBRE_TEST: TEdit;
    ePREGUNTA: TEdit;
    eTEMA: TEdit;
    gbRegistros: TGroupBox;
    ID_TEST: TLabel;
    lA: TLabel;
    lB: TLabel;
    lC: TLabel;
    lCorrecta: TLabel;
    lD: TLabel;
    lNomTest: TLabel;
    lPregunta: TLabel;
    lTema: TLabel;
    procedure btBorrarCasillasClick(Sender: TObject);
    procedure BtBorrarRetornoCarroClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btInsertarClick(Sender: TObject);
    procedure cbID_TESTautoChange(Sender: TObject);
    procedure eAKeyPress(Sender: TObject; var Key: char);
    procedure eBKeyPress(Sender: TObject; var Key: char);
    procedure eCKeyPress(Sender: TObject; var Key: char);
    procedure eDChange(Sender: TObject);
    procedure eDKeyPress(Sender: TObject; var Key: char);
    procedure eID_TESTKeyPress(Sender: TObject; var Key: char);
    procedure eNOMBRE_TESTKeyPress(Sender: TObject; var Key: char);
    procedure ePREGUNTAChange(Sender: TObject);
    procedure ePREGUNTAKeyPress(Sender: TObject; var Key: char);
    procedure eTEMAKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

  private

  public

  end;

var
  fmIntroRegistros: TfmIntroRegistros;

implementation
   uses unit1;
{$R *.lfm}

{ TfmIntroRegistros }

procedure GeneradorBDNuevo;
var
  suma_valor_actual_mas_uno : integer;
begin
  { Cogemos el siguiente valor para la primary key }
  with form1.sqlGenerador do
  begin
     SQL.text := 'SELECT GEN_ID( GEN_TEST_INDIVIDUAL_ID, 0 ) FROM RDB$DATABASE';
     Open();
     Active := true;
     suma_valor_actual_mas_uno := FieldByName('GEN_ID').AsInteger + 1;
     fmIntroRegistros.eID_TEST.text := IntToStr(suma_valor_actual_mas_uno);
  end;
end;

procedure TfmIntroRegistros.btCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TfmIntroRegistros.btBorrarCasillasClick(Sender: TObject);
begin
  ePregunta.Text := ('');
  eA.Text := ('');
  eB.Text := ('');
  eC.Text := ('');
  eD.Text := ('');
end;

procedure EliminarRetornoCarro(var C: string);
var
  i       : integer;
  Espacio : string[1];
begin
  i:=pos(chr(10),C);
  if i = 0 then Exit;
  Espacio := ' ';
  Delete(C,i,1);
  Insert (Espacio,C,i);
  EliminarRetornoCarro(C);
end;

procedure TfmIntroRegistros.BtBorrarRetornoCarroClick(Sender: TObject);
var
  Cadena : string;
begin
  Cadena := eNombre_Test.Text;
  EliminarRetornoCarro(Cadena);
  eNombre_Test.Text := (Cadena);

  Cadena := ePregunta.Text;
  EliminarRetornoCarro(Cadena);
  ePregunta.Text := (Cadena);

  Cadena := eA.Text;
  EliminarRetornoCarro(Cadena);
  eA.Text := (Cadena);

  Cadena := eB.Text;
  EliminarRetornoCarro(Cadena);
  eB.Text := (Cadena);

  Cadena := eC.Text;
  EliminarRetornoCarro(Cadena);
  Ec.Text := (Cadena);

  Cadena := eD.Text;
  EliminarRetornoCarro(Cadena);
  eD.Text := (Cadena);
end;

procedure TfmIntroRegistros.btInsertarClick(Sender: TObject);
var
  Query         : TSQLQuery;
  error,entero  : integer;
  //Trans : TSQLTransaction;
begin
  { Salir sin registrar nada y del procedimiento si ... }
  if (eID_Test.text = ('')) or (eNombre_Test.Text = ('')) or (eTema.text = ('')) or
     (ePregunta.Text = ('')) or (eA.Text = ('')) or (eB.Text = ('')) or
     (eC.Text = ('')) or (eD.Text = ('')) then
     begin
        showmessage ('Faltan campos por rellenar, comprueba que todos los campos esten rellenos');
        exit;
     end; { Salir sin registrar nada y del procedimiento si ... }

  { Comprobar si es un número entero el valor del ID_Test }
  Val(eID_Test.Text,entero,error);
  if error <> 0 then
     begin
       showmessage ('Introduzca un número entero en la casilla ID_Test.');
       exit;
     end; { Comprobar si es un número entero el valor del ID_Test }

  { Comprobar si es un número entero el valor del tema }
  Val(eTema.Text,entero,error) ; // Comprobar integer cadena en tema
  if error <> 0 then
  begin
    showmessage ('Introduzca un número entero en la casilla del Tema.');
    exit;
  end; { Comprobar si es un número entero el valor del tema }

  { Comprobar longitud de la cadena a introducire en Nombre_Test.text }
  if Length(eNombre_Test.text) > 255 then
  begin
    showmessage ('El texto introducido en Nombre_Test supera los 255 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en Nombre_Test.text }

  { Comprobar longitud de la cadena a introducire en Pregunta }
  if (Length(ePregunta.Text) > 500) then
  begin
    showmessage ('El texto introducido en Pregunta supera los 500 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en Pregunta }

  { Comprobar longitud de la cadena a introducire en eA }
  if (Length(eA.Text) > 500) then
  begin
    showmessage ('El texto introducido en A) supera los 500 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en eA }

  { Comprobar longitud de la cadena a introducire en eB }
  if (Length(eB.Text) > 500) then
  begin
    showmessage ('El texto introducido en B) supera los 500 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en eB }

  { Comprobar longitud de la cadena a introducire en eC }
  if (Length(eC.Text) > 500) then
  begin
    showmessage ('El texto introducido en C) supera los 500 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en eC }

  { Comprobar longitud de la cadena a introducire en eD }
  if (Length(eD.Text) > 500) then
  begin
    showmessage ('El texto introducido en D) supera los 500 carácteres tiene que reducirlo');
    exit;
  end; { Comprobar longitud de la cadena a introducire en eD }

  if cbMantDialog.Checked = True then
    begin
    {codigo para insertar}
      //Trans := TSQLTransaction.Create(form1.IBConnection1);
      Query := TSQLQuery.Create(nil);
      try
        Query.Database := form1.IBConnection1;

        Query.SQL.Text := 'insert into TEST_INDIVIDUAL (ID_TEST,NOMBRE_TEST,TEMA,PREGUNTA,A,B,C,D,CORRECTA) values(:ID_TEST,:NOMBRE_TEST,:TEMA,:PREGUNTA,:A,:B,:C,:D,:CORRECTA);';
        Query.Prepare;

        Query.Params.ParamByName('ID_TEST').AsInteger := StrToInt(eID_TEST.Text);
        Query.Params.ParamByName('NOMBRE_TEST').AsString := eNOMBRE_TEST.Text;
        Query.Params.ParamByName('TEMA').AsInteger := StrToInt(eTEMA.Text);
        Query.Params.ParamByName('PREGUNTA').AsString := ePREGUNTA.Text;
        Query.Params.ParamByName('A').AsString := eA.Text;
        Query.Params.ParamByName('B').AsString := eB.Text;
        Query.Params.ParamByName('C').AsString := eC.Text;
        Query.Params.ParamByname('D').AsString := eD.Text;
        Query.Params.ParamByname('CORRECTA').AsString := cmbCorrecta.Text;

        Query.ExecSQL;

        if form1.SQLQuery1.State in [dsInsert, dsEdit] then
           form1.SQLQuery1.Post;
        if form1.SQLQuery1.Active then
           form1.SQLQuery1.ApplyUpdates;
        if form1.SQLTransaction1.Active then
           form1.SQLTransaction1.CommitRetaining;

        eID_TEST.Text := FloatToStr(StrToFloat(eID_TEST.Text) + 1);

        form1.SQLQuery1.refresh;
        form1.SQLQuery1.Last;
      finally
        Query.Free;
      end;
    end
  else { Si solo es par un solo registro entonces... }
    begin
    {codigo para insertar y cerrar el dialogo}
     Query := TSQLQuery.Create(nil);
      try
        Query.Database := form1.IBConnection1;

        Query.SQL.Text := 'insert into TEST_INDIVIDUAL (ID_TEST,NOMBRE_TEST,TEMA,PREGUNTA,A,B,C,D,CORRECTA) values(:ID_TEST,:NOMBRE_TEST,:TEMA,:PREGUNTA,:A,:B,:C,:D,:CORRECTA);';
        Query.Prepare;

        Query.Params.ParamByName('ID_TEST').AsInteger := StrToInt(eID_TEST.Text);
        Query.Params.ParamByName('NOMBRE_TEST').AsString := eNOMBRE_TEST.Text;
        Query.Params.ParamByName('TEMA').AsInteger := StrToInt(eTEMA.Text);
        Query.Params.ParamByName('PREGUNTA').AsString := ePREGUNTA.Text;
        Query.Params.ParamByName('A').AsString := eA.Text;
        Query.Params.ParamByName('B').AsString := eB.Text;
        Query.Params.ParamByName('C').AsString := eC.Text;
        Query.Params.ParamByname('D').AsString := eD.Text;
        Query.Params.ParamByname('CORRECTA').AsString := cmbCorrecta.Text;

        Query.ExecSQL;

        if form1.SQLQuery1.State in [dsInsert, dsEdit] then
           form1.SQLQuery1.Post;
        if form1.SQLQuery1.Active then
           form1.SQLQuery1.ApplyUpdates;
        if form1.SQLTransaction1.Active then
           form1.SQLTransaction1.CommitRetaining;
        form1.SQLQuery1.refresh;
        form1.SQLQuery1.Last;
      finally
        Query.Free;

      close;
      end;
    end;
end;
procedure TfmIntroRegistros.cbID_TESTautoChange(Sender: TObject);
begin
  if cbID_TESTauto.Checked = True then
    eID_TEST.Enabled := False
  else
    eID_TEST.Enabled := True;
end;

procedure TfmIntroRegistros.eAKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eBKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eCKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eDChange(Sender: TObject);
begin

end;

procedure TfmIntroRegistros.eDKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eID_TESTKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eNOMBRE_TESTKeyPress(Sender: TObject; var Key: char
  );
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.ePREGUNTAChange(Sender: TObject);
begin

end;

procedure TfmIntroRegistros.ePREGUNTAKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.eTEMAKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TfmIntroRegistros.FormActivate(Sender: TObject);
begin
  GeneradorBDNuevo;
end;

procedure TfmIntroRegistros.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  with form1.sqlGenerador do
  begin
     close();
  end;

end;

end.

