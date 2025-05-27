{

6.  Agregar al menú del programa del ejercicio 5, opciones para: 
a.  Añadir  uno  o  más  celulares  al final del archivo con sus datos ingresados por 
teclado. 
b.  Modificar el stock de un celular dado. 
c.  Exportar el contenido del archivo binario a un archivo de texto denominado: 
”SinStock.txt”, con aquellos celulares que tengan stock 0. 
 
NOTA: Las búsquedas deben realizarse por nombre de celular. 

}

program ej06;

const
    NOMBRE_TEXTO = 'celulares.txt';
    NOMBRE_STOCK = 'SinStock.txt';
    VALORALTO = 9999;

type
    opcion= 0..7;
    str= String[40];

    celular = record
        codigo: integer;
        nombre: str;
        descripcion: str;
        marca: str;
        precio: real;
        stock: integer;
        stock_min: integer;
    end;

    archivo_celular= file of celular;

procedure leer_celular(var archivo:archivo_celular; var c: celular);
begin
    if (not eof(archivo)) then read(archivo, c)
    else c.codigo := VALORALTO;
end;

procedure aniadir_celulares(var archivo: archivo_celular; var cargado: boolean);
    procedure leer_c(var c: celular);
    begin
        with c do begin
            write('Codigo (',VALORALTO,' para terminar): '); readln(codigo);
            if (codigo <> VALORALTO) then begin
                write('Nombre: '); readln(nombre);
                write('Marca: '); readln(marca);
                write('Descripcion: '); readln(descripcion);
                write('Precio: $'); readln(precio);
                write('Stock: '); readln(stock);
                write('Stock minimo: '); readln(stock_min);
                writeln(' ');
            end;
        end;
    end;

    procedure buscar (var archivo: archivo_celular; c: celular; var esta: boolean);
    var
        aux: celular;
    begin
        seek(archivo, 0);
        leer_celular(archivo, aux);
        while ((aux.codigo <> VALORALTO) and (not esta)) do begin
            if ((aux.codigo <> VALORALTO) and (aux.codigo = c.codigo)) then begin
                if ((aux.nombre = c.nombre) and (aux.descripcion = c.descripcion) and (aux.marca = c.marca)
                and (aux.precio = c.precio) and (aux.stock_min = c.stock_min)) then begin
                    esta:= true;
                    aux.stock := aux.stock + c.stock;
                    seek(archivo, filepos(archivo)-1);
                    write(archivo, aux);

                end
                else writeln('ERROR: Datos del celular no coinciden.');
            end
            else leer_celular(archivo, aux);
        end;
    end;
var
    c: celular;
    esta: boolean;
begin 
    if cargado then reset(archivo)
    else begin 
        rewrite(archivo);
        cargado:= true;
    end;

    leer_c(c);
    while (c.codigo <> VALORALTO) do begin
        esta:= false;
        buscar(archivo, c, esta);
        if (not esta) then write(archivo, c);
        leer_c(c);
    end;
    close(archivo);
end;

procedure cargar_del_texto(var archivo: archivo_celular; var cargado: boolean);
var
    c: celular;
    texto: text;
    aux: String;
begin
    assign(texto, NOMBRE_TEXTO);
    reset(texto);

    rewrite(archivo);

    cargado:= false;

    while (not eof(texto)) do begin
        readln(texto, c.codigo, c.precio, c.marca);
        readln(texto, c.stock, c.stock_min, c.descripcion);
        readln(texto, c.nombre);
        readln(texto, aux);

        write(archivo, c);
        cargado:= true;
    end;
    if (not cargado) then writeln('ERROR: El listado esta vacio.');
    close(texto);
    close(archivo);
end;

procedure mostrar_celular (c: celular);
begin
    with c do begin
        writeln('#', codigo, ' ', nombre, ' ', marca, ' (', descripcion, '): $', precio:0:2, ' (', stock, ' / ', stock_min, ')' );
        writeln(' ');
    end;
end;

procedure listar_stock_bajo(var archivo: archivo_celular; cargado: boolean);
var
    c: celular;
    aux: str;
begin
    if (cargado) then begin
        reset(archivo);
        leer_celular(archivo, c);
        while (c.codigo <> VALORALTO) do begin
            if (c.stock < c.stock_min) then mostrar_celular(c);
            leer_celular(archivo, c);
        end;
        close(archivo);
    end
    else begin
        write('No hay celulares cargados, desea cargar el archivo? (S/N): '); readln(aux); writeln(' ');
        if ((aux = 'S') or (aux = 's')) then aniadir_celulares(archivo, cargado);
    end; 
end;

procedure listar_descripcion(var archivo: archivo_celular; cargado: boolean);
var
    c: celular;
    d: str;
    aux: str;

