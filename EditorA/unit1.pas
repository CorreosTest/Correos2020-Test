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

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, db, Forms, Controls, Graphics,
  Dialogs, Menus, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    btBuscar: TButton;
    btResetBusqueda: TButton;
    BTTGuardar: TButton;
    btInserRegistro: TButton;
    cbMayusMin: TCheckBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    EdDato: TEdit;
    gbBuscar: TGroupBox;
    IBConnection1: TIBConnection;
    Label1: TLabel;
    LConsulRealizar: TLabel;
    miGuardCambios: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    miBorrarBDRecientes: TMenuItem;
    miBd1: TMenuItem;
    miBd2: TMenuItem;
    miBd3: TMenuItem;
    miBd4: TMenuItem;
    miBd5: TMenuItem;
    miRegistrarBDreciente: TMenuItem;
    miNuevaBase: TMenuItem;
    miAcerca: TMenuItem;
    miAyuda: TMenuItem;
    Posicion: TLabel;
    miGeneral: TMainMenu;
    miArchivo: TMenuItem;
    miRegistrarBase: TMenuItem;
    miSalir: TMenuItem;
    OpenDialog1: TOpenDialog;
    rgCampo: TRadioGroup;
    sdGuardarBase: TSaveDialog;
    SQLQuery1: TSQLQuery;
    sqlGenerador: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btBuscarClick(Sender: TObject);
    procedure btInserRegistroClick(Sender: TObject);
    procedure btResetBusquedaClick(Sender: TObject);
    procedure BTTGuardarClick(Sender: TObject);
    procedure CerrandoAplicacion(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure EdDatoKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure miArchivoClick(Sender: TObject);
    procedure miBd1Click(Sender: TObject);
    procedure miBd2Click(Sender: TObject);
    procedure miBd3Click(Sender: TObject);
    procedure miBd4Click(Sender: TObject);
    procedure miBd5Click(Sender: TObject);
    procedure miBorrarBDRecientesClick(Sender: TObject);
    procedure miGuardCambiosClick(Sender: TObject);
    procedure miRegistrarBaseClick(Sender: TObject);
    procedure miSalirClick(Sender: TObject);
    procedure miNuevaBaseClick(Sender: TObject);
    procedure miAcercaClick(Sender: TObject);
    procedure SQLQuery1AfterScroll(DataSet: TDataSet);

  private
    procedure GlobalException (sender: TObject; e: Exception);

  public

  end;

const
  Texto_menuReciente = 'EditorA-BdRecientes.txt';

var
  Form1: TForm1;

implementation
   uses intoregistro, fmAcerde; // Acdemos al formulario de insertar registro y ventana acerca

{$R *.lfm}

{ TForm1 }

procedure MostrarMenusOcultosMega;
var
  // Variable Tipo TStringList
  BDRecientes     : TStringList;
  // Variable tipo Texto para comprobar que txt del menu exite
  Total         : integer;
  ListaRecorrer : byte;
  DirConfig     : String;
  {$IFDEF LINUX}
    NombreApp    : String;
    LongitudDir  : Byte;
    DirUnix      : string;
  {$ENDIF}
begin
  {$IFDEF LINUX}
    NombreApp := ApplicationName;
    LongitudDir := length(NombreApp);
    DirUnix := GetAppConfigDir(false);
    LongitudDir := LongitudDir + 1;
    Delete(DirUnix,Length(DirUnix)-LongitudDir,LongitudDir+1);
    if not DirectoryExists(DirUnix) then
     if Not CreateDir(DirUnix) then
       showmessage ('No se pudo crear el directorio '+DirUnix);
   {$ENDIF}

  DirConfig := GetAppConfigDir(false);
  if not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
     showmessage ('No se pudo crear el directorio '+DirConfig);

  // Actualizar los menus
  // comprobamos que hay algo en el arhcivo de texto releyenod donde se guardaron los registros
  BDRecientes := TStringList.Create;
  if FileExists(DirConfig + Texto_menuReciente) then
   BDRecientes.LoadFromFile(DirConfig + Texto_menuReciente);

  Total := BDRecientes.Count;
  if Total >= 1 then
  begin
   form1.miRegistrarBDreciente.enabled := true;
   form1.miBorrarBDRecientes.Enabled := true;
   for ListaRecorrer := 0 to Total do
    begin
      case ListaRecorrer of
         1 : begin
              form1.miBd1.Visible := true;
              form1.miBd1.Caption := BDRecientes[0];
             end;
         2 : begin
              form1.miBd2.Visible := true;
              form1.miBd2.Caption := BDRecientes[1];
             end;
         3 : begin
              form1.miBd3.Visible := true;
              form1.miBd3.Caption := BDRecientes[2];
             end;
         4 : begin
              form1.miBd4.Visible := true;
              form1.miBd4.Caption := BDRecientes[3];
             end;
         5 : begin
              form1.miBd5.Visible := true;
              form1.miBd5.Caption := BDRecientes[4];
             end;
      end;
    end;
   end;
  BDRecientes.Free;
end;

procedure menuMeterBDReciente(BDReciente: string);
var
  // Variable Tipo TStringList
  BDRecientes  : TStringList;
  // Variable tipo Texto para comprobar que txt del menu exite
  PosicionRepe : integer;
  Total        : integer;
  DirConfig    : string;
  {$IFDEF UNIX}
    NombreApp    : String;
    LongitudDir  : Byte;
    DirUnix      : string;
  {$ENDIF}
begin
  {$IFDEF UNIX}
    NombreApp := ApplicationName;
    LongitudDir := length(NombreApp);
    DirUnix := GetAppConfigDir(false);
    LongitudDir := LongitudDir + 1;
    Delete(DirUnix,Length(DirUnix)-LongitudDir,LongitudDir+1);
    if not DirectoryExists(DirUnix) then
     if Not CreateDir(DirUnix) then
       showmessage ('No se pudo crear el directorio '+DirUnix);
   {$ENDIF}
  DirConfig := GetAppConfigDir(false);
  if not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
     showmessage ('No se pudo crear el directorio '+DirConfig);

  // Creamos la TStringList Para gestionar los links buenos
  BDRecientes := TStringList.Create;

  // Cargos el archivo de texto donde se guardan los links
  if FileExists(DirConfig + Texto_menuReciente) then
   begin
     BDRecientes.LoadFromFile(DirConfig + Texto_menuReciente);

     PosicionRepe := BDRecientes.IndexOf(BDReciente);
     Total := BDRecientes.Count;
     if PosicionRepe < 0 then
      begin
        BDRecientes.Insert (0,BDReciente);
      end
     else
      if Total > 1 then
       BDRecientes.Move(PosicionRepe,0);
   end
  else // Si no existe el archivo
    BDRecientes.Add(BDReciente);

  BDRecientes.SaveToFile(DirConfig + Texto_menuReciente);
    // Liberamos la memoria
  BDRecientes.Free;

  // llamamos a mostrar archivos
  MostrarMenusOcultosMega;
end; // Introduce datos en la lista para cargar en el menú

 procedure CargarBaseDeDatos(ruta:string);
begin
  form1.SQLQuery1.Close;
  form1.SQLQuery1.Close;

  form1.IBConnection1.Connected := false;

  form1.SQLTransaction1.Active := false;

  form1.IBConnection1.DatabaseName := ruta;
  form1.IBConnection1.UserName := 'SYSDBA';
  form1.IBConnection1.Password := 'masterkey';
  form1.IBConnection1.CharSet := 'UTF8';
  form1.IBConnection1.Dialect := 3;
  form1.IBConnection1.Connected := True;

  form1.SQLTransaction1.DataBase := form1.IBConnection1;
  form1.SQLTransaction1.Active := True;

  form1.SQLQuery1.DataBase := form1.IBConnection1;
  form1.SQLQuery1.SQL.text := 'SELECT r.ID_TEST, r.NOMBRE_TEST, r.TEMA, r.PREGUNTA, r.A, r.B, r.C, r.D, r.CORRECTA FROM TEST_INDIVIDUAL r';
  form1.SQLQuery1.Open();
  form1.SQLQuery1.Active := true;

  form1.Datasource1.DataSet := form1.SQLQuery1;
  form1.DBNavigator1.DataSource := form1.Datasource1;

  form1.DBGrid1.DataSource := form1.Datasource1;

  form1.BTTGuardar.Enabled := True;
  form1.miGuardCambios.Enabled  := True;
  form1.BtBuscar.enabled := True;
  form1.EdDato.enabled := True;
  form1.rgCampo.enabled := True;
  form1.btResetBusqueda.enabled := True;
  form1.btInserRegistro.Enabled := True;
  form1.cbMayusMin.Enabled := True;

  form1.sqlGenerador.DataBase := form1.IBConnection1;

  form1.sqlQuery1.refresh;

  if not(form1.BTTGuardar.Enabled) then
     ShowMessage('La Clave primaria no funciona para esta tabla. No se puede editar.');

  form1.Caption := 'Correos 2020 Test Editor test ['+ruta+']';

  // Guardamos el nombre de la base de datos
  menuMeterBDReciente(ruta);
end;

procedure TForm1.miRegistrarBaseClick(Sender: TObject);
begin
  if opendialog1.execute then
    CargarBaseDeDatos(opendialog1.FileName);
end;

procedure TForm1.miSalirClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.miNuevaBaseClick(Sender: TObject);
var
 Fire: TIBConnection;
 ATransaction : TSQLTransaction;
 generador : string;
begin
  if sdGuardarBase.execute then
    begin
       Fire:=TIBConnection.Create(nil);
       try
          Fire.HostName := ''; //cadena vacia por eser Firebird embebido; debe ser completado para cliente/server Firebird
          Fire.DatabaseName := sdGuardarBase.FileName; //(ruta y) nombre del fichero
          // El nombre de usuario y la contraseña no importan para la autenticación, pero obtienes autorizaciones en la base de datos
          // basado en el nombre (y opcionalmente el papel) que das.
          Fire.Username := 'SYSDBA';
          Fire.Password := 'masterkey'; // password por defecto para SYSDBA
          Fire.Charset := 'UTF8'; //Envía y recibe datos de cadena en codificación UTF8
          Fire.Dialect := 3; //Ya nadie usa 1 o 2.
          Fire.Params.Add('PAGE_SIZE=16384'); //Me gusta un tamaño de página grande (se usa al crear una base de datos). Útil para índices más grandes => tamaños de columna posibles más grandes

          // Busca si hay una base de datos en el directorio de la aplicación.
          // Si no es así, lo crea. Nota: esto puede fallar si no tiene suficientes permisos.

          // Si no es una base de datos embebida este código sobra
          if (FileExists(sdGuardarBase.FileName)=false) then
          begin
             showmessage('Base de datos '+sdGuardarBase.FileName+' embebida creada....');
              // Crear la base de datos, ya que no existe
           try
             Fire.CreateDB; // Crea el archivo de la base de datos
           except
             on E: Exception do
             begin
               showmessage ('ERROR creando la base de datos. Probablemente tenga problemas con la libreria embebida:' + #13 +
               '- no todos los archivos están presentes' +  #13 + '- Incorrecta arquitectua (ejemplo 32 bit en lugar de 64 bit' + #13 +
               'Mensaje excepcional:'+ #13 + E.ClassName+'/'+E.Message);
             end;
           end;
           // Creo las tablas
           ATransaction := TSQLTransaction.Create(Fire);
           Fire.Transaction := ATransaction;
           Fire.Open;
           ATransaction.StartTransaction;
           Fire.ExecuteDirect ('CREATE TABLE TEST_INDIVIDUAL (ID_TEST integer NOT NULL, NOMBRE_TEST varchar(255) NOT NULL);');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD TEMA integer NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD PREGUNTA varchar(500);');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD A varchar(500) NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD B varchar(500) NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD C varchar(500) NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL add D varchar(500) NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD CORRECTA char(1) NOT NULL;');
           Fire.ExecuteDirect ('ALTER TABLE TEST_INDIVIDUAL ADD CONSTRAINT INTEG_23 PRIMARY KEY (ID_TEST);');
           ATransaction.Commit;

           ATransaction.StartTransaction;
           Fire.ExecuteDirect ('CREATE SEQUENCE GEN_TEST_INDIVIDUAL_ID;');
           ATransaction.Commit;

           generador := 'CREATE TRIGGER TEST_INDIVIDUAL_BI FOR TEST_INDIVIDUAL ACTIVE ' +
                        'BEFORE insert POSITION 0 ' +
                        'AS DECLARE VARIABLE tmp DECIMAL(18,0); '+ #13 +
                        'BEGIN ' +  #13 +
                        ' IF (NEW.ID_TEST IS NULL) THEN ' + #13 +
                        '  NEW.ID_TEST = GEN_ID(GEN_TEST_INDIVIDUAL_ID, 1); ' +  #13 +
                        ' ELSE BEGIN ' + #13 +
                        '   tmp = GEN_ID(GEN_TEST_INDIVIDUAL_ID, 0); ' + #13 +
                        '   if (tmp < new.ID_TEST) then ' + #13 +
                        '      tmp = GEN_ID(GEN_TEST_INDIVIDUAL_ID, new.ID_TEST-tmp); ' + #13 +
                        '   END '+ #13 +
                        'END ;';

           ATransaction.StartTransaction;
           Fire.ExecuteDirect (generador);
           ATransaction.Commit;

           Fire.Close;
           ATransaction.Free;
           CargarBaseDeDatos (sdGuardarBase.FileName);
        end
          else showmessage ('Base de datos no creada ya existe una con el mismo nombre');
   finally
    Fire.Free;
   end;
 end;
end;

procedure TForm1.miAcercaClick(Sender: TObject);
begin
  fmAcerca.showmodal;
end;

procedure TForm1.SQLQuery1AfterScroll(DataSet: TDataSet);
begin
  Posicion.Caption:= IntToStr(SQLQuery1.RecNo) + ' de ' + IntToStr(SQLQuery1.RecordCount);
end;

procedure GuardarTodosLosCambios;
begin
  try
    if form1.SQLQuery1.State in [dsInsert, dsEdit] then
      form1.SQLQuery1.Post;
    if form1.SQLQuery1.Active then
      form1.SQLQuery1.ApplyUpdates;
    if form1.SQLTransaction1.Active then
      form1.SQLTransaction1.CommitRetaining;
  except
    on E: Exception do
    begin
      ShowMessage('No se pudieron guardar los datos por: ' + e.Message);
    end;
  end;
end;

procedure TForm1.BTTGuardarClick(Sender: TObject);
begin
  GuardarTodosLosCambios;
end;

procedure TForm1.CerrandoAplicacion(Sender: TObject;
  var CloseAction: TCloseAction);
var
 Salida, Ventana: Integer;
begin
  with application do begin
    Ventana := MB_ICONQUESTION + MB_YESNO;
    Salida := MessageBox ('¿Desea Salir?', 'Salir', Ventana);
    if Salida = IDYES then
     Application.terminate
    else
     CloseAction:= caNone;
  end;
end;

procedure TForm1.EdDatoKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
     begin
       key:=#0;
       SelectNext(ActiveControl,true, true);
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnException:= @GlobalException;
end;

procedure TForm1.miArchivoClick(Sender: TObject);
begin
  MostrarMenusOcultosMega
end;

procedure BorrarMenusUnidadAbiertos;
begin
  form1.miBd1.Visible := false;
  form1.miBd2.Visible := false;
  form1.miBd3.Visible := false;
  form1.miBd4.Visible := false;
  form1.miBd5.Visible := false;
end;

procedure BorrarNombresRegistradosOcultos (menuBorrar : string);
var
// Variable Tipo TStringList
  BDRecientes     : TStringList;
  PosicionRepe    : Integer;
  Total           : Integer;
  DirConfig       : String;
begin
  DirConfig := GetAppConfigDir(false);
  if not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
     showmessage ('No se pudo crear el directorio '+DirConfig);

  // Borrar un registro del txt de importados
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + Texto_menuReciente) then
   begin
    BDRecientes := TStringList.Create;
    BDRecientes.LoadFromFile(DirConfig + Texto_menuReciente);
    PosicionRepe := BDRecientes.IndexOf(menuBorrar);

    if PosicionRepe > -1 then
     BDRecientes.Delete(PosicionRepe);

    Total := BDREcientes.Count;

    if Total = 0 then
     begin
      form1.miBorrarBDRecientes.enabled := false;
      form1.miRegistrarBDreciente.enabled := false;
     end;

    BDRecientes.SaveToFile(DirConfig + Texto_menuReciente);
    BDRecientes.Free;

    showmessage('No Existe el archivo '+menuBorrar);

   end;
