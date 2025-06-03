{

Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con 
la información correspondiente a las prendas que se encuentran a la venta.
 De cada prenda  se  registra:  cod_prenda,  
                                descripción,  
                                colores,  
                                tipo_prenda,  
                                stock  y 
                                precio_unitario.  

Ante  un  eventual  cambio  de  temporada,  se  deben  actualizar  las prendas  a la venta. 

Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas. 

Deberá implementar un procedimiento que reciba ambos archivos y  realice la baja lógica de las prendas, 

para ello deberá modificar el stock de la prenda correspondiente a valor negativo. 

Adicionalmente,  deberá  implementar  otro  procedimiento  que  se  encargue  de 
efectivizar  las  bajas  lógicas  que  se  realizaron  sobre  el  archivo  maestro  con  la 
información  de  las  prendas  a  la  venta.

Para  ello  se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo),  
en el cual se copien únicamente aquellas prendas que no están marcadas como borradas. 

Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro 
original. 

}

program ej06;

const VALORALTO = 9999;

type

    str = string[40];

    prenda = record
        codigo: integer;
        descripcion: str;
        colores: str;
        tipo: str;
        stock: integer;
        precio: real;
    end;

    a_prendas = file of prenda;
    a_codigos = file of integer;

procedure leer_prenda(var a: a_prendas; var p: prenda);
begin
    if (not eof(a)) then read(a, p)
    else p.codigo:= VALORALTO;
end;

procedure leer_codigo(var a: a_codigos; var c:integer);
begin
    if (not eof(a)) then read(a, c)
    else c:= VALORALTO;
end;

procedure eliminar_prendas(var prendas: a_prendas; var codigos: a_codigos);
var
    p: prenda;
    c: integer;
begin
    reset(prendas);
    reset(codigos);

    leer_codigo(codigos, c);
    while (c <> VALORALTO) do begin
        seek(prendas, 0);
        leer_prenda(prendas, p);
        while(p.codigo <> VALORALTO) and (p.codigo <> c) do leer_prenda(prendas, p);
        if (p.codigo = c) then begin
            if (p.stock >= 0) then
                p.stock := -1;

            seek(prendas, filepos(prendas) -1);
            write(prendas, p); 
        end
        else begin
            writeln ('El codigo #', c, ' no se encuentra en el archivo.'); writeln('');
        end;
        leer_codigo(codigos, c);
    end;
    close(prendas); close(codigos);
    writeln('Prendas eliminadas.'); writeln('');
end;

procedure compactar_archivo (var prendas: a_prendas);
var
    p: prenda;
    prendas_act: a_prendas;
begin
    reset (prendas);

    assign(prendas_act, 'auxiliar');
    rewrite(prendas_act);

    leer_prenda(prendas, p);
    while (p.codigo <> VALORALTO) do begin
        if (p.stock >= 0) then
            write(prendas_act, p); 
        leer_prenda(prendas, p);
    end;

    close(prendas);
    close(prendas_act);

    rename(prendas, 'viejas');
    rename(prendas_act, 'prendas');


    writeln('Archivo compactado.'); writeln('');
end;








var
    prendas: a_prendas;
    codigos: a_codigos;

begin
    assign(prendas, 'prendas');
    assign(codigos, 'codigos');
    eliminar_prendas(prendas, codigos);
    compactar_archivo(prendas);

end.