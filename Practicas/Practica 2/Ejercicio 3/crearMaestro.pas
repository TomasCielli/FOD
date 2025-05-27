program CrearMaestro;

type
	str = string[50];
	
	datos = record
		provincia: str;
		alfabetizados: integer;
		total: integer;
	end;
	
	archivoMaestro = file of datos;

procedure leerDatos(var d: datos);
begin
	with d do begin
		write('Nombre de la provincia ("" para finalizar): '); readln(provincia);
		if (provincia <> '') then begin
			write('Cantidad de alfabetizados: '); readln(alfabetizados);
			write('Total de encuestados: '); readln(total);
		end;
	end;
	writeln('-----------------------------');
end;

procedure crearMaestro(var aM: archivoMaestro);
var
	d: datos;
begin
	rewrite(aM);
	leerDatos(d);
	while (d.provincia <> '') do begin
		write(aM, d);
		leerDatos(d);
	end;
	close(aM);
	writeln('Archivo maestro creado con exito.');
end;

procedure imprimirMaestro(var aM: archivoMaestro);
var
	d: datos;
begin
	reset(aM);
	while not eof(aM) do begin
		read(aM, d);
		writeln('Provincia: ', d.provincia);
		writeln('  Alfabetizados: ', d.alfabetizados);
		writeln('  Total encuestados: ', d.total);
		writeln('-----------------------------');
	end;
	close(aM);
end;

var
	aM: archivoMaestro;
	op: char;

begin
	assign(aM, 'ArchivoMaestro');
	write('Deseas (C)rear o (V)er el archivo maestro? '); readln(op);
	case upcase(op) of
		'C': crearMaestro(aM);
		'V': imprimirMaestro(aM);
	else
		writeln('Opción no valida.');
	end;
end.