end;
procedure TForm1.miBd1Click(Sender: TObject);
begin
  // Menu 1 oculto
  if FileExists(miBd1.Caption) then
   CargarBaseDeDatos(miBd1.Caption)
  else
     begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresRegistradosOcultos(miBd1.Caption);
     end;

end;

procedure TForm1.miBd2Click(Sender: TObject);
begin
  // Menu 2 oculto
  if FileExists(miBd2.Caption) then
   CargarBaseDeDatos(miBd2.Caption)
  else
     begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresRegistradosOcultos(miBd2.Caption);
     end;
end;

procedure TForm1.miBd3Click(Sender: TObject);
begin
  // Menu 3 oculto
  if FileExists(miBd3.Caption) then
   CargarBaseDeDatos(miBd3.Caption)
  else
     begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresRegistradosOcultos(miBd3.Caption);
     end;
end;

procedure TForm1.miBd4Click(Sender: TObject);
begin
  // Menu 4 oculto
  if FileExists(miBd4.Caption) then
   CargarBaseDeDatos(miBd4.Caption)
  else
     begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresRegistradosOcultos(miBd4.Caption);
     end;
end;

procedure TForm1.miBd5Click(Sender: TObject);
begin
  // Menu 5 oculto
  if FileExists(miBd5.Caption) then
   CargarBaseDeDatos(miBd5.Caption)
  else
     begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresRegistradosOcultos(miBd5.Caption);
     end;
