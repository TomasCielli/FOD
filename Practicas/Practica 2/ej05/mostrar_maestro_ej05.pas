program mostrar_maestro_ej05;

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
    fecha: dma;
    tiempo: real;
  end;

  archivo = file of log;

var
  mae: archivo;
  reg: log;

begin
  assign(mae, 'maestro');
  reset(mae);
  
  writeln('Contenido del archivo maestro:');
  writeln('-------------------------------');
  
  while not eof(mae) do
  begin
    read(mae, reg);
    writeln('Usuario: ', reg.codigo);
    writeln('Fecha  : ', reg.fecha.dia:2, '/', reg.fecha.mes:2, '/', reg.fecha.anio);
    writeln('Horas  : ', reg.tiempo:0:2);
    writeln('-------------------------------');
  end;

  close(mae);
end.
