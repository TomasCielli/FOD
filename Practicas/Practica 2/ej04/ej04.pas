{

4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. 
De cada producto se almacena: código del producto, 
                              nombre, 
                              descripción, 
                              stock disponible, 
                              stock mínimo y 
                              precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 10 sucursales de la cadena. 

Se debe realizar el procedimiento que recibe los 10 detalles y actualiza el stock del archivo maestro. 

La información que se recibe en los detalles es: código de producto y cantidad vendida. 

Además, se deberá informar en un archivo de texto: nombre de producto, 
                                                   descripción, 
                                                   stock disponible y 
                                                   precio 
de aquellos productos que tengan stock disponible por debajo del stock mínimo. 

Pensar alternativas sobre realizar el informe en el mismo procedimiento de actualización, o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).
Rpta: Hacer el informe en el procedimiento de actualizacion esmas rapido ya que se lee una sola vez de memoria.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle puede venir 0 o N registros de un determinado producto.

}

program ej04;

const VALORALTO = 9999;
const CANTSUCURSALES = 10;

type
    str = string[30];
    rango_sucursales = 1..CANTSUCURSALES;

    producto = record
        codigo: integer;
        nombre: str;
        descripcion: str;
        stock: integer;
        stock_min: integer;
        precio: real;
    end;

    archivo_maestro = file of producto;

    reg_det = record
        codigo: integer;
        cantidad: integer;
    end;

    archivo_detalle = file of reg_det;

    detalles = array [rango_sucursales] of archivo_detalle;
    vector_rdet = array [rango_sucursales] of reg_det;

procedure leer (var a: archivo_detalle; var d: reg_det);
begin
    if (not eof(a)) then read(a, d)
    else d.codigo:= VALORALTO;
end;

procedure minimo(var vec_detalles: detalles; var vec: vector_rdet; var min: reg_det);
var
    i, indicemin: rango_sucursales;
    valormin: integer;
begin
    valormin:= VALORALTO;
    for i:= 1 to CANTSUCURSALES do begin
        if (vec[i].codigo <= valormin) then begin
            valormin:= vec[i].codigo;
            indicemin:= i;
        end;
    end;
    min:= vec[indicemin];
    leer(vec_detalles[indicemin], vec[indicemin]);
end;

procedure stock_bajo(p: producto; var texto: text);
begin
    if (p.stock < p.stock_min) then begin
        writeln(texto, '#', p.codigo,'| ', p.nombre, ': $', p.precio:0:2, ' (', p.stock, '/', p.stock_min, ')');
        writeln(texto,'Descripcion: ', p.descripcion);
        writeln(texto, '');
    end;
end;

procedure actualizar_maestro(var mae: archivo_maestro; var vec_detalles: detalles);
var
    vec_registros: vector_rdet;
    min: reg_det;
    i: rango_sucursales;
    aux, total: integer;
    regm: producto;
    texto: text;

begin
    assign(texto, 'stock_bajo.txt');
    rewrite(texto);
    reset(mae);
    read(mae, regm);

    for i:= 1 to CANTSUCURSALES do begin
        reset(vec_detalles[i]);
        leer(vec_detalles[i], vec_registros[i]);
    end;

    minimo(vec_detalles, vec_registros, min);
    while (min.codigo <> VALORALTO) do begin
        aux:= min.codigo;
        total:= 0;
        while (min.codigo = aux) do begin
            total:= total + min.cantidad;
            minimo(vec_detalles, vec_registros, min);
        end;
        while (not eof(mae)) and (regm.codigo <> aux) do read(mae, regm);
        regm.stock:= regm.stock - total;
        stock_bajo(regm, texto);
        seek(mae, filepos(mae) -1);
        write(mae, regm);
    end;

    close(texto);
    close(mae);
    for i:= 1 to CANTSUCURSALES do close(vec_detalles[i]);
end;

var
    mae: archivo_maestro;
    vec_detalles: detalles;

begin
    assign(mae, 'maestro');

    assign(vec_detalles[1],'detalle_1');
    assign(vec_detalles[2],'detalle_2');
    assign(vec_detalles[3],'detalle_3');
    assign(vec_detalles[4],'detalle_4');
    assign(vec_detalles[5],'detalle_5');
    assign(vec_detalles[6],'detalle_6');
    assign(vec_detalles[7],'detalle_7');
    assign(vec_detalles[8],'detalle_8');
    assign(vec_detalles[9],'detalle_9');
    assign(vec_detalles[10],'detalle_10');

    actualizar_maestro(mae, vec_detalles);
    
end.