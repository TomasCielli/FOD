program crearVentas;

const
	
	FINAL=0;

type
	
	venta=record
		codigo:integer;
		cantidad:integer;
	end;
	
	archivoVentas = file of venta;

procedure cargarVentas(var aV:archivoVentas);
	procedure leerVenta(var v:venta);
	begin
		with v do begin
			write('Codigo de producto (',FINAL,' para terminar): '); readln(v.codigo);
			if (v.codigo <> FINAL) then begin
				write('Unidades vendidas: ');readln(v.cantidad);
			end;
		end;
	end;
	
var
	v:venta;
begin
	rewrite(aV);
	leerVenta(v);
	while (v.codigo <> FINAL) do begin
		write(aV,v);
		leerVenta(v);
	end;
end;
	





var
	
	aV:archivoVentas;

begin

	
	assign(aV,'Ventas');
	
	writeln('-------------- Datos de las Ventas ----------------');
	writeln('');
	cargarVentas(aV);
	
end.
