{

2. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. 

Para ello, genera un archivo maestro donde figuran todos los productos que comercializa. 

De cada producto se maneja la siguiente información: código de producto, nombre comercial, precio de venta, stock actual y stock mínimo. 

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 

De cada venta se registran: código de producto y cantidad de unidades vendidas. 


Se pide realizar un programa con opciones para:


	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:

		● Ambos archivos están ordenados por código de producto.

		● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.

		● El archivo detalle sólo contiene registros que están en el archivo maestro.


	b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.}







program Ejer2;

const

	FINAL=0;

type
	
	opciones= FINAL .. 2;
	
	str=string[50];
	
	producto =     record
		codigo:   integer;
		nombre:       str;
		precio:       real;
		stock:    integer;
		stockMin: integer;
	end;
	
	venta = 	  record
		codigo:  integer;
		cantidad:integer;
	end;
	
	archivoProductos = file of producto;
	
	archivoVentas =    file of venta;

procedure leerProducto(var a: archivoProductos; var p:producto);
begin
	if (not eof(a)) then read(a,p)
					else p.codigo := FINAL;
end;

procedure leerventa(var a: archivoVentas; var v:venta);
begin
	if (not eof(a)) then read(a,v)
					else v.codigo := FINAL;
end;


{------------------------------- PUNTO A ------------------------------------------}


procedure actualizarProductos(var aP:archivoProductos; cod:integer; cant:integer);
var
	p:producto;
begin
	
	leerProducto(aP,p);
	while (p.codigo < cod) do leerProducto(aP,p);
	p.stock:= p.stock - cant;
	seek(aP,filepos(aP)-1);
	write(aP,p);
end;


procedure recorrerVentas (var aP:archivoProductos; var  aV:archivoVentas);
var
	v:venta;
	total,codAnt:integer;
begin
	
	reset(aP); reset(aV);
	leerVenta(aV,v);
	while (v.codigo <> FINAL) do begin
		total:= 0; codAnt:= v.codigo;
		while (codAnt = v.codigo) do begin
			total:= total + v.cantidad;
			leerVenta(aV,v);
		end;
		actualizarProductos(aP,codAnt,total);
	end;
	close(aP); close(aV);
end;
		

{----------------------------- PUNTO B --------------------------------}

procedure escribirProducto(var aT:text; p:producto);
begin
	
	writeln(aT,'------------ Producto ------------');
	writeln(aT,'');
	writeln(aT,p.nombre,' $',p.precio:0:2);
	writeln(aT,p.stock,' / ', p.stockMin);
	writeln(aT,'');

end;

procedure listarStockMin (var aP:archivoProductos);
var
	p:producto;
	aT:text;
begin
	assign(aT,'stock_minimo.txt');
	reset(ap); rewrite(aT);
	
	leerProducto(aP,p);
	while(p.codigo <> FINAL) do begin
		if (p.stock < p.stockMin) then escribirProducto(aT,p);
		leerProducto(aP,p);
	end;
	close(aP); close(aT);
end;






var
	opcion: opciones;
	aP:archivoProductos; aV:archivoVentas;

begin
	
	assign(aP,'Productos');
	assign(aV,'Ventas');
	
	repeat
		
		writeln('');
		writeln('Elija una opcion: ');
		writeln(FINAL,': Fin.');
		writeln('1: Actualizar Productos.');
		writeln('2: Listar productos con bajo stock.');
		writeln('');
		
		write('Opcion --->'); readln(opcion);
		case opcion of
		
			FINAL: writeln('PROGRAMA TERMINADO.');
		
			1: recorrerVentas(aP,aV);
		
			2: listarStockMin(aP);
		
		end;
	until (opcion = FINAL);

end.
