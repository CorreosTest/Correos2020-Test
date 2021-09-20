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

program ModificarResultadosTest;
{$mode objfpc}{$H+}
{$IFDEF WINDOWS}
  {$codepage cp1252}
{$ENDIF}
uses
  {$IFDEF WINDOWS}
    lazutils,windows, crt, sysutils, Classes;
  {$ENDIF}
  {$IFDEF LINUX}
   crt, sysutils, Classes;
  {$ENDIF}

type
  Cadena255 = string[255];
  TestHecho = record
     NombreTest        : cadena255;
     Fecha             : string[19];
     Tiempo            : string[8];
     Aciertos          : integer;
     Fallos            : integer;
     Porcentaje        : integer;
     Interruptor       : boolean;
  end;

  Fichero = file of TestHecho;

var
  Archivo      : Fichero;
  DirConfig    : String;
  DirReal      : String;
  Numero       : byte;
  Barra        : char;
  {$IFDEF LINUX}
    NombreApp    : String;
    LongitudDir  : Byte;
    DirUnix      : string;
  {$ENDIF}
 procedure PulsarTecla;
 var
   tecla : char;
 begin
    GotoXY(21,23);
    TextColor(LightBlue);
    Writeln ('Pulsar cualquier tecla para continuar.');
    tecla := ReadKey;
    TextColor(White);
    ClrScr;
 end;   // PulsarUnaTecla

 procedure Activar (var F:Fichero);
 var
   Resultado : integer;
 begin
   ClrScr;
   {$I-}
   System.Reset (F);
   Resultado := System.IOresult;
   {$I+}
   if Resultado <> 0 then
      System.Rewrite (F);
   System.Close (f)
end; // Activar

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
var
 resultado : string[3];
 UTFaString : string;
begin
  with T do
    if T.Interruptor then
       begin
         resultado := FloatToStr(Porcentaje / 10 );
         {$IFDEF WINDOWS}
           UTFaString := UTF8toANSI(NombreTest);
         {$ENDIF}
         {$IFDEF LINUX}
           UTFaString := NombreTest;
         {$ENDIF}
         TextColor(Green);
         GotoXY (5,2);     Write ('Nombre Test:');
         TextColor(Brown);
         GotoXY (7,3);     Write (UTFaString);
         TextColor(Green);
         GotoXY (5,5);     Write ('Aciertos Test:');
         TextColor(Brown);
         GotoXY (7,6);     Write (Aciertos);
         TextColor(Green);
         GotoXY (5,8);     Write ('Fallos Test:');
         TextColor(Brown);
         GotoXY (7,9);     Write (Fallos);
         TextColor(Green);
         GotoXY (5,11);    Write ('Fecha Test:');
         TextColor(Brown);
         GotoXY (7,12);    Write (Fecha);
         TextColor(Green);
         GotoXY (5,14);    Write ('Porcentaje:');
         TextColor(Brown);
         GotoXY (7,15);    Write (Porcentaje,' %');
         TextColor(Green);
         GotoXY (5,17);    Write ('Nota:');
         TextColor(Brown);
         GotoXY (7,18);    Write (resultado);
         TextColor(Green);
         GotoXY (5,20);    Write   ('Tiempo transcurrido:');
         TextColor(Brown);
         GotoXY (7,21);    Write (Tiempo);
       end;
     PulsarTecla;
end; // Ver

procedure RecogerRegistro (var T: TestHecho);
var
 UTF8Archivo: string;
begin
  with T do
    begin
      TextColor(Green);
      GotoXY (20,9); Write ('Nombre Test : ');
      TextColor(White);
      {$IFDEF WINDOWS}
        ReadLn (UTF8Archivo);
        NombreTest := ANSItoUTF8(UTF8Archivo);
      {$ENDIF}
      {$IFDEF LINUX}
        ReadLn (NombreTest);
      {$ENDIF}
      TextColor(Green);
      GotoXY (20,10); Write ('Aciertos Test : ');
      TextColor(White);
      ReadLn (Aciertos );
      TextColor(Green);
      GotoXY (20,11); Write ('Fallos Test : ');
      TextColor(White);
      Readln (Fallos);
      TextColor(Green);
      GotoXY (20,12); Write ('Fecha Test : ');
      TextColor(White);
      ReadLn (Fecha);
      TextColor(Green);
      GotoXY (20,13); Write ('Porcentaje : ');
      TextColor(White);
      ReadLn (Porcentaje);
      TextColor(Green);
      GotoXY (20,14); Write ('Tiempo transcurrido : ');
      TextColor(White);
      ReadLn(Tiempo);
      Interruptor := true;
    end;
  PulsarTecla;
end; // Leer Registro

procedure ListadoTodosRegistrados (var F: fichero);
var
  T : TestHecho;
