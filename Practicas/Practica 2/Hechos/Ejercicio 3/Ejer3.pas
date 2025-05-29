{

3. A partir de información sobre la alfabetización en la Argentina, 

se necesita actualizar un archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas alfabetizadas y total de encuestados. 

Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes, 

dichos archivos contienen: nombre de la provincia, código de localidad, cantidad de alfabetizados y cantidad de encuestados. 

Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.


NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.

}

program Ejer3;

const

	FINAL = '';

type

	str= string[50];
	
	datos = record
		provincia:str;
		alfabetizados:integer;
		total:integer;
	end;
	
	archivoMaestro= file of datos;
	
	censo = record
		provincia:str;
		codigoLocalidad:integer;
		alfabetizados:integer;
		total:integer;
	end;
	
	archivoDetalle= file of censo;
	
procedure leerDatos (var a:archivoMaestro; var d:datos);
begin
	if (not eof(a)) then read(a,d)
	else d.provincia:=FINAL;
end;

procedure leerCenso (var a:archivoDetalle; var c:censo);
begin
	if (not eof(a)) then read(a,c)
	else c.provincia:= FINAL;
end;

procedure minimo (var d1,d2:archivoDetalle; var c1,c2,min:censo);
begin
	if (c1.provincia <= c2.provincia) then begin
		min:=c1;
		leerCenso(d1,c1);
	end
	else {(c2.provincia < c1.provincia)} begin
		min:=c2;
		leerCenso(d2,c2);
	end;
end;

	
{procedure actualizarMaestro (var aM:archivoMaestro;var aD1,aD2:archivoDetalle);
var
	
	d:datos;
	c1,c2,min,ant:censo;
	
begin

	reset(aD1); reset(aD2); reset(aM);
	
	leerCenso(aD1,c1); leerCenso(aD2,c2);
	
	minimo(aD1,aD2,c1,c2,min);
	while (min.provincia <> FINAL) do begin
	
		ant:=min; ant.total:=0; ant.alfabetizados:=0;
		while (min.provincia = ant.provincia) do begin
			
			ant.total:=ant.total + min.total;
			ant.alfabetizados:= ant.alfabetizados + min.alfabetizados;
			minimo(aD1,aD2,c1,c2,min);
		end;
		leerDatos(aM,d);
		while ((d.provincia <>FINAL) and (d.provincia <> ant.provincia))do leerDatos(aM,d);
		d.total:= ant.total; d.alfabetizados:= ant.alfabetizados;
		seek(aM,filepos(aM)-1);
		write(aM,d);
	end;
	
	close(aD1); close(aD2); close(aM
	reset(aM); reset(aD1); reset(aD2);
	leerDatos(aM,d); leerCenso(aD1,c1); leerCenso(aD2,c2);
	minimo(c1,c2,min);
	while (min.provincia <> FINAL) do begin
		while (d.provincia < min.provincia) do leerDatos(aM,d);
		
	
end;}

procedure actualizarMaestro(var aM: archivoMaestro; var aD1, aD2: archivoDetalle);
var
  d: datos;         { Registro del maestro }
  c1, c2, min, ant: censo;  { Registros de los detalles }
begin
  reset(aM);  reset(aD1);  reset(aD2);
  leerDatos(aM, d);           { Lee el primer registro del maestro }
  leerCenso(aD1, c1);         { Lee el primer registro del primer detalle }
  leerCenso(aD2, c2);         { Lee el primer registro del segundo detalle }
  minimo(aD1, aD2, c1, c2, min);  { Obtiene el mínimo de los detalles }
  
  while (min.provincia <> FINAL) do begin
    { Avanzamos en el maestro hasta encontrar la provincia que coincide con el mínimo }
    while (d.provincia <> min.provincia) do begin
		write(d.provincia);
		write(min.provincia);
		leerDatos(aM, d);
    end;  
    if (d.provincia = min.provincia) then begin
      ant := min;                       { Guardamos el registro actual de detalle }
      ant.total := 0;                   { Inicializamos acumuladores }
      ant.alfabetizados := 0;
      
      { Acumulamos los datos de todos los detalles para esa provincia }
      while (min.provincia = d.provincia) do begin
        ant.total := ant.total + min.total;
        ant.alfabetizados := ant.alfabetizados + min.alfabetizados;
        minimo(aD1, aD2, c1, c2, min);  { Avanza en los detalles }
      end;
      
      { Actualizamos el registro maestro correspondiente }
      d.total := ant.total;
      d.alfabetizados := ant.alfabetizados;
      seek(aM, filepos(aM) - 1);  { Retrocedemos para sobreescribir el registro leído }
      write(aM, d);
      
      { Leemos el siguiente registro maestro para continuar con el merge }
      leerDatos(aM, d);
    end;
    { Si la provincia del maestro es mayor que la del detalle,
       el mínimo ya se consume en el inner while }      
  end;
  
  close(aM);  close(aD1);  close(aD2);
end;


procedure imprimirMaestro(var aM: archivoMaestro);
var
	d: datos;
begin
	writeln('');
	reset(aM);
	writeln('--- CONTENIDO DEL ARCHIVO MAESTRO ---');
	writeln('');
	while not eof(aM) do begin
		read(aM, d);
		writeln('Provincia: ', d.provincia);
		writeln('  Alfabetizados: ', d.alfabetizados);
		writeln('  Total encuestados: ', d.total);
		writeln('-----------------------------');
	end;
	writeln('');
	close(aM);
end;


var
	aM:archivoMaestro; aD1,aD2:archivoDetalle;
	
begin
	
	assign(aM,'ArchivoMaestro');
	assign(aD1,'Detalle_1'); assign(aD2,'Detalle_2');
	
	imprimirMaestro(aM);
	
	actualizarMaestro(aM,aD1,aD2);

	imprimirMaestro(aM);
	
end.
