{
   7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de Informática. 
   
   Cada registro del archivo maestro contiene: código de alumno, 
											   apellido,
											   nombre, 
											   cantidad de cursadas aprobadas 
											   y cantidad de materias con final aprobado. 
	El archivo maestro está ordenado por código de alumno.

Además, se tienen dos archivos detalle con información sobre el desempeño académico de los alumnos: un archivo de cursadas 
																									y un archivo de exámenes finales. 

	El archivo de cursadas contiene información sobre las materias cursadas por los alumnos. 
	Cada registro incluye: código de alumno, 
						   código de materia, 
						   año de cursada y 
						   resultado (solo interesa si la cursada fue aprobada o desaprobada). 

	Por su parte, el archivo de exámenes finales contiene información sobre los exámenes finales rendidos. 
	Cada registro incluye: código de alumno, 
						   código de materia, 
						   fecha del examen y 
						   nota obtenida. 
						   
	Ambos archivos detalle están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o más registros por alumno en el archivo maestro. 

Un alumno podría cursar una materia muchas veces, así como también podría rendir el final de una materia en múltiples ocasiones.

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la información de los archivos detalle. 

Las reglas de actualización son las siguientes:
	● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas aprobadas.
	
	● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad de materias con final aprobado.

Notas:
	● Los archivos deben procesarse en un único recorrido.
	
	● No es necesario comprobar que no haya inconsistencias en la información de los archivos detalles. 
	  Esto es, no puede suceder que un alumno apruebe más de una vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar ocurre con los exámenes finales.

}


program Ejer7;

const

	valor_alto = 32767;
	
type
	
	str = string[50];
	
	rangoD = 1..31;
	rangoM = 1..12;
	
	dma = record
		dia: rangoD;
		mes: rangoM;
		anio: integer;
	end;
	
	registro_maestro = record
		codigo: integer;
		apellido, nombre: str;
		cursadas, finales: integer;
	end;
	
	cursada = record
		codigo: integer;
		materia: integer;
		anio: integer;
		resultado: boolean;
	end;
	
	final = record
		codigo: integer;
		materia: integer;
		fecha: dma;
		nota: integer;
	end;
	
	cursadas = file of cursada;
	finales = file of final;
	maestro = file of registro_maestro;

procedure leer_alumno(var mae: maestro; a: registro_maestro); begin
	if (not eof(mae)) then read(mae,a)
	else a.codigo:= valor_alto;
end; procedure leer_cursada(var cur: cursadas; c: cursada); begin
	if (not eof(cur)) then read(cur,c)
	else c.codigo:= valor_alto;
end; procedure leer_final(var fin: finales; f: final); begin
	if (not eof(fin)) then read(fin,f)
	else f.codigo:= valor_alto;
end;

procedure actualizar_maestro(var mae: maestro; var cur: cursadas; var fin: finales);
var
	alumno: registro_maestro; una_cursada: cursada; un_final: final;
	termino_cursadas, termino_finales: boolean;

begin

	reset(mae); reset(cur); reset(fin);
	
	leer_cursada(cur,una_cursada); leer_final(fin,un_final);
	if (una_cursada.codigo <> valor_alto) then termino_cursadas:= false; 
	if (un_final.codigo <> valor_alto) then termino_finales:= false;
	
	while (not termino_cursadas or not termino_finales) do begin
		if ((not termino_cursadas) and (not termino_finales)) then begin
			if (una_cursada.codigo < un_final.codigo) then begin
				procesar_cursada(mae, una_cursada, termino_cursadas);
			end;
			else begin
				procesar_final(mae, un_final, termino_finales);
			end;
		end
		else if (termino_cursadas) then procesar_final(mae, un_final, termino_finales)
			 else procesar_cursada(mae, una_cursada, termino_finales);
	end; 
	
	close(mae); close(cur); close(fin);
end;

//HACER LOS PROCESA_...   (TENER EN CUENTA DE LEER DENTRO Y ACTUALIZAR LOS TERMINO_...)
