{

5.  Realizar  un  programa  para  una  tienda  de  celulares,  que  presente  un  menú  con 
opciones para: 
    
    a.  Crear un archivo de registros no ordenados de celulares y cargarlo con datos 
    ingresados desde un archivo de texto denominado “celulares.txt”. Los registros 
    correspondientes a los celulares deben contener: código de celular, 
                                                     nombre, 
                                                     descripción, 
                                                     marca, 
                                                     precio, 
                                                     stock mínimo y 
                                                     stock disponible. 
    
    b.  Listar en pantalla los datos de aquellos celulares que tengan un stock menor al 
    stock mínimo. 
    
    c.  Listar  en  pantalla  los  celulares  del  archivo  cuya  descripción  contenga  una 
    cadena de caracteres proporcionada por el usuario. 
    
    d.  Exportar el archivo creado en el inciso a) a un archivo de texto denominado 
    “celulares.txt” con todos los celulares del mismo. El archivo de texto generado 
    podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que 
    debería respetar el formato dado para este tipo de archivos en la NOTA 2. 
 
NOTA  1:  El  nombre  del  archivo  binario  de  celulares debe ser proporcionado por el 
usuario. 

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique 
en tres  líneas consecutivas. En la primera se especifica: código de celular,  el precio y marca, 
                              en la segunda el stock disponible, stock mínimo y la descripción y 
                              en la tercera nombre  en  ese  orden.  
Cada  celular  se  carga  leyendo  tres  líneas  del  archivo “celulares.txt”. 

}

program ej05;

const
    NOMBRE_TEXTO = 'celulares.txt';
    VALORALTO = 9999;

type
    opcion= 0..4;
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
        writeln('ERROR: El archivo no esta cargado.');
        writeln(' ');
    end;
end;

procedure listar_descripcion(var archivo: archivo_celular; cargado: boolean);
var
    c: celular;
    d: str;

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
        writeln('ERROR: El archivo no esta cargado.');
        writeln(' ');
    end;
end;

procedure exportar_texto(var archivo: archivo_celular; cargado: boolean);
var
    texto: text;
    c: celular;
begin
    if (cargado) then begin
        assign(texto, NOMBRE_TEXTO);
        rewrite(texto);
        reset(archivo);

        leer_celular(archivo, c);
        while(c.codigo <> VALORALTO) do begin
            writeln(texto, c.codigo, ' ', c.precio, ' ', c.marca);
            writeln(texto, c.stock, ' ', c.stock_min, ' ', c.descripcion);
            writeln(texto, c.nombre);

            leer_celular(archivo,c);
        end;
        close(archivo);
        close(texto);
    end
    else begin
        writeln('ERROS: El archivo no esta cargado.');
        writeln(' ');
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
        write('Opcion: '); readln(opc); writeln(' ');

        case opc of
            1: cargar_del_texto(archivo, cargado);
            2: listar_stock_bajo(archivo, cargado);
            3: listar_descripcion(archivo, cargado);
            4: exportar_texto(archivo, cargado);
        end;

    until (opc = 0);

End.