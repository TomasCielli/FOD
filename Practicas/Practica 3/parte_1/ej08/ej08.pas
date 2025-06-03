{

Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes. 

De cada distribución se conoce: nombre, 
                                año de lanzamiento, 
                                número de versión  del  kernel,  
                                cantidad  de  desarrolladores  y   
                                descripción.  

El  nombre  de  las distribuciones no puede repetirse. 

Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida. 

Escriba  la  definición  de  las  estructuras  de  datos  necesarias  y  los  siguientes 
procedimientos: 

    a.  BuscarDistribucion:  
            módulo  que  recibe  por  parámetro  el  archivo,  un 
            nombre de distribución y devuelve la posición dentro del archivo donde se 
            encuentra  el registro correspondiente a la distribución dada (si existe) o 
            devuelve -1 en caso de que no exista.. 

    b.  AltaDistribucion: 
            módulo que recibe como parámetro el archivo y el registro 
            que contiene los datos de una nueva distribución, y se encarga de agregar 
            la distribución   al archivo reutilizando espacio disponible en caso de que 
            exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). 
            En caso de que la distribución que se quiere agregar ya exista se debe 
            informar “ya existe la distribución”. 

    c.  BajaDistribucion:  
            módulo  que  recibe  como  parámetro  el  archivo  y  el 
            nombre de una distribución, y se encarga de dar de baja lógicamente la 
            distribución  dada.  Para  marcar una distribución como borrada se debe 
            utilizar el campo cantidad de desarrolladores para mantener actualizada 
            la lista invertida. Para verificar que la distribución a borrar exista debe utilizar 
            el  módulo  BuscarDistribucion.  En  caso  de  no  existir  se  debe  informar 
            “Distribución no existente”.

}

program ej08;

const
    VALORALTO = 9999;

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

procedure leer(var a: archivo_distribuciones; var d: distribucion);
begin
    if (not eof(a)) then read(a, d)
    else d.cantidad_desarrolladores:= VALORALTO;
end;

{a.  BuscarDistribucion:  
            módulo  que  recibe  por  parámetro  el  archivo,  un 
            nombre de distribución y devuelve la posición dentro del archivo donde se 
            encuentra  el registro correspondiente a la distribución dada (si existe) o 
            devuelve -1 en caso de que no exista.. }

procedure BuscarDistribucion (var a: archivo_distribuciones; nombre: str; var pos: integer);
var
    d: distribucion;
begin
    reset(a);
    leer(a, d);
    while (d.cantidad_desarrolladores <> VALORALTO) and (d.cantidad_desarrolladores > 0) and (d.nombre <> nombre) do leer(a, d);
    if (d.nombre = nombre) then pos:= filepos(a) -1
    else pos:= -1;
    close(a);
end;

{b.  AltaDistribucion: 
            módulo que recibe como parámetro el archivo y el registro 
            que contiene los datos de una nueva distribución, y se encarga de agregar 
            la distribución   al archivo reutilizando espacio disponible en caso de que 
            exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). 
            En caso de que la distribución que se quiere agregar ya exista se debe 
            informar “ya existe la distribución”. }

procedure AltaDistribucion (var a: archivo_distribuciones; d: distribucion);
var
    cabecera, eliminado: distribucion;
    pos: integer;
begin
    BuscarDistribucion(a, d.nombre, pos);
    if (pos = -1) then begin
        reset(a);
        leer(a, cabecera);
        if (cabecera.cantidad_desarrolladores = 0) then begin
            seek(a, filesize(a));
            write(a, d);
        end
        else begin
            seek(a, cabecera.cantidad_desarrolladores * -1);
            read(a, eliminado);
            cabecera.cantidad_desarrolladores:= eliminado.cantidad_desarrolladores;
            seek(a, cabecera.cantidad_desarrolladores * -1);
            write(a, d);

            seek(a, 0);
            write(a, cabecera);
        end;
        close(a);
    end
    else begin
        writeln('Ya existe la distribucion.'); writeln('');
    end;
end;

{c.  BajaDistribucion:  
            módulo  que  recibe  como  parámetro  el  archivo  y  el 
            nombre de una distribución, y se encarga de dar de baja lógicamente la 
            distribución  dada.  Para  marcar una distribución como borrada se debe 
            utilizar el campo cantidad de desarrolladores para mantener actualizada 
            la lista invertida. Para verificar que la distribución a borrar exista debe utilizar 
            el  módulo  BuscarDistribucion.  En  caso  de  no  existir  se  debe  informar 
            “Distribución no existente”.}

procedure BajaDistribucion(var a: archivo_distribuciones; nombre: str);
var
    pos: integer;
    d, cabecera: distribucion;
begin
    BuscarDistribucion(a, nombre, pos);
    if (pos <> -1) then begin
        reset(a);
        leer(a, cabecera);

        seek(a, pos);
        leer(a, d);
        d.cantidad_desarrolladores:= cabecera.cantidad_desarrolladores;
        seek(a, filepos(a) -1);
        write(a, d);

        seek(a, 0);
        cabecera.cantidad_desarrolladores:= pos * -1;
        write(a, cabecera);

        close(a);

    end
    else begin
        writeln('Distribucion no existente.'); writeln('');
    end;
end;

procedure LeerDist(var d: distribucion);
begin
    with d do begin
        write('Nombre (ZZZ para cancelar): '); readln(nombre);
        if (nombre <> 'ZZZ') then begin
            write('Anio: '); readln(anio);
            write('Version: '); readln(version);
            write('Cantidad de desarrolladores: '); readln(cantidad_desarrolladores);
            write('Descripcion: '); readln(descripcion);
        end;
    end;
end;

var
    a: archivo_distribuciones;
    opc: integer;
    d: distribucion;
    nombre: str;
begin
    assign(a, 'distribuciones');
    repeat
        writeln('');
        writeln('Opcion 0: Cerrar.');
        writeln('Opcion 1: Agregar Distribucion.');
        writeln('Opcion 2: Eliminar Distribucion.');
        write('Opcion: '); readln(opc); writeln('');

        if (opc < 0) or (opc > 2) then begin
            writeln('ERROR: Opcion no valida.');
            writeln('');
        end;

        case opc of
            1:  begin
                    LeerDist(d);
                    if (d.nombre <> 'ZZZ') then
                        AltaDistribucion(a, d);
                end;


            2:  begin
                    write('Distribucion que desea eliminar (nombre): '); readln(nombre); writeln('');
                    BajaDistribucion(a, nombre);
                end;
            end;

    until opc = 0
end.