end;

procedure TForm1.miBorrarBDRecientesClick(Sender: TObject);
var
// Variable Tipo TStringList
  BDRecientes     : TStringList;
  DirConfig       : String;
  {$IFDEF UNIX}
    NombreApp    : String;
    LongitudDir  : Byte;
    DirUnix      : string;
  {$ENDIF}
begin
  {$IFDEF UNIX}
    NombreApp := ApplicationName;
    LongitudDir := length(NombreApp);
    DirUnix := GetAppConfigDir(false);
    LongitudDir := LongitudDir + 1;
    Delete(DirUnix,Length(DirUnix)-LongitudDir,LongitudDir+1);
    if not DirectoryExists(DirUnix) then
     if Not CreateDir(DirUnix) then
       showmessage ('No se pudo crear el directorio '+DirUnix);
   {$ENDIF}

  DirConfig := GetAppConfigDir(false);
  if not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
     showmessage ('No se pudo crear el directorio '+DirConfig);

  // Borrar historial
  // Creamos la TStringList Para gestionar los links buenos
  if FileExists(DirConfig + Texto_menuReciente) then
   begin
    BDRecientes := TStringList.Create;
    BDRecientes.LoadFromFile(DirConfig + Texto_menuReciente);
    BDRecientes.clear;
    BDRecientes.SaveToFile(DirConfig + Texto_menuReciente);
    BDRecientes.Free;
    form1.miBorrarBDRecientes.Enabled := false;
    form1.miRegistrarBDreciente.Enabled := false;

    BorrarMenusUnidadAbiertos;
   end;
