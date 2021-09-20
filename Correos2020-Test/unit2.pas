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
unit Unit2;

{$mode objfpc}{$H+}

interface


 uses
  Classes, SysUtils, IBConnection, sqldb, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, Buttons, LCLType, Menus, ExtCtrls,Process, Types;
  // LCLType = Messagebox, Inputobox
  // Process = TProcess lanza app
  // Eliminada Fileutil, ahora se copia a "mano"
type
  Cadena255 = string[255];
  TestHecho = record
     NombreTest        : cadena255;
     Fecha             : string[19];
     Tiempo            : string[8];
     Aciertos          : integer;
     Fallos            : integer;
     TantoXciento      : integer;
     Interruptor       : boolean;
  end;

  Fichero = file of TestHecho;

  { TForm2 }

  TForm2 = class(TForm)
    btBuscar: TButton;
    CheckBox1: TCheckBox;
    cbCaseSensitive: TCheckBox;
    ComboBox1: TComboBox;
    eBuscarListbox: TEdit;
    IBConnection1: TIBConnection;
    Label1: TLabel;
    Label2: TLabel;
    Form2: TLabel;
    lNTestElegidos: TLabel;
    lNombre: TLabel;
    lNombreTest: TLabel;
    lNumTestDispo: TLabel;
    lTiempo: TLabel;
    lFecha: TLabel;
    lTiempoTranscurrido: TLabel;
    lFechaHora: TLabel;
    lAciertosFallosPorcentaje: TLabel;
    lBuscarPorCadena: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    miABrirBD: TMenuItem;
    miImportarBDReciente: TMenuItem;
    miBorrarBDImpotadsRecientes: TMenuItem;
    miBDI1: TMenuItem;
    miBDI2: TMenuItem;
    miBDI3: TMenuItem;
    miBDI4: TMenuItem;
    miBDI5: TMenuItem;
    miBorradBDAbiertas: TMenuItem;
    miAbridBDRecientes: TMenuItem;
    miBDA1: TMenuItem;
    miBDA2: TMenuItem;
    miBDA3: TMenuItem;
    miBDA4: TMenuItem;
    miBDA5: TMenuItem;
    miImportarBD: TMenuItem;
    miBd5: TMenuItem;
    miBd4: TMenuItem;
    miBd3: TMenuItem;
    miBd2: TMenuItem;
    miBd1: TMenuItem;
    N1: TMenuItem;
    miMEGAReciente: TMenuItem;
    MiBorrarHistorialMega: TMenuItem;
    miMEGANuevo: TMenuItem;
    miMEGA: TMenuItem;
    miAcercaDe: TMenuItem;
    miAyuda: TMenuItem;
    miArchivo: TMenuItem;
    miAbrirBaseDeDatos: TMenuItem;
    miSalir: TMenuItem;
    miBarra: TMenuItem;
    miImportar: TMenuItem;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btBuscarClick(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure eBuscarListboxKeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ListBox1KeyPress(Sender: TObject; var Key: char);
    procedure MenuItem1Click(Sender: TObject);
    procedure miABrirBDClick(Sender: TObject);
    procedure miBd1Click(Sender: TObject);
    procedure miBd2Click(Sender: TObject);
    procedure miBd3Click(Sender: TObject);
    procedure miBd4Click(Sender: TObject);
    procedure miBd5Click(Sender: TObject);
    procedure miBDA1Click(Sender: TObject);
    procedure miBDA2Click(Sender: TObject);
    procedure miBDA3Click(Sender: TObject);
    procedure miBDA4Click(Sender: TObject);
    procedure miBDA5Click(Sender: TObject);
    procedure miAbrirBaseDeDatosClick(Sender: TObject);
    procedure miAcercaDeClick(Sender: TObject);
    procedure miBDI1Click(Sender: TObject);
    procedure miBDI2Click(Sender: TObject);
    procedure miBDI3Click(Sender: TObject);
    procedure miBDI4Click(Sender: TObject);
    procedure miBDI5Click(Sender: TObject);
    procedure miBorradBDAbiertasClick(Sender: TObject);
    procedure miBorrarBDImpotadsRecientesClick(Sender: TObject);
    procedure MiBorrarHistorialMegaClick(Sender: TObject);
    procedure miImportarBDClick(Sender: TObject);
    procedure miImportarClick(Sender: TObject);
    procedure miMEGAClick(Sender: TObject);
    procedure miMEGANuevoClick(Sender: TObject);
    procedure miSalirClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);

  private

  public
     { variable para todos los formularios }
   Numero : String;  // Numero total de Test
   TodosLosTest :Boolean;
   Random : Boolean; // Cargar aleatoriamente el test
   BaseDeDatos : String; // ruta-nombre de la base de datos
end;

Const
  Abierto_menuReciente = 'Abierto_Menu_Reciente.txt';
  Importado_menuReciente = 'Importado_menu_Reciente.txt';
  mega_menuReciente = 'Mega_menu_reciente.txt';
  LogMegaTXT = 'Log-megadl.txt';
  ArchivoExiste = 'ERROR: File already exists at';
  LinkIncorrecto = 'WARNING: Skipping invalid Mega download link:';
  mega_borrado_servidor = 'ENOENT';

var
  Form2: TForm2;
  { Variable archivo }
  Archivo : Fichero;
  Existe : boolean; // Para saber si existe un registro y tacharlo en la lista

 implementation  // Para acceder al formulario 2
   uses
      Unit1, uAcercaDe;
{$R *.lfm}


{ TForm2 }

procedure borrarEtiquetasRealizados;
begin
  Form2.lfecha.caption := ('');
  Form2.lAciertosFallosPorcentaje.caption := ('');
  Form2.lFechaHora.caption := ('');
  Form2.lTiempoTranscurrido.caption := ('');
  Form2.lTiempo.caption := ('');
  Form2.lNombre.caption := ('');
  Form2.lNombreTest.caption := ('');
  Form2.label4.Caption := ('');
end;

procedure CargarBase(ruta:string);
Const
  // Selecciona solo un item
  SQLSoloTemas = 'select distinct TEMA from test_individual ';
