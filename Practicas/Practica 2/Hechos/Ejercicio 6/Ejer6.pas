{

6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, 

la información contenida en los mismos es la siguiente: código de localidad, 
														código cepa, 
														cantidad de casos activos, 
														cantidad de casos nuevos, 
														cantidad de casos recuperados, 
														cantidad de casos fallecidos.
														
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, 
																		  nombre localidad, 
																		  código cepa, 
																		  nombre cepa, 
																		  cantidad de casos activos, 
																		  cantidad de casos nuevos, 
																		  cantidad de recuperados y 
																		  cantidad de fallecidos.
																		  
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles recibidos, se reciben 10 detalles. 

Todos los archivos están ordenados por código de localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:

	1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.

	2. Idem anterior para los recuperados.

	3. Los casos activos se actualizan con el valor recibido en el detalle.

	4. Idem anterior para los casos nuevos hallados.


Realice las declaraciones necesarias, el programa principal y los procedimientos que requiera para la actualización solicitada e informe cantidad de localidades con más de 50 casos activos 
(las localidades pueden o no haber sido actualizadas).

}

program Ejer6;

uses crt;

CONST

	valor_alto = 32767;
	cant_detalles = 10;
	
type

	str = string[50];
	
	datos_detalle = record 
		cod_localidad, cod_cepa, activos, nuevos, recuperados, fallecidos: integer;
	end;
	
	datos_maestro = record
		cod_localidad: integer;
		nom_localidad: str;
		cod_cepa:integer;
		nom_cepa:integer;
		activos, nuevos, recuperados, fallecidos: integer;
	end;
	
	detalle = file of datos_detalle;
	maestro = file of datos_maestro;
	
	detalles = array [1 .. cant_detalles] of detalle;
	
	vector_datos = array [1 .. cant_detalles] of datos_detalle;
	
procedure leer (var a:detalle; var d:datos_detalle); begin
	if (not eof(a)) then read(a,d) else d.cod_localidad:= valor_alto;
end;


procedure leer_maestro(var a:maestro; var d:datos_maestro); begin
	if (not eof(a)) then read(a,d)
	else d.cod_localidad:= valor_alto;
end;

procedure minimo (var deta: detalles; var datos: vector_datos; var min: datos_detalle);

var

	i,pos: integer;

begin
	
	min.cod_localidad:= valor_alto;
	pos:= valor_alto;
	
	for i:= 1 to cant_detalles do begin
	
		if ((datos[i].cod_localidad <> valor_alto) and ((datos[i].cod_localidad < min.cod_localidad) or ((datos[i].cod_localidad = min.cod_localidad) and (datos[i].cod_cepa < min.cod_cepa)))) then begin
			
			min:= datos[i];
			pos:= i;
		
		end;
	
	end;
	if (pos <> valor_alto) then leer(deta[pos],datos[pos]);

end;

procedure actualizar_maestro (var mae: maestro; var deta: detalles);

	procedure editar_maestro(var mae:maestro; d:datos_detalle);
	var
		aux:datos_maestro;
	begin
		leer_maestro(mae,aux);
		while (aux.cod_localidad <> d.cod_localidad) do leer_maestro(mae,aux);
		aux.fallecidos := aux.fallecidos + d.fallecidos;
		aux.recuperados:= aux.recuperados + d.recuperados;
		aux.activos:= d.activos;
		aux.nuevos:= d.nuevos;
		seek(mae,filepos(mae)-1);
		write(mae,aux);
	end;
		
var
	i: integer;
	datos: vector_datos;
	min,aux: datos_detalle;
	
begin
	
	for i := 1 to cant_detalles do begin
		reset(deta[i]);
		leer(deta[i], datos[i]);
	end;
	
	reset(mae);
	
	minimo(deta, datos, min);
	while (min.cod_localidad <> valor_alto) do begin
		
		aux.cod_localidad:= min.cod_localidad;
		while ((min.cod_localidad <> valor_alto) and (min.cod_localidad = aux.cod_localidad)) do begin
			
			aux.cod_cepa:= min.cod_cepa;
			aux.fallecidos:=0; aux.recuperados:=0; aux.activos:=0; aux.nuevos:=0;
			while ((min.cod_localidad <> valor_alto) and (min.cod_localidad = aux.cod_localidad) and (min.cod_cepa = aux.cod_cepa)) do begin
			
				aux.fallecidos:= aux.fallecidos + min.fallecidos;
				aux.recuperados:= aux.recuperados + min.recuperados;
				aux.activos:= aux.activos + min.activos;
				aux.nuevos:= aux.nuevos + min.nuevos;
				minimo(deta,datos,min);
			
			end;
			
			editar_maestro(mae,aux);
		
		end;
	
	end;
	close(mae);
	for i:= 1 to cant_detalles do begin
		close(deta[i]);
	end;

end;	

procedure contar_casos (var localidades: integer; var mae:maestro);
var
	l: datos_maestro;

begin
	localidades:=0;
	reset(mae);
	leer_maestro(mae,l);
	while (l.cod_localidad <> valor_alto) do begin
		if (l.activos > 50) then localidades:= localidades + 1;
		leer_maestro(mae,l);
	end;
	close(mae);
end;

var

	mae : maestro;
	deta: detalles;
	i,localidades: integer;
	aux:string;
	
begin

	assign(mae,'maestro');
	for i:= 1 to cant_detalles do begin
		Str(i,aux);
		assign(deta,'detalle '+aux);
	end;
	contar_casos(mae,localidades);
	writeln('Hay un total de ',localidades,' localidad que tienen mas de 50 casos activos.');
	
	actualizar_maestro(mae,deta);
	
	contar_casos(mae,localidades);
	writeln('Hay un total de ',localidades,' localidad que tienen mas de 50 casos activos.');

end.

end;
