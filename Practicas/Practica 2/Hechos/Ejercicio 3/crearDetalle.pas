program CrearDetalles;

type
	str = string[50];

	censo = record
		provincia: str;
		codigoLocalidad: integer;
		alfabetizados: integer;
		total: integer;
	end;

	archivoDetalle = file of censo;

procedure leerCenso(var c: censo);
begin
	with c do begin
		write('Nombre de la provincia ("" para finalizar): '); readln(provincia);
		if (provincia <> '') then begin
			write('Codigo de localidad: '); readln(codigoLocalidad);
			write('Cantidad de alfabetizados: '); readln(alfabetizados);
			write('Total de encuestados: '); readln(total);
		end;
	end;
	writeln('-----------------------------');
end;

procedure crearDetalle(var aD: archivoDetalle; num: integer);
var
	c: censo;
begin
	rewrite(aD);
	writeln('--- Cargando Detalle_', num, ' ---');
	leerCenso(c);
	while (c.provincia <> '') do begin
		write(aD, c);
		leerCenso(c);
	end;
	close(aD);
	writeln('Detalle_', num, ' creado.');
end;

procedure imprimirDetalle(var aD: archivoDetalle; num: integer);
var
	c: censo;
begin
	reset(aD);
	writeln('--- Detalle_', num, ' ---');
	while not eof(aD) do begin
		read(aD, c);
		writeln('Provincia: ', c.provincia);
		writeln('  Localidad: ', c.codigoLocalidad);
		writeln('  Alfabetizados: ', c.alfabetizados);
		writeln('  Total: ', c.total);
		writeln('-----------------------------');
	end;
	close(aD);
end;

var
	aD1, aD2: archivoDetalle;
	op: char;

begin
	assign(aD1, 'Detalle_1');
	assign(aD2, 'Detalle_2');
	write('Deseas (C)rear o (V)er los archivos detalle? '); readln(op);
	case upcase(op) of
		'C': begin
			crearDetalle(aD1, 1);
			crearDetalle(aD2, 2);
		end;
		'V': begin
			imprimirDetalle(aD1, 1);
			imprimirDetalle(aD2, 2);
		end;
	else
		writeln('Opcion no válida.');
	end;
end.