begin
  Form2.SQLQuery1.Close;
  Form2.IBConnection1.Connected := false;
  Form2.SQLTransaction1.Active := false;

  Form2.BaseDeDatos := ruta;

  try
   Form2.IBConnection1.DatabaseName := Form2.BaseDeDatos;
   Form2.IBConnection1.UserName := 'SYSDBA';
   Form2.IBConnection1.Password := 'masterkey';
   Form2.IBConnection1.CharSet := 'UTF8';
   Form2.IBConnection1.Dialect := 3;
   Form2.IBConnection1.Connected := True;
   Form2.SQLTransaction1.DataBase := Form2.IBConnection1;
   Form2.SQLTransaction1.Active := True;
   Form2.SQLQuery1.DataBase := Form2.IBConnection1;
   Form2.SQLQuery1.SQL.text := SQLSoloTemas;
   Form2.SQLQuery1.Open();
   Form2.SQLQuery1.Active := true;
   Form2.SQLQuery1.Refresh;

   Form2.ListBox1.Clear;
   Form2.ComboBox1.Items.Clear;
   Form2.ComboBox1.Text := 'Elija el tema';
   Form2.lNumTestDispo.caption := (''); // Borra la etiqueta con el número de test
   Form2.ComboBox1.Items.Add('Todos los Test');
   while (not Form2.SQLQuery1.EOF) do
    begin
     Form2.ComboBox1.Items.Add ('Tema: ' + Form2.SQLQuery1.FieldByName('TEMA').AsString); // Escogidos solo los temas añadelos a los items
     Form2.SQLQuery1.Next;
    end;
   Form2.SQLQuery1.Close;
   Form2.Caption := 'Correos2020-Test [' + ruta + ']';
   except
     on E: Exception do
       begin
         showmessage ('ERROR NO HAY BASE DE DATOS, DETALLES TÉCNICOS: '+ #13 + E.ClassName+'/'+E.Message);
       end;
   end;
   { Borrar etiquetas en el arranque }
   borrarEtiquetasRealizados;
end; { cargar base }

procedure TestRealizadosArranque;
var
 Resultado : integer;
 DirConfig : string;
begin
   DirConfig := GetAppConfigDir(false);
   System.Assign (Archivo, DirConfig + 'Testhechos.dat');
   {$I-}
   System.Reset (Archivo);
   Resultado := System.IOresult;
   {$I+}
   if Resultado <> 0 then
      System.Rewrite (Archivo);
   System.Close (Archivo)
end;

function Posicion (C: Cadena255; var F: Fichero) : integer;
var
  Registro : TestHecho;
  Hallado : boolean;
begin
  Hallado := false;
  System.Seek (F,0);
  while not System.Eof(F) and not Hallado do
   begin
     System.Read (F,Registro);
     Hallado := Registro.NombreTest = C;
   end;
   if Hallado then
     Posicion := System.FilePos(F) -1
   else
     Posicion := -1;
end; // Posición

procedure Ver (T: TestHecho);
begin
  with T do
   if T.Interruptor then
     begin
      Form2.lNombre.caption :=('Nombre del Test: ');
      Form2.lNombreTest.caption := (NombreTest);
      Form2.lFecha.Caption := ('Test realizado con Fecha/Hora: ');
      Form2.lFechaHora.Caption := (Fecha);
      Form2.lTiempo.caption := ('En un tiempo de: ');
      Form2.lAciertosFallosPorcentaje.Caption := ('Aciertos: '+IntToStr(Aciertos)+' / Fallos: '+IntToStr(Fallos)+' / Porcentaje de Aciertos: '+IntToStr(TantoXciento)+' %')+' / Nota: '+FloatToStr(TantoXCiento / 10);
      Form2.lTiempoTranscurrido.caption := (Tiempo);
     end;
end; // Ver

procedure Consultar (var F: Fichero; NTest: string);
var
 T : TestHecho;
 C : Cadena255;
 I : integer;
begin
  System.Reset (F);
  C := NTest;
  I := Posicion (C,F);
  if I = -1 then
   begin
     borrarEtiquetasRealizados;
   end
    else
     begin
      System.Seek (F, I);
      System.Read (F, T);
      if T.Interruptor then
       begin
         if Form2.listbox1.SelCount = 1 then
            Ver (T);
         if Form2.listbox1.SelCount = 0 then
            Existe := true;
       end
        else
          begin
            showmessage ('El registro fue dado de baja.');
          end;
     end;
  System.Close (F);
end; // Consultar

procedure resolviendo;
begin
  { Resuelve la selección }

  if Form2.CheckBox1.checked = true then
    Form2.Random := true
  else
    Form2.Random := false;

  if Form2.listBox1.Selcount > 0 then
   begin
     form1.IniciarCronometro := True;
     form1.showmodal;
   end;

end;

function listaAlista(sqlFinal : string): string;
begin
  form2.SQLQuery1.SQL.Text := sqlFinal;
  form2.SQLQuery1.open();
  listaAlista := form2.SQLQuery1.FieldByName('TOTAL').AsString;
  form2.SQLQuery1.close();
end;

procedure TForm2.ListBox1Click(Sender: TObject);
Const
  SQLUnSoloItem = 'SELECT COUNT(NOMBRE_TEST) AS TOTAL FROM TEST_INDIVIDUAL WHERE NOMBRE_TEST=';
var
  c,d,posicion,CuentaParcial : integer;
  SQLfinal, CadenasElegidas  : string;
begin
  { Borrar sqlFinal }
  sqlFinal := '';
  { Iniciar contador d}
  d := 0;
  //Refrescamos la listbox, por "dibujar en ella"
  listBox1.Refresh;
  {Cuando se cliquea mas de un item en la Listbox}
  if listBox1.Selcount > 1 then
    for c:= 0 to ListBox1.Items.Count - 1 do // Iterar por todos los items
     begin
      if ListBox1.Selected[c] then  // Si es seleccioando
       begin
         d := d +1;
         CadenasElegidas :=  ListBox1.Items.Strings[c];
         if TodosLosTest = True then
           begin
              posicion := pos(':',CadenasElegidas); //nos dice la posicion de los dos puntos
              if posicion = 7 then
                Delete(CadenasElegidas,1,8);
              if posicion = 8 then
                Delete(CadenasElegidas,1,9);
           end;

         // Si hay varios items elegidos en la lista procede a contar
         if sqlFinal = '' then  // primer item
           begin
             sqlFinal := SQLUnSoloItem + #39 + CadenasElegidas + #39;
             CuentaParcial := StrToInt(listaAlista(sqlFinal));
           end
         else if  d < Listbox1.SelCount then  // item intermedio
           begin
             sqlFinal := SQLUnSoloItem + #39 + CadenasElegidas + #39;
             CuentaParcial := CuentaParcial + StrToInt(listaAlista(sqlFinal));
           end
         else if d = Listbox1.SelCount then  // Item final
           begin
             sqlFinal := SQLUnSoloItem + #39 + CadenasElegidas + #39;
             CuentaParcial := CuentaParcial + StrToInt(listaAlista(sqlFinal));
             sqlFinal := '';
             Numero := IntToStr(CuentaParcial);
           end;

       end;
     end;

  // Un solo item
  if listBox1.Selcount = 1 then
    for c:= ListBox1.Items.Count - 1 downto 0 do
      if ListBox1.Selected[c] then
       begin
        CadenasElegidas := ListBox1.Items.Strings[c];
        if TodosLosTest = True then
         begin
          posicion := pos(':',CadenasElegidas); //nos dice la posicion de los dos puntos
          if posicion = 7 then
            Delete(CadenasElegidas,1,8);
          if posicion = 8 then
            Delete(CadenasElegidas,1,9);
         end;

          sqlFinal := SQLUnSoloItem + #39 + CadenasElegidas + #39;
          SQLQuery1.SQL.Text := sqlFinal;
          SQLQuery1.open();
          Numero := SQLQuery1.FieldByName('TOTAL').AsString; { Esta variable se pasa al formulario de test form1 }
          SQLQuery1.Close();
          { Consultar fallos de un solo test }
          Consultar(Archivo,CadenasElegidas);
        end;

    { Anota el número de Test de un Nombre del Test }
   //SQLQuery1.SQL.Text := 'SELECT COUNT(NOMBRE_TEST) FROM TEST_INDIVIDUAL WHERE NOMBRE_TEST='+chr(39)+valor+chr(39);
   //showmessage (sqlFinal);
   if listBox1.Selcount > 0 then
    begin
     { Muestra el numero de test en el label }
     label4.Caption := 'Número total de Preguntas: '+Numero;

     sqlFinal := '';
    end;

   { Nos borra la etiqueta del número de preguntas si no hay test seleccionado }
   if listbox1.Selcount = 0 Then  borrarEtiquetasRealizados;

  end;

procedure TForm2.ListBox1DblClick(Sender: TObject);
begin
  {Se llama a resolver }
  resolviendo;
end;

procedure TForm2.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox) do
   begin
     {Los Items pares de color rojo}
     {Los impares en negro}
     if Odd(Index) then
      begin
        Canvas.Font.Color:=clTeal;
        //canvas.Brush.Color := LightBlue;
        Canvas.Font.Style := [fsBold]
      end
     else
      begin
        Canvas.Font.Color:=clDefault;
        Canvas.Font.Style := [fsBold]
      end;
     Canvas.FillRect(ARect);
     Canvas.TextOut(ARect.Left,ARect.Top,Items[Index]);
   end;

  with (Control as TListBox).canvas do
   begin
     if odSelected in State then
      begin
        //Brush.Color := ClBlue;
        Font.Color := clWhite;
      end;

     FillRect(ARect);
     TextOut(ARect.Left, ARect.Top, (Control as TListBox).Items[Index]);
     if odFocused In State then
      begin
        Brush.Color := ListBox1.Color;
        DrawFocusRect(ARect);
      end;
   end;
