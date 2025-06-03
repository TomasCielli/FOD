{

Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados), 
agregándole una opción para realizar bajas copiando el último registro del archivo en la posición del registro a borrar 
y luego truncando el archivo en la posición del último registro de forma tal de evitar duplicados.

}

program ej01;

const
    FIN = 'fin';
    
type
    opciones = 0..8;
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

procedure listar_nombre(var archivo: archivo_e);
var
    e: empleado;
    encontro: boolean;
    palabra: str;

begin
    write('Nombre / Apellido: '); readln(palabra); writeln('');
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
    hay: boolean;
begin
    hay:= false;
    reset(archivo);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        writeln('Empleado #', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
        writeln(' ');
        hay:= true;
        leer(archivo, e);
    end;
    close(archivo);
    if (not hay) then writeln('No hay empleados cargados.')
end;

procedure listar_mayores(var archivo: archivo_e);
var
    e: empleado;
    hay: boolean;
begin
    hay:= false;
    reset(archivo);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        if (e.edad > 70) then begin
            writeln('Empleado #', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
            writeln(' ');
            hay:= true;
        end;
        leer(archivo, e);
    end;
    close(archivo);
    if (not hay) then writeln('No hay empleados cerca de jubilarse.');
end;



procedure aniadir_empleado(var archivo: archivo_e);

    procedure buscar(var archivo: archivo_e; var esta: boolean; emp: empleado);
    var
        e: empleado;
    begin
        seek(archivo, 0);
        esta:= false;
        leer(archivo, e);
        while ((e.apellido <> FIN) and (not esta)) do begin
            if (e.numero = emp.numero) then esta:= true;
            leer(archivo, e);
        end;
    end;

var
    cant: integer;
    e: empleado;
    esta: boolean;
begin
    cant:= 0;
    reset (archivo);
    leer_e(e);
    while (e.apellido <> fin) do begin
        buscar(archivo, esta, e);
        if (not esta) then begin
            seek(archivo, filesize(archivo));
            write(archivo, e);
            cant:= cant + 1;
        end
        else writeln('Ya existe un empleado con ese numero.');
        leer_e(e);
    end;
    close(archivo);
    writeln('Se cargaron un total de: ', cant, ' empleados.');
    writeln(' ');
end;

procedure modificar_edad(var archivo: archivo_e);
var
    numero, edad: integer;
    e: empleado;
    encontro: boolean;
begin
    write('Numero del empleado a modificar: '); readln(numero); writeln(' ');
    encontro:= false;
    reset(archivo);
    leer(archivo, e);
    while ((e.apellido <> FIN) and (not encontro)) do begin
        if (e.numero = numero) then begin
            write('Edad nueva: '); readln(edad); writeln(' ');
            e.edad:= edad;
            seek(archivo, filepos(archivo) - 1);
            write(archivo, e);
        end;
    end;
    if (not encontro) then writeln('No se encontro empleado con ese numero.');
    close(archivo);
end;

procedure exportar_todos(var archivo: archivo_e);
var
    e: empleado;
    texto: Text;
    vacio: boolean;

begin
    vacio:= true;
    assign(texto,'todos_empleados.txt');
    rewrite(texto);
    reset(archivo);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        writeln(texto, '#', e.numero, ': ', e.apellido, ' ', e.nombre, ', ', e.dni, ' (', e.edad, ' anios).');
        vacio:= false;
        leer(archivo,e);
    end;
    if (vacio) then writeln(texto, 'No hay empleados cargados.');
    close(texto);
    close(archivo);
end;

procedure exportar_0(var archivo: archivo_e);
var
    texto: Text;
    e: empleado;
    vacio: boolean;

begin
    vacio:= true;
    assign(texto, 'faltaDNIEmpleado.txt');
    reset(archivo);
    rewrite(texto);
    leer(archivo, e);
    while (e.apellido <> FIN) do begin
        if (e.dni = 0) then begin
            writeln(texto, '#', e.numero, ': ', e.apellido, ' ', e.nombre, ' (', e.edad, ' anios).');
            vacio:= false;
        end;
        leer(archivo, e);
    end;
    if (vacio) then writeln(texto, 'No hay empleados sin DNI.');
    close(texto);
    close(archivo);
end;

procedure eliminar_empleado(var a: archivo_e);
var
    e: empleado;
    pos: integer;
    ape: str;

begin
    write('Apellido del empleado que desea eliminar: '); readln(ape); writeln(' ');
    reset(a);

    leer(a, e);
    while (e.apellido <> FIN) and (e.apellido <> ape) do leer(a, e);
    if (e.apellido = ape) then begin
        if (filepos(a)-1 = filesize(a)-1) then begin
            seek(a, filepos(a)-1);
            truncate(a);
        end
        else begin
            pos:= filepos(a)-1;  //Guarda su posicion
            seek(a, filesize(a)-1);  //Va hasta el ultimo elemento
            read(a ,e);  //Lo lee

            seek(a, pos);  //Va a la posicion a eliminar
            write(a, e);   //La sobreescribe

            seek(a, filesize(a)-1);
            truncate(a);
        end;
    end
    else writeln('No se encontro el empleado con el apellido: ', ape);
    
    close(a);
end;


var
    opc: opciones;
    archivo: archivo_e;
    nomb_archivo: str;
    cant: integer;

begin
    
    write('Nombre del archivo: '); readln(nomb_archivo); writeln('');
    assign(archivo, nomb_archivo);

    reset(archivo);
    if (eof(archivo)) then begin
        cant:= 0;

        cargar_archivo(archivo, cant);

        writeln('Hay un total de: ', cant, ' empleados cargados.');
    end;
    close(archivo);

    repeat
        writeln('Opcion 0: Salir.');
        writeln('Opcion 1: Listar empleados con determinado nombre.');
        writeln('Opcion 2: Listar todos los empleados.');
        writeln('Opcion 3: Listar mayores de 70.');
        writeln('Opcion 4: Aniadir empleados.');
        writeln('Opcion 5: Modificar edad de un empleado.');
        writeln('Opcion 6: Exportar todos los empleados.'); 
        writeln('Opcion 7: Exportar empleados sin DNI.');
        writeln('Opcion 8: Eliminar empleado.');
        write('Opcion: '); readln(opc);
        writeln(' ');

        case opc of
            1:  listar_nombre(archivo);
            2:  listar_todo(archivo);
            3:  listar_mayores(archivo);
            4:  aniadir_empleado(archivo);
            5:  modificar_edad(archivo);
            6:  exportar_todos(archivo);
            7:  exportar_0(archivo);
            8:  eliminar_empleado(archivo);
        end;

    until (opc = 0)
End.