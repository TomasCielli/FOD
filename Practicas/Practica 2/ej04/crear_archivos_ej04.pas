program crear_archivos_ej04;

const
  CANTSUCURSALES = 10;

type
  str = string[30];

  producto = record
    codigo: integer;
    nombre: str;
    descripcion: str;
    stock: integer;
    stock_min: integer;
    precio: real;
  end;

  reg_det = record
    codigo: integer;
    cantidad: integer;
  end;

  archivo_maestro = file of producto;
  archivo_detalle = file of reg_det;

procedure crear_maestro(var f: archivo_maestro);
var
  p: producto;
begin
  rewrite(f);
  p.codigo := 1; p.nombre := 'Papas'; p.descripcion := 'Papas congeladas 1kg'; p.stock := 100; p.stock_min := 20; p.precio := 150.5;
  write(f, p);
  p.codigo := 2; p.nombre := 'Espinaca'; p.descripcion := 'Espinaca congelada 500g'; p.stock := 80; p.stock_min := 15; p.precio := 120.0;
  write(f, p);
  p.codigo := 3; p.nombre := 'Helado'; p.descripcion := 'Helado de crema 1.5L'; p.stock := 50; p.stock_min := 10; p.precio := 450.75;
  write(f, p);
  p.codigo := 4; p.nombre := 'Pizza'; p.descripcion := 'Pizza congelada 400g'; p.stock := 30; p.stock_min := 10; p.precio := 300.0;
  write(f, p);
  p.codigo := 5; p.nombre := 'Nuggets'; p.descripcion := 'Nuggets de pollo 1kg'; p.stock := 60; p.stock_min := 25; p.precio := 320.4;
  write(f, p);
  close(f);
end;

procedure crear_detalle(var f: archivo_detalle; datos: array of reg_det);
var
  i: integer;
begin
  rewrite(f);
  for i := 0 to High(datos) do
    write(f, datos[i]);
  close(f);
end;

var
  mae: archivo_maestro;
  det1, det2, det3, det4, det5, det6, det7, det8, det9, det10: archivo_detalle;

  datos_det1: array[0..1] of reg_det = ((codigo:1; cantidad:5), (codigo:2; cantidad:3));
  datos_det2: array[0..1] of reg_det = ((codigo:1; cantidad:2), (codigo:3; cantidad:1));
  datos_det3: array[0..0] of reg_det = ((codigo:4; cantidad:7));
  datos_det5: array[0..1] of reg_det = ((codigo:5; cantidad:4), (codigo:2; cantidad:1));
  datos_det6: array[0..0] of reg_det = ((codigo:1; cantidad:6));
  datos_det8: array[0..1] of reg_det = ((codigo:3; cantidad:2), (codigo:4; cantidad:1));
  datos_det10: array[0..0] of reg_det = ((codigo:5; cantidad:3));

begin
  assign(mae, 'maestro');
  crear_maestro(mae);

  assign(det1, 'detalle_1');
  crear_detalle(det1, datos_det1);

  assign(det2, 'detalle_2');
  crear_detalle(det2, datos_det2);

  assign(det3, 'detalle_3');
  crear_detalle(det3, datos_det3);

  assign(det4, 'detalle_4');
  rewrite(det4); // archivo vacío
  close(det4);

  assign(det5, 'detalle_5');
  crear_detalle(det5, datos_det5);

  assign(det6, 'detalle_6');
  crear_detalle(det6, datos_det6);

  assign(det7, 'detalle_7');
  rewrite(det7); // archivo vacío
  close(det7);

  assign(det8, 'detalle_8');
  crear_detalle(det8, datos_det8);

  assign(det9, 'detalle_9');
  rewrite(det9); // archivo vacío
  close(det9);

  assign(det10, 'detalle_10');
  crear_detalle(det10, datos_det10);
end.
