program mostrar_maestro;

type
    str = string[30];

    reg_mae = record
        provincia: str;
        alfabetizados: integer;
        encuestados: integer;
    end;

    archivo_maestro = file of reg_mae;

var
    mae: archivo_maestro;
    r: reg_mae;

begin
    assign(mae, 'maestro');
    reset(mae);

    writeln('--- Contenido del archivo maestro ---');
    writeln;

    while not eof(mae) do begin
        read(mae, r);
        writeln('Provincia: ', r.provincia);
        writeln('  Alfabetizados: ', r.alfabetizados);
        writeln('  Encuestados:   ', r.encuestados);
        writeln;
    end;

    close(mae);
end.
