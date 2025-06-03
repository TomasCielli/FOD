{

El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. 

Para ello, genera un archivo maestro donde figuran todos  los  productos  que  comercializa.  

De  cada  producto  se  maneja  la  siguiente información: código de producto, 
                                                           nombre comercial, 
                                                           precio de venta, 
                                                           stock actual y 
                                                           stock mínimo. 

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 

De cada venta se registran: código de producto y 
                            cantidad de unidades vendidas. 

Resuelve los siguientes puntos:  

    a.  Se  pide  realizar  un  procedimiento  que  actualice  el  archivo  maestro  con el 
    archivo detalle, teniendo en cuenta que:
    
        i.  Los archivos no están ordenados por ningún criterio. 

        ii.  Cada registro del maestro puede ser actualizado por 0, 1 ó más registros 
        del archivo detalle.

    b.  ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que 
    cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del 
    archivo detalle?

}

program ej01;
const
    VALORALTO = 9999;

type

    str = string[40];

    producto = record
        codigo: integer;
        nombre: str;
        precio: real;
        stock: integer;
        stock_min: integer;
    end;

    a_productos = file of producto;

    venta = record
        codigo: integer;
        cantidad: integer;
    end;

    a_ventas = file of venta;

procedure leer(var a: a_productos; var p: producto);
begin
    if (not eof(a)) then read(a, p)
    else p.codigo:= VALORALTO;
end;

procedure buscar(var a: a_productos; c: integer; var pos: integer);
var
    p: producto;
begin
    seek(a, 0);
    leer(a, p);
    while (p.codigo <> VALORALTO) and (p.codigo <> c) do leer(a, p);
    if (p.codigo = c) then pos:= filepos(a) -1
    else pos:= -1;
end;

procedure actualizar_productos(var mae: a_productos; var det: a_ventas);
var
    pos: integer;
    v: venta;
    p: producto;
begin
    reset(det);
    reset(mae);
    while (not eof(det)) do begin
        read(det, v);
        buscar(mae, v.codigo, pos);
        if (pos <> -1) then begin
            seek(mae, pos);
            leer(mae, p);
            p.stock:= p.stock - v.cantidad;

            seek(mae, pos);
            write(mae, p);
        end
        else begin
            writeln('El producto #', v.codigo, ' no se encuentra en el listado de productos.');
            writeln('');
        end;
    end;
    close(det);
    close(mae);
end;


begin
    
end.