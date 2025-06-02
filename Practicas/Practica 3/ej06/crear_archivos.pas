program crear_archivos;

type
    str = string[40];

    prenda = record
        codigo: integer;
        descripcion: str;
        colores: str;
        tipo: str;
        stock: integer;
        precio: real;
    end;

    a_prendas = file of prenda;
    a_codigos = file of integer;

var
    fprendas: a_prendas;
    fcodigos: a_codigos;
    p: prenda;
    c: integer;

begin
    assign(fprendas, 'prendas');
    rewrite(fprendas);

    // Prenda 1
    p.codigo := 101;
    p.descripcion := 'Remera Lisa';
    p.colores := 'Rojo, Azul';
    p.tipo := 'Remera';
    p.stock := 10;
    p.precio := 1500.0;
    write(fprendas, p);

    // Prenda 2
    p.codigo := 102;
    p.descripcion := 'Jean Slim';
    p.colores := 'Azul';
    p.tipo := 'Pantalón';
    p.stock := 5;
    p.precio := 4500.0;
    write(fprendas, p);

    // Prenda 3
    p.codigo := 103;
    p.descripcion := 'Camisa Cuadros';
    p.colores := 'Negro y Blanco';
    p.tipo := 'Camisa';
    p.stock := 3;
    p.precio := 3800.0;
    write(fprendas, p);

    // Prenda 4
    p.codigo := 104;
    p.descripcion := 'Buzo Oversize';
    p.colores := 'Gris';
    p.tipo := 'Buzo';
    p.stock := 8;
    p.precio := 5200.0;
    write(fprendas, p);

    // Prenda 5
    p.codigo := 105;
    p.descripcion := 'Campera Corta';
    p.colores := 'Negra';
    p.tipo := 'Campera';
    p.stock := 4;
    p.precio := 9000.0;
    write(fprendas, p);

    // Prenda 6
    p.codigo := 106;
    p.descripcion := 'Pantalón Cargo';
    p.colores := 'Verde Militar';
    p.tipo := 'Pantalón';
    p.stock := 6;
    p.precio := 6100.0;
    write(fprendas, p);

    close(fprendas);

    // Archivo de códigos a eliminar
    assign(fcodigos, 'codigos');
    rewrite(fcodigos);

    c := 102; write(fcodigos, c); // Jean Slim
    c := 104; write(fcodigos, c); // Buzo Oversize
    c := 999; write(fcodigos, c); // No existe
    c := 106; write(fcodigos, c); // Pantalón Cargo

    close(fcodigos);

    writeln('Archivos "prendas" y "codigos" creados correctamente.');
end.
