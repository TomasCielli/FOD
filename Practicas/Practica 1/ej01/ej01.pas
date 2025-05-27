{

1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.

}
program ej01;

const
    FIN = 30000;

var
    numero: integer;
    archivo: file of integer;
    nomb_archivo: String;
    cant: integer;

begin
    write('Nombre del archivo: '); readln(nomb_archivo); writeln('');
    
    assign(archivo, nomb_archivo);
    cant:= 0; 

    write('Escriba un numero: '); readln(numero); writeln('');
    if (numero <> FIN) then begin 
        rewrite(archivo);
        while (numero <> FIN) do begin
            write(archivo, numero);
            write('Escriba un numero: '); readln(numero); writeln('');
            cant:= cant + 1;      
        end;
        close(archivo);
    end;
    writeln('El archivo tiene ', cant, ' numeros cargados.');
End.