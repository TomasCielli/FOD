program crear_datos_ej03;

type
    str = string[30];

    reg_mae = record
        provincia: str;
        alfabetizados: integer;
        encuestados: integer;
    end;

    reg_det = record
        provincia: str;
        codigo: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;

    archivo_maestro = file of reg_mae;
    archivo_detalle = file of reg_det;

var
    mae: archivo_maestro;
    det1, det2: archivo_detalle;
    rm: reg_mae;
    rd: reg_det;

begin
    // Crear archivo maestro
    assign(mae, 'maestro');
    rewrite(mae);

    rm.provincia := 'Buenos Aires'; rm.alfabetizados := 1000; rm.encuestados := 1200; write(mae, rm);
    rm.provincia := 'Cordoba';      rm.alfabetizados := 800;  rm.encuestados := 900;  write(mae, rm);
    rm.provincia := 'Santa Fe';     rm.alfabetizados := 950;  rm.encuestados := 1100; write(mae, rm);
    rm.provincia := 'Tucuman';      rm.alfabetizados := 700;  rm.encuestados := 850;  write(mae, rm);

    close(mae);

    // Crear detalle 1
    assign(det1, 'detalle_1');
    rewrite(det1);

    rd.provincia := 'Buenos Aires'; rd.codigo := 101; rd.alfabetizados := 50; rd.encuestados := 60; write(det1, rd);
    rd.provincia := 'Cordoba';      rd.codigo := 201; rd.alfabetizados := 30; rd.encuestados := 40; write(det1, rd);
    rd.provincia := 'Santa Fe';     rd.codigo := 301; rd.alfabetizados := 20; rd.encuestados := 25; write(det1, rd);

    close(det1);

    // Crear detalle 2
    assign(det2, 'detalle_2');
    rewrite(det2);

    rd.provincia := 'Buenos Aires'; rd.codigo := 102; rd.alfabetizados := 70; rd.encuestados := 80; write(det2, rd);
    rd.provincia := 'Santa Fe';     rd.codigo := 302; rd.alfabetizados := 25; rd.encuestados := 30; write(det2, rd);
    rd.provincia := 'Tucuman';      rd.codigo := 401; rd.alfabetizados := 40; rd.encuestados := 45; write(det2, rd);

    close(det2);

    writeln('Archivos creados correctamente.');
end.
