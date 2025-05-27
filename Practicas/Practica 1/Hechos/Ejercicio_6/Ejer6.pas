
{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

Program Ejer6;
const

	FINAL=0;

type

	str=string[50]; opciones=0..8;
	
	celular = record
		codigo:integer;
		nombre:str;
		descripcion:str;
		marca:str;
		precio:real;
		stockMin:integer;
		stock:integer;
	end;
	
	archivoCelulares = file of celular;
	
	lista=^nodo;
	nodo=record
		dato:celular;
		sig:lista;
	end;

procedure leer(var arch:archivoCelulares; var c:celular);
begin
	if (not eof(arch)) then read(arch,c)
	else c.codigo := FINAL;
end;


procedure cargarLista(var l:lista; c: celular);
var
	nue:lista;
begin
	new(nue); nue^.dato:=c; nue^.sig:=l; l:=nue;
end;

procedure crearArchivo(var arch:archivoCelulares);
var
	carga:text;
	c:celular;
	nombre_fisico:str;

begin
	writeln('');
	write('Nombre del archivo: '); readln(nombre_fisico);
	writeln('');
	
	assign(arch,nombre_fisico); assign(carga,'celulares.txt');
	reset(carga); rewrite(arch);
	
	
	while (not EOF(carga)) do begin
		readln(carga,c.codigo,c.precio,c.marca);readln(carga,c.stock,c.stockMin,c.descripcion); readln(carga,c.nombre);
		write(arch,c);
	end;
	close(arch); close(carga);
end;


procedure imprimirCelular(c:celular);
begin
	with c do begin
		writeln('');
		writeln('------------------------');
		writeln('');
		
		writeln('Codigo: ',codigo);
		writeln('Nombre: ',nombre);
		writeln('Descripcion: ',descripcion);
		writeln('Marca: ', marca);
		writeln('Precio: $',precio:0:2);
		writeln('Stock: ', stock, '.  Minimo: ',stockMin);
	end;
end;

procedure stockMinimo(var arch: archivoCelulares);
var
	c:celular;
begin
	reset(arch);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		if (c.stock < c.stockMin) then begin
			imprimirCelular(c);
			writeln('');
			writeln('------------------------');
			writeln('');
		end;
		leer(arch,c);
	end;
	close(arch);
end;

procedure buscarCadena(var arch: archivoCelulares; cadena:str);
var
	c:celular;
begin
	reset(arch);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		if (pos(lowercase(cadena), lowercase(c.descripcion)) > 0) then begin
			imprimirCelular(c);
			writeln('');
			writeln('------------------------');
			writeln('');
		end;
		leer(arch,c);
	end;
	close(arch);
end;

procedure exportarArchivo(var arch:archivoCelulares);
var
	archT:text;
	c:celular;
begin
	assign(archT,'celulares.txt');
	reset(arch);
	rewrite(archT);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		writeln(archT, c.codigo,' ', c.precio:0:2,' ', c.marca);
		writeln(archT, c.stock, ' ',c.stockMin, ' ',c.descripcion);
		writeln(archT, c.nombre);
		leer(arch,c);
	end;
	close(arch); close(archT);
end;


procedure aniadirCelular(var arch:archivoCelulares);
var
	c:celular;
begin
	
	write('Codigo (',FINAL,' = fin): '); readln(c.codigo);
	if (c.codigo <> FINAL) then begin
		reset(arch);
		seek(arch,filesize(arch));
		while (c.codigo <> FINAL) do begin
			
			write('Nombre: '); readln(c.nombre);
			write('Descripcion: '); readln(c.descripcion);
			write('Marca: '); readln(c.marca);
			write ('Precio: $'); readln(c.precio);
			write('Stock Minimo: '); readln(c.stockMin);
			write('Stock: '); readln(c.stock);
		
			write(arch,c);
			
			writeln('');
			writeln('--------- Datos del Celular ----------');
			writeln('');
			
			writeln('Codigo (',FINAL,' = fin): '); readln(c.codigo);
		end;
		close(arch);
		
		writeln('');
		writeln('Carga completada.');
		writeln('');
	end
	else begin
		 writeln('');
		 writeln('No se cargo ningun celular.');
		 writeln('');
	end;
end;

procedure modificarStock(var arch:archivoCelulares; celu: str);
var
	c:celular; antes:integer;
begin
	reset(arch);
	leer(arch,c);
	while ((c.codigo <> FINAL) and (c.nombre <> celu)) do leer(arch,c);
	if ((c.codigo <> FINAL) and (c.nombre = celu)) then	begin
		antes:=c.stock;
		write('Nuevo Stock: '); readln(c.stock);
		
		seek(arch,filepos(arch)-1);
		write(arch,c);
		
		writeln('');
		writeln('Stock modificado.');
		writeln(antes,' --> ',c.stock);
		writeln('');
		
	end
	else writeln('No se encontro un celular con ese nombre.');
	close(arch);
end;

procedure exportarArchivoStock (var arch:archivoCelulares);
var
	archT:text; c:celular;
begin
	assign(archT,'SinStock.txt');
	reset(arch);
	rewrite(archT);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		if (c.stock < c.stockMin) then begin
			writeln(archT, c.codigo,' ', c.precio:0:2,' ', c.marca);
			writeln(archT, c.stock, ' ',c.stockMin, ' ',c.descripcion);
			writeln(archT, c.nombre);
		end;
		leer(arch,c);
	end;
	close(arch);
	close(archT);
end;

procedure mostrarTodo(var arch:archivoCelulares);
var
	c:celular;
begin
	reset(arch);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		imprimirCelular(c);
		leer(arch,c);
	end;
	close(arch);
end;


var

	opcion:opciones; celu,cadena:str; celulares:archivoCelulares;
	creado:boolean;

Begin
	creado:=false;

	repeat
	
		writeln('Elija la opcion del menu: ');writeln('0:Fin'); writeln('1:Crear Archivo'); writeln('2:Celulares con poco Stock');writeln('3:Buscar descripcion');writeln('4:Exportar Archivo'); writeln('5:Agregar celular');writeln('6:Modificar stock'); writeln('7:Exportar los sin Stock'); 
		write('Opcion: '); readln(opcion);
		
		if (opcion <> 0) then begin
			case opcion of
			
			1:	begin
					writeln('');
					writeln('Creando archivo.');
					writeln('');
					
					crearArchivo(celulares);
					
					writeln('');
					writeln('Archivo creado.');
					writeln('');
					
					creado:=true;
					
				end;
			
			2:	begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						writeln('Celulares con stock menor al minimo: ');
						writeln('');
						
						stockMinimo(celulares);
						writeln('');
					end;
				end;
			
			3:	begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						write('Que cadena desea buscar?: '); readln(cadena);
						writeln('');
						
						writeln('');
						writeln('Celulares con la cadena "',cadena,'": ');
						writeln('');
						
						buscarCadena(celulares,cadena);
						writeln('');
						
					end;
				end;
				
			4:	begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						writeln('Exportando archivo...');
						exportarArchivo(celulares);
						writeln('');
						writeln('Archivo exportado.');
						writeln('');
					end;
				end;
			
			5:  begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						writeln('--------- Datos del Celular ----------');
						writeln('');
						
						aniadirCelular(celulares);
						
					end;
				end;
			
			6:  begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						write('Nombre del celular que desea modificar: '); readln(celu);
						writeln('');
						
						modificarStock(celulares,celu);
						
						
					end;
				end;
				
			7:	begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						writeln('Exportando archivo...');
						writeln('');
						
						exportarArchivoStock(celulares);
						
						writeln('');
						writeln('Archivo exportado.');
						writeln('');
					end;
				end;
			8:  begin
					if (not creado) then begin
						writeln('');
						writeln('El archivo no fue creado aun.');
						writeln('');
					end
					else begin
						writeln('');
						writeln('Todos los celulares del archivo:');
						writeln('');
						writeln('');
						
						mostrarTodo(celulares);
						writeln('');
						writeln('------------------------');
						writeln('');
					end;
				end;
			end;
		end;
	until (opcion = 0);
 
 
    
End.
