{
1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión, 

de cada uno de ellos se conoce: código de empleado, nombre y monto de la comisión.

La información del archivo se encuentra ordenada por código de empleado y cada empleado puede aparecer más de una vez en el archivo de comisiones.

Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte.
En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.}


program Ejer1;

const	FINAL=0;

type
	
	str=string[50];
	
	empleado=record
		codigo:integer;
		nombre: str;
		valor:real;
	end;
	
	archivoEmpleados = file of empleado;

procedure leer(var a:archivoEmpleados; var e:empleado);
begin
	if (not EOF(a)) then read(a,e)
	else e.codigo:=FINAL;
end;
	
procedure compactarArchivo (var arch:archivoEmpleados; var compactado:archivoEmpleados);

var 
	
	e,empleadoAnt:empleado; 
	total:real;

begin
	reset(arch); rewrite(compactado);
	leer(arch,e);
	
	while (e.codigo <> FINAL) do begin
	
		empleadoAnt:= e; total:=0;
		while (empleadoAnt.codigo = e.codigo) do begin
			
			total:= total + e.valor;
			leer(arch,e);
			
		end;
		empleadoAnt.valor:=total;
		write(compactado,empleadoAnt);
	end;
	close(arch); close(compactado);
end;
	
procedure leerEmpleado (var e:empleado);
begin
	
	with e do begin
		writeln('');
		write('Codigo del empleado (',FINAL,' para terminar): '); readln(codigo);
		if (codigo <> FINAL) then begin
			write('Nombre del empleado: ');readln(nombre);
			write('Monto de la comision: $');readln(valor);
		end;
	end;
	writeln('');
	writeln('----------------------');
	writeln('');	
end;

procedure crearArchivo (var a:archivoEmpleados);
var
	e:empleado;
begin
	rewrite(a);
	leerEmpleado(e);
	while (e.codigo <> FINAL) do begin
		write(a,e);
		leerEmpleado(e);
	end;
end;

procedure imprimirArchivo(var a:archivoEmpleados; comprimido:boolean);
var
	e:empleado;
begin
	reset(a);
	leer(a,e);
	while (e.codigo <> FINAL) do begin
		writeln('');
		writeln('-------------------------');
		writeln('');
		writeln('Nombre: ',e.nombre);
		writeln('Codigo: ',e.codigo);
		if (comprimido) then write('Monto total de comisiones: $')
						else write('Monto de la comision: $');
		writeln(e.valor:0:2);
		writeln('');
		writeln('-------------------------');
		writeln('');
		leer(a,e);
	end;
	close(a);
end;


var
	c,a:archivoEmpleados;
begin
	assign(c,'Compactado');
	assign(a,'Comisiones');
	crearArchivo(a);
	imprimirArchivo(a,false);
	compactarArchivo(a,c);
	imprimirArchivo(c,true);
end.