end;

procedure TForm2.ListBox1KeyPress(Sender: TObject; var Key: char);
begin
  { Pulsando el intro estando seleccionado un item en el listbox }
  if (key=#13) and (ActiveControl is TListbox) then
   resolviendo;
end; {Pulsado enter/intro en el listbox }

procedure MostrarMenusAbrirOcultos;
var
  // Variable Tipo TStringList
  BDARecientes     : TStringList;
  // Variable tipo Texto para comprobar que txt del menu exite
  Total           : integer;
  ListaRecorrer   : byte;
  DirConfig       : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Actualizar los menus
  // comprobamos que hay algo en el arhcivo de texto releyenod donde se guardaron los registros
  BDARecientes := TStringList.Create;
  if FileExists(DirConfig + Abierto_menuReciente) then
    BDARecientes.LoadFromFile(DirConfig + Abierto_menuReciente);

  Total := BDARecientes.Count;
  if Total >= 1 then
  begin
   form2.miAbridBDRecientes.Enabled := true;
   form2.miBorradBDAbiertas.Enabled := true;
   for ListaRecorrer := 0 to Total do
    begin
      case ListaRecorrer of
         1 : begin
              form2.miBDA1.Visible := true;
              form2.miBDA1.Caption := BDARecientes[0];
             end;
         2 : begin
              form2.miBDA2.Visible := true;
              form2.miBDA2.Caption := BDARecientes[1];
             end;
         3 : begin
              form2.miBDA3.Visible := true;
              form2.miBDA3.Caption := BDARecientes[2];
             end;
         4 : begin
              form2.miBDA4.Visible := true;
              form2.miBDA4.Caption := BDARecientes[3];
             end;
         5 : begin
              form2.miBDA5.Visible := true;
              form2.miBDA5.Caption := BDARecientes[4];
             end;
      end;
    end;
   end;
  BDARecientes.Free;
end;

procedure MostrarMenusImportarOcultos;
var
 // Variable Tipo TStringList
 BDIRecientes     : TStringList;
 // Variable tipo Texto para comprobar que txt del menu exite
 Total           : integer;
 ListaRecorrer   : byte;
 DirConfig       : string;
begin
  // Actualizar los menus
  // comprobamos que hay algo en el arhcivo de texto releyenod donde se guardaron los registros
  DirConfig := GetAppConfigDir(false);
  BDIRecientes := TStringList.Create;
  if FileExists(DirConfig + Importado_menuReciente) then
    BDIRecientes.LoadFromFile(DirConfig + Importado_menuReciente);

  Total := BDIRecientes.Count;
  if Total >= 1 then
  begin
   form2.miImportarBDReciente.Enabled := true;
   form2.miBorrarBDImpotadsRecientes.Enabled := true;
    for ListaRecorrer := 0 to Total do
     begin
      case ListaRecorrer of
         1 : begin
              form2.miBDI1.Visible := true;
              form2.miBDI1.Caption := BDIRecientes[0];
             end;
         2 : begin
              form2.miBDI2.Visible := true;
              form2.miBDI2.Caption := BDIRecientes[1];
             end;
         3 : begin
              form2.miBDI3.Visible := true;
              form2.miBDI3.Caption := BDIRecientes[2];
             end;
         4 : begin
              form2.miBDI4.Visible := true;
              form2.miBDI4.Caption := BDIRecientes[3];
             end;
         5 : begin
              form2.miBDI5.Visible := true;
              form2.miBDI5.Caption := BDIRecientes[4];
             end;
      end;
     end;
  end;
  BDIRecientes.Free;
end;

procedure menuAbrirtosBDReciente(BDAReciente: string);
var
  // Variable Tipo TStringList
  BDARecientes  : TStringList;
  // Variable tipo Texto para comprobar que txt del menu exite
  PosicionRepe : integer;
  Total        : integer;
  DirConfig    : String;
begin
  Dirconfig := GetAppConfigDir(false);
  // Creamos la TStringList Para gestionar los Archivos buenos
  BDARecientes := TStringList.Create;

  // Cargos el archivo de texto donde se guardan los links
  if FileExists(DirConfig + Abierto_menuReciente) then
   begin
     BDARecientes.LoadFromFile(DirConfig + Abierto_menuReciente);

     PosicionRepe := BDARecientes.IndexOf(BDAReciente);
     Total := BDARecientes.Count;
     if PosicionRepe < 0 then
      begin
        BDARecientes.Insert (0,BDAReciente);
     end
     else
       if Total > 1 then
         BDARecientes.Move(PosicionRepe,0);
   end
  else  // Si no existe el fichero
    BDARecientes.Add(BDAReciente);

  // Guardamos en un archivo txt
  if DirectoryExists(DirConfig) then
    BDARecientes.SaveToFile(DirConfig + Abierto_menuReciente);

  // Liberamos la memoria
  BDARecientes.Free;

  // llamamos a mostrar archivos
  MostrarMenusAbrirOcultos;
end; // Introduce datos en la lista para cargar en el menú

procedure menuImportadaBDReciente(BDIReciente: string);
var
  // Variable Tipo TStringList
  BDIRecientes  : TStringList;
  // Variable tipo Texto para comprobar que txt del menu exite
  PosicionRepe : integer;
  Total        : integer;
  DirConfig    : String;
begin
  // Creamos la TStringList Para gestionar los archivos buenos
  BDIRecientes := TStringList.Create;

  DirConfig := GetAppConfigDir(false);
  // Cargos el archivo de texto donde se guardan los links
  if FileExists(DirConfig + Importado_menuReciente) then
   begin
    BDIRecientes.LoadFromFile(DirConfig + Importado_menuReciente);
    BDIRecientes.LoadFromFile(DirConfig + Importado_menuReciente);
    PosicionRepe := BDIRecientes.IndexOf(BDIReciente);
    Total := BDIRecientes.Count;
    if PosicionRepe < 0 then
     begin
      BDIRecientes.Insert (0,BDIReciente);
     end
    else
     if Total > 1 then
      BDIRecientes.Move(PosicionRepe,0);
   end
  else // Si no existe el fichero
   BDIRecientes.Add (BDIReciente);

  if DirectoryExists(DirConfig) then
    BDIRecientes.SaveToFile(DirConfig + Importado_menuReciente);

  // Liberamos la memoria
  BDIRecientes.Free;

  // llamamos a mostrar archivos
  MostrarMenusImportarOcultos;
end; // Introduce datos en la lista para cargar en el menú

procedure TForm2.miABrirBDClick(Sender: TObject);
begin
  if opendialog1.execute then
   begin
    CargarBase(opendialog1.FileName);
    menuAbrirtosBDReciente(opendialog1.FileName);
   end;
end;

procedure BorrarMenusUnidadAbiertos;
begin
  form2.miBDA1.Visible := false;
  form2.miBDA2.Visible := false;
  form2.miBDA3.Visible := false;
  form2.miBDA4.Visible := false;
  form2.miBDA5.Visible := false;
end;

procedure BorrarNombresAbiertosOcultos (menuBorrar : string);
var
// Variable Tipo TStringList
  BDARecientes     : TStringList;
  PosicionRepe     : Integer;
  Total            : Integer;
  DirConfig        : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar un registro del txt de importados
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + Abierto_menuReciente) then
   begin
    BDARecientes := TStringList.Create;
    BDARecientes.LoadFromFile(DirConfig + Abierto_menuReciente);
    PosicionRepe := BDARecientes.IndexOf(menuBorrar);

    if PosicionRepe > -1 then
     BDARecientes.Delete(PosicionRepe);

    Total := BDAREcientes.Count;

    if Total = 0 then
     begin
      form2.miAbridBDRecientes.Enabled := false;
      form2.miBorradBDAbiertas.Enabled := false;
     end;

    if DirectoryExists(DirConfig) then
     BDARecientes.SaveToFile(DirConfig + Abierto_menuReciente);
    BDARecientes.Free;

    showmessage('No Existe el archivo '+menuBorrar);
   end;
