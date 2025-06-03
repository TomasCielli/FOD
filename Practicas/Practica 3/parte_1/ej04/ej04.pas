{

Dada la siguiente estructura:  
     
    type 
        reg_flor = record 
            nombre: String[45]; 
            codigo: integer; 
        end; 
 
    tArchFlores = file of reg_flor; 

Las bajas se realizan apilando registros borrados y las altas reutilizando registros 
borrados.  

El registro 0 se usa como cabecera de la pila de registros borrados: 
el número 0 en el campo código implica que no hay registros borrados y -N indica que el 
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:

    Abre  el  archivo  y  agrega  una  flor,  recibida  como  parámetro 
    manteniendo la política descrita anteriormente

    procedure  agregarFlor  (var  a:  tArchFlores  ;  nombre:  string; 
    codigo:integer); 

b.  Liste  el  contenido  del  archivo  omitiendo  las  flores eliminadas. Modifique lo que 
considere necesario para obtener el listado.

}

program ej04;

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
begin
    assign(a,'flores');
    agregarFlor(a, 'xd', 20);
    listar_flores(a);
    
end.