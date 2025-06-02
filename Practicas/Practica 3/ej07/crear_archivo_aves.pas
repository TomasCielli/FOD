program crear_archivo_aves;

type
    str = string[50];

    ave = record
        codigo: integer;
        nombre: str;
        familia: str;
        descripcion: str;
        zona: str;
    end;

    archivo_aves = file of ave;

procedure crear_archivo(var a: archivo_aves);
var
    p: ave;
begin
    assign(a, 'aves');  // Sin extensión .dat
    rewrite(a);  // Crea o sobrescribe el archivo

    // Aves cargadas
    p.codigo := 1;
    p.nombre := 'Cóndor Andino';
    p.familia := 'Cathartidae';
    p.descripcion := 'Ave carroñera de gran tamaño';
    p.zona := 'Cordillera de los Andes';
    write(a, p);

    p.codigo := 2;
    p.nombre := 'Cardenal Amarillo';
    p.familia := 'Thraupidae';
    p.descripcion := 'Ave pequeña con canto melodioso';
    p.zona := 'Bosques del norte argentino';
    write(a, p);

    p.codigo := 3;
    p.nombre := 'Tordo Renegrido';
    p.familia := 'Icteridae';
    p.descripcion := 'Ave común de zonas húmedas';
    p.zona := 'Llanuras pampeanas';
    write(a, p);

    p.codigo := 4;
    p.nombre := 'Águila Mora';
    p.familia := 'Accipitridae';
    p.descripcion := 'Ave rapaz de gran envergadura';
    p.zona := 'Regiones montañosas';
    write(a, p);

    p.codigo := 5;
    p.nombre := 'Pato Crestudo';
    p.familia := 'Anatidae';
    p.descripcion := 'Pato con penacho en la cabeza';
    p.zona := 'Humedales y lagunas';
    write(a, p);

    p.codigo := 6;
    p.nombre := 'Macá Tobiano';
    p.familia := 'Podicipedidae';
    p.descripcion := 'Ave acuática endémica de Santa Cruz';
    p.zona := 'Meseta Patagónica';
    write(a, p);

    p.codigo := 7;
    p.nombre := 'Flamenco Austral';
    p.familia := 'Phoenicopteridae';
    p.descripcion := 'Ave rosada de largas patas';
    p.zona := 'Lagunas altoandinas';
    write(a, p);

    p.codigo := 8;
    p.nombre := 'Ñandú Petiso';
    p.familia := 'Rheidae';
    p.descripcion := 'Ave no voladora parecida al avestruz';
    p.zona := 'Patagonia';
    write(a, p);

    close(a);
    writeln('Archivo "aves" creado y cargado con 8 registros.');
end;

var
    a: archivo_aves;

begin
    crear_archivo(a);
end.