end;

procedure TForm1.miGuardCambiosClick(Sender: TObject);
begin
  GuardarTodosLosCambios
end;

procedure TForm1.GlobalException(Sender: TObject; E : Exception);
begin
  MessageDlg('Excepción', 'Nombre de la excepción técnica: '+ #13 +
  e.Message, mtError, [mbOk], 0);
end;

procedure TForm1.btBuscarClick(Sender: TObject);
var
 NomColl : string;
 entero,error : integer;
begin
  with SQLQuery1 do
  begin
     Close;

     Val(edDato.Text,entero,error) ; // Comprobar integer cadena en tema

     if cbMayusMin.Checked = true then
       NomColl := 'CONTAINING '+ #39 + edDato.Text + #39
     else
       NomColl := 'LIKE '+ #39 + '%'+ edDato.Text + '%'+ #39;

     case rgCampo.ItemIndex of
      -1: showmessage ('Selecciona un campo a buscar');
       0: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE NOMBRE_TEST ' + NomColl ;
       1: if error = 0 then SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE TEMA ' + NomColl else showmessage ('Introduzca un número entero');
       2: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE PREGUNTA ' + NomColl;
       3: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE A ' + NomColl;
       4: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE B ' + NomColl;
       5: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE C ' + NomColl;
       6: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE D ' + NomColl;
       7: SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE ID_TEST ' + NomColl;
     end;

     Open;
   end;
end;

procedure TForm1.btInserRegistroClick(Sender: TObject);
begin
  GuardarTodosLosCambios;
  fmIntroRegistros.showmodal;
end;

procedure TForm1.btResetBusquedaClick(Sender: TObject);
begin
  SQLQuery1.close;
  SQLQuery1.SQL.Text := 'SELECT r.ID_TEST, r.NOMBRE_TEST, r.TEMA, r.PREGUNTA, r.A, r.B, r.C, r.D, r.CORRECTA FROM TEST_INDIVIDUAL r';
  SQLQuery1.Open;
end;

end.

