program CrearArchivoDistribuciones;

type
    str = string[50];

    distribucion = record
        nombre: str;
        anio: str;
        version: str;
        cantidad_desarrolladores: integer;
        descripcion: str;
    end;

    archivo_distribuciones = file of distribucion;

var
    a: archivo_distribuciones;
    d: distribucion;

procedure AgregarDistribucion(nombre, anio, version: str; cant_dev: integer; desc: str);
begin
    d.nombre := nombre;
    d.anio := anio;
    d.version := version;
    d.cantidad_desarrolladores := cant_dev;
    d.descripcion := desc;
    write(a, d);
end;

begin
    assign(a, 'distribuciones');
    rewrite(a);

    // Cabecera: cantidad_desarrolladores = 0 indica que la lista libre está vacía
    d.nombre := 'CABECERA';
    d.anio := '';
    d.version := '';
    d.cantidad_desarrolladores := 0; // Lista libre vacía
    d.descripcion := '';
    write(a, d);

    // Algunos registros de ejemplo
    AgregarDistribucion('Ubuntu', '2004', '5.15', 1500, 'Distribucion basada en Debian');
    AgregarDistribucion('Fedora', '2003', '6.1', 1200, 'Distribucion patrocinada por Red Hat');
    AgregarDistribucion('Arch', '2002', '6.9', 300, 'Distribucion rolling release');
    AgregarDistribucion('Debian', '1993', '5.10', 1000, 'Distribucion madre de muchas otras');
    
    close(a);
    writeln('Archivo creado y cargado con distribuciones.');
end.
