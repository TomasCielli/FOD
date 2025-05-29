program crear_archivos_ej05;

const
  CANTMAQUINAS = 5;

type
  rango_dias = 1..31;
  rango_meses = 1..12;
  rango_maquinas = 1..CANTMAQUINAS;

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
  i: integer;
  archivos: array [rango_maquinas] of archivo;
  reg: log;

procedure crear_detalle(nombre: string; codigos: array of integer; fechas: array of dma; tiempos: array of real);
var
  f: archivo;
  i: integer;
begin
  assign(f, nombre);
  rewrite(f);
  for i := 0 to High(codigos) do
  begin
    reg.codigo := codigos[i];
    reg.fecha := fechas[i];
    reg.tiempo := tiempos[i];
    write(f, reg);
  end;
  close(f);
end;

var
  fechas1, fechas2, fechas3, fechas4, fechas5: array[0..1] of dma;
begin
  // Fechas para las sesiones
  fechas1[0].dia := 1; fechas1[0].mes := 5; fechas1[0].anio := 2025;
  fechas1[1] := fechas1[0];

  fechas2 := fechas1;
  fechas3 := fechas1;
  fechas4 := fechas1;
  fechas5 := fechas1;

  // Crear los 5 archivos con datos de prueba simples
  crear_detalle('detalle_1', [1, 1], fechas1, [2.5, 1.5]);     // Total 4.0
  crear_detalle('detalle_2', [1, 2], fechas2, [1.0, 2.0]);     // Usuario 1 y 2
  crear_detalle('detalle_3', [2, 2], fechas3, [1.5, 0.5]);     // Usuario 2
  crear_detalle('detalle_4', [3, 3], fechas4, [2.0, 3.0]);     // Usuario 3
  crear_detalle('detalle_5', [1, 3], fechas5, [2.0, 1.0]);     // Usuario 1 y 3

  writeln('Archivos detalle creados.');
end.
