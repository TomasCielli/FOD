{3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. 
De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. 
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.

ii. Listar en pantalla los empleados de a uno por línea.

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
program Ejer3;

const
	
	FIN='fin';

type

	opciones=0..2;
	opciones2=0..3;
	str=string[30];
	
	empleado=record
		numero:integer;
		apellido:str;
		nombre:str;
		edad:integer;
		dni:integer;
	end;
	
	archivoEmp= file of empleado;
	
	lista= ^nodo;
	nodo= record
		dato:empleado;
		sig:lista;
	end;
	
procedure leer(var arch:archivoEmp; var e:empleado);
begin
	if (not EOF(arch)) then read(arch,e)
	else e.apellido:=FIN;
end;

procedure crearArchivo(var arch:archivoEmp);
	function leerEmpleado: empleado;
	var
		e:empleado;
	begin
		writeln('----------------------------');
		writeln('Datos del empleado: ');
		writeln('');
		
		write('Apellido: ');
		readln(e.apellido);
		if (e.apellido <> FIN) then begin
			write('Nombre: ');
			readln(e.nombre);
			write('Numero: ');
			readln(e.numero);
			write('Edad: ');
			readln(e.edad);
			write('DNI: ');
			readln(e.dni);
		end;
		leerEmpleado:=e;
	end;
var
	e:empleado;

begin
	e:=leerEmpleado;
	if (e.apellido = FIN) then writeln('Archivo creado vacio.')
	else begin
		rewrite(arch);
		while (e.apellido <> FIN) do begin
			write(arch,e);
			e:=leerEmpleado;
		end;
		close(arch);
	end;
end;
		

procedure recorrerArchivo(var arch:archivoEmp);
	
	procedure crearListas(var arch:archivoEmp; var l_empleados:lista; var l_buscados:lista; var l_jubilados:lista; palabra, buscar:str; creadas:boolean);
		
		procedure agregarALista(var l:lista; e:empleado);
		var
			nue:lista;
		begin
			new(nue); nue^.dato:=e; nue^.sig:=l;
			l:=nue;
		end;
		
	var	
		e:empleado;
	begin
		reset(arch);
		leer(arch,e);
		while (e.apellido <> FIN) do begin
			if (not creadas) then begin
				agregarALista(l_empleados,e);
				if (e.edad > 70) then agregarALista(l_jubilados,e);
			end;
			if ((((buscar = 'Nombre') or (buscar = 'nombre')) and (e.nombre= palabra)) or (((buscar = 'Apellido') or (buscar = 'apellido')) and (e.apellido = palabra))) 
				then agregarALista(l_buscados, e);
			leer(arch,e);
		end;
		close(arch);
	end;
	
	
	procedure imprimirLista(l:lista);
	begin
		while (l <> nil) do begin
			writeln('Empleado n°', l^.dato.numero,': ',l^.dato.apellido,' ', l^.dato.nombre,' | ', l^.dato.edad,' años.');
			l:=l^.sig; 
		end;
	end;
	
var
	l_buscados,l_jubilados,l_empleados:lista;
	opcion:opciones2;
	buscar,palabra,buscarAnt,palabraAnt:str;
	creadas:boolean;
begin
	l_buscados:=nil;l_jubilados:=nil; l_empleados:=nil; buscar:='nada';palabra:='ZZZ'; creadas:=false; palabraAnt:=''; buscarAnt:='';
	write('Elija una opcion de busqueda (0:fin, 1: buscar nombre/apellido, 2: todos los empleados, 3: mayores de 70 años): ');
	readln(opcion);
	
	while (opcion <> 0) do begin
		case opcion of
			1:	begin
					write('Buscar por (nombre/apellido): ');
					readln(buscar);
					if ((buscar = 'nombre') or (buscar = 'Nombre')) then write('Nombre a buscar: ')
					else write('Apellido a buscar: ');
					readln(palabra);
				end;
			2: 	begin
					writeln('');
					writeln('------------------------------');
					writeln('');
					write('Todos los empleados:');
					writeln('');
				end;
			3:	begin
					writeln('');
					writeln('Empleados mayores de 70 anios: ');
					writeln('');
				end;
		end;
		if (not creadas) then begin
			crearListas(arch,l_empleados,l_buscados,l_jubilados,palabra,buscar,creadas);
			creadas:=true;
		end
		else if ((opcion = 1) and (palabra <> palabraAnt) or (buscar <> buscarAnt)) then begin
			l_buscados:=nil;
			crearListas(arch,l_empleados,l_buscados,l_jubilados,palabra,buscar,creadas);
		end;
		case opcion of
			1: imprimirLista(l_buscados);
			2: imprimirLista(l_empleados);
			3: imprimirLista(l_jubilados);
		end;
		write('Elija una opcion de busqueda (0:fin, 1: buscar nombre/apellido, 2: todos los empleados, 3: mayores de 70 años): ');
		readln(opcion);
	end;
	writeln('Volviendo al menu anterior.');
end;


var
	
	arch:archivoEmp;
	opcion:opciones;
	nombre_fisico:str;
	creado:boolean;
						
begin
	creado:=false;
	write('Elija una opcion (0:fin, 1:crear archivo, 2:listar archivo):');
	readln(opcion);
	while (opcion <> 0) do begin
		if (opcion=1) then begin
		
			write('Nombre del archivo: ');
			readln(nombre_fisico);
			writeln('');
			
			assign(arch,nombre_fisico);
			crearArchivo(arch);
			creado:=true;
			
			writeln('');
			writeln('Archivo creado.');
			writeln('');
			
		end
		else begin
			if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
			else recorrerArchivo(arch);
		end;
		write('Elija una opcion (0:fin, 1:crear archivo, 2:listar archivo):');
		readln(opcion);
	end;
	writeln('');
	writeln('Programa terminado.');
	writeln('');
end.
			
