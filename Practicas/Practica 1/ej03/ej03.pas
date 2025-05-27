{

3.  Realizar un programa que presente un menú con opciones para: 

    a.  Crear un archivo de registros no ordenados de empleados y completarlo con 
    datos  ingresados  desde  teclado.  
    De  cada  empleado  se registra: número de empleado, 
                                     apellido, 
                                     nombre, 
                                     edad y 
                                     DNI. 
    Algunos empleados se ingresan con DNI 00. 
    La carga finaliza cuando se ingresa el String ‘fin’ como apellido. 
    
    b.  Abrir el archivo anteriormente generado y 

        i.  Listar en pantalla los datos de empleados que tengan un nombre o apellido 
        determinado, el cual se proporciona desde el teclado. 

        ii.  Listar en pantalla los empleados de a uno por línea.  

        iii.  Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse. 

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario. 

}

program ej03;

const
    FIN = 'fin';
    
type
    opciones = 0..3;
    str = String[40];

    empleado = record
        numero: integer;
        apellido: str;
        nombre: str;
        edad: integer;
        dni: integer;
    end;
    archivo_e = file of empleado;

procedure leer(var archivo: archivo_e; var e: empleado);
begin
    if (not eof(archivo)) then read(archivo, e)
    else e.apellido := FIN;
end;

procedure leer_e(var e: empleado);
begin
    with e do begin
        write('Apellido (escriba fin para terminar): '); readln(apellido);
        if (apellido <> FIN) then begin
            write('Nombre: '); readln(nombre);
            write('Numero: '); readln(numero);
            write('Edad: '); readln(edad);
            write('DNI: '); readln(dni);
            writeln(' ');
        end;
    end;
end;

procedure cargar_archivo(var archivo: archivo_e; var cant: integer);
var
    e: empleado;
begin
    rewrite(archivo);
    leer_e(e);
    while (e.apellido <> FIN) do begin
        write(archivo, e);
        cant:= cant + 1;
        leer_e(e);
    end;
    close(archivo);
end;

procedure listar_nombre(var archivo: archivo_e; palabra: str);
var
    e: empleado;
    encontro: boolean;

begin
    reset(archivo);
    encontro:= false;
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        if ((e.apellido = palabra) or (e.nombre = palabra)) then begin
            writeln('Empleado #', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
            writeln(' ');
            encontro := true;
        end;
        leer(archivo, e);
    end;
    if (not encontro) then write ('No se encontro empleado.');
    close(archivo);
end;

procedure listar_todo(var archivo: archivo_e);
var
    e: empleado;
begin
    reset(archivo);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        writeln('Empleado #', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
        writeln(' ');
        leer(archivo, e);
    end;
    close(archivo);
end;

procedure listar_mayores(var archivo: archivo_e);
var
    e: empleado;
begin
    reset(archivo);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        if (e.edad > 70) then begin
            writeln('Empleado #', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
            writeln(' ');
        end;
        leer(archivo, e);
    end;
    close(archivo);
end;

var
    opc: opciones;
    archivo: archivo_e;
    nomb_archivo, palabra: str;
    cant: integer;

begin
    cant:= 0;
    write('Nombre del archivo: '); readln(nomb_archivo); writeln('');
    assign(archivo, nomb_archivo);

    cargar_archivo(archivo, cant);

    writeln('Hay un total de: ', cant, ' empleados cargados.');

    repeat
        writeln('Opcion 0: Salir, Opcion 1: Listar empleados con determinado nombre ');
        writeln('Opcion 2: Listar todos los empleados, Opcion 3: Listar mayores de 70');
        write('Opcion: ');

        readln(opc);

        case opc of
            1:  begin
                    write('Nombre / Apellido: '); readln(palabra); writeln('');
                    listar_nombre(archivo, palabra);
                end;
            2:  listar_todo(archivo);
            3:  listar_mayores(archivo);
        end;

    until (opc = 0)
End.