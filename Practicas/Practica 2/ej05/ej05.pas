{

5. Suponga que trabaja en una oficina donde está montada una LAN (red local). 

La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas se conectan con un servidor central. 

Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal 
y por cuánto tiempo estuvo abierta. 

Cada archivo detalle contiene los siguientes campos: cod_usuario, 
                                                    fecha, 
                                                    tiempo_sesion. 
                                                    
Debe realizar un procedimiento que reciba los archivos detalle y genere un archivo maestro con los siguientes datos: cod_usuario, 
                                                                                                                     fecha, 
                                                                                                                     tiempo_total_de_sesiones_abiertas.

Notas:
    ● Cada archivo detalle está ordenado por cod_usuario y fecha.
    
    ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
    
    ● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

}
program ej05;

const VALORALTO = 9999;
const CANTMAQUINAS = 5;

type
    rango_dias = 1..31;
    rango_meses = 1..12;
    rango_maquinas = 1..CANTMAQUINAS;

    dma = record
        dia: rango_dias;
        mes: rango_meses;
        anio: integer;
    end;

    log = record
        codigo: integer;
        fecha: dma;
        tiempo: real;
    end;

    archivo = file of log;

    vector_maquinas = array [rango_maquinas] of archivo;
    vector_logs = array [rango_maquinas] of log;


procedure leer(var a: archivo; var d: log);
begin
    if (not eof(a)) then read(a, d)
    else d.codigo:= VALORALTO;
end;

procedure minimo(var vec_maquinas: vector_maquinas; var vec_logs: vector_logs; var min: log);
var
    i, pos: rango_maquinas;
    menor: integer;

begin
    menor:= VALORALTO;
    for i:= 1 to CANTMAQUINAS do begin
        if (vec_logs[i].codigo <= menor) then begin
            menor:= vec_logs[i].codigo;
            pos:= i;
        end;
    end;
    min:= vec_logs[pos];
    leer(vec_maquinas[pos], vec_logs[pos]);
end;

procedure crear_maestro(var mae: archivo; var vec_maquinas: vector_maquinas);
var
    i: rango_maquinas;
    vec_logs: vector_logs;
    min, regm: log;
    usuario: integer;
    horas: real;
    fecha: dma;

begin
    rewrite(mae);
    for i:= 1 to CANTMAQUINAS do begin
        reset(vec_maquinas[i]);
        leer(vec_maquinas[i], vec_logs[i]);
    end;
    minimo(vec_maquinas, vec_logs, min);
    while (min.codigo <> VALORALTO) do begin
        usuario:= min.codigo;
        while (min.codigo = usuario) do begin
            fecha:= min.fecha;
            horas:= 0;
            while (min.codigo = usuario) and ((min.fecha.anio = fecha.anio) and (min.fecha.mes = fecha.mes) and
            (min.fecha.dia = fecha.dia)) do begin
                horas:= horas + min.tiempo;
                minimo(vec_maquinas, vec_logs, min);
            end;
            regm.codigo:= usuario; regm.fecha:= fecha; regm.tiempo:= horas;
            write(mae, regm);
        end;
    end;
    for i:= 1 to CANTMAQUINAS do close(vec_maquinas[i]);
    close(mae);
end;

var
    mae: archivo;
    maquinas: vector_maquinas;
begin
    assign(mae, 'maestro');
    assign(maquinas[1],'detalle_1');
    assign(maquinas[2],'detalle_2');
    assign(maquinas[3],'detalle_3');
    assign(maquinas[4],'detalle_4');
    assign(maquinas[5],'detalle_5');

    crear_maestro(mae, maquinas);

end.











begin
    
end.
    