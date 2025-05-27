
{5. Realizar un programa para una tienda de celulares, que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”. 
Los registros correspondientes a los celulares deben contener: código de celular, nombre, descripción, marca, precio, stock mínimo y stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. 
El archivo de texto generado podría ser utilizado en un futuro como archivo de carga (ver inciso a), 
por lo que debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas. 
En la primera se especifica: código de celular, el precio y marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.
Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
}

Program Ejer5;
const

	FINAL=9999;

type

	str=string[50]; opciones=0..4;
	
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

procedure imprimirLista(l:lista);
begin
	if (l=nil) then writeln('No hay celulares con esas especificaciones.');
	while (l <> nil) do begin
		with (l^.dato) do writeln(nombre, marca,' - ', stock,' unidades: ', descripcion);
		l:=l^.sig;
	end;
end;

procedure recorrerArchivo(var arch:archivoCelulares; var lista_sin_stock,lista_descripcion:lista; cadena:str);
var
	c:celular;
begin
	reset(arch);
	leer(arch,c);
	while (c.codigo <> FINAL) do begin
		if (c.stock < c.stockMin) then cargarLista(lista_sin_stock,c);
		if (pos(lowercase(cadena), lowercase(c.descripcion)) > 0) then cargarLista(lista_descripcion,c);
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
		writeln(archT, c.codigo, c.precio, c.marca);
		writeln(archT, c.stock, c.stockMin, c.descripcion);
		writeln(archT, c.nombre);
		leer(arch,c);
	end;
	close(arch); close(archT);
end;

var

	opcion:opciones; cadena:str; celulares:archivoCelulares;
	lista_sin_stock,lista_descripcion:lista; editado,creado:boolean;

Begin
	lista_sin_stock:=nil; lista_descripcion:=nil; editado:=false; creado:=false;

	repeat
	
		write('Elija la opcion del menu (0:fin, 1:Crear Archivo, 2:Celulares con poco Stock, 3:Buscar descripcion, 4:Exportar Archivo): '); readln(opcion);
		
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
					editado:=true;
				end;
			
			2..3:begin
					if (not creado) then writeln('El archivo no fue creado aun.')
					else begin
						if (opcion = 3) then begin
							write('Cadena a buscar: ');
							readln(cadena);
						end;
						
						if (editado) then begin
							recorrerArchivo(celulares,lista_sin_stock,lista_descripcion,cadena);
							editado:=false;
						end;
						
						if (opcion = 2) then begin
							
							writeln('');
							writeln('Celulares con poco stock: ');
							writeln('');
							
							imprimirLista(lista_sin_stock);
							writeln('');
							writeln('');
						end
						
						else begin
							
							writeln('');
							writeln('Celulares con la  descripcion buscada: ');
							writeln('');
							
							imprimirLista(lista_descripcion);
							writeln('');
							writeln('');
						end;
					end;
				end;
				
			4:	begin
					if (not creado) then writeln('El archivo no fue creado aun.')
					else begin
						writeln('');
						writeln('Exportando archivo...');
						exportarArchivo(celulares);
						writeln('');
						writeln('Archivo exportado.');
						writeln('');
					end;
				end;
			end;
		end;
	until (opcion = 0);
 
 
 
 
 
 
 
    
End.
