{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el ejercicio 1,
 informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados. 
 El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. 
 Además, el algoritmo deberá listar el contenido del archivo en pantalla.}
 
program Ejer2;
const
    FIN=30000;
	MENOR=1500;
type
    archivo= file of integer;

var
    a: archivo;
    num:integer;
    nombre_fisico:String[50];
    cant,promedio,total:integer;

begin
    write('Escriba el nombre del archivo: ');
    readln(nombre_fisico);
    writeln('');
    
    assign(a,nombre_fisico);
    
    write('Escriba un numero: ');
    readln(num);
    writeln('');
    
    if (num <> FIN) then begin
		rewrite(a);
		while (num <> FIN) do begin
			write(a,num);
			write('Escriba un numero: ');
			readln(num);
			writeln('');
		end;
	end;
	close(a);
	
	cant:=0;
	total:=0;
	promedio:=0;
	
	reset(a);
	if (EOF(a)) then writeln('El archivo esta vacio')
	else begin
		write('Numeros del archivo "',nombre_fisico,': ');
		while (not EOF(a)) do begin
			read(a,num);
			if (num < menor) then cant:=cant+1;
			total:=total+1;
			promedio:=promedio+num;
			if (not EOF(a)) then write(' ',num,',')
			else write (' ',num,'.');
		end;
		writeln('');
		writeln('Numeros menores a ',MENOR,': ',cant);
		writeln('Promedio de los numeros: ',(promedio/total):0:2);
	end;
	close(a);	
		
end.
