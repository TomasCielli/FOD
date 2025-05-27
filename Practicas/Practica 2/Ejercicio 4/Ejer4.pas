{

4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. 

De cada producto se almacena: código del producto, 
							  nombre, 
							  descripción, 
							  stock disponible, 
							  stock mínimo 
							  y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. 



Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo maestro. 

La información que se recibe en los detalles es: código de producto 
												 y cantidad vendida. 

Además, se deberá informar en un archivo de texto: nombre de producto, 
												   descripción, 
												   stock disponible 
												   y precio 
de aquellos productos que tengan stock disponible por debajo del stock mínimo.


Pensar alternativas sobre realizar el informe en el mismo procedimiento de actualización, o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).


Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle puede venir 0 o N registros de un determinado producto.

}


program Ejer4;

const
	
	valor_alto = 32767;
	cant_sucursales = 30;
	
type
	
	str = string[50];
	
	producto = record
		codigo: integer;
		nombre: str;
		descripcion: str;
		stock: integer;
		stock_min: integer;
		precio: real;
	end;
	
	venta = record
		codigo: integer;
		cantidad: integer;
	end;
	
	maestro = file of producto;
	
	detalle = file of venta;
	
	vector_detalles = array [1..cant_sucursales] of detalle;
	vector_ventas = array [1..cant_sucursales] of venta;
	
procedure leer (var a: detalle; var v: venta); begin
	if (not eof(a)) then read(a,v)
	else v.codigo := valor_alto;
end;

procedure minimo (var detalles: vector_detalles; var ventas: vector_ventas; var min: venta);

var

	i,pos : integer;
	
begin

	min.codigo := valor_alto;            //el codigo minimo tiene el numero mas alto
	for i:= 1 to cant_sucursales do begin  //recorrer todo el vector de ventas
		if (ventas[i].codigo < min.codigo) then begin	//si la venta tiene un codigo menor que la minima hasta el momento
			min:= ventas[i];   //se actualiza el minimo
			pos:= i;		//se guarda su posicion
		end;
	end;
	if (min.codigo <> valor_alto) then leer(detalles[pos], ventas[pos]);  //si (no llego al fianl) carga otra venta en la posicion guardada

end;

procedure actualizar_stock (var mae: maestro; var detalles: vector_detalles);

	procedure cargar_texto (var txt:text; p:producto);
	begin
		writeln(txt,'Producto: ',p.nombre);
		writeln(txt,'Descripcion: ',p.descripcion);
		writeln(txt,'Stock: ',p.stock);
		writeln(txt,'Precio: $',p.precio:0:2);
		
		writeln(txt, ' ');
		writeln(txt,'--------------');
		writeln(txt, ' ');
	end;
		
var
	i:integer;
	p: producto;
	ventas: vector_ventas;
	txt:text;
	min: venta;
begin
	
	assign(txt,'Stock Bajo.txt');  // Asigna el archivo de texto
	rewrite(txt);              // Lo sobreescribe
	
	for i:= 1 to cant_sucursales do begin  
		reset(detalles[i]);				// Abre los archivos detalles (con las ventas)
		leer(detalles[i],ventas[i]);    // Carga el vector de ventas
	end;
	
	reset(mae); // Abre el archivo maestro
	minimo(detalles,ventas,min);  // Actualiza el minimo
	
	while (min.codigo <> valor_alto) do begin  // Mientras no se terminen las ventas de los detalles
		
		read(mae,p);  // Lee el producto del maestro
		while (min.codigo <> p.codigo) do read(mae,p);  // Avanza hasta que el producto y la venta tengan el mismo codigo
		
		while (p.codigo = min.codigo) do begin  // Mientras que el producto y la venta tengan el mismo codigo
			p.stock := p.stock - min.cantidad;  	// Resta la cantidad
			minimo(detalles,ventas,min);  			// Avanza a la siguiente venta
		end;
		
		if (p.stock < p.stock_min) then cargar_texto(txt,p);  //Si el producto tiene menos stock que el minimo, lo agrega al archivo de texto
		
		seek(mae, filepos(mae)-1);    // Busca la posicion del producto en el maestro
		write(mae,p);				  // Carga el producto denuevo al maestro, con el stock modificado
		
	end;
	
	close(txt);  // Cierra el archivo de texto
	close(mae);  // Cierra el maestro
	for i:= 1 to cant_sucursales do close(detalles[i]);    // Cierra los detalles
end;
		
begin
	write('Hola Tomi');
end.