end;

procedure TForm2.miBDA1Click(Sender: TObject);
begin
  // Menu 1 oculto de Abrir
  if FileExists(miBDA1.caption) then
   begin
    CargarBase(miBDA1.Caption);
    menuAbrirtosBDReciente(miBDA1.Caption);
   end
  else
   begin
    BorrarMenusUnidadAbiertos;
    BorrarNombresAbiertosOcultos(miBDA1.Caption);
   end
end;

procedure TForm2.miBDA2Click(Sender: TObject);
begin
  // Menu 2 oculto de Abrir
  if FileExists(miBDA2.caption) then
   begin
    CargarBase(miBDA2.Caption);
    menuAbrirtosBDReciente(miBDA2.Caption);
   end
  else
    begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresAbiertosOcultos(miBDA2.Caption);
    end;
end;

procedure TForm2.miBDA3Click(Sender: TObject);
begin
  // Menu 3 oculto de Abrir
  if FileExists(miBDA3.caption) then
   begin
    CargarBase(miBDA3.Caption);
    menuAbrirtosBDReciente(miBDA3.Caption);
   end
  else
    begin
      BorrarMenusUnidadAbiertos;
      BorrarNombresAbiertosOcultos(miBDA3.Caption);
    end;
end;

procedure TForm2.miBDA4Click(Sender: TObject);
begin
  // Menu 4 oculto de Abrir
  if FileExists(miBDA4.caption) then
   begin
    CargarBase(miBDA4.Caption);
    menuAbrirtosBDReciente(miBDA4.Caption);
   end
  else
   begin
     BorrarMenusUnidadAbiertos;
     BorrarNombresAbiertosOcultos(miBDA4.Caption);
   end;
end;

procedure TForm2.miBDA5Click(Sender: TObject);
begin
  // Menu 5 oculto de Abrir
  if FileExists(miBDA5.caption) then
   begin
    CargarBase(miBDA5.Caption);
    menuAbrirtosBDReciente(miBDA5.Caption);
   end
  else
    begin
     BorrarMenusUnidadAbiertos;
     BorrarNombresAbiertosOcultos(miBDA5.Caption);
    end;
end;

procedure TForm2.miAbrirBaseDeDatosClick(Sender: TObject);
begin
  // Comprueba si hay test de antes y lo desbloquea.
  MostrarMenusAbrirOcultos;
end;

procedure TForm2.miAcercaDeClick(Sender: TObject);
begin
  fmAcercaDe.showmodal;
end;

function CopiarArchivo(Origen, Destino: string): boolean;
var
 MemBuffer : TMemoryStream;
begin
  // Copia un archivo, sobreeescribiendolo si existe
  // Almacena en el caché todo el contenido del archivo en la memoria.
  // Devuelve true(verdadero) si realizo correctamente la copia; false(falso) si se produce un error
  result := false;
  MemBuffer := TMemoryStream.Create;
  try
   MemBuffer.LoadFromFile(Origen);
   MemBuffer.SaveToFile(Destino);
   result := true
  except
    // Excepción que nos tragamos; el resultado de la función es false de forma predeterminada
  end;

  // Limpiar de memoria el cache en memoria
  MemBuffer.Free
end;

procedure importarDeOcultos(Ruta : string);
var
 Respuesta, boxstyle: integer;
 mensaje, titulo, DirConfig : string;
begin
  mensaje := '¿Realmente quiere poner esta base de datos como predefinida?';
  titulo := 'Atención';
  with application do begin
   boxstyle := MB_ICONQUESTION + MB_YESNO;
   Respuesta := MessageBox (PChar(mensaje), PChar(titulo), boxstyle);
   if Respuesta = IDYES then
    begin
      Dirconfig := GetAppConfigDir(false);
      if not DirectoryExists(DirConfig) then
       if Not CreateDir(DirConfig) then
         showmessage ('No se pudo crear el directorio '+DirConfig);
      form2.SQLQuery1.Close;
      form2.IBConnection1.Connected := false;
      form2.SQLTransaction1.Active := false;
      If CopiarArchivo(Ruta,DirConfig+'base1.fdb') Then
       begin
         ShowMessage('Perfecto, fichero copiado');
         CargarBase(DirConfig+'base1.fdb');
         // Mandamos archivo a lista de abiertos
         menuImportadaBDReciente(Ruta);
       end
       else
         ShowMessage('No se pudo copiar el fichero');
       end;
  end;