begin
  System.Reset (F);
  while not Eof(F) do
   begin
     ClrScr;
     TextColor(LightBlue);
     GotoXY(35,1); Write ('Registro : ');
     TextColor(White);
     WriteLn (System.FilePos (F) + 1 : 1);
     System.Read (F,T);
     if T.Interruptor then
       Ver (T)
     else
       begin
         GotoXY (34, 12);
         TextColor(Brown);
         WriteLn ('Registro vacio.');
         PulsarTecla;;
       end;
    end;
   System.Close (F);
end; // Listado Total

procedure Ampliar (var F: Fichero);
var
  R, T : TestHecho;
  I    : integer;      { Posición del registro en el archivo }
begin
  ClrScr;
  TextColor(Green);
  GotoXY (25,2); WriteLn ('Estas en el menú de altas.');
  System.Reset (F);
  TextColor(LightBlue);
  GotoXY (8,4);
  WriteLn ('Pulse cualquier tecla, excepto -[n] o [N]- que se utilizan para Salir');
  while Upcase (Readkey) <> 'N' do
    begin
     ClrScr;
       GotoXY (20,7);
       TextColor(Brown);
       WriteLn ('Introduzca los datos del nuevo registro.');
       RecogerRegistro (T);
       I := Posicion (T.NombreTest, F);
       if I= -1 then
         begin
           I := System.FileSize (F);
           System.Seek (F, I);
           System.Write (F, T);
         end
       else
         begin
           System.Seek (F, I);
           System.Read (F, R);
           if R.Interruptor then
            begin
              GotoXY (20,21);
              WriteLn ('El elemento ya existe.');
           end
         else
           Write (F, T);
         end;
       GotoXY (15, 12);
       TextColor(LightBlue);
       WriteLn ('Pulse - [n] o [N] - si quiere salir de la opción altas.');
    end;
   System.Close (f);
end; // Ampliar

procedure Borrar (var F : Fichero);
var
  T : TestHecho;
  C : Cadena255;
  I : integer;
begin
  System.Reset (F);
  repeat
    ClrScr;
    GotoXY (24,2);
    TextColor(Green);
    WriteLn ('Estas en la opción de bajas.');
    System.Reset (F);
    GotoXY (20,4);
    TextColor(LightBlue);
    WriteLn ('Introduce el nombre del Test a borrar.');
    WriteLn;
    TextColor(White);
    ReadLn (C);
    {$IFDEF WINDOWS}
      C := ANSItoUTF8(C);
    {$ENDIF}
    I := Posicion (C, F);
    if I = -1 then
      begin
        GotoXY (20, 11);
        TextColor(Brown);
        WriteLn ('No existe el nombre del Test buscado.');
      end
    else
      begin
        System.Seek (F, I);
        System.Read (F, T);
        if T.Interruptor then
          begin
            ClrScr;
            Ver (T);
            T.Interruptor := false;
            I := System.FilePos (F) - 1;
            System.Seek (F,I);
            System.Write (F,T);
          end;
         GotoXY (24, 11);
         TextColor(Brown);
         WriteLn ('El registro fue dado de baja.');
        end;
      PulsarTecla;
      GotoXY (20,11);
      TextColor(LightBlue);
      WriteLn ('Pulse - [n] o [N] - para salir de opción bajas.');
   until UpCase (Readkey) = 'N';
   System.close (F)
end; // Borrar

procedure Modificar (var F: Fichero);
var
  T : TestHecho;
  C : Cadena255;
  I : integer;
begin
  System.Reset (F);
  repeat
    ClrScr;
    GotoXY (25,2);
    TextColor(Green);
    WriteLn ('Esta en la opción de modificaciones.');
    GotoXY (23,4);
    TextColor(LightBlue);
    WriteLn ('Introce el nombre del Test a modificar.');
    TextColor(White);
    ReadLn(C);
    {$IFDEF WINOWS}
      C := ANSItoUTF8 (C);
    {$ENDIF}
    I := Posicion (C,F);
    if I = -1 then
      begin
        GotoXY (23,11);
        TextColor(Brown);
        WriteLn ('No existe el nombre de Test buscado.');
      end
    else
      begin
        System.Seek (F, I);
        System.Read (F, T);
        if T.Interruptor then
          begin
           ClrScr;
            Ver(T);
            GotoXY (20, 7);
            TextColor(LightBlue);
            WriteLn ('Introduzca nuevos datos del registro.');
            RecogerRegistro (T);
            I := System.FilePos (F) - 1;
            System.Seek (F, I);
            System.Write (F,T);
            GotoXY (30, 11);
            TextColor(Brown);
            WriteLn ('Registro modificado.');
          end
         else
           begin
             GotoXY (24,11);
             TextColor(Brown);
             WriteLn ('El registro fue dado de baja.');
           end;
      end;
    PulsarTecla;
    GotoXY (15,12);
    TextColor(LightBlue);
    WriteLn ('Pulse - [n] o [N] - para salir de la opción de modificaciones.');
   until UpCase (Readkey) = 'N';
   System.Close (F);
