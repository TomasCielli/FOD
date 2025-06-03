program crear_flores;

type
    reg_flor = record 
        nombre: String[45]; 
        codigo: integer; 
    end; 

    tArchFlores = file of reg_flor;

procedure crearArchivo(var a: tArchFlores);
var
    f: reg_flor;
    nombreArchivo: string;
begin
    write('Ingrese nombre del archivo (sin ".dat"): ');
    readln(nombreArchivo);
    assign(a, nombreArchivo); // sin .dat
    rewrite(a);
    
    // Escribimos la cabecera
    f.codigo := 0;
    f.nombre := '';
    write(a, f);

    close(a);
end;

procedure cargarFlores(var a: tArchFlores);
var
    f: reg_flor;
begin
    reset(a);
    seek(a, filesize(a)); // Apuntar después de la cabecera
    writeln('--- Ingrese flores ---');
    writeln('(codigo = 0 para terminar)');
    repeat
        write('Código: ');
        readln(f.codigo);
        if (f.codigo <> 0) then begin
            write('Nombre: ');
            readln(f.nombre);
            write(a, f);
        end;
    until (f.codigo = 0);
    close(a);
end;

var
    archivo: tArchFlores;
begin
    crearArchivo(archivo);
    cargarFlores(archivo);
    writeln('Archivo creado exitosamente!');
end.