end;

procedure BorrarNombresImportadosOcultos(menuBorrar : string);
var
// Variable Tipo TStringList
  BDIRecientes     : TStringList;
  PosicionRepe     : Integer;
  Total            : Integer;
  DirConfig        : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar un registro del txt de importados
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + Importado_menuReciente) then
   begin
    BDIRecientes := TStringList.Create;
    BDIRecientes.LoadFromFile(DirConfig + Importado_menuReciente);
    PosicionRepe := BDIRecientes.IndexOf(menuBorrar);

    if PosicionRepe > -1 then
     BDIRecientes.Delete(PosicionRepe);

    Total := BDIREcientes.Count;

    if Total = 0 then
     begin
      form2.miImportarBDReciente.Enabled := false;
      form2.miBorrarBDImpotadsRecientes.Enabled := false;
     end;

    if DirectoryExists(DirConfig) then
      BDIRecientes.SaveToFile(DirConfig + Importado_menuReciente);
    BDIRecientes.Free;

    showmessage('No Existe el archivo '+menuBorrar);
   end;
end;

procedure BorrarMenusUnidadImportados;
begin
  form2.miBDI1.Visible := false;
  form2.miBDI2.Visible := false;
  form2.miBDI3.Visible := false;
  form2.miBDI4.Visible := false;
  form2.miBDI5.Visible := false;
end;

procedure TForm2.miBDI1Click(Sender: TObject);
begin
  // Menu 1 oculto de Importar
  if FileExists(miBDI1.caption) then
   importarDeOcultos(miBDI1.caption)
  else
   begin
    BorrarMenusUnidadImportados;
    BorrarNombresImportadosOcultos(miBDI1.Caption);
   end;
end;

procedure TForm2.miBDI2Click(Sender: TObject);
begin
  // Menu 2 oculto de Importar
  if FileExists(miBDI2.caption) then
   importarDeOcultos(miBDI2.caption)
  else
   begin
     BorrarNombresImportadosOcultos(miBDI2.Caption);
     BorrarMenusUnidadImportados;
   end;
end;

procedure TForm2.miBDI3Click(Sender: TObject);
begin
  // Menu 3 oculto de Importar
  if FileExists(miBDI3.caption) then
   importarDeOcultos(miBDI3.caption)
  else
   begin
     BorrarNombresImportadosOcultos(miBDI3.Caption);
     BorrarMenusUnidadImportados;
   end;
end;

procedure TForm2.miBDI4Click(Sender: TObject);
begin
  // Menu 4 oculto de Importar
  if FileExists(miBDI4.caption) then
   importarDeOcultos(miBDI4.caption)
  else
   begin
     BorrarNombresImportadosOcultos(miBDI4.Caption);
     BorrarMenusUnidadImportados;
   end;
end;

procedure TForm2.miBDI5Click(Sender: TObject);
begin
  // Menu 1 oculto de Importar
  if FileExists(miBDI5.caption) then
   importarDeOcultos(miBDI5.caption)
  else
   begin
     BorrarNombresImportadosOcultos(miBDI5.Caption);
     BorrarMenusUnidadImportados;
   end;
end;

procedure TForm2.miBorradBDAbiertasClick(Sender: TObject);
var
// Variable Tipo TStringList
  BDARecientes     : TStringList;
  DirConfig        : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar historial
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + Abierto_menuReciente) then
   begin
    BDARecientes := TStringList.Create;
    BDARecientes.LoadFromFile(DirConfig + Abierto_menuReciente);
    BDARecientes.clear;
    BDARecientes.SaveToFile(DirConfig + Abierto_menuReciente);
    BDARecientes.Free;
    miAbridBDRecientes.Enabled := false;
    miBorradBDAbiertas.Enabled := false;
    miBDA1.Visible := False;
    miBDA2.Visible := False;
    miBDA3.Visible := False;
    miBDA4.Visible := False;
    miBDA5.Visible := False;
   end;
end;

procedure TForm2.miBorrarBDImpotadsRecientesClick(Sender: TObject);
var
// Variable Tipo TStringList
  BDIRecientes     : TStringList;
  DirConfig        : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar historial
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + Importado_menuReciente) then
   begin
    BDIRecientes := TStringList.Create;
    BDIRecientes.LoadFromFile(DirConfig + Importado_menuReciente);
    BDIRecientes.clear;
    BDIRecientes.SaveToFile(DirConfig + Importado_menuReciente);
    BDIRecientes.Free;
    miImportarBDReciente.Enabled := false;
    miBorrarBDImpotadsRecientes.Enabled := false;
    miBDI1.Visible := False;
    miBDI2.Visible := False;
    miBDI3.Visible := False;
    miBDI4.Visible := False;
    miBDI5.Visible := False;
   end;
end;

procedure TForm2.MiBorrarHistorialMegaClick(Sender: TObject);
var
// Variable Tipo TStringList
  linksMEGA     : TStringList;
  DirConfig     : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar historial
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + mega_menuReciente) then
   begin
    linksMEGA := TStringList.Create;
    linksMEGA.LoadFromFile(DirConfig + mega_menuReciente);
    linksMEGA.clear;
    linksMEGA.SaveToFile(DirConfig + mega_menuReciente);
    linksMEGA.Free;
    miMEGAReciente.Enabled := false;
    miBorrarHistorialMega.Enabled := false;
    miBd1.Visible := False;
    miBd2.Visible := False;
    miBd3.Visible := False;
    miBd4.Visible := False;
    miBd5.Visible := False;
   end;
end;

procedure TForm2.miImportarBDClick(Sender: TObject);
var
 Respuesta, boxstyle: integer;
 mensaje, titulo, DirConfig : string;
begin
 if opendialog1.execute then
  begin
   if FileExists(opendialog1.FileName) then
     begin
      mensaje := '¿Realmente quiere poner esta base de datos como predefinida?';
      titulo := 'Atención';
      with application do begin
        boxstyle := MB_ICONQUESTION + MB_YESNO;
        Respuesta := MessageBox (PChar(mensaje), PChar(titulo), boxstyle);
        if Respuesta = IDYES then
          begin
            SQLQuery1.Close;
            IBConnection1.Connected := false;
            SQLTransaction1.Active := false;
            DirConfig := GetAppConfigDir(false);
            if not DirectoryExists(DirConfig) then
             if Not CreateDir(DirConfig) then
               showmessage ('No se pudo crear el directorio '+DirConfig);
            If copiararchivo(opendialog1.Filename, DirConfig+'base1.fdb') Then
             begin
               ShowMessage('Perfecto, fichero copiado');
               CargarBase(DirConfig+'base1.fdb');
               // Mandamos archivo a lista de abiertos
               menuImportadaBDReciente(opendialog1.FileName);
             end
             else
              ShowMessage('No se puedo copiar el fichero');
            end;
      end;
     end
  end;
