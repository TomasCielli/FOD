program generar_datos_prueba;

const
  CANTDELEGACIONES = 3;  // pruebas con 3 delegaciones
  VALORALTO = 9999;

type
  str = string[50];
  dma = record dia: 1..31; mes: 1..12; anio: 2014..2025; end;
  hms = record hora, minuto, segundo: 0..59; end;
  dir = record calle, numero, piso, depto, ciudad: str; end;
  datos_pariente = record nombre, apellido: str; dni: integer; end;

  reg_nacimiento = record
    numero: integer;
    nombre, apellido: str;
    direccion: dir;
    matricula: str;
    madre, padre: datos_pariente;
  end;
  archivo_nac = file of reg_nacimiento;

  reg_fallecimiento = record
    numero: integer;
    dni: integer;
    nombre, apellido: str;
    matricula: str;
    fecha: dma;
    hora: hms;
    direccion: dir;
  end;
  archivo_fal = file of reg_fallecimiento;

  delegacion = record det_nac: archivo_nac; det_fal: archivo_fal; end;
  vector_deleg = array[1..CANTDELEGACIONES] of delegacion;

var
  deleg: vector_deleg;
  rn: reg_nacimiento;
  rf: reg_fallecimiento;

begin
  // Asignar archivos
  assign(deleg[1].det_nac, 'nacimientos_1');
  assign(deleg[1].det_fal, 'fallecimientos_1');
  assign(deleg[2].det_nac, 'nacimientos_2');
  assign(deleg[2].det_fal, 'fallecimientos_2');
  assign(deleg[3].det_nac, 'nacimientos_3');
  assign(deleg[3].det_fal, 'fallecimientos_3');

  // Datos de prueba delegación 1
  rewrite(deleg[1].det_nac);
  rn.numero := 1;
  rn.nombre := 'Nombre1';
  rn.apellido := 'Apellido1';
  rn.direccion.calle := 'Calle1'; rn.direccion.numero := '1'; rn.direccion.piso := '1'; rn.direccion.depto := 'A'; rn.direccion.ciudad := 'Ciudad1';
  rn.matricula := 'M1';
  rn.madre.nombre := 'Madre1'; rn.madre.apellido := 'Map1'; rn.madre.dni := 1001;
  rn.padre.nombre := 'Padre1'; rn.padre.apellido := 'Pap1'; rn.padre.dni := 2001;
  write(deleg[1].det_nac, rn);
  close(deleg[1].det_nac);

  rewrite(deleg[1].det_fal);
  // no hay fallecimiento para 1
  close(deleg[1].det_fal);

  // Datos de prueba delegación 2
  rewrite(deleg[2].det_nac);
  rn.numero := 2;
  rn.nombre := 'Nombre2';
  rn.apellido := 'Apellido2';
  rn.direccion.calle := 'Calle2'; rn.direccion.numero := '2'; rn.direccion.piso := '2'; rn.direccion.depto := 'B'; rn.direccion.ciudad := 'Ciudad2';
  rn.matricula := 'M2';
  rn.madre.nombre := 'Madre2'; rn.madre.apellido := 'Map2'; rn.madre.dni := 1002;
  rn.padre.nombre := 'Padre2'; rn.padre.apellido := 'Pap2'; rn.padre.dni := 2002;
  write(deleg[2].det_nac, rn);
  close(deleg[2].det_nac);

  rewrite(deleg[2].det_fal);
  rf.numero := 2;
  rf.dni := 3002;
  rf.nombre := 'Fallec2';
  rf.apellido := 'Fap2';
  rf.matricula := 'FM2';
  rf.fecha.dia := 10; rf.fecha.mes := 5; rf.fecha.anio := 2020;
  rf.hora.hora := 12; rf.hora.minuto := 0; rf.hora.segundo := 0;
  rf.direccion.calle := 'CFal2'; rf.direccion.numero := '12'; rf.direccion.piso := '2'; rf.direccion.depto := 'B'; rf.direccion.ciudad := 'CiudadF2';
  write(deleg[2].det_fal, rf);
  close(deleg[2].det_fal);

  // Datos de prueba delegación 3
  rewrite(deleg[3].det_nac);
  rn.numero := 3;
  rn.nombre := 'Nombre3';
  rn.apellido := 'Apellido3';
  rn.direccion.calle := 'Calle3'; rn.direccion.numero := '3'; rn.direccion.piso := '3'; rn.direccion.depto := 'C'; rn.direccion.ciudad := 'Ciudad3';
  rn.matricula := 'M3';
  rn.madre.nombre := 'Madre3'; rn.madre.apellido := 'Map3'; rn.madre.dni := 1003;
  rn.padre.nombre := 'Padre3'; rn.padre.apellido := 'Pap3'; rn.padre.dni := 2003;
  write(deleg[3].det_nac, rn);
  close(deleg[3].det_nac);

  rewrite(deleg[3].det_fal);
  // no hay fallecimiento para 3
  close(deleg[3].det_fal);
end.
