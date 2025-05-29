{

2.  El encargado de ventas de un negocio de productos de limpieza desea administrar el stock 
de los productos que vende. 

Para ello, genera un archivo maestro donde figuran todos los productos que comercializa. 

De cada producto se maneja la siguiente información: código de producto, 
                                                     nombre comercial, 
                                                     precio de venta, 
                                                     stock actual y 
                                                     stock mínimo. 

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 

De cada  venta  se  registran:  código  de  producto  y  cantidad  de  unidades  vendidas.  

Se  pide realizar un programa con opciones para: 
    
    a.  Actualizar el archivo maestro con el archivo detalle, sabiendo que: 
        
        ●  Ambos archivos están ordenados por código de producto. 
        
        ●  Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del 
        archivo detalle. 
        
        ●  El archivo detalle sólo contiene registros que están en el archivo maestro. 
    
    b.  Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo 
    stock actual esté por debajo del stock mínimo permitido.

}

program ej02;

const VALORALTO = 9999;

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

procedure leer(var a: archivo_detalle; var v: venta);
begin
    if (not eof(a)) then read(a, v)
    else v.codigo := VALORALTO;
end;

procedure actualizar_maestro(var mae: archivo_maestro; var det: archivo_detalle);
var
    aux, total: integer;
    p: producto;
    v: venta;
begin
    reset(mae);
    reset(det);

    read(mae, p);
    leer(det, v);

    while (v.codigo <> VALORALTO) do begin
        aux:= v.codigo;
        total:= 0;
        while (aux = v.codigo) do begin
            total:= total + v.cant;
            leer(det, v);
        end;
        while (p.codigo <> aux) do read(mae, p);
        p.stock:= p.stock  - total;
        seek(mae, filepos(mae) -1);
        write(mae, p);
    end;

    close(mae);
    close(det);

end;

procedure listar_stock_bajo(var a: archivo_maestro);

procedure leer(var a: archivo_maestro; var p: producto);
begin
    if (not eof(a)) then read(a, p)
    else p.codigo := VALORALTO;
end;

var
    texto: text;
    p: producto;
begin
    
    assign(texto, 'stock_minimo.txt');
    reset(a);
    rewrite(texto);
    writeln(texto, 'Productos con poco stock:');
    writeln(texto, '');

    leer(a, p);
    while (p.codigo <> VALORALTO) do begin
        if (p.stock < p.stock_min) then
            writeln(texto, '#', p.codigo, '| ', p.nombre, ': $', p.precio:0:2, ' (', p.stock, '/', p.stock_min,')');
        leer(a, p);
    end;

    close(a);
    close(texto);
end;
var
    mae: archivo_maestro; det: archivo_detalle;
    opc: integer;
begin
    assign(mae, 'productos');
    assign(det, 'ventas');
    repeat
        writeln('Opcion 0: Cerrar.');
        writeln('Opcion 1: Actualizar maestro.');
        writeln('Opcion 2: Listar productos con poco stock.');
        write('Opcion: '); readln(opc); writeln('');
        case opc of 
            1: actualizar_maestro(mae, det);
            2: listar_stock_bajo(mae);
        end;
        if (opc < 0) or (opc > 2) then begin
            writeln('ERROR: Introduzca una opcion valida.');
            writeln('');
        end;
    until opc = 0
end.