end;

procedure TForm2.miImportarClick(Sender: TObject);
begin
  MostrarMenusImportarOcultos;
end;

procedure mostrarMenusOcultosMega;
var
 // Variable Tipo TStringList
 linksMEGA      : TStringList;
 // Variable tipo Texto para comprobar que txt del menu exite
 Total           : integer;
 ListaRecorrer   : byte;
 DirConfig       : string;
begin
  DirConfig := GetAppConfigDir(false);
  // Actualizar los menus
  // comprobamos que hay algo en el arhcivo de texto releyenod donde se guardaron los registros
  linksMEGA := TStringList.Create;
  if FileExists(DirConfig + mega_menuReciente) then
    linksMEGA.LoadFromFile(DirConfig + mega_menuReciente);

  Total := linksMEGA.Count;
  if Total >= 1 then
  begin
   form2.miMEGAReciente.Enabled := True;
   form2.MiBorrarHistorialMega.Enabled := True;
   for ListaRecorrer := 0 to Total do
     begin
      case ListaRecorrer of
         1 : begin
              form2.miBd1.Visible := true;
              form2.miBd1.Caption := linksMEGA[0];
             end;
         2 : begin
              form2.miBd2.Visible := true;
              form2.miBd2.Caption := linksMEGA[1];
             end;
         3 : begin
              form2.miBd3.Visible := true;
              form2.miBd3.Caption := linksMEGA[2];
             end;
         4 : begin
              form2.miBd4.Visible := true;
              form2.miBd4.Caption := linksMEGA[3];
             end;
         5 : begin
              form2.miBd5.Visible := true;
              form2.miBd5.Caption := linksMEGA[4];
             end;
      end;
     end;
  end;
  linksMEGA.Free;
end;

procedure TForm2.miMEGAClick(Sender: TObject);
begin
  mostrarMenusOcultosMega
end;

procedure menuMeterLink(MEGAlink : string);
var
 // Variable Tipo TStringsList
 linksMega    : TSTringList;
 PosicionRepe : Integer;
 Total        : Integer;
 DirConfig    : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Se carga el archivo de texto donde se guardan los links
  linksMega := TStringList.Create;
  if FileExists(DirConfig + mega_menuReciente)then
  begin
   linksMega.LoadFromFile(DirConfig + mega_menuReciente);

   PosicionRepe := linksMega.IndexOf(MEGAlink);
   Total := linksMega.Count;
   if PosicionRepe < 0 then
    linksMega.Insert (0,Megalink)
   else if Total > 1 then
    linksMega.Move(PosicionRepe,0);
  end
  else
    linksMega.Add (Megalink);

  if DirectoryExists(DirConfig) then
   linksMega.SaveToFile(DirConfig + mega_menuReciente);

  // liberamos memoria
  linksMega.Free;

  // Llamamos a mostrar menus ocultos
  mostrarMenusOcultosMega;
end;

procedure borrarMenusUnidadMEGA;
begin
  form2.miBd1.Visible := false;
  form2.miBd2.Visible := false;
  form2.miBd3.Visible := false;
  form2.miBd4.Visible := false;
  form2.miBd5.Visible := false;
end;

procedure borrarCaptionsMEGAOcultos(menuBorrar : string);
var
// Variable Tipo TStringList
  linksMega        : TStringList;
  PosicionRepe     : Integer;
  Total            : Integer;
  DirConfig        : String;
begin
  DirConfig := GetAppConfigDir(false);
  // Borrar un registro del txt de importados
  // Creamos la TStringList Para gestionar los archivos
  if FileExists(DirConfig + mega_menuReciente) then
   begin
    linksMega := TStringList.Create;
    linksMega.LoadFromFile(DirConfig + mega_menuReciente);
    PosicionRepe := linksMega.IndexOf(menuBorrar);

    if PosicionRepe > -1 then
     linksMega.Delete(PosicionRepe);

    Total := linksMega.Count;

    if Total = 0 then
     begin
      form2.miMEGAReciente.Enabled := false;
      form2.miBorrarHistorialMega.Enabled := false;
     end;

    if DirectoryExists(DirConfig) then
     linksMega.SaveToFile(DirConfig + mega_menuReciente);
    linksMega.Free;

   end;
end;

procedure DescargaMega(link, bd_caption : string);
const
  appLinux           = 'megadl';
  appWindows         = 'megatools';
  Parametro1         = '--path';
  Parametro2         = '--print-names';
  Parametro3         = '--no-progress';
  ParametroWindows   = 'dl';
var
 ProcesoMegadl    :  TProcess;
 Logmega          :  TStringList;
 Log              :  String;
 ErrorLink        :  String;
 Mensaje          :  Pchar;
 Numero           :  Byte;
 NombreArchivo    :  String;
 NombreSinExt     :  String;
 Posicion         :  Byte;
 EstiloMB         :  Integer;
 RespuestaMB      :  Integer;
 Ruta             :  Pchar;
 Barra            :  Pchar;
 Aleatorio        :  Integer;
 DescargadoEnTemp :  String;
 YaEstaTemp       :  String;
 NoEstaEnMega     :  String;
 SinConexionRed   :  String;
 Origen           :  String;
 Destino          :  String;
 DirUsuario       :  String;
 DirConfig        :  String;
