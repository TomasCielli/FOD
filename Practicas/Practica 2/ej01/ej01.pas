{

Una  empresa  posee un archivo con información de los ingresos percibidos por diferentes 
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado, 
                                                                   nombre  y  
                                                                   monto  de  la  comisión.  

La  información  del  archivo  se  encuentra  ordenada  por código  de  empleado  y  cada  empleado puede aparecer más de una vez en el archivo de 
comisiones.  

Realice  un  procedimiento  que  reciba  el archivo anteriormente descrito y lo compacte.

En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una 
única vez con el valor total de sus comisiones.

NOTA:  No  se  conoce  a  priori  la  cantidad  de  empleados.  Además,  el  archivo  debe  ser 
recorrido una única vez.

}

program ej01;

const VALORALTO = 9999;

type
    str = string[30];

    empleado = record
        codigo : integer;
        nombre : str;
        monto : real;
    end;

    archivo = file of empleado;

procedure leer(var a: archivo; var e: empleado);
begin
    if (not eof(a)) then read(a, e)
    else e.codigo := VALORALTO;
end;

procedure compactar(var a, compactado: archivo);
var
    e, aux: empleado;
    total: real;

begin
    reset(a);
    rewrite(compactado);

    leer(a, e);
    while (e.codigo <> VALORALTO) do begin
        total:= 0;
        aux:= e;
        while (e.codigo = aux.codigo) do begin
            total:= total + e.monto;
            leer(a, e);
        end;
        aux.monto:= total;
        write(compactado, aux);
    end;
    close(a);
    close(compactado);
end;

procedure mostrar_archivo(var a: archivo; titulo: str);
var
    e: empleado;
begin
    reset(a);
    writeln('--- ', titulo, ' ---');
    while not eof(a) do begin
        read(a, e);
        writeln('Codigo: ', e.codigo, ' | Nombre: ', e.nombre, ' | Monto: $', e.monto:0:2);
    end;
    close(a);
    writeln;
end;

var
    a, c: archivo;

begin
    assign(a, 'comisiones');
    assign(c, 'compactado');

    compactar(a, c);

    mostrar_archivo(a, 'Comisiones');
    mostrar_archivo(c, 'Compactado');
end.

