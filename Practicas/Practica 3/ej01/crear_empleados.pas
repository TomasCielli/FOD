program crear_empleados;

type
    str = string[40];

    empleado = record
        numero: integer;
        apellido: str;
        nombre: str;
        edad: integer;
        dni: integer;
    end;

    archivo_e = file of empleado;

procedure crearArchivo(const nombre: str);
var
    archivo: archivo_e;
    e: empleado;
begin
    assign(archivo, nombre);
    rewrite(archivo);

    // Empleado 1
    e.numero := 1;
    e.apellido := 'Gomez';
    e.nombre := 'Juan';
    e.edad := 45;
    e.dni := 12345678;
    write(archivo, e);

    // Empleado 2
    e.numero := 2;
    e.apellido := 'Perez';
    e.nombre := 'Maria';
    e.edad := 72;
    e.dni := 87654321;
    write(archivo, e);

    // Empleado 3
    e.numero := 3;
    e.apellido := 'Lopez';
    e.nombre := 'Carlos';
    e.edad := 60;
    e.dni := 0;
    write(archivo, e);

    // Empleado 4
    e.numero := 4;
    e.apellido := 'Martinez';
    e.nombre := 'Ana';
    e.edad := 30;
    e.dni := 11223344;
    write(archivo, e);

    // Empleado 5
    e.numero := 5;
    e.apellido := 'Sanchez';
    e.nombre := 'Luis';
    e.edad := 69;
    e.dni := 99887766;
    write(archivo, e);

    close(archivo);
    writeln('Archivo "', nombre, '" creado con 5 empleados.');
end;

var
    nombreArchivo: str;
begin
    write('Ingrese el nombre del archivo a crear (sin ".dat"): ');
    readln(nombreArchivo);
    crearArchivo(nombreArchivo);
end.
