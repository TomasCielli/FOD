program generar_comisiones;

type
    str = string[30];
    
    comision = record
        codigo: integer;
        nombre: str;
        monto: real;
    end;

    archivo_comisiones = file of comision;

var
    arch: archivo_comisiones;
    c: comision;

begin
    assign(arch, 'comisiones');
    rewrite(arch);

    // Cargamos registros ordenados por código (como pide la consigna)
    // Empleado 1 (dos comisiones)
    c.codigo := 1; c.nombre := 'Juan Perez'; c.monto := 1500.0; write(arch, c);
    c.codigo := 1; c.nombre := 'Juan Perez'; c.monto := 3200.5; write(arch, c);

    // Empleado 2 (una sola comisión)
    c.codigo := 2; c.nombre := 'Ana Gomez'; c.monto := 2200.75; write(arch, c);

    // Empleado 3 (tres comisiones)
    c.codigo := 3; c.nombre := 'Luis Lopez'; c.monto := 1000.0; write(arch, c);
    c.codigo := 3; c.nombre := 'Luis Lopez'; c.monto := 800.25; write(arch, c);
    c.codigo := 3; c.nombre := 'Luis Lopez'; c.monto := 900.0; write(arch, c);

    // Empleado 4 (una comisión)
    c.codigo := 4; c.nombre := 'Carla Ruiz'; c.monto := 4000.0; write(arch, c);

    close(arch);

    writeln('Archivo de comisiones generado exitosamente (comisiones.dat).');
end.
