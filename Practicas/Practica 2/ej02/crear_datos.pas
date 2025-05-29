program crear_datos;

type
    str = string[30];

    producto = record
        codigo: integer;
        nombre: str;
        precio: real;
        stock: integer;
        stock_min: integer;
    end;

    venta = record
        codigo: integer;
        cant: integer;
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of venta;

var
    mae: archivo_maestro;
    det: archivo_detalle;
    p: producto;
    v: venta;

begin
    assign(mae, 'productos');
    rewrite(mae);

    // Datos del archivo maestro (ordenados por código)
    p.codigo := 1;
    p.nombre := 'Detergente';
    p.precio := 120.50;
    p.stock := 50;
    p.stock_min := 20;
    write(mae, p);

    p.codigo := 2;
    p.nombre := 'Lavandina';
    p.precio := 80.00;
    p.stock := 30;
    p.stock_min := 10;
    write(mae, p);

    p.codigo := 3;
    p.nombre := 'Jabon Liquido';
    p.precio := 200.75;
    p.stock := 40;
    p.stock_min := 15;
    write(mae, p);

    p.codigo := 4;
    p.nombre := 'Limpiavidrios';
    p.precio := 150.00;
    p.stock := 25;
    p.stock_min := 10;
    write(mae, p);

    p.codigo := 5;
    p.nombre := 'Desinfectante';
    p.precio := 175.90;
    p.stock := 10;
    p.stock_min := 12;  // Este quedará por debajo del mínimo para testear
    write(mae, p);

    close(mae);

    // Ahora creamos el archivo detalle
    assign(det, 'ventas');
    rewrite(det);

    // Datos del archivo detalle (ventas del día, ordenadas por código)
    v.codigo := 1; v.cant := 5; write(det, v);
    v.codigo := 1; v.cant := 10; write(det, v);
    v.codigo := 2; v.cant := 15; write(det, v);
    v.codigo := 3; v.cant := 20; write(det, v);
    v.codigo := 5; v.cant := 5; write(det, v); // Dejará stock por debajo del mínimo

    close(det);

    writeln('Archivos creados correctamente.');
end.