begin
  // Comprobamo si existe el directorio temporal donde vamos a descargar los datos
  {$IFDEF WINDOWS}
    Barra := '\';
  {$ENDIF}

  {$IFDEF UNIX}
    Barra := '/';
  {$ENDIF}

  DirConfig := GetAppConfigDir(false);
  if Not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
    showmessage ('No se pudo crear el directorio '+DirConfig);

  DirUsuario := DirConfig + 'Temp';
  if Not DirectoryExists(DirUsuario) then
   if Not CreateDir(DirUsuario) then
    showmessage ('No se pudo crear el directorio'+DirUsuario);

  // Iniciamos un proceso
  ProcesoMegadl := TProcess.Create(nil);

  // Asignamos a ProcesoMegadl la orden que de ejecutar.
  {$IFDEF LINUX}
  ProcesoMegadl.Executable := appLinux;
  {$IFEND}
  {$IFDEF WINDOWS}
  ProcesoMegadl.Executable := appWindows;
  ProcesoMegadl.Parameters.Add (ParametroWindows);
  {$IFEND}
  ProcesoMegadl.Parameters.Add (Parametro1);
  ProcesoMegadl.Parameters.Add (DirUsuario);
  ProcesoMegadl.Parameters.Add (Parametro2);
  ProcesoMegadl.Parameters.Add (Parametro3);
  ProcesoMegadl.Parameters.Add (Link);

  // Definimos el comportamiento de TProcess
  // La opción poWaitOnExit detiene CorreosTest-2020 hasta que termina el proceso
  // La opción poUsePipes utilizamos tuberias Input/Output para capturar la salida para procesarla
  // La opción poNoConsole No permite en win32 el acceso a cmd (no aparece)
  // La opción poStrderrToOutput redirige el error estándar al flujo de salida estandar. Captura los errores
  ProcesoMegadl.Options := ProcesoMegadl.Options + [poWaitOnExit, poNoConsole, poStderrToOutPut, poUsePipes];

  // Lanzamos la ejecución todo lo preparado hasta ahora forma y comportamiento de TProcess
  // Correos2020-Test se detiene hasta que obtiene la base de datos con megadl
  ProcesoMegadl.Execute;

  // Creamos un TStrings, para guardar los logs
  Logmega := TStringList.Create;

  // Cargamos el LOG de Megadl en la TStrings
  Logmega.LoadFromStream(ProcesoMegadl.Output);

  // Guardamos el LOG en el fichero de Texto
  Logmega.SaveToFile(DirUsuario+LogMegaTXT);

  // Guardamos la salida en una variable para trabajar con ella
  Log := Logmega[0];

  // Liberamos la memoria utilizada por la TStrings y de TProcess
  Logmega.Free;
  ProcesoMegadl.Free;

  // Comprobamos si hay conexión a internet o hay un error en la Red
  SinConexionRed := Log;
  Numero := (Length(Log)-17);
  Delete(SinConexionRed,1,Numero);
  if SinConexionRed = 'resolve host name'  then
   begin
    showmessage ('Fallo en la red, comprueba que tiene conexión a Internet');
    // salir del procedimiento si no hay conexión
    exit;
   end;

  // Comprobamos que esta en MEGA el archivo y no fue borrado
  NoEstaEnMega := Log;
  Numero := (Length(Log)-6);
  Delete(NoEstaEnMega,1,Numero);
  if NoestaEnMega = mega_borrado_servidor then
   begin
    Mensaje := PChar('Link fue borrado de MEGA: '+ link);
    Application.MessageBox (Mensaje,'Error',MB_ICONHAND);
    if bd_caption = 'Inputbox' then
     exit
    else
     begin
      // Borramos del menu el link que ya no sirve de los menus individuales
      borrarCaptionsMEGAOcultos(bd_caption);
      borrarMenusUnidadMEGA;
      exit;
     end;
   end;

  // Comprobamos que el link de MEGA es invalido
  ErrorLink := Log;
  Numero := (length(Log)-45);
  Delete(ErrorLink,46,Numero);
  if ErrorLink = LinkIncorrecto then
   begin
    Mensaje := PChar('Link MEGA Invalido:'+#32+#39+link+#39);
    Application.MessageBox (Mensaje,'Error',MB_ICONHAND);
   end
  else // Si el enlace es correcto, lo mandamos guardar en el historial de link recientes
    menuMeterLink(link);

  // Comprobamos que el fichero no este descargado antes
  // Al mismo tiempo informa si ya esta en el archivo temporal
  if ErrorLink <> LinkIncorrecto then
   begin
    DescargadoEnTemp := Log;
    Numero := (Length(Log)-29);
    Delete(DescargadoEnTemp,30,Numero);
    if DescargadoEnTemp = ArchivoExiste then
     begin
      YaEstaTemp := Log;
      Numero := 30;
      Delete(YaEstaTemp,1,Numero);
      Showmessage ('Error, el archivo ya existe en: '+YaEstaTemp);
     end;
   end;

  // Obtenemos el nombre del archivo descargado y aplicamos las directrices de archvos de windows o unix
  if (ErrorLink <> LinkIncorrecto) and (DescargadoEnTemp <> ArchivoExiste) then
   begin
    NombreArchivo := Log;
    while Pos(Barra,NombreArchivo) > 0 do
     begin
      Posicion := Pos(Barra,NombreArchivo);
      Delete(NombreArchivo,1,Posicion);
     end;

    // Se comprueba si existe una base de datos que este utilizando el programa
    if FileExists(DirConfig + 'base1.fdb') then
     with application do begin
      EstiloMB := MB_ICONQUESTION + MB_YESNO;
      RespuestaMB := MessageBox('Actualmente tiene una base de datos de test llamada base1.fdb, ¿desea sobreeescribirla?','¿Sobreescribir?',EstiloMB);
      If RespuestaMB = IDYES then
       begin
        // Desactivamos base de datos para copiar archivo
        form2.SQLQuery1.Close;
        form2.IBConnection1.Connected := false;
        form2.SQLTransaction1.Active := false;
        // Se copia el archivo como base principal
        Origen := DirUsuario+Barra+NombreArchivo;
        Destino := DirConfig+'base1.fdb';
        If CopiarArchivo(Origen,Destino)  Then
         begin
           // Carga la base de datos
           CargarBase(DirConfig + 'base1.fdb');
           // Avisa que se ha copiado el archivo
           showmessage ('Archivo copiado');
           // Borrar el archivo Original
           DeleteFile(Origen);
          end;
        end;
      if RespuestaMB = IDNO then
       // Si se responde No, renombra el archivo con un nombre aleatorio para poder consultar o borra manualmente
       begin
        Randomize; // Inicia el pseudo generador de números aleatorios
        Aleatorio := Random(35000); // con este rango de 1 a 35000

        Numero := length(NombreArchivo)-3;
        NombreSinExt := NombreArchivo;
        Delete(NombreSinExt,Numero,length(NombreArchivo));
        Ruta := Pchar('El archivo es renombrado como '+NombreSinExt+'-'+IntToStr(Aleatorio)+'.fdb y esta en la carpeta '+DirUsuario+Barra+NombreSinExt+'-'+IntToStr(Aleatorio)+'.fdb puede abrirlo, importarlo o borrarlo de forma manual');

        if RenameFile (DirUsuario+Barra+NombreArchivo, DirUsuario+Barra+NombreSinExt+'-'+IntToStr(Aleatorio)+'.fdb') then
         MessageBox (Ruta, 'Renombrado', MB_ICONHAND)
       end;
     end;

    // Si no hay ninguna base de datos Copiar el archivo de Temp a directorio App,
    if not FileExists(DirConfig + 'base1.fdb') then
     if CopiarArchivo (DirUsuario+Barra+NombreArchivo, DirConfig+'base1.fdb') then
      begin
       // Avisa que se ha copiado el archivo
       showmessage ('Archivo copiado');
       // Borra el archivo original
       DeleteFile(DirUsuario+Barra+NombreArchivo);
       // Desactivamos base de datos para copiar archivo
       form2.SQLQuery1.Close;
       form2.IBConnection1.Connected := false;
       form2.SQLTransaction1.Active := false;
       // Carga la base de datos
       CargarBase(DirConfig+'base1.fdb');
      end;
   end;
end;

procedure TForm2.miMEGANuevoClick(Sender: TObject);
Const
  Titulo = 'Link de Mega';
  Mensaje = 'Introduce el Link de una base de datos alojada en Mega';
  OrigenInputBox = 'InputBox';
var
 // Para guardar el link
 LinkIntroducido : string;
begin
  LinkIntroducido := InputBox (Titulo,Mensaje,'');
  if LinkIntroducido <> '' then
   DescargaMega(LinkIntroducido, OrigenInputBox);
end;

procedure TForm2.MenuItem1Click(Sender: TObject);
const
  OrigenMenu = 'InputBox';
  linkMega = 'https://mega.nz/folder/oewkgRzQ#0s_rRiMBZOK6RryP2kem3Q';
begin
  DescargaMega(LinkMega, OrigenMenu);
end;

procedure TForm2.miBd1Click(Sender: TObject);
begin
  DescargaMega(miBd1.Caption , miBd1.Caption);
end;

procedure TForm2.miBd2Click(Sender: TObject);
begin
  DescargaMega(miBd2.Caption, miBd2.Caption);
end;

procedure TForm2.miBd3Click(Sender: TObject);
begin
  DescargaMega(miBd3.Caption, miBd3.Caption);
end;

procedure TForm2.miBd4Click(Sender: TObject);
begin
  DescargaMega(miBd4.Caption, miBd4.Caption);
end;

procedure TForm2.miBd5Click(Sender: TObject);
begin
  DescargaMega(miBd5.Caption, miBd5.caption);
end;

procedure TForm2.miSalirClick(Sender: TObject);
begin
  close;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  Salida, Ventana: Integer;
begin
  { Salir de la aplicación }
  with application do begin
     Ventana := MB_ICONQUESTION + MB_YESNO;
     Salida := MessageBox ('¿Desea Salir?', 'Salir', Ventana);
     if Salida = IDYES then
      begin
        Application.terminate;
      end;
   end;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
  { Se llama ha resolver }
  resolviendo;
  { Si es aleatorio se marca }
end;

procedure TForm2.ComboBox1Select(Sender: TObject);
var
  Tema : String[8]; // Para borrar el añadido de tema en la cadena es de 8 limitado a 99 test
begin
  { Combobox1 para elegir tema }
  borrarEtiquetasRealizados;
  Tema := ComboBox1.Text; // Se guarda el valor elegido

  if ComboBox1.ItemIndex <= 9 then
    Delete(Tema,1,5)   // Para borrar el añadido de tema en la cadena
  else
    Delete(Tema,1,6);  // Para borrar el añadido de tema en la cadena

  ListBox1.Items.Clear;  // se borra el ListBox
  if (Combobox1.ItemIndex = 0) and (combobox1.Text <> '') then   // Si se selecciona todas los test
   begin
     SQLQuery1.SQL.text := 'SELECT DISTINCT Nombre_test, TEMA FROM TEST_INDIVIDUAL ORDER BY TEMA';
     SQLQuery1.Open();
     while (not SQLQuery1.EOF) do
     begin
       ListBox1.Items.Add ('Tema ' + SQLQuery1.FieldByName('TEMA').AsString + ': '
           + SQLQuery1.FieldByName('NOMBRE_TEST').AsString);
       SQLQuery1.Next;
     end;
     SQLQuery1.Close();
     // SQLQuery1.SQL.Text := 'SELECT count(NOMBRE_TEST) from TEST_INDIVIDUAL';
     // SQLQuery1.Open();

     //Numero := SQLQuery1.FieldByName('COUNT').AsString;
     //label4.caption := 'Número total de preguntas: '+Numero;

     //SQLQuery1.Close();
     { Seleccionar todos los items }


     { Bloquear seleccion en todos los test }
     TodosLosTest := True;
     // ListBox1.Selectall;
     // ListBox1.Click;
     //Valor := ComboBox1.Text;
  end
  else if combobox1.Text <> '' then
   begin
     SQLQuery1.SQL.Text := 'SELECT DISTINCT NOMBRE_TEST FROM TEST_INDIVIDUAL WHERE Tema = '+Chr(39)+Tema+Chr(39);
     SQLQuery1.Open();
     while (not SQLQuery1.EOF) do
     begin
        ListBox1.Items.Add (SQLQuery1.FieldByName('NOMBRE_TEST').AsString);
        SQLQuery1.Next;
     end;

     TodosLosTest := False;
   end;
   SQLQuery1.Close;

   { Si hay seleccionado algo en el combobox y hay algo en listbox que haga }
   if (listbox1.items.count >= 0) and (combobox1.Text <> '') then
    begin
      eBuscarListbox.Enabled := True;
      btBuscar.Enabled := True;
      CheckBox1.Enabled := True;
      cbCaseSensitive.Enabled := True;
      lBuscarPorCadena.Enabled := True;
      {Añadimos el número de test disponibles por tema o todos los que hay }
        lNumTestDispo.Caption := (': Test disponibles '+IntToStr(listbox1.Items.Count));
    end;

end;

procedure TForm2.eBuscarListboxKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   if (ActiveControl is TEdit) then
   begin
        key:=#0;
        SelectNext(ActiveControl,true, true);
    end;
end;

procedure TForm2.btBuscarClick(Sender: TObject);
var
  contador : integer;
  cadena : string;
  Buscado, Encontrado : boolean;
begin
  for contador := 0 to (Listbox1.Items.Count - 1) do
     if ListBox1.Selected[contador] then ListBox1.Selected[contador] := False;

  if eBuscarListbox.Text = '' then
   showmessage('No hay nada que buscar')
  else
    begin
     cadena := eBuscarListbox.Text;
     contador := 0;
     Encontrado := False;
    repeat
      if cbCaseSensitive.checked then
        Buscado := Pos(lowercase(cadena), lowercase(Listbox1.Items[contador])) <> 0
      else
        Buscado := Pos(cadena, Listbox1.Items[contador]) <> 0;

      if Buscado then
       begin
         Listbox1.Selected[contador] := true;
         Encontrado := True;
         Buscado := False;
       end;
      if not Buscado then inc(contador);
     until (contador > Listbox1.Items.Count - 1);

     if not Encontrado then
      ShowMessage('No se encuentra ' + cadena)
     else
      listbox1.Click;
    end;
end;

procedure TForm2.FormActivate(Sender: TObject);
var
  DirConfig : String;
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
  // creamos el directorio de aplicación si no existe
  if not DirectoryExists(DirConfig) then
   if Not CreateDir(DirConfig) then
     showmessage ('No se pudo crear el directorio '+DirConfig);

  // Arrancamos el mostar de resultados al principio porque si no falla
  TestRealizadosArranque;

  // Borrar etiquetas del número de test de la listbox
  lNumTestDispo.caption := ('');

  if FileExists(DirConfig + 'base1.fdb') then
    CargarBase(DirConfig + 'base1.fdb')
  else
    begin
     showmessage ('No existe una base de datos: Importe o introduzca una a través de MEGA.');
     borrarEtiquetasRealizados;
    end;

end;


procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  { Cerrar Ventana bajo pregunta }
  CloseAction:= caNone;
  speedbutton1.Click;
end;

end.

