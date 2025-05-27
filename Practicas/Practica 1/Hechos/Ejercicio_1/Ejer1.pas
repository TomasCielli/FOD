{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita incorporar datos al archivo. 
Los números son ingresados desde teclado. 
La carga finaliza cuando se ingresa el número 30000, que no debe incorporarse al archivo. 
El nombre del archivo debe ser proporcionado por el usuario desde teclado.}

program Ejer1;
const
    fin=30000;

type
    archivo= file of integer;

var
    a: archivo;
    num:integer;
    nombre_fisico:String[50];

begin
    write('Escriba el nombre del archivo: ');
    readln(nombre_fisico);
    writeln('');
    
    assign(a,nombre_fisico);
    
    write('Escriba un numero: ');
    readln(num);
    writeln('');
    
    if (num <> fin) then begin
		rewrite(a);
		while (num <> fin) do begin
			write(a,num);
			write('Escriba un numero: ');
			readln(num);
			writeln('');
		end;
	end;
end.
