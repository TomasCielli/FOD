{

2.  Realizar  un  algoritmo,  que  utilizando  el  archivo  de  números  enteros  no  ordenados 
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el 
promedio  de  los  números  ingresados.  El  nombre  del  archivo  a  procesar  debe  ser 
proporcionado  por  el  usuario  una  única  vez.   Además, el algoritmo deberá listar el 
contenido del archivo en pantalla.

}

program ej02;

const
    MENOR = 1500;

var
    nomb_archivo : String;
    numero, total, cant, cant_menores: integer;
    archivo: file of integer;

procedure procesar_numero(numero: integer; var total, cant, cant_menores: integer);
begin
    if (numero < MENOR) then cant_menores := cant_menores + 1;
    cant:= cant + 1;
    total:= total + numero;
end;

begin
    cant:= 0; cant_menores:= 0; total:= 0;

    write('Nombre del archivo: '); readln(nomb_archivo); writeln('');
    
    assign(archivo, nomb_archivo);
    cant:= 0;
    reset(archivo);
    while (not eof(archivo)) do begin
        read(archivo, numero);
        procesar_numero(numero, total, cant, cant_menores)
    end;
    close(archivo);
    write('Hay un total de ', cant, ' numeros, de los cuales ', cant_menores, ' son menores de ', MENOR,
    '. El promedio de todos los numeros da: ', (total/cant):0:2);

End.