begin
    if (cargado) then begin
        write('Descripcion que desea buscar: '); readln(d); writeln(' ');
        reset(archivo);
        
        leer_celular(archivo, c);
        while (c.codigo <> VALORALTO) do begin
            if (pos(d, c.descripcion) <> 0) then mostrar_celular(c);
            leer_celular(archivo,c);
        end;
        close(archivo);
    end
    else begin
        write('No hay celulares cargados, desea cargar el archivo? (S/N): '); readln(aux); writeln(' ');
        if ((aux = 'S') or (aux = 's')) then aniadir_celulares(archivo, cargado);
    end; 
end;

procedure exportar_texto(var archivo: archivo_celular; cargado: boolean);
var
    texto: text;
    c: celular;
    aux: str;
begin
    if (cargado) then begin
        assign(texto, NOMBRE_TEXTO);
        rewrite(texto);
        reset(archivo);

        leer_celular(archivo, c);
        while(c.codigo <> VALORALTO) do begin
            writeln(texto, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
            writeln(texto, c.stock, ' ', c.stock_min, ' ', c.descripcion);
            writeln(texto, c.nombre);
            writeln(texto,'');

            leer_celular(archivo,c);
        end;
        close(archivo);
        close(texto);
    end
    else begin
        write('No hay celulares cargados, desea cargar el archivo? (S/N): '); readln(aux); writeln(' ');
        if ((aux = 'S') or (aux = 's')) then aniadir_celulares(archivo, cargado);
    end; 
end;


procedure modificar_stock(var archivo: archivo_celular; cargado: boolean);
var
    c:celular;
    aux: str;
    codigo, cant: integer;
    encontre: boolean;

begin
    if (cargado) then begin
        encontre:= false;
        write('Codigo de telefono a modificar: '); readln(codigo); writeln();
        reset(archivo);
        
        leer_celular(archivo, c);
        while ((c.codigo <> VALORALTO) and (not encontre)) do begin
            if (c.codigo <> VALORALTO) and (c.codigo = codigo)then begin
                encontre:= true;
                write('Cuanto se modifica el stock'); readln(cant); writeln(' ');
                c.stock := c.stock + cant;

                seek(archivo,filepos(archivo) - 1);
                write(archivo, c);
                close(archivo);
            end
            else leer_celular(archivo, c)
        end;
    end
    else begin
        write('No hay celulares cargados, desea cargar el archivo? (S/N): '); readln(aux); writeln(' ');
        if ((aux = 'S') or (aux = 's')) then aniadir_celulares(archivo, cargado);
    end; 
end;

{c.  Exportar el contenido del archivo binario a un archivo de texto denominado: 
”SinStock.txt”, con aquellos celulares que tengan stock 0. }

procedure exportar_sin_stock(var archivo: archivo_celular; cargado: boolean);
var
    texto: Text;
    c: celular;
    aux: str;
begin
    if (cargado) then begin
        assign(texto, 'SinStock.txt');
        rewrite(texto);
        reset(archivo);
        
        leer_celular(archivo, c);
        write('Llegue');
        while (c.codigo <> VALORALTO) do begin
            if (c.stock = 0) then begin
                write('Llegue');
                writeln(texto, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
                writeln(texto, c.stock, ' ', c.stock_min, ' ', c.descripcion);
                writeln(texto, c.nombre);
                writeln(texto,'');
            end;
            leer_celular(archivo, c);
        end;
        close(texto);
    end
    else begin
        write('No hay celulares cargados, desea cargar el archivo? (S/N): '); readln(aux); writeln(' ');
        if ((aux = 'S') or (aux = 's')) then aniadir_celulares(archivo, cargado);
    end; 
end;

var
    opc: opcion;
    archivo: archivo_celular;
    nomb_archivo: str;
    cargado: boolean;

begin

    write('Nombre del archivo: '); readln(nomb_archivo); writeln(' ');
    assign(archivo, nomb_archivo);

    cargado:= false;

    repeat
        writeln('Opcion 0: Cerrar.');
        writeln('Opcion 1: Cargar del texto.');
        writeln('Opcion 2: Listar stock bajo.');
        writeln('Opcion 3: Listar por descripcion.');
        writeln('Opcion 4: Exportar a texto.');
        writeln('Opcion 5: Aniadir celulares.');
        writeln('Opcion 6: Modificar stock de un celular.');
        writeln('Opcion 7: Exportar a texto sin stock.');
        write('Opcion: '); readln(opc); writeln(' ');

        case opc of
            1: cargar_del_texto(archivo, cargado);
            2: listar_stock_bajo(archivo, cargado);
            3: listar_descripcion(archivo, cargado);
            4: exportar_texto(archivo, cargado);
            5: aniadir_celulares(archivo, cargado);
            6: modificar_stock(archivo, cargado);
            7: exportar_sin_stock(archivo, cargado);
        end;

    until (opc = 0);

End.