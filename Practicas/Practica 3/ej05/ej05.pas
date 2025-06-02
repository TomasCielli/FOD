{

Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo: 
Abre el archivo y elimina la flor recibida como parámetro manteniendo 
la política descripta anteriormente

}

program ej05;

const VALORALTO = 9999;

type 
        reg_flor = record 
            nombre: String[45]; 
            codigo: integer; 
        end; 
 
    tArchFlores = file of reg_flor; 

procedure leer(var a: tArchFlores; var f:reg_flor);
begin
    if (not eof(a)) then read(a, f)
    else f.codigo:= VALORALTO;
end;

procedure  agregarFlor  (var a: tArchFlores; nombre: string; codigo:integer); 
var
    borrado, cabecera, f: reg_flor;
    pos: integer;
    

begin
    reset(a);
    f.nombre:= nombre; f.codigo:= codigo;

    leer(a, cabecera);
    if (cabecera.codigo = 0) then begin
        seek(a, filesize(a));
        write(a, f);
    end
    else begin
        pos:= cabecera.codigo * -1;

        seek(a, pos);
        read(a, borrado);
        seek(a, filepos(a) -1);
        write(a, f);

        cabecera.codigo:= borrado.codigo;
        seek(a, 0);
        write(a, cabecera);

    end;
    close(a);
end;

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
    cabecera, f: reg_flor;
    pos: integer;

begin
    reset(a);
    leer(a, cabecera);
    leer(a, f);
    while (f.codigo <> VALORALTO) and (f.codigo <> flor.codigo) do leer(a, f);
    if (f.codigo  = flor.codigo) then begin
        seek(a, filepos(a) -1);
        f.codigo:= cabecera.codigo;
        cabecera.codigo:= filepos(a) * -1; //Pasa la posicion en negativo
        write(a, f);
        seek(a, 0);
        write(a, cabecera);
    end
    else begin
        writeln('No se encontro una flor con ese codigo'); writeln('');
    end;
    close(a);
//falacia de afirmacion del consecuente
//falacia de negacion del antecedente

end;

procedure listar_flores(var a: tArchFlores);
var
    f: reg_flor;

begin
    reset(a);
    leer(a, f);
    while (f.codigo <> VALORALTO) do begin
        if (f.codigo > 0) then
            writeln('#', f.codigo, ': ', f.nombre, '.');
        leer(a, f);
    end;
end;

var
    a: tArchFlores; 
    f: reg_flor;
begin
    f.nombre:= 'Flor_1';
    f.codigo:= 1;
    assign(a,'flores');

    agregarFlor(a, f.nombre, f.codigo);
    agregarFlor(a, 'Flor_2', 2);
    listar_flores(a);
    writeln('');

    eliminarFlor(a, f);
    listar_flores(a);
end. 