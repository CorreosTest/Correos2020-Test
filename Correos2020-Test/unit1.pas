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
  Classes, SysUtils, IBConnection, sqldb, DB, Forms, Controls, Graphics,
  Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLType, Buttons, ComCtrls,
  Menus;

type
  { Registros de fallos en Array }
  FallosNoRepe = Array of Integer;
  FallosABCD = Array of Char;

  { Empieza el registro de archivos }
  Cadena255 = string[255];
  TestHecho = record
     NombreTest    : cadena255;
     Fecha         : string[19];
     Tiempo        : string[8];
     Aciertos      : integer;
     Fallos        : integer;
     TantoXciento  : integer;
     Sw	           : boolean;
  end;

  Fichero = file of TestHecho;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    btPausaCrono: TButton;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    IBConnection1: TIBConnection;
    imgUnlike: TImage;
    imgLike: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    l_cronometro: TLabel;
    ProgressBar1: TProgressBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Timer1: TTimer;

    procedure btPausaCronoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBText3Click(Sender: TObject);
    procedure DBText4Click(Sender: TObject);
    procedure DBText4DblClick(Sender: TObject);
    procedure DBText4MouseLeave(Sender: TObject);
    procedure DBText4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBText5Click(Sender: TObject);
    procedure DBText5DblClick(Sender: TObject);
    procedure DBText5MouseLeave(Sender: TObject);
    procedure DBText5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBText6Click(Sender: TObject);
    procedure DBText6DblClick(Sender: TObject);
    procedure DBText6MouseLeave(Sender: TObject);
    procedure DBText6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBText7Click(Sender: TObject);
    procedure DBText7DblClick(Sender: TObject);
    procedure DBText7MouseLeave(Sender: TObject);
    procedure DBText7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label4DblClick(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Label5Click(Sender: TObject);
    procedure Label5DblClick(Sender: TObject);
    procedure Label5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Label6Click(Sender: TObject);
    procedure Label6DblClick(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Label6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Label7Click(Sender: TObject);
    procedure Label7DblClick(Sender: TObject);
    procedure Label7MouseLeave(Sender: TObject);
    procedure Label7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private

  public
    { Varibles Publicas para form2}
    IniciarCronometro: boolean; // Inicar el crono desde form2
  end;

var
  Form1: TForm1;
  hora: integer;
  minuto: integer;
  segundo: integer;
  respuestaA: boolean;
  respuestaB: boolean;
  respuestaC: boolean;
  respuestaD: boolean;
  Porcentaje : real; // Porcentaje del test
  Contador,TotalFallos, TotalAciertos,PosicionAntesAnterior: integer;
  Fallos, Aciertos: FallosNoRepe; // Array de Aciertos y Fallos
  ErrorABCD :  FallosABCD; // Array que guarda las letras de los errores
  NoModificarAciertosFallos: boolean;  // Test Se pulsa no en seguir al siguiente test
  PosicionAvance : boolean;
  FinDeTest : boolean; // Donde termina el test
  Arch : Fichero; // Varible de tipo fichero

  implementation      // Para acceder a datos del otro formulario
  uses Unit2;

{$R *.lfm}

{ TForm1 }

procedure Activar (var F:Fichero);
var
 Resultado : integer;
begin
  {$I-}
  Reset (F);
  Resultado := IOresult;
  {$I+}
  if Resultado <> 0 then
     Rewrite (F);
  System.Close (F);
end; { Activar }

function Posicion (N: Cadena255; var F: Fichero) : integer;
var
  Registro : TestHecho;
  Hallado : boolean;
begin
  Hallado := false;
  Seek (F,0);
  while not Eof(F) and not Hallado do
   begin
     Read (F,Registro);
     Hallado := Registro.NombreTest = N;
   end;
   if Hallado then
     Posicion := FilePos(F) -1
   else
     Posicion := -1;
end; { Posición }

procedure TestHechoSobrescribir(var F: Fichero; NombreTestMod:string);
{ Mensaje pregunta si sobreescribir resultados test hecho }
var
  T         : TestHecho;
  N         : Cadena255;
  I         : integer;
  Respuesta : integer;
  boxstyle  : integer;
  mensaje   : string;
  titulo    : string;
begin
  titulo := 'Test realizado anteriormente';
  mensaje := 'Test realizado anteriormente, ¿desea sobreescribir los resultados?';
  with application do begin
    boxstyle := MB_ICONQUESTION + MB_YESNO;
    Respuesta := MessageBox (PChar(mensaje), PChar(titulo), boxstyle);
    if Respuesta = IDYES then
     begin
       N := NombreTestMod;
       System.Close (F);
       System.Reset (F);
       I := Posicion (N,F);
       if I = -1 then
        begin
         showmessage ('No existe el nombre del Test que desea consultar');
        end
       else
        begin
          System.Seek (F, I);
          System.Read (F, T);
          if T.Sw then
           begin
             with T do begin
               NombreTest := N;
               Aciertos := TotalAciertos;
               Fallos := TotalFallos;
               Fecha := FormatDateTime('dd/mm/yyyy hh:nn:ss', now);
               TantoXciento := round(porcentaje) ;
               Tiempo := form1.l_cronometro.Caption;
               Sw := true;
             end;
             I := System.FilePos (F) - 1;
             System.Seek (F, I);
             System.Write (F,T);
             showmessage ('Registro actualizado correctamente');
           end
          else
            showmessage ('El registro fue dado de baja');

       end;
    end
     else
       MessageBox ('Conserva los resultados anteriores', 'Atención',MB_ICONHAND);

  end;
 end;

procedure Ampliar (var F: Fichero);
var
  R, T : TestHecho;
  I    : integer;      { Posición del registro en el archivo }
 // Nom  : string;
begin
    Reset (F);
    {LeerRegistro }
    with T do
    begin
        NombreTest := form1.DBText2.Caption;
        Aciertos := TotalAciertos;
        Fallos := TotalFAllos;
        Fecha := FormatDateTime('dd/mm/yyyy hh:nn:ss', now);
        TantoXciento := round(porcentaje) ;
        Tiempo := form1.l_cronometro.Caption;
        Sw := true;
    end;
    I := Posicion (T.NombreTest, F);
    if I= -1 then
     begin
      I := FileSize (F);
      Seek (F, I);
      write (F, T);
     end
      else
        begin
          Seek (F, I);
          Read (F, R);
          if R.Sw then
           begin
             TestHechoSobrescribir(F,T.NombreTest);
           end
          else
             write (F, T);
           end;

     Porcentaje := 0;
     TotalAciertos := 0;
     TotalFallos := 0;
  System.Close (F);
end; { Ampliar }

procedure DesactivarRespuestas;
 begin
  { Desactivar Todas las Respuestas }
  respuestaA := False;
  respuestaB := False;
  respuestaC := False;
  respuestaD := False;

  form1.dbtext4.font.color := clDefault;
  form1.label4.font.color := clDefault;
  form1.dbtext5.font.color := clDefault;
  form1.label5.font.color := clDefault;
  form1.dbtext6.font.color := clDefault;
  form1.label6.font.color := clDefault;
  form1.dbtext7.font.color := clDefault;
  form1.label7.font.color := clDefault;
end;  { DesactivarRespuestas }

procedure cargarDatosBD;
begin
  form1.SQLQuery1.Close;
  form1.IBConnection1.Connected := false;
  form1.SQLTransaction1.Active := false;

  form1.IBConnection1.DatabaseName := form2.BaseDeDatos;
  form1.IBConnection1.UserName := 'SYSDBA';
  form1.IBConnection1.Password := 'masterkey';
  form1.IBConnection1.CharSet := 'UTF8';
  form1.IBConnection1.Dialect := 3;
  form1.IBConnection1.Connected := True;
  form1.SQLTransaction1.DataBase := form1.IBConnection1;
  form1.SQLTransaction1.Active := True;
  form1.SQLQuery1.DataBase := form1.IBConnection1;


  form1.Datasource1.DataSet := form1.SQLQuery1;
  form1.DBNavigator1.DataSource := form1.Datasource1;

  form1.DBText1.DataSource := form1.Datasource1;
  form1.DBText2.DataSource := form1.Datasource1;
  form1.DBText3.DataSource := form1.Datasource1;
  form1.DBText4.DataSource := form1.Datasource1;
  form1.DBText5.DataSource := form1.Datasource1;
  form1.DBText6.DataSource := form1.Datasource1;
  form1.DBText7.DataSource := form1.Datasource1;
  form1.DBText8.DataSource := form1.Datasource1;

  form1.DBText1.DataField := 'TEMA';
  form1.DBText2.DataField := 'NOMBRE_TEST';
  form1.DBText3.DataField := 'PREGUNTA';
  form1.DBText4.DataField := 'A';
  form1.DBText5.Datafield := 'B';
  form1.DBText6.Datafield := 'C';
  form1.DBText7.Datafield := 'D';
  form1.DBText8.Datafield := 'CORRECTA';


  form1.DBNavigator1.DataSource := form1.Datasource1;
  DesactivarRespuestas;

  form1.SpeedButton2.Enabled := False;

  //timer1.Enabled := False;
  //form1.Enabled := False;
end; { cargarDatosBD }

procedure reporteAciertos;
var
  c : integer;
begin
 if (Contador = PosicionAntesAnterior) then
   PosicionAvance := true;

 if (PosicionAvance = true) and (FinDeTest = False) then
 begin
  if (Fallos[Contador] = 0)  then
    begin
      Aciertos[Contador] := 1;
      Fallos[Contador] := 0;
    end;
   for c := 1 to Contador do
    begin
      TotalFallos := TotalFallos + Fallos[c];
      TotalAciertos := TotalAciertos + Aciertos[c];
    end;

   form1.label12.Caption:= 'Aciertos '+IntToStr(TotalAciertos)+ ' / Fallos '+IntToStr(TotalFallos);
   TotalAciertos := 0;
   TotalFallos := 0;
   // if (Contador = StrToInt(form2.Numero)) then
   //    for c := 0 to Contador do
   //  Aciertos[c] := 0;
 end;
end;  { reporteAciertos }

procedure reporteFallo(Rx : char);
var
  c : integer;
begin
 if (Contador = PosicionAntesAnterior) then
   PosicionAvance := true;
 if (PosicionAvance = true) and (FinDeTest = False) then
  begin
   if (Fallos[Contador] = 0) and (NoModificarAciertosFallos = False)then
   begin
      Fallos[Contador] := 1;    // Apunta el fallo numericamente
      Aciertos[Contador] := 0;  // No apunta el Acierto numericamente
      ErrorABCD[Contador] := Rx; // Apunta la primera letra introducida.
   end;

   for c := 1 to Contador do
     begin
      TotalFallos := TotalFallos + Fallos[c];
      TotalAciertos := TotalAciertos +Aciertos[c];
     end;
   form1.label12.Caption:= 'Aciertos '+IntToStr(TotalAciertos)+ ' / Fallos '+IntToStr(TotalFallos);
   TotalFallos := 0;
   TotalAciertos := 0;
  //if (Contador = StrToInt(form2.Numero)) then
   // for c := 0 to Contador do
   //     Fallos[c] := 0;
 end;
end; { reporteFallo}

procedure MensajeEmergente(correcta, pregunEnsi: string);
{ Mensaje de Acierto para hacer el siguiente test }
var
  Respuesta, boxstyle: integer;
  mensaje, titulo : string;
begin
  mensaje := correcta + ') ' + pregunEnsi + chr(10) + chr(10) +
  '¿Deseas hacer un nuevo test?';
  titulo := 'Correcto';
  with application do begin
     boxstyle := MB_ICONQUESTION + MB_YESNO;
     Respuesta := MessageBox (PChar(mensaje), PChar(titulo), boxstyle);
     if Respuesta = IDYES then
      begin
        // MessageBox ('Siguiente test', 'Respuesta', MB_ICONINFORMATION);
        if (not form1.SQLQuery1.EOF) then  // no dar para delante si esta al final
        begin
          reporteAciertos;
          NoModificarAciertosFallos := False;
          contador := contador + 1;
          form1.SQLQuery1.Next;
          //Sleep(400);
          form1.SpeedButton2.Enabled := True;
        end;
        { Test muestra la suma de uno mas }
        form1.Label11.caption := IntToStr(Contador)+' de '+form2.Numero;
      end
      else
        begin
           MessageBox ('Recuerda que para hacer el siguiente test debes pulsar si',
           'Respuesta',MB_ICONHAND);
           ReporteAciertos;
           NoModificarAciertosFallos := True;
        end;
     end;
   DesactivarRespuestas;
   if form1.IniciarCronometro = false then form1.btPausaCrono.Click;
end;  { MensajeEmergente }

procedure MvRatSobreResA;
begin
  if (respuestaA = False) and (form1.DBText4.font.color <> clRed)
   and (FinDeTest = False) then
   begin
    form1.DBText4.font.color := clPurple;
    form1.label4.font.color := clPurple;
  end;
end; { Mover Raton Sobre Respuesta A }

procedure MvRatSobreResB;
begin
  if (respuestaB = False) and (form1.DBText5.Font.color <> clRed)
   and (FinDeTest = False) then
  begin
   form1.dbtext5.font.color := clPurple;
   form1.label5.font.color := clPurple;
  end;
end; { Mover Raton Sobre Respuesta B }

procedure MvRatSobreResC;
begin
  if (respuestaC = false) and (form1.dbtext6.font.color <> clRed)
   and (FinDeTest = False) then
  begin
   form1.dbtext6.font.color := clPurple;
   form1.label6.font.color := clPurple;
  end;
end; { Mover Raton Sobre Respuesta C }

procedure MvRatSobreResD;
begin
  if (respuestaD = false) and (form1.DBText7.font.color <> clRed)
   and (FinDeTest = False) then
  begin
    form1.dbtext7.font.color := clPurple;
    form1.label7.font.color := clPurple;
  end;
end; { Mover Raton sobre Respuesta D }

procedure RetRatSobreResA;
begin
  if (respuestaA = False) and (form1.dbtext4.font.color <> clRed)
   and (FinDeTest = False) then
  begin
    form1.dbtext4.font.color := clDefault;
    form1.label4.font.color := clDefault
  end;
  form1.label14.Visible := False; // oculta respuesta incorrecta del label
end; { Retirar Ratón Sobre Respuesta A }

procedure RetRatSobreResB;
begin
 if (respuestaB = False) and (form1.dbtext5.font.color <> clRed)
  and (FinDeTest = False) then
 begin
   form1.dbtext5.font.color := clDefault;
   form1.label5.font.color := clDefault;
 end;
 form1.label14.Visible := False; // oculta respuesta incorrecta del label
end; { Retirar Ratón sobre Respuesta B }

procedure RetRatSobreResC;
begin
  if (respuestaC = False) and (form1.dbtext6.font.color <> clRed)
   and (FinDeTest = False) then
  begin
    form1.dbtext6.font.color := clDefault;
    form1.label6.font.color := clDefault;
  end;
  form1.label14.Visible := False; // oculta respuesta incorrecta del label
end; { Retirar Ratón Sobre Respuesta C }

procedure RetRatSobreResD;
begin
  if (respuestaD = False) and (form1.DBText7.font.color <> clRed)
   and (FinDeTest = False) then
  begin
    form1.dbtext7.font.color := clDefault;
    form1.label7.font.color := clDefault;
  end;
  form1.label14.Visible := False; // oculta respuesta incorrecta del label
end; { Retirar Ratón Sobre Respuesta D }

procedure ClickRespuestaA;
begin
  if FinDeTest = False then
  begin
    respuestaA := True;
    respuestaB := False;
    respuestaC := False;
    respuestaD := False;

    form1.dbtext4.font.color := clFuchsia;
    form1.label4.font.color := clFuchsia;

    RetRatSobreResB;
    RetRatSobreResC;
    RetRatSobreResD;
  end;
end; { Click Seleccionado Respuesta A}

procedure ClickRespuestaB;
begin
  if FinDeTest = False then
  begin
   respuestaB := True;
   respuestaA := False;
   respuestaC := False;
   respuestaD := False;

   form1.dbtext5.font.color := clFuchsia;
   form1.label5.font.color := clFuchsia;

   RetRatSobreResA;
   RetRatSobreResC;
   RetRatSobreResD;
  end;
end; { Click Seleccionado Respuesta B}

procedure ClickRespuestaC;
begin
 if FinDeTest = False then
 begin
  respuestaC := True;
  respuestaA := False;
  respuestaB := False;
  respuestaD := False;

  form1.dbtext6.font.color := clFuchsia;
  form1.label6.font.color := clFuchsia;

  RetRatSobreResA;
  RetRatSobreResB;
  RetRatSobreResD;
 end;
end; { Click Seleccionado Respuesta C}

procedure ClickRespuestaD;
begin
 if FinDeTest = False then
 begin
  respuestaD := True;
  respuestaA := False;
  respuestaB := False;
  respuestaC := False;

  form1.dbtext7.font.color := clFuchsia;
  form1.label7.font.color := clFuchsia;

  RetRatSobreResA;
  RetRatSobreResB;
  RetRatSobreResC;
 end;
end; { Click Seleccionado Respuesta D}

procedure TForm1.DBText4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResA;
end;

procedure TForm1.DBText5Click(Sender: TObject);
begin
  ClickRespuestaB;
end;

procedure TForm1.DBText5DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
    begin
      //Sleep(400); // pausa de 100 ms
      form1.SpeedButton1.Click ;
    end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.DBText5MouseLeave(Sender: TObject);
begin
  RetRatSobreResB;
end;

procedure TForm1.DBText5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResB;
end;

procedure TForm1.DBText6Click(Sender: TObject);
begin
  ClickRespuestaC;
end;

procedure TForm1.DBText6DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
     //Sleep(400); // pausa de 100 ms
     form1.SpeedButton1.Click ;
   end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.DBText6MouseLeave(Sender: TObject);
begin
  RetRatSobreResC;
end;

procedure TForm1.DBText6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResC;
end;

procedure TForm1.DBText7Click(Sender: TObject);
begin
  ClickRespuestaD;
end;

procedure TForm1.DBText7DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
     //Sleep(400); // pausa de 100 ms
     form1.SpeedButton1.Click ;
   end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.DBText7MouseLeave(Sender: TObject);
begin
  RetRatSobreResD;
end;

procedure TForm1.DBText7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
   MvRatSobreResD;
end;

procedure TForm1.FormActivate(Sender: TObject);
const
  SQLsentenciaInicial = 'SELECT * FROM TEST_INDIVIDUAL WHERE NOMBRE_TEST=';
  SQLunion = 'UNION ALL';
  SQLrandonInicial = 'SELECT * FROM (SELECT * FROM TEST_INDIVIDUAL WHERE NOMBRE_TEST=';
  SQLParaTerminar = ') ORDER BY rand();';
var
  c,d,posicion : integer;
  sqlFinal, CadenasElegidas : string;
begin
  { En la activación del formulario}
  cargarDatosBD;
  SQLQuery1.close();
   { Borrar sqlFinal }
  sqlFinal := '';
  { Iniciar contador d}
  d := 0;
  {Cuando se cliquea mas de un item en la Listbox ( a partir de 2 seleccionados )}
  if (form2.listBox1.Selcount > 1) and (form2.Random = False) then
    for c:= 0 to form2.ListBox1.Items.Count - 1 do // Iterar por todos los items
     begin
      if form2.ListBox1.Selected[c] then  // Si es seleccioando
       begin
         d := d +1;
         CadenasElegidas :=  form2.ListBox1.Items.Strings[c];
         if form2.TodosLosTest = True then
          begin
            posicion := pos(':',CadenasElegidas); //nos dice la posicion de los dos puntos
            if posicion = 7 then
              Delete(CadenasElegidas,1,8);
            if posicion = 8 then
              Delete(CadenasElegidas,1,9);
          end;
         if sqlFinal = '' then
           sqlFinal := SQLsentenciaInicial + #39 + CadenasElegidas + #39 + #10 + SQLunion
         else if  d = form2.Listbox1.SelCount then
           sqlFinal := Sqlfinal + #10 + SQLsentenciaInicial + #39 + CadenasElegidas + #39
         else if  d < form2.Listbox1.SelCount then
           sqlFinal := Sqlfinal + #10 + SQLsentenciaInicial + #39 + CadenasElegidas + #39 + #10 + SQLunion;
       end;
     end;

  if form2.listBox1.Selcount = 1 then
    for c:= form2.ListBox1.Items.Count - 1 downto 0 do
      if form2.ListBox1.Selected[c] then
       begin
        CadenasElegidas := form2.ListBox1.Items.Strings[c];
        if form2.TodosLosTest = True then
         begin
          posicion := pos(':',CadenasElegidas); //nos dice la posicion de los dos puntos
          if posicion = 7 then
            Delete(CadenasElegidas,1,8);
          if posicion = 8 then
            Delete(CadenasElegidas,1,9);
         end;
        { Seleccionado un solo registro aleatorio o no aleatorio }
        if form2.Random = False then
          sqlFinal := SQLsentenciaInicial + #39 + CadenasElegidas + #39
        else
          sqlFinal := SQLSentenciaInicial + #39 + CadenasElegidas + #39 + ' ORDER BY RAND()';
       end;


  if (form2.listBox1.Selcount > 1) and (form2.Random = True) then
   begin
    for c:= 0 to form2.ListBox1.Items.Count - 1 do // Iterar por todos los items
     begin
      if form2.ListBox1.Selected[c] then  // Si es seleccioando
       begin
         d := d +1;
         CadenasElegidas :=  form2.ListBox1.Items.Strings[c];
         if form2.TodosLosTest = True then
           begin
             posicion := pos(':',CadenasElegidas); //nos dice la posicion de los dos puntos
             if posicion = 7 then
              Delete(CadenasElegidas,1,8);
             if posicion = 8 then
              Delete(CadenasElegidas,1,9);
           end;
         if sqlFinal = '' then
           sqlFinal := SQLrandonInicial + #39 + CadenasElegidas + #39 + #10 + SQLunion
         else if  d = form2.Listbox1.SelCount then
           sqlFinal := Sqlfinal + #10 + SQLsentenciaInicial + #39 + CadenasElegidas + #39 + SQLParaTerminar
         else if  d < form2.Listbox1.SelCount then
           sqlFinal := Sqlfinal + #10 + SQLsentenciaInicial + #39 + CadenasElegidas + #39 + #10 + SQLunion;
       end;
     end;
     // else
  end;
  SQLQuery1.SQL.Text := SqlFinal;

  //showmessage(sqlFinal);
  SQLQuery1.open();

    { Número de Test (contador) }
    Contador := 1;  // Empieza el Test con el número 1
    TotalFallos := 0;  // Se ponen los Fallos totales a Cero
    TotalAciertos := 0;  // Se ponen los Falos totales a Cero
    PosicionAntesAnterior := 1; // Poner a cero varible donde se quedo después de anterior
    Label11.caption := IntToStr(contador)+' de '+form2.Numero;  // Marca test actual y número de test
    label12.caption := 'Aciertos 0 / Fallos 0';
    PosicionAvance := true;
    SetLength(Fallos,StrToInt(Form2.Numero)+1); // Define el array enteros para los fallos (Fallos)
    SetLength(Aciertos,StrToInt(Form2.Numero)+1); // Define el array enteros para los aciertos (Aciertos)
    SetLength(ErrorABCD,StrToInt(Form2.Numero)+1); // Define el array char para guardar la primera letra fallida
    SQLQuery1.Active := true;
    FinDeTest := False; // Empieza el test
end; { Form1 FormActivate}

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
 Respuesta, boxstyle: integer;
 mensaje, titulo : string;
begin
  { Ocultar Ventana bajo pregunta }
  mensaje := '¿Volver a la ventana anterior?';
  titulo := '¿Cerrar Ventana?';
  with application do
  begin
    boxstyle := MB_ICONQUESTION + MB_YESNO;
    Respuesta := MessageBox (PChar(mensaje), PChar(titulo), boxstyle);
    if Respuesta = IDYES then
       Close
    else
      CloseAction:= caNone;
  end;
end; { TForm1.FormClose  }

procedure TForm1.FormDeactivate(Sender: TObject); {Desactivando formulario }
var
  c: integer;
begin
  { Borra lo que quedo en las respuestas}
  DesactivarRespuestas;
  { Pone a cero el cronometro (reseteado común y corriente) }
  hora := 0;
  minuto := 0;
  segundo := 0;
  l_cronometro.Caption := '00:00:00 ';
  { Paramos el mecanismo del reloj, para ahorrar memoria }
  IniciarCronometro := False;
  { Resetear variable posicion }
  PosicionAntesAnterior := 1;
  { Reseamos Aciertos fallos }
  for c := 1 to StrToInt(form2.Numero) do
    begin
      Fallos[c] := 0;
      Aciertos[c] := 0;
      ErrorABCD[c] := #0;
    end;
  { Ponemos que vaya al primer registro de la base de datos }
  SQLQuery1.First;
  { Activamos el boton de siguiente }
  SpeedButton1.Enabled := True;
  { Desactivamso el botón de Anterior }
  SpeedButton2.Enabled := False;
  { Invisilizar botones }
  Label8.visible := False; // visibilidad para respuestas correctas
  DBText8.visible := False; // visibilidad para las respestas correctas
  progressbar1.Visible := False; //invisibilizar la barra
  label13.Visible := False; // invisibilidad para la etiqueta de la barra de progreso
  imgLike.Visible := False; // invisibilidad imagen like
  imgUnLike.Visible := False; // invisibilidad imagen unlike
  { que actualice los resultados de los test }
  if form2.listbox1.SelCount = 1 then form2.listbox1.Click ;
  { Que vuelva a activar el botón de pausar el cronometro }
  btPausaCrono.Enabled := True;
  // Desactivamos base de datos para poder copiar importar, nuevas bases de mega y liberar memoria
  SQLQuery1.Close;
  IBConnection1.Connected := false;
  SQLTransaction1.Active := false;
end; {Desactivando formulario }

procedure TForm1.Label4Click(Sender: TObject);
begin
  ClickRespuestaA;
end;

procedure TForm1.Label4DblClick(Sender: TObject);
begin
  { Activar Botor next, con Doble Click }
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
    //Sleep(400); // pausa de 100 ms
    form1.SpeedButton1.Click ;
   end;
end;

procedure TForm1.Label4MouseLeave(Sender: TObject);
begin
  RetRatSobreResA;
end;

procedure TForm1.Label4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResA;
end;

procedure TForm1.Label5Click(Sender: TObject);
begin
  ClickRespuestaB;
end;

procedure TForm1.Label5DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
    //Sleep(400); // pausa de 100 ms
    form1.SpeedButton1.Click ;
   end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.Label5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResB;
end;

procedure TForm1.Label6Click(Sender: TObject);
begin
  ClickRespuestaC;
end;

procedure TForm1.Label6DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
     //Sleep(400); // pausa de 100 ms
     form1.SpeedButton1.Click ;
   end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.Label6MouseLeave(Sender: TObject);
begin
   RetRatSobreResC;
end;

procedure TForm1.Label6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
   MvRatSobreResC;
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
  ClickRespuestaD;
end;

procedure TForm1.Label7DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
   begin
     //Sleep(400); // pausa de 100 ms
     form1.SpeedButton1.Click ;
   end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.Label7MouseLeave(Sender: TObject);
begin
  RetRatSobreResD;
end;

procedure TForm1.Label7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  MvRatSobreResD;
end;

procedure PonerVerdeEtiquetasTestTerminado(Verde : char);
begin
  if Verde = 'A' then // pone en verde la etiqueta A una vez termiando el test
   begin
    form1.dbtext4.font.color := clGreen;
    form1.label4.font.color := clGreen;
   end;

  if Verde = 'B' then // pone en verde la etiqueta B una vez termiando el test
   begin
    form1.dbtext5.font.color := clGreen;
    form1.label5.font.color := clGreen;
   end;

  if Verde = 'C' then // pone en verde la etiqueta C una vez termiando el test
   begin
    form1.dbtext6.font.color := clGreen;
    form1.label6.font.color := clGreen;
   end;

  if Verde = 'D' then  // pone en verde la etiqueta D una vez termiando el test
   begin
    form1.dbtext7.font.color := clGreen;
    form1.label7.font.color := clGreen;
   end;

end; { PonerVerdeEtiquetasTestTerminado }

procedure PonerRojoEtiquetasTest(Rojo : char);
begin
  if Rojo = 'A' then
   begin
    form1.dbtext4.font.color := clRed;
    form1.label4.font.color := clRed;
   end;

  if Rojo = 'B' then
   begin
    form1.dbtext5.font.color := clRed;
    form1.label5.font.color := clRed;
   end;

  if Rojo = 'C' then
   begin
    form1.dbtext6.font.color := clRed;
    form1.label6.font.color := clRed;
   end;

  if Rojo = 'D' then
   begin
    form1.dbtext7.font.color := clRed;
    form1.label7.font.color := clRed;
   end;

end; { PonerRojoEtiquetasTest }

procedure MarcarErrorTestTerminado(Contador: integer);
begin
  DesactivarRespuestas;
  if ErrorABCD[Contador] = #0 then // Si no hay nada grabado en el ascci en esa posición de la matriz
   begin
     form1.imglike.Visible := true;
     form1.imgUnlike.Visible := false;
     case form1.DBText8.Caption of  // Pone en verde etiqueta A,B,C o D, según corresponda
       'A' : PonerVerdeEtiquetasTestTerminado('A');
       'B' : PonerVerdeEtiquetasTestTerminado('B');
       'C' : PonerVerdeEtiquetasTestTerminado('C');
       'D' : PonerVerdeEtiquetasTestTerminado('D');
     end;
   end
    else
   begin
     form1.imglike.Visible := false;
     form1.imgUnlike.Visible := true;
     case ErrorABCD[Contador] of  // Pone en rojo etiqueta A,B,C o D, según corresponda
       'A' : PonerRojoEtiquetasTest('A');
       'B' : PonerRojoEtiquetasTest('B');
       'C' : PonerRojoEtiquetasTest('C');
       'D' : PonerRojoEtiquetasTest('D');
     end;
     { Cuando hay un error, llamamos a marcar en verde la respuetas correcta }
     PonerVerdeEtiquetasTestTerminado(form1.DBText8.Caption[1]);
  end;
end; { MarcarErrorTestTerminado }

procedure TForm1.SpeedButton1Click(Sender: TObject); { Botón Siguiente }
const
  rA = 'A';
  rB = 'B';
  rC = 'C';
  rD = 'D';
var
  Respuesta : string[1];
  TextoRespuesta : string;
  c : integer;
  DirConfig  : string;
begin
  //Sleep(150);
  if FindeTest = False then  // Si no hemos realizado el test por completo empieza...
  begin
     Respuesta := SQLQuery1.FieldByName('Correcta').AsString ;

     if ((Respuesta = rA) and (respuestaA = True)) or
        ((Respuesta = rB) and (respuestaB = True)) or
        ((Respuesta = rC) and (respuestaC = True)) or
        ((Respuesta = RD) and (respuestaD = True)) then
     begin
        case Respuesta of
          rA :  TextoRespuesta := SQLQuery1.FieldByName('A').AsString;
          rB :  TextoRespuesta := SQLQuery1.FieldByName('B').AsString;
          rC :  TextoRespuesta := SQLQuery1.FieldByName('C').AsString;
          rD :  TextoRespuesta := SQLQuery1.FieldByName('D').AsString;
        end;
         //   while(not SQLQuery1.EOF)do begin
         // do something with the current record
        // move to the next record

    { Apunta del acierto en la etiquetea }
    if (contador < StrToInt(form2.numero)) then // Anteriormente := if (not SQLQuery1.EOF) then
      MensajeEmergente(Respuesta,TextoRespuesta) // Envía mensaje
    else
    begin     // Último Test de la serie
      IniciarCronometro := False; // Para maquinaria libera memoria crono
      btPausaCrono.Enabled := False; // Poner el boton deshabilitado
      btPausaCrono.Caption := ('&Pausar Cronometro');
      reporteAciertos;
      FinDeTest := True;  // señala el fin del test
      showmessage('Respuesta Correcta fin de serie test '+chr(10)+chr(10)+Respuesta+') '+TextoRespuesta);

      { Calculando porcentaje }
      for c := 1 to Contador do
       begin
         TotalAciertos := TotalAciertos + Aciertos[c];
         TotalFallos := TotalFallos + Fallos[c];
       end;
       progressbar1.visible := True;
       label13.Visible := True;
       Porcentaje := (TotalAciertos / StrToInt(form2.Numero))*100;
       //TotalAciertos := 0;
       Porcentaje := trunc(Porcentaje);
       label13.Caption := 'Porcentaje de aciertos: '+FloatToStr(Porcentaje)+' % / Nota: '+FloatToStr(Porcentaje/10);
       Progressbar1.Position := round(Porcentaje);
       //Porcentaje := 0;

       speedButton1.Enabled := false;
       DesactivarRespuestas;

      { Muestra las etiquetas de aciertos/ fallo respaso }
       Label8.Visible := True; // visibilidad para respuestas correctas
       DBText8.Visible := True; // visibilidad para las respestas correcta
       { Envía que chequee la última respuesta con like o unlike en las imagenes }
       MarcarErrorTestTerminado(Contador);
       { Para guardar los test guardados solo si se selecciono un item de momento}
       if form2.listBox1.Selcount = 1 then
        begin
          DirConfig := GetAppConfigDir(false);
          System.Assign (Arch, DirConfig + 'Testhechos.dat');
          Activar(Arch);
          Ampliar(Arch);
        end; { Para guardar los test guardados solo si se selecciono un item de momento}
    end;
  end;
    { Inicia el cronometro si hay seleccionada una repuesta y se pulsa el botón avanzar }
     if ((IniciarCronometro = False) and (respuestaA)) or ((IniciarCronometro = false) and (respuestaB))
      or ((IniciarCronometro = False) and (respuestaC)) or ((IniciarCronometro = false) and (respuestaD)) then
       btPausaCrono.click;

   { Respuestas equivocadas }
   if ((Respuesta <> rA) and (respuestaA = True)) then
      begin
       PonerRojoEtiquetasTest(rA);
       //showmessage('No es la repuesta correcta');
       { Desactivar una vez comprobado para que al pulsar no vuelva a salir }
       respuestaA := False;

       label14.Visible := True;
       reporteFallo(rA);
      end;
   if ((Respuesta <> rB) and (respuestaB = True)) then
     begin
        PonerRojoEtiquetasTest(rB);
        //showmessage('No es la repuesta correcta');
        { Desactivar una vez comprobado para que al pulsar no vuelva a salir }
        respuestaB := False;

        label14.Visible := True;
        reporteFallo(rB);
     end;
   if ((Respuesta <> rC) and (respuestaC = True)) then
     begin
      PonerRojoEtiquetasTest(rC);
      //showmessage('No es la repuesta correcta');
      { Desactivar una vez comprobado para que al pulsar no vuelva a salir }
      respuestaC := False;

      label14.Visible := True;
      reporteFallo(rC);
     end;
   if ((Respuesta <> rD) and (respuestaD = True)) then
     begin
      PonerRojoEtiquetasTest(rD);
      //showmessage('No es la repuesta correcta');
      { Desactivar una vez comprobado para que al pulsar no vuelva a salir }
      respuestaD := False;

      label14.Visible := True;
      reporteFallo(rD);
     end;
  //if (contador = StrToInt(form2.Numero)) and (correcta = True) then
  end  // Si es test esta terminado para moverse por los test
  else if (Contador < StrToInt(form2.numero)) then  // no dar para delante si esta al final
        begin
          Contador := Contador + 1;
          //Sleep(20);
          SQLQuery1.Next;
          SpeedButton2.Enabled := True;
          Label11.caption := IntToStr(Contador)+' de '+form2.Numero; // Escribe el número del test donde estamos
          if (Contador = StrToInt(form2.Numero)) then
            SpeedButton1.Enabled := False;
          { Para que marque los like unlike terminado el test }
          MarcarErrorTestTerminado(Contador);
        end;
end; { Botón Siguiente }

procedure TForm1.SpeedButton2Click(Sender: TObject);  { Botón Anterior }
begin
  //Sleep(400);
  if (Contador > 1) and (contador <= StrToInt(form2.Numero)) then
    begin
      if (Contador > PosicionAntesAnterior) then  // anota la marcha atras del boton y donde
        begin
          PosicionAntesAnterior := Contador;   // se quedo para volver a contar
          //Showmessage (IntToStr(PosicionAntesAnterior));
          PosicionAvance := False;
        end;

      Contador := Contador -1;
      DesactivarRespuestas; // Borra opciones elegidas anteriormente
      SQLQuery1.Prior;
    end;

  if (contador = 1) then
    begin
    SpeedButton2.Enabled := false;
    //timer1.Enabled := True;
    end;
  Label11.caption := IntToStr(Contador)+' de '+form2.Numero;

  if (not SQLQuery1.EOF) then
  //if (contador > 2 ) then
     SpeedButton1.Enabled := true;
  { para que retroceda bien al final del test }
  {if (Contador = StrToInt(form2.Numero)) and (FinDeTest = True) then
    begin
     showmessage(IntToStr(contador));
     Contador := Contador -1;
     DesactivarRespuestas; // Borra opciones elegidas anteriormente
     SQLQuery1.Prior;
    end;        }
    if (FinDeTest = true) then // Si el test esta terminado y damos a retroceder...
      MarcarErrorTestTerminado(Contador);

end; { Botón Anterior }

procedure TForm1.SpeedButton3Click(Sender: TObject); { Clicl boton Cerrar }
begin
  close;
end; { Clicl boton Cerrar }

procedure TForm1.DBText4MouseLeave(Sender: TObject);
begin
  RetRatSobreResA;
end;

procedure TForm1.DBText4Click(Sender: TObject); { ClickRespuestaA }
begin
  ClickRespuestaA;
end; { ClickRespuestaA }

procedure TForm1.DBText4DblClick(Sender: TObject);
begin
  if (form1.SpeedButton1.Enabled = True) and (FinDeTest = False) then
    begin
      //Sleep(400); // pausa de 100 ms
      form1.SpeedButton1.Click ;
    end;
end; { Activar Botor next, con Doble Click }

procedure TForm1.Button1Click(Sender: TObject);  { Botón de Busqueda provisional }
begin
  SQLQuery1.Close();
  SQLQuery1.SQL.text := 'SELECT * FROM TEST_INDIVIDUAL WHERE PREGUNTA LIKE '+ chr(39)+ '%'+ edit1.Text + '%'+chr(39);
  SQLQuery1.Open();
end; { Botón de Busqueda provisional }

procedure TForm1.DBText3Click(Sender: TObject);
begin

end;

procedure TForm1.btPausaCronoClick(Sender: TObject);  { Pausa Cronometro }
begin
  if IniciarCronometro then
    begin
      IniciarCronometro := false;
      btPausaCrono.Caption := ('&Iniciar Cronometro');
    end
     else
      begin
        IniciarCronometro := true;
        btPausaCrono.Caption := ('&Pausar Cronometro');
      end;
end; { Pausa Cronometro }

procedure TForm1.Timer1Timer(Sender: TObject);  { Temporizador }
var
  segFinal: string[2];
  minFinal: string[2];
  horFinal: string[2];
begin
  { Cronometro }
  if IniciarCronometro = True then //Arrancando el cronometro
  segundo := segundo + 1;

  if segundo > 59 then
  begin
    minuto := minuto + 1;
    segundo := 0;

    if minuto > 59 then
    begin
      hora := hora + 1;
      minuto := 0;
    end;
  end;
  { Mostrar Datos en etiqueta}
  segFinal := IntToStr(segundo);
  minFinal := IntToStr(minuto);
  horFinal := IntToStr(hora);
  if (segundo <= 9) then
    segFinal := '0' + IntToStr(segundo);

  if (minuto <= 9) then
    minFinal := '0' + IntToStr(minuto);

  if (hora <= 9) then
    horFinal := '0' + IntToStr(hora);


  l_cronometro.Caption := horFinal + ':' + minFinal + ':' + segFinal + ' ';
  { barra titulo form1 }
  form1.Caption := 'Correos2020-test - Tiempo transcurrido: ' + l_cronometro.Caption;
end; { Temporizador }


end.
