{7. Realizar un programa que permita:

a)  Crear un archivo binario a partir de la información almacenada en un archivo de texto. 

	El nombre del archivo de texto es: “novelas.txt”. 
	La información en el archivo de texto consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas.
	
	Los datos de cada novela se almacenan en dos líneas en el archivo de texto. 
	La primera línea contendrá la siguiente información: código novela, precio y género, y la segunda línea almacenará el nombre de la novela.

b)  Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una novela y modificar una existente. 
	Las búsquedas se realizan por código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}


program Ejer7;

const
	
	NOMBREATEXTO= 'novelas.txt';
	FINAL= 0;

type
	
	opciones= 0..4;
	str=string[50];

	novela= record
		codigo:integer;
		nombre:str;
		genero:str;
		precio:real;
	end;
	
	archivoNovelas = file of novela;

procedure leer (var a:archivoNovelas;var n:novela);
begin
	if (not EOF(a)) then read(a,n)
	else n.codigo := FINAL;
end;
	
procedure CrearArchivo(var a:archivoNovelas; var texto:text);
var
	n:novela; nombre:str;
begin
	write('Nombre del archivo: '); readln(nombre);
	assign(a,nombre);
	rewrite(a);
	reset(texto);
	
	while (not EOF(texto)) do begin
		readln(texto,n.codigo,n.precio,n.genero); readln(texto,n.nombre);
		write(a,n);
	end;
	
	close(texto); close(a);
	
	writeln('');
	writeln('Archivo creado.');
	writeln('');
	writeln('----------------------------------------');
	writeln('');
end;

procedure AgregarAlArchivo(var a:archivoNovelas; var modi:boolean);
var
	n:novela;
begin
	write('Codigo (',FINAL,' = fin):'); readln(n.codigo);
	if (n.codigo <> FINAL) then begin
		modi:=true;
		reset(a);
		while (n.codigo <> FINAL) do begin
			with n do begin
				write('Nombre: '); readln(n.nombre);
				write('Genero: '); readln(n.genero);
				write('Precio: $'); readln(n.precio);
			end;
			seek(a,fileSize(a));
			write(a,n);
			writeln('---------------------');
			writeln('');
			write('Codigo (',FINAL,' = fin):'); readln(n.codigo);
		end;
		close(a);
	end
	else writeln('No se cargo ninguna novela.');
	
	writeln('');
	writeln(' Carga finalizada.');
	writeln('');
	writeln('----------------------------------------');
	writeln('');
end;

procedure ModificarArchivo (var a:archivoNovelas; var AModificado:boolean);
var
	n:novela; opcion:opciones; auxI,codigo:integer; auxStr:str; auxReal:real; modificado:boolean;
begin
	
	reset(a);
	writeln('');
	write('Codigo de la novela que desea modificar (',FINAL,' para cancelar): '); readln(codigo);
	writeln('');
	modificado:=false;
	if (codigo <> FINAL) then begin
		leer(a,n);
		while ((n.codigo <> FINAL) and (n.codigo <> codigo)) do leer(a,n);
		if ((n.codigo <> FINAL) and (n.codigo = codigo)) then begin
			repeat
				write('Que desea modificar? (0:Fin, 1:Codigo, 2:Nombre, 3:Genero, 4:Precio): '); readln(opcion);
				case opcion of
				
				1:	begin
						auxI:= n.codigo;
						write('Codigo nuevo: '); readln(n.codigo);
						writeln(auxI, ' --> ', n.codigo);
						writeln('');
						modificado:=true;
					end;
					
				2:	begin
						auxStr:= n.nombre;
						write('Nombre nuevo: '); readln(n.nombre);
						writeln(auxStr, ' --> ', n.nombre);
						writeln('');
						modificado:=true;
					end;
					
				3:	begin
						auxStr:= n.genero;
						write('Genero nuevo: '); readln(n.genero);
						writeln(auxStr, ' --> ', n.genero);
						writeln('');
						modificado:=true;
					end;
					
				4:	begin
						auxReal:= n.precio;
						write('Precio nuevo: $'); readln(n.precio);
						writeln('$',auxReal:0:2, ' --> $', n.precio:0:2);
						writeln('');
						modificado:=true;
					end;
				end;
			until (opcion = FINAL);
			
			if (modificado) then begin
				seek(a,filePos(a)-1);
				write(a,n);
				AModificado:=true;
			end;
		end
		else writeln('No se encontro una novela con ese codigo.');
	end
	else writeln('Modificacion cancelada.');
	close(a);
end;

procedure ExportarATexto (var a:archivoNovelas; var texto:text);
var
	n:novela;
begin
	reset(a);
	rewrite(texto);
	leer(a,n);
	while (n.codigo <> FINAL) do begin
		writeln(texto,n.codigo,' ',n.precio:0:2,' ',n.genero);
		writeln(texto,n.nombre);
		leer(a,n);
	end;
	close(a);
	close(texto);
end;

procedure ImprimirNovela(n:novela);
begin
	with n do begin
		writeln('');
		writeln('-----------------------');
		writeln('Codigo: ',codigo);
		writeln('Nombre: ',nombre);
		writeln('Genero: ',genero);
		writeln('Precio: $',precio:0:2);
		writeln('-----------------------');
		writeln('');
	end;
end;

procedure ImprimirArchivo(var a:archivoNovelas);
var
	n:novela;
begin
	reset(a);
	leer(a,n);
	while (n.codigo <> FINAL) do begin
		ImprimirNovela(n);
		leer(a,n);
	end;
	close(a);
end;

var

	aT:text; a:archivoNovelas; opcion:opciones; creado, modi:boolean;

begin
	
	assign(aT,'novelas.txt');
	creado:=false;
	
	repeat
		modi:=false;
		
		writeln('');
		writeln('');
		writeln('Que desea realizar?');
		writeln('-------------------');
		writeln('');
		writeln(FINAL,':Terminar');
		writeln('1:Crear Archivo');
		writeln('2:Agregar Novelas Al Archivo');
		writeln('3:Modificar Novelas Del Archivo');
		writeln('');
		writeln('-------------------');
		writeln('');
		write('Opcion: '); readln(opcion);
		case opcion of
		
			FINAL: writeln('Programa Terminado.');
			
			1:	begin
					CrearArchivo(a,aT);
					creado:=true;
				end;
				
			2:	if (creado) then AgregarAlArchivo(a,modi) else writeln('Archivo no creado.');
			
			3:  if (creado) then ModificarArchivo(a,modi) else writeln('Archivo no creado.');
			
			4: if (creado) then ImprimirArchivo(a) else writeln('Archivo no creado.');
		end;
		
		if (modi) then ExportarATexto(a,aT);
		
	until (opcion = FINAL);
	
end.
