{

5. Suponga que trabaja en una oficina donde está montada una LAN (red local). 

La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas se conectan con un servidor central. 

Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por cuánto tiempo estuvo abierta. 

Cada archivo detalle contiene los siguientes campos: cod_usuario, 
													 fecha, 
													 tiempo_sesion. 


Debe realizar un procedimiento que reciba los archivos detalle 

y genere un archivo maestro con los siguientes datos: cod_usuario, 
													  fecha, 
													  tiempo_total_de_sesiones_abiertas.



Notas:
	
	● Cada archivo detalle está ordenado por cod_usuario y fecha.

	● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.

	● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

}

program Ejer5;

CONST

	valor_alto = 32767;
	cantidad_de_maquinas = 5;
	
type
	
	rango_dias = 1..31;
	rango_meses = 1..12;
	
	dma = record
		dia: rango_dias;
		mes: rango_meses;
		anio: integer;
	end;
	
	log = record
		codigo: integer;
		fecha : dma;
		tiempo : real;
	end;
	
	detalle = file of log;
	maestro = file of log;
	
	vector_detalles = array [1..cantidad_de_maquinas] of detalle;
	vector_logs = array [1..cantidad_de_maquinas] of log;
	
procedure leer (var a: detalle; var l: log); begin
	if (not eof(a)) then read(a,l)
	else l.codigo := valor_alto;
end;

procedure minimo (var logs: vector_logs; var detalles: vector_detalles; var min: log);

	function fecha_menor (f,f_min:dma): boolean; begin
	
		if (f.anio < f_min.anio) then fecha_menor:= true
		else if ((f.anio = f_min.anio) and (f.mes < f_min.mes)) then fecha_menor:= true
			 else if ((f.anio = f_min.anio) and (f.mes = f_min.mes) and (f.dia < f_min.dia)) then fecha_menor:=true
				  else fecha_menor:=false;
	end;

var

	i,pos:integer;
	
begin
	
	min.codigo:= valor_alto;
	pos:=valor_alto;
	
	for i:= 1 to cantidad_de_maquinas do begin
		if ((logs[i].codigo <> valor_alto) and (logs[i].codigo <= min.codigo)) then begin
			if (fecha_menor(logs[i].fecha, min.fecha)) then begin
				min:=logs[i];
				pos:=i;
			end;
		end;
	end;
	if (pos <> valor_alto) then leer(detalles[pos],logs[pos]);
end;

procedure crear_maestro (var mae:maestro; var detalles: vector_detalles);
var

	i,codigo: integer;
	min,aux: log;
	logs: vector_logs;
	fecha:dma;
	total: real;

begin
	
	assign(mae,'Maestro');
	rewrite(mae);
	
	for i:= 1 to cantidad_de_maquinas do begin
		reset(detalles[i]);
		leer(detalles[i],logs[i]);
	end;
	
	minimo(logs,detalles,min);
	while (min.codigo <> valor_alto) do begin
	
		codigo:= min.codigo;
		while ((min.codigo <> valor_alto) and (codigo = min.codigo)) do begin
		
			fecha:= min.fecha;
			total:= 0.0;
			while ((min.codigo <> valor_alto) and (codigo = min.codigo) and ((fecha.anio = min.fecha.anio) and (fecha.mes = min.fecha.mes) and (fecha.dia = min.fecha.dia))) do begin
			
				total:= total + min.tiempo;
				minimo(logs,detalles,min);
				
			end;
			aux.codigo:= codigo; aux.fecha:= fecha; aux.tiempo:= total;
			write(mae,aux);
			
		end;
		
	end;
	close(mae);
	for i:=1 to cantidad_de_maquinas do close(detalles[i]);

end;

begin

	writeln('Hola Tomi');
	
end.
