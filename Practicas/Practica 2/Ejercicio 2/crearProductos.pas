program crearProductos;
const

	FINAL=0;

type
	
	str=string[50];
	
	producto = record
		codigo:integer;
		nombre:str;
		precio:real;
		stock:integer;
		stockMin:integer;
	end;
	
	archivoProductos= file of producto;
	

procedure crearProductos (var aP:archivoProductos);
	procedure leerCamposProducto(var p:producto);
	begin
		writeln('');
		writeln('-------- Datos del Producto --------');
		writeln('');
		
		write('Codigo (',FINAL,' para terminar): ');readln(p.codigo);
		if (p.codigo <> FINAL) then begin
			write('Nombre: ');readln(p.nombre);
			write('Precio: $');readln(p.precio);
			write('Stock: ');readln(p.stock);
			write('Stock minimo: ');readln(p.stockMin);
		end;
	end;

var
	p:producto;
begin
	
	rewrite(aP);
	leerCamposProducto(p);
	while (p.codigo <> FINAL) do begin
		write(aP,p);
		leerCamposProducto(p);
	end;
	writeln('');
	writeln('------------------------------------');
	writeln('');
end;

var

	aP:archivoProductos;
	
begin
	
	assign(aP,'Productos');
	crearProductos(aP);
	
end.
