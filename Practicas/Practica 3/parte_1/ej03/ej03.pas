{

Realizar un programa que genere un archivo de novelas filmadas durante el presente 
año. 
De cada novela se registra: código, 
                            género, 
                            nombre, 
                            duración, 
                            director  y 
                            precio. 

El programa debe presentar un menú con las siguientes opciones: 
    
    a.  Crear el archivo y cargarlo a partir de datos ingresados por teclado. 

    Se utiliza la técnica de lista invertida para recuperar espacio libre en el archivo.
    
    Para ello, durante la creación del archivo, en el primer registro del mismo  se  debe  almacenar  la  cabecera  de  la  lista.  
    
    Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela, 
    el cual indica que no hay espacio libre dentro del archivo.

    b.  Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso  a),  
    se utiliza lista invertida para recuperación de espacio.
    En particular, para el campo de “enlace” de la lista (utilice el código de novela  como  enlace),  
    se debe especificar los números de registro referenciados con signo negativo.  
    
    Una vez abierto el archivo, brindar operaciones para: 
    
            i.  Dar de alta una novela leyendo la información desde teclado. 
            Para esta  operación, en caso de ser posible, deberá recuperarse el espacio libre. 
            Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5, 
            se debe leer el registro en la posición 5, copiarlo en la posición 0 
            (actualizar la lista de espacio libre) y grabar el nuevo registro en la posición 5. 
            Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.

            ii.  Modificar  los  datos  de una novela leyendo la información desde 
            teclado. El  código de novela no puede ser modificado.

            iii.  Eliminar una novela cuyo código es ingresado por teclado. 
            Por ejemplo, si se da de baja un registro en la posición 8, en el campo 
            código de novela del registro cabecera deberá figurar -8, y en el 
            registro en la posición 8 debe copiarse el antiguo registro cabecera.

    c.  Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre. 
    El archivo debe llamarse “novelas.txt”. 

NOTA:  Tanto  en  la creación como en la apertura el nombre del archivo debe ser proporcionado por el usuario. 


}

program ej03;

const
    VALORALTO = 9999;
    NOMBRETEXTO = 'novelas.txt';

type

    str = string[40];

    novela = record
        codigo: integer;
        genero: str;
        nombre: str;
        duracion: str;
        director: str;
        precio: real;
    end;

    archivo = file of novela;

procedure crear_archivo (var a: archivo);
var
    n: novela;
begin
    rewrite(a);
    n.codigo:= 0;
    write(a, n);

    writeln('Datos de la novela: '); writeln('');
    write('Codigo (',VALORALTO,' para terminar): #'); readln(n.codigo); writeln('');

    while (n.codigo <> VALORALTO) do begin
        with n do begin
            write('Nombre: '); readln(nombre); writeln('');
            write('Genero: '); readln(genero); writeln('');
            write('Duracion: '); readln(duracion); writeln('');
            write('Director: '); readln(director); writeln('');
            write('Precio: $'); readln(precio); writeln('');

            write(a, n);
            writeln('Novela cargada.'); writeln('');
            writeln('---------------'); writeln('');

            writeln('Datos de la novela: '); writeln('');
            write('Codigo (',VALORALTO,' para terminar): #'); readln(n.codigo); writeln('');
        end;
    end;
    close(a);
end;

procedure cargar_novela(var a: archivo);
var
    cabecera, n: novela;
    pos_libre: integer;

begin
    write('Codigo (',VALORALTO,' para cancelar): #'); readln(n.codigo); writeln('');
    if (n.codigo <> VALORALTO) then begin
        write('Nombre: '); readln(n.nombre); writeln('');
        write('Genero: '); readln(n.genero); writeln('');
        write('Duracion: '); readln(n.duracion); writeln('');
        write('Director: '); readln(n.director); writeln('');
        write('Precio: $'); readln(n.precio); writeln('');

        seek(a, 0);
        read(a, cabecera);

        if (cabecera.codigo = 0) then begin
            seek(a, filesize(a));
            write(a, n);
        end
        else begin
            pos_libre:= cabecera.codigo;
            seek(a, pos_libre);
            read(a, cabecera);

            seek(a, 0);
            write(a, cabecera);

            seek(a, pos_libre);
            write(a, n);
        end;
    end
    else begin
        writeln('');
        writeln('Carga cancelada.');
        writeln('');
    end;
end;

procedure leer(var a: archivo; var n:novela);
begin
    if (not eof(a)) then read(a, n)
    else n.codigo:= VALORALTO;
end;

procedure modificar_datos (var a: archivo);
var
    aux, n: novela;

begin
    write('Codigo de la novela que desea modificar (', VALORALTO,' para cancelar): #'); readln(n.codigo); writeln('');
    if (n.codigo <> VALORALTO) then begin
        writeln('Buscando novela...');writeln('');

        seek(a, 1);
        leer(a, aux);
        while (aux.codigo <> VALORALTO) and (aux.codigo <> n.codigo) do leer(a, aux);
        if (aux.codigo = n.codigo) then begin
            writeln('Nuevos datos: '); writeln('');
            write('Nombre: '); readln(n.nombre); writeln('');
            write('Genero: '); readln(n.genero); writeln('');
            write('Duracion: '); readln(n.duracion); writeln('');
            write('Director: '); readln(n.director); writeln('');
            write('Precio: $'); readln(n.precio); writeln('');

            seek(a, filepos(a) -1);
            write(a, n);
            writeln('Novela modificada.'); writeln('');
        end
        else begin
            writeln('');
            writeln('No se encontro una novela con ese codigo'); 
            writeln('');
        end;
    end;
