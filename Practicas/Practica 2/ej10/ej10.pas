{

10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por provincia y localidad. 

Para ello, se posee un archivo con la siguiente información: código de provincia, 
                                                             código de localidad, 
                                                             número de mesa y 
                                                             cantidad de votos en dicha mesa. 

Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia
Código de Localidad                  Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____

Código de Provincia
Código de Localidad                  Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..

Total General de Votos: ___


NOTA: La información está ordenada por código de provincia y código de localidad.

}

program ej10;

const VALORALTO = 'ZZZZZZZZZZZZZ';

type


    str = string[30];

    reg_a = record
        provincia: str; //con str porque quedan mas fachero
        localidad: str;
        mesa: integer;
        votos: integer;
    end;

    archivo = file of reg_a;

procedure leer(var a: archivo; var d: reg_a);
begin
    if (not eof(a)) then read(a, d)
    else d.provincia:= VALORALTO;
end;

procedure informar(var a: archivo);
var
    r: reg_a;
    prov, loca: str;
    tot, tot_prov, tot_loca: integer;

begin
    reset(a);
    leer(a, r);
    tot:= 0;
    while (r.provincia <> VALORALTO) do begin
        prov:= r.provincia;
        tot_prov:= 0;
        writeln(prov,': ');
        writeln('');
        while (r.provincia = prov) do begin
            loca:= r.localidad;
            tot_loca:= 0;
            while (r.provincia = prov) and (r.localidad = loca) do begin
                tot_loca:= tot_loca + r.votos;
                leer(a, r);
            end;
            write(loca, ' : ', tot_loca,' votos. |');
            tot_prov:= tot_prov + tot_loca;
        end;
        writeln('');
        writeln('Total de votos en ', prov,': ', tot_prov, ' votos.');
        writeln('');
        tot:= tot + tot_prov;
    end;
    writeln('');
    writeln('Total general de votos: ', tot, ' votos.');
    writeln('');
    close(a);
end;

var
    a:archivo;
begin
    assign(a, 'votos');
    informar(a);
end.