end; // Modificar

procedure Consultar (var F: Fichero);
var
  T : TestHecho;
  C : Cadena255;
  I : integer;
begin
  System.Reset (F);
  repeat
    ClrScr;
    GotoXY (25,2);
    TextColor(Green);
    WriteLn ('Estas en la opción de consultas.');
    GotoXY (21,4);
    TextColor(LightBlue);
    WriteLn ('Introduzca nombre del Test a consultar.');
    TextColor(White);
    ReadLn(C);
    {$IFDEF WINDOWS}
      C := ANSItoUTF8(C);
    {$ENDIF}
    I := Posicion (C,F);
    if I = -1 then
      begin
        GotoXY (20,11);
        TextColor(LightBlue);
        WriteLn ('No existe el nombre que desea consultar.');
      end
    else
      begin
        System.Seek (F, I);
        System.Read (F, T);
        if T.Interruptor then
          begin
            ClrScr;
            Ver (T);
          end
        else
          begin
            GotoXY (20,11);
            WriteLn ('El registro fue dado de baja.');
            PulsarTecla;
          end;
      end;
    GotoXY (15,12);
    TextColor(LightBlue);
    WriteLn ('Pulse - [n] o [N] - para salir de opción de consultas.');
  until UpCase (Readkey) = 'N';
  System.Close (F);
end; // Consultar

procedure AcercaDe;
begin
  repeat
    Clrscr;
    GotoXY(20,8);
    TextColor (White);
    write ('Dios con nosotros.');

    GotoXY(20,10);
    TextColor(Green);
    write ('Programa para la consolidación de Correos.');

    GotoXY (20,16);
    TextColor (LightBlue);
    Write ('Pulse - [n] o [N] - para salir de Acerca.');
  until UpCase(Readkey) = 'N';
end; // Acerca de

procedure Menu (var F: Fichero);
var
  Opcion : char;
begin
  repeat
    ClrScr;
    TextColor(Green);
    GotoXY (35,2);  WriteLn ('Menu Principal');
    TextColor(Blue);
    GotoXY (25,7);  WriteLn ('1) Ampliar Test Hechos.');
    TextColor(Brown);
    GotoXY (25,9);  WriteLn ('2) Borrar Registros de Test hechos.');
    TextColor(Blue);
    GotoXY (25,11);  WriteLn ('3) Modificar Test Hechos.');
    TextColor(Brown);
    GotoXY (25,13); WriteLn ('4) Consultar un Test.');
    TextColor(Blue);
    GotoXY (25,15); WriteLn ('5) Listar Todos los Test.');
    TextColor(Brown);
    GotoXY (25,17); WriteLn ('6) Acerca de.');
    TextColor(Blue);
    GotoXY (25,19); WriteLn ('7) Salir.');
    TextColor(Green);
    GotoXY (22,22); Write ('Elija una opción pulsando: ' );
    TextColor(White); Write ('1,2,3,4,5,6 y 7.');
    repeat
      Opcion := Readkey;
    until Opcion in ['1'..'7'];
    ClrScr;
    case Opcion of
      '1': Ampliar (F);
      '2': Borrar (F);
      '3': Modificar (F);
      '4': Consultar (F);
      '5': ListadoTodosRegistrados (F);
      '6': AcercaDe;
    end;
  until Opcion = '7';
end;   // Menú

{$R *.res}

begin
  { Pograma principal }
  {$IFDEF WINDOWS}
    SetConsoleOutputCP(1252);
    SetConsoleCP(1252);
    Barra := '\';
  {$ENDIF}

  {$IFDEF LINUX}
    Barra := '/';
    NombreApp := ApplicationName;
    LongitudDir := length(NombreApp);
    DirUnix := GetAppConfigDir(false);
    LongitudDir := LongitudDir + 1;
    Delete(DirUnix,Length(DirUnix)-LongitudDir,LongitudDir+1);
    if not DirectoryExists(DirUnix) then
     if Not CreateDir(DirUnix) then
       write ('No se pudo crear el directorio '+DirUnix);
  {$ENDIF}


  ClrScr;

  DirConfig := GetAppConfigDir(false);
  Numero := Length(DirConfig)-23;
  DirReal := Dirconfig;
  Delete(DirReal,Numero,length(DirConfig));
  DirConfig := DirReal + 'Correos2020-Test' + Barra;
   if not DirectoryExists(DirConfig) then
    if Not CreateDir(DirConfig) then
      Write ('No se pudo crear el directorio '+DirConfig);

  Assign (Archivo, DirConfig + 'Testhechos.dat');
  Activar(Archivo);
  Menu (Archivo)
end.