end;

procedure eliminar_novela(var a: archivo);
var
    cabecera, n: novela;
    codigo, pos: integer;

begin
    write('Codigo de la novela que desea borrar (',VALORALTO,' para cancelar): #'); readln(codigo); writeln('');
    if (codigo <> VALORALTO) then begin
        seek(a, 0);
        leer(a, cabecera);

        leer(a, n);
        while (n.codigo <> VALORALTO) and (n.codigo <> codigo) do leer(a, n);
        if (n.codigo = codigo) then begin
            seek(a, filepos(a) -1);
            pos:= filepos(a);
            n.codigo:= cabecera.codigo;
            write(a, n);

            seek(a, 0);
            cabecera.codigo:= pos * -1;
            write(a, cabecera);
        end
        else begin
            writeln('');
            writeln('No se encontro una novela con ese codigo'); 
            writeln('');
        end;
    end;
end;


procedure abrir_archivo (var a: archivo);
var
    opc: integer;

begin
    reset(a);

    writeln('');
    writeln('Archivo abierto.'); 
    writeln('');

    repeat

        writeln('Opcion 0: Atras.');
        writeln('Opcion 1: Cargar novela.');
        writeln('Opcion 2: Modificar novela.');
        writeln('Opcion 3: Eliminar novela.');
        write('Opcion: '); readln(opc); writeln('');

        case opc of
        
            1: cargar_novela(a);
            2: modificar_datos(a);
            3: eliminar_novela(a);

        end;

        if (opc < 0) or (opc > 3) then begin
            writeln('');
            writeln('ERROR: Opcion no valida.');
            writeln('');
        end;

    until opc = 0;

    close(a);
end;

procedure mostrar_archivo(var a: archivo);
var
  n: novela;
begin
  reset(a);
  writeln('------ NOVELAS ACTIVAS ------');
  leer(a, n);
  while (n.codigo <> VALORALTO) do begin
    if (n.codigo > 0) then begin
      writeln('Codigo: ', n.codigo);
      writeln('Nombre: ', n.nombre);
      writeln('Genero: ', n.genero);
      writeln('Precio: $', n.precio:0:2);
      writeln('----------------------------');
    end;
    leer(a, n);
  end;

  // Volvemos al inicio para mostrar las eliminadas
  seek(a, 1);
  leer(a, n);
  writeln('------ NOVELAS ELIMINADAS ------');
  while (n.codigo <> VALORALTO) do begin
    if (n.codigo <= 0) then begin
      writeln('Codigo: ', n.codigo);
      writeln('Nombre: ', n.nombre);
      writeln('Genero: ', n.genero);
      writeln('Precio: $', n.precio:0:2);
      writeln('----------------------------');
    end;
    leer(a, n);
  end;
  close(a);
end;


procedure exportar_archivo(var a: archivo);
var
    texto: text;
    n: novela;
begin
    assign(texto, 'novelas.txt');
    rewrite(texto);
    writeln(texto,'----------- LISTADO NOVELAS -----------');
    writeln(texto, '');

    reset(a);
    leer(a, n);
    while (n.codigo <> VALORALTO) do begin
        if (n.codigo > 0) then begin
            writeln(texto, '');
            writeln(texto, '#', n.codigo, ' ', n.nombre, ' | $', n.precio:0:2);
        end;
        leer(a, n);
    end;

    seek(a, 1);

    writeln(texto,' ');
    writeln(texto,'----------- NOVELAS ELIMINADAS -----------');
    writeln(texto, '');

    leer(a, n);
    while( n.codigo <> VALORALTO) do begin
        if (n.codigo <= 0) then begin
            writeln(texto, '');
            writeln(texto, '#', n.codigo, ' ', n.nombre, ' | $', n.precio:0:2);
        end;
        leer(a, n);
    end;

    close(texto);
    close(a);
end;


var
    a: archivo;
    opc: integer;
    nomb_arc: str;

begin
    write('Nombre del archivo a trabajar: '); readln(nomb_arc); writeln('');
    assign(a, nomb_arc);

    repeat
        writeln('Opcion 0: Cerrar.');
        writeln('Opcion 1: Crear archivo de cero.');
        writeln('Opcion 2: Trabajar sobre archivo existente.');
        writeln('Opcion 3: Exportar archivo a texto.');
        writeln('Opcion 4: Mostrar contenido del archivo.');


        write('Opcion: '); readln(opc); writeln('');

        case opc of

        1: crear_archivo(a);
        2: abrir_archivo(a);
        3: exportar_archivo(a);
        4: mostrar_archivo(a);


        end;

        if (opc < 0) or (opc > 4) then begin
            writeln('');
            writeln('ERROR: Opcion no valida.');
            writeln('');
        end;
    
    until opc = 0

end.