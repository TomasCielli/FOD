{

3. A partir de información sobre la alfabetización en la Argentina, 
se necesita actualizar un archivo que contiene los siguientes datos: nombre de provincia, 
                                                                     cantidad de personas alfabetizadas y 
                                                                     total de encuestados. 

Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, 
                                                                                                            código de localidad, 
                                                                                                            cantidad de alfabetizados y 
                                                                                                            cantidad de encuestados. 

Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.

}
program ej03;

const VALORALTO = 'ZZZZZZZZZZZZZZZZZZZZZ';

type
    str = string[30];
    reg_mae = record
        provincia: str;
        alfabetizados: integer;
        encuestados: integer;
    end;

    reg_det = record
        provincia: str;
        codigo: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;

    archivo_maestro = file of reg_mae;
    archivo_detalle = file of reg_det;

procedure leer(var a: archivo_detalle; var dato: reg_det);
begin
    if (not eof(a)) then read(a, dato)
    else dato.provincia:= VALORALTO;
end;

procedure minimo(var det1, det2: archivo_detalle; var r1, r2, min: reg_det);
begin
    if (r1.provincia <= r2.provincia) then begin
        min:= r1;
        leer(det1, r1);
    end
    else begin
        min:= r2;
        leer(det2, r2);
    end;
end;

procedure actualizar_maestro(var mae: archivo_maestro; var det1, det2: archivo_detalle);
var
    aux: str;
    r1, r2, min: reg_det;
    total_alfa, total_enc: integer;
    regm: reg_mae;
begin
    reset(det1); reset(det2); reset(mae);

    read(mae,regm); leer(det1, r1); leer(det2, r2);

    minimo(det1, det2, r1, r2, min);
    while (min.provincia <> VALORALTO) do begin
        
        total_alfa:= 0;
        total_enc:= 0;
        aux:= min.provincia;
        while (min.provincia = aux) do begin
            
            total_alfa:= total_alfa + min.alfabetizados;
            total_enc:= total_enc + min.encuestados;
            minimo(det1, det2, r1, r2, min);
        end;
        while(regm.provincia <> aux) do read(mae, regm);
        regm.alfabetizados:= regm.alfabetizados + total_alfa;
        regm.encuestados:= regm.encuestados + total_enc;
        seek(mae, filepos(mae) -1);
        write(mae, regm);
    end;
    close(det1); close(det2); close(mae);
end;
        
var
    det1, det2: archivo_detalle;
    mae: archivo_maestro;

begin
    assign(det1, 'detalle_1');
    assign(det2, 'detalle_2');
    assign(mae, 'maestro');

    actualizar_maestro(mae, det1, det2);
end.