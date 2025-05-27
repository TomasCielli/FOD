{4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado. 
Tener en cuenta que no se debe agregar al archivo un empleado con un número de empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

program Ejer4;

const
	
	FIN='fin';

type

	opciones=0..6;
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
	
procedure anadirEmpleados(var arch:archivoEmp);
var
	repetido:boolean;
	e,earch:empleado;
begin
	e:=leerEmpleado;
	while (e.apellido <> FIN) do begin
		reset(arch);
		repetido:=false;
		leer(arch,earch);
		while (earch.apellido <> FIN) and (not repetido) do begin
			if ((earch.apellido <> FIN)and (earch.numero = e.numero)) then begin
				writeln('Ese numero de empleado ya esta en uso.');
				repetido:=true;
			end
			else leer(arch,earch);
		end;
		if (not repetido) then begin
			write(arch,e);
			
			writeln('');
			writeln('Empleado cargado.');
			writeln('');
		end;
		close(arch);
		e:=leerEmpleado;
	end;
end;

procedure crearArchivo(var arch:archivoEmp);

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

procedure modificarEdad(var arch:archivoEmp; numeroMod, edadMod:integer);
var
	e:empleado;
	listo:boolean;
begin
	listo:=false;
	reset(arch);
	leer(arch,e);
	while ((e.apellido <> FIN) and (not listo))do begin
		if (e.numero = numeroMod) then begin
			e.edad:=edadMod;
			seek(arch,filepos(arch)-1);
			write(arch,e);
			listo:=true;
		end
		else leer(arch,e);
	end;
	close(arch);
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
			writeln('Empleado n', l^.dato.numero,': ',l^.dato.apellido,' ', l^.dato.nombre,' | ', l^.dato.edad,' anios.');
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
	write('Elija una opcion de busqueda (0:fin, 1: buscar nombre/apellido, 2: todos los empleados, 3: mayores de 70 anios): ');
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
		write('Elija una opcion de busqueda (0:fin, 1: buscar nombre/apellido, 2: todos los empleados, 3: mayores de 70 anios): ');
		readln(opcion);
	end;
	writeln('Volviendo al menu anterior.');
end;

procedure exportarArchivo(var arch: archivoEmp);
var
	archT: text;
	e:empleado;
begin
	assign(archT,'todos_empleados.txt');
	reset(arch);
	rewrite(archT);
	leer(arch,e);
	while (e.apellido <> FIN) do begin
		with e do
			writeln(archT, ' ', numero:0, ' ',apellido,' ',nombre,' ',edad:0,' ',dni:0);
		leer(arch,e);
	end;
	close(arch);close(archT);
end;

procedure exportarArchivoSinDNI(var arch:archivoEmp);
var
	archT:text;
	e:empleado;
begin
	assign(archT,'faltaDNIEmpleado.txt');
	reset(arch);
	rewrite(archT);
	leer(arch,e);
	while (e.apellido <> FIN) do begin
		if (e.dni = 00) then begin
			with e do
				writeln(archT, ' ', numero:0, ' ',apellido,' ',nombre,' ',edad:0,' ',dni:0);
		end;
		leer(arch,e);
	end;
	close(arch);close(archT);
end;

var
	
	arch:archivoEmp;
	opcion:opciones;
	nombre_fisico:str;
	creado:boolean;
	numeroMod,edadMod:integer;
	
begin
	creado:=false;
	write('Elija una opcion (0:fin, 1:crear archivo, 2:listar archivo, 3:agregar empleados, 4:modificar edad de un empleado, 5:exportar archivo, 6:exportar empleados sin DNI):');
	readln(opcion);
	while (opcion <> 0) do begin
		case opcion of
			1:	begin {3.a. Crear un archivo de registros no ordenados de empleados}
		
					write('Nombre del archivo: ');
					readln(nombre_fisico);
					writeln('');
				
					assign(arch,nombre_fisico);
					crearArchivo(arch);
					creado:=true;
				
					writeln('');
					writeln('Archivo creado.');
					writeln('');
				end;
			2:	begin {3.b. Abrir el archivo anteriormente generado y}
					if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
					else recorrerArchivo(arch);
				end;
			3: 	begin {4.a. Añadir uno o más empleados al final del archivo}
					if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
					else begin
						writeln('');
						writeln('Aniadir empleados: ');
						writeln('');
						
						anadirEmpleados(arch);
					end;
				end;
			4:	begin {4.b. Modificar la edad de un empleado dado.}
					if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
					else begin
						writeln('');
						write('Numero del empleado que desea modificar: ');
						read(numeroMod);
						write(' / Edad: ');
						readln(edadMod);
						writeln('');
						modificarEdad(arch,numeroMod,edadMod);
						writeln('Edad modificada.');
						writeln('');
					end;
				end;
			5:	begin {4.c. Exportar el contenido del archivo}
					if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
					else begin
						exportarArchivo(arch);
						writeln('');
						writeln('Archivo completo exportado.');
						writeln('');
					end;
				end;
			6: 	begin {d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).}
					if (not creado) then writeln('EL ARCHIVO NO FUE CREADO.')
					else begin
						exportarArchivoSinDNI(arch);
						writeln('');
						writeln('');
					end;
				end;
				
		end;	
		writeln('');
		writeln('');
		writeln('');
		writeln('');
		writeln('');	
		write('Elija una opcion (0:fin, 1:crear archivo, 2:listar archivo, 3:agregar empleados, 4:modificar edad de un empleado, 5:exportar archivo, 6:exportar empleados sin DNI):');
		readln(opcion);
	end;
	writeln('');
	writeln('Programa terminado.');
	writeln('');
end.
			
