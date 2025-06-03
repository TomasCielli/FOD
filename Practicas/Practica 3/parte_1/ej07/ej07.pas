{

Se cuenta con un archivo que almacena información sobre especies de aves en vía 
de extinción, para ello se almacena: código, 
                                     nombre de la especie, 
                                     familia de ave, 
                                     descripción y 
                                     zona geográfica. 

El archivo no está ordenado por ningún criterio. 

Realice un  programa  que  permita  borrar  especies  de  aves  extintas.  

Este  programa  debe disponer de dos procedimientos:  

    a.  Un procedimiento que dada una especie de ave (su código) marque la misma 
    como borrada (en caso de querer borrar múltiples especies de aves, se podría 
    invocar este procedimiento repetidamente). 

    b.  Un  procedimiento  que  compacte  el  archivo,  quitando  definitivamente  las 
    especies de aves marcadas como borradas.  Para quitar los registros se deberá 
    copiar el último registro del archivo en la posición del registro a borrar y luego 
    eliminar del archivo el último registro de forma tal de evitar registros duplicados. 

    i.  Implemente una variante de este procedimiento de compactación del 
    archivo (baja física) donde el archivo se trunque una sola vez. 

}

program ej07;

const
    VALORALTO = 9999;

type
    
    str = string[50];

    ave = record
        codigo: integer;
        nombre: str;
        familia: str;
        descripcion: str;
        zona: str;
    end;

    archivo_aves = file of ave;

    {a.  Un procedimiento que dada una especie de ave (su código) marque la misma 
    como borrada (en caso de querer borrar múltiples especies de aves, se podría 
    invocar este procedimiento repetidamente). }

procedure leer(var a: archivo_aves; var d: ave);
begin
    if (not eof(a)) then read(a, d)
    else d.codigo:= VALORALTO;
end;

procedure marcar_aves(var a: archivo_aves);
var
    c: integer;
    p: ave;
begin
    reset(a);
    write ('Codigo de ave que desea eliminar (0 para terminar): '); readln(c); writeln('');
    while (c <> 0) do begin
        seek(a, 0);
        leer(a, p);
        while (p.codigo <> VALORALTO) and (p.codigo <> c) do leer(a, p);
        if (p.codigo = c) then begin
            p.codigo:= p.codigo * -1;
            seek(a, filepos(a) -1);
            write(a, p);
        end
        else begin
            writeln('El codigo #', c, ' no pertenece a nigun ave del archivo.');
        end;
        write ('Codigo de ave que desea eliminar (0 para terminar): '); readln(c); writeln('');
    end;
    close(a);
end;

procedure compactar_archivo(var a:archivo_aves);
var 
    p: ave;
    ult_pos, pos: integer;

begin

    reset(a);  //Abre el archivo
    ult_pos:= filesize(a);  // Indice del último registro válido
    pos:= 0;  // Indice actual de lectura desde el inicio

    while (pos < ult_pos) do begin  //Mientras la posicion no llegue al final
        seek(a, pos);  //Me muevo a la posicion
        leer(a, p);  //Leo el ave
        if (p.codigo < 0) then begin //Si tiene codigo negativo (fue borrado)
            repeat
                ult_pos:= ult_pos - 1;  //Resto un de la ultima posicion
                seek(a, ult_pos);  //Voy a la nueva ultima posicion
                leer(a, p);  //Leo el ultimo elemento
            until (p.codigo >= 0) or (pos >= ult_pos);  //Hasta que el que lea tenga o un codigo positivo, o se termine el archivo (pos alcance la ultima posicion)

            if (pos < ult_pos) then begin  //Si no se termino el archivo (pos no alcanzo la ultima posicion)
                seek(a, pos);  //Va a pos
                write(a, p);  //Escribe el ultimo elemnto
            end;
        end;
        pos:= pos +1;  //Incrementa pos
    end;
    seek(a, ult_pos);  //Una vez recorrio todo el archivo, va al ultimo elemento
    truncate(a);  //Borra todo lo que este al final (ultima posicion, no del archivo))
    close(a);  //Cierra el archivo
end;

procedure mostrar_aves(var a: archivo_aves);
var
    p: ave;
begin
    reset(a);
    writeln('LISTADO DE AVES EN EL ARCHIVO:');
    writeln('------------------------------');
    while not eof(a) do begin
        read(a, p);
        if (p.codigo < 0) then
            writeln('🟥 [ELIMINADA] Codigo: ', -p.codigo, ', Nombre: ', p.nombre, ', Familia: ', p.familia,
                    ', Zona: ', p.zona)
        else
            writeln('🟩 [ACTIVA]    Codigo: ', p.codigo, ', Nombre: ', p.nombre, ', Familia: ', p.familia,
                    ', Zona: ', p.zona);
    end;
    close(a);
    writeln('------------------------------');
end;


var
    a: archivo_aves;

begin
    assign(a, 'aves');

    mostrar_aves(a);
    writeln('');
    writeln('');

    marcar_aves(a);
    mostrar_aves(a);
    writeln('');
    writeln('');

    compactar_archivo(a);
    mostrar_aves(a);
end.