program generar_archivo_novelas;

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

var
    a: archivo;
    n: novela;

procedure agregar(var a: archivo; cod: integer; nom, gen, dur, dir: str; precio: real);
begin
    n.codigo := cod;
    n.nombre := nom;
    n.genero := gen;
    n.duracion := dur;
    n.director := dir;
    n.precio := precio;
    write(a, n);
end;

begin
    assign(a, 'novelas');
    rewrite(a);

    // Cabecera sin espacio libre
    n.codigo := 0;
    n.genero := '';
    n.nombre := '';
    n.duracion := '';
    n.director := '';
    n.precio := 0.0;
    write(a, n);

    // 10 novelas activas
    agregar(a, 1, 'El Padrino', 'Drama', '175 min', 'Francis Ford Coppola', 5000.00);
    agregar(a, 2, 'Interestelar', 'Ciencia Ficcion', '169 min', 'Christopher Nolan', 4600.00);
    agregar(a, 3, 'Pulp Fiction', 'Crimen', '154 min', 'Quentin Tarantino', 4300.00);
    agregar(a, 4, 'La La Land', 'Musical', '128 min', 'Damien Chazelle', 4100.00);
    agregar(a, 5, 'Forrest Gump', 'Drama', '142 min', 'Robert Zemeckis', 3900.00);
    agregar(a, 6, 'Inception', 'Accion', '148 min', 'Christopher Nolan', 4700.00);
    agregar(a, 7, 'Coco', 'Animacion', '105 min', 'Lee Unkrich', 3500.00);
    agregar(a, 8, 'Parasite', 'Thriller', '132 min', 'Bong Joon-ho', 4200.00);
    agregar(a, 9, 'El Laberinto del Fauno', 'Fantasia', '118 min', 'Guillermo del Toro', 3800.00);
    agregar(a, 10, 'El secreto de sus ojos', 'Suspenso', '129 min', 'Juan José Campanella', 4000.00);

    close(a);
    writeln('Archivo "novelas" generado correctamente con 10 novelas.');
end.
