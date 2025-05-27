{

7.  Realizar un programa que permita: 

a)  Crear un archivo binario a partir de la información almacenada en un archivo de 
texto.  

El  nombre  del  archivo  de  texto  es:  “novelas.txt”.  

La  información  en el archivo de texto consiste en:    código de novela, 
                                                        nombre, 
                                                        género y 
                                                        precio de diferentes novelas argentinas. 

Los datos de cada novela se almacenan en dos líneas en el archivo de texto. 

La primera línea contendrá la siguiente información:    código novela, 
                                                        precio y 
                                                        género, y 
la segunda línea almacenará el nombre de la novela.

b)  Abrir  el  archivo  binario  y  permitir  la  actualización del mismo. 

Se debe poder agregar  una  novela  y modificar una existente. 

Las búsquedas se realizan por código de novela. 

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado

}

program ej07;

const

    NOMBRETEXTO = 'novelas.txt';

    FIN = -1;

type 

    str = String[40];

    novela = record
        codigo: integer;
        nombre: str;
        genero: str;
        precio: real;
    end;

    archivo_novela = file of novela;

procedure leer_novela(var a: archivo_novela; var n: novela);
begin
    if not (eof(a)) then read(a, n)
    else n.codigo := FIN;
end;

procedure exportar(var a: archivo_novela);
var
    texto: Text;
    n: novela;
begin
    assign(texto, 'novelas.txt');
    rewrite(texto);
    seek(a, 0);
    leer_novela(a, n);
    while (n.codigo <> FIN) do begin
        writeln(texto, n.codigo, ' ', n.precio:0:2, ' ', n.genero);
        writeln(texto, n.nombre);
        leer_novela(a, n);
    end;
    close(texto);
end;

procedure importar(var a: archivo_novela);
var
    n: novela;
    texto: Text;
begin
    assign(texto, 'novelas.txt');
    reset(texto);

    while (not eof(texto)) do begin
        readln(texto, n.codigo, n.precio, n.genero);
        readln(texto, n.nombre);
        write(a, n);
    end;

    close(texto);
end;


function esta (var a: archivo_novela; c: integer): boolean;
var 
    n: novela;
    encontre: boolean;
begin
    seek(a, 0);
    encontre:= false;
    leer_novela(a, n);

    while (n.codigo <> FIN) and (not encontre) do begin
        if (n.codigo = c) then encontre:= true
        else leer_novela(a, n);
    end;
    esta:= encontre;
end;

procedure modificar_novela(var a: archivo_novela; c: integer);
var
    n: novela;
    encontre: boolean;
begin

    encontre := false;
    seek(a, 0);

    leer_novela(a, n);
    while (n.codigo <> FIN) and (not encontre) do begin
        if (n.codigo = c) then begin
            encontre := true;
            writeln('Nuevos datos: '); writeln(' ');
            write('  '); write('Nombre: '); readln(n.nombre); writeln(' ');
            write('  '); write('Genero: '); readln(n.genero); writeln(' ');
            write('  '); write('Precio: $'); readln(n.precio); writeln(' ');
            seek(a, filepos(a) -1);
            write(a, n);
        end
        else leer_novela(a, n);
    end;
    if (not encontre) then begin
        writeln('ERROR: No se encontro el codigo.'); writeln(' ');
    end;
end;

procedure crear_novela (var a: archivo_novela; var n: novela);
var
    aux: char;
begin
    with n do begin
        write('Codigo (', FIN,' para terminar): '); readln(codigo); writeln(' ');
        if (codigo <> FIN) then begin
            if (not esta(a, n.codigo)) then begin
                write('Nombre: '); readln(nombre); writeln(' ');
                write('Genero: '); readln(genero); writeln(' ');
                write('Precio: $'); readln(precio); writeln(' ');
            end
            else begin
                write('ERROR: Ya existe una novela con ese codigo, desea modificarla? (S/N): '); readln(aux); writeln(' ');
                if ((aux = 'S') or (aux = 's')) then modificar_novela(a, n.codigo)
                else crear_novela(a, n);
            end;
        end;
    end;
end;

procedure agregar_novelas (var a: archivo_novela);
var
    n:novela;
begin
    crear_novela(a, n);
    while (n.codigo <> FIN) do begin
        write(a, n);
        crear_novela(a, n);
    end;
end;

var
    nomb: str;
    a: archivo_novela;
    opc, c: integer;
    cargado: boolean;
begin
    write('Nombre del archivo: '); readln(nomb); writeln(' ');
    assign(a, nomb);
    cargado:= false;


    repeat
        writeln('Opcion 0: Cerrar.');
        writeln('Opcion 1: Agregar Novela.');
        writeln('Opcion 2: Modificar Novela.');
        writeln('Opcion 3: Importar del texto.');
        writeln('Opcion 4: Exportar al texto.');
        write('Opcion: '); readln(opc); writeln(' ');
        
        case opc of 
            1:  begin
                    if cargado then reset(a) else rewrite(a);
                    agregar_novelas(a);
                    close(a);
                    cargado:= true;
                end;
            2:  begin
                    if cargado then begin
                        write('Codigo de novela a modificar: '); readln(c); writeln(' ');
                        reset(a);
                        modificar_novela(a, c);
                        close(a);
                    end
                    else begin
                        writeln('ERROR: El archivo binario no esta cargado.'); writeln(' ');
                    end;
                end;
            3:  begin
                    rewrite(a);
                    importar(a);
                    close(a);
                    cargado:= true;
                end;
            4:  begin
                    if cargado then begin
                        reset(a);
                        exportar(a);
                        close(a);
                    end
                    else begin
                        writeln('ERROR: El archivo binario no esta cargado.'); writeln(' ');
                    end;
                end;
        end;

        if (opc < 0) or (opc > 4) then begin
            writeln('ERROR: Opcion no valida.'); writeln(' ');
        end;


    until opc = 0;
End.