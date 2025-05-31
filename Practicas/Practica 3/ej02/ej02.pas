{

Definir un programa que genere un archivo con registros de longitud fija conteniendo 
información  de  asistentes  a  un  congreso  a  partir  de  la  información  obtenida  por 
teclado.
 
Se deberá almacenar la siguiente información: nro de asistente, 
                                              apellido y nombre,  
                                              email,  
                                              teléfono  y  
                                              D.N.I.  

Implementar  un  procedimiento  que,  a  partir  del archivo de datos generado, 
elimine de forma lógica todos los asistentes con nro de asistente inferior a 1000.  

Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo String a su elección.  
Ejemplo:  ‘@Saldaño’. 


}
program ej02;

const 
    VALORALTO = 9999;
    ELIMINADO = '@';

type 

    str = string[40];

    asistente = record
        numero: integer;
        nombre: str;
        email: str;
        telefono: str;
        dni: str;
    end;

    archivo = file of asistente;

procedure crear_archivo(var a:archivo);
var
    d: asistente;
begin
    writeln('Datos del archivo: '); writeln(''); writeln('');
    rewrite(a);
    write('Numero (', VALORALTO,' para terminar): #'); readln(d.numero); writeln('');
    while (d.numero <> VALORALTO) do begin
        with d do begin
            write('Nombre y Apellido: '); readln(nombre); writeln('');
            write('DNI: '); readln(dni); writeln('');
            write('Email: '); readln(email); writeln('');
            write('Telefono: '); readln(telefono); writeln('');

            write(a, d);
            writeln('Asistente #',numero, ' cargado.');
            writeln('------------------------'); writeln('');

            write('Numero (', VALORALTO,' para terminar): #'); readln(d.numero); writeln('');
        end;
    end;
    close(a);
end;

procedure leer(var a: archivo; var d: asistente);
begin
    if (not eof(a)) then read(a, d)
    else d.numero:= VALORALTO;
end;

procedure eliminar(var a: archivo);
var
    d: asistente;
begin
    reset(a);
    leer(a, d);
    while (d.numero <> VALORALTO) do begin
        if (d.numero < 1000) then begin
            d.nombre:= ELIMINADO + d.nombre;
            seek(a, filepos(a) -1);
            write(a, d);
        end;
        leer(a, d);
    end;
    close(a);
end;

procedure mostrar(var a: archivo);
var
    d: asistente;
begin
    reset(a);
    leer(a, d);
    while (d.numero <> VALORALTO) do begin
        writeln('#', d.numero, ' ', d.nombre);
        leer(a, d);
    end;
    close(a);
end;

var
    a:archivo;

begin
    assign(a, 'asistentes');
    crear_archivo(a);
    mostrar(a);
    writeln('');
    writeln('');
    
    eliminar(a);
    mostrar(a);
    
end.