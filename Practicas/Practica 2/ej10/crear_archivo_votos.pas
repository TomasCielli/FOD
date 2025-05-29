program crear_archivo_votos;

type
  str = string[30];

  reg_a = record
    provincia: str;
    localidad: str;
    mesa: integer;
    votos: integer;
  end;

  archivo = file of reg_a;

var
  a: archivo;
  r: reg_a;

procedure agregar(prov, loca: str; mesa, votos: integer);
begin
  r.provincia := prov;
  r.localidad := loca;
  r.mesa := mesa;
  r.votos := votos;
  write(a, r);
end;

begin
  assign(a, 'votos');
  rewrite(a);

  // Provincia de Buenos Aires
  agregar('Buenos Aires', 'La Plata', 1, 120);
  agregar('Buenos Aires', 'La Plata', 2, 80);
  agregar('Buenos Aires', 'Mar del Plata', 1, 90);

  // Catamarca
  agregar('Catamarca', 'San Fernando del Valle', 1, 60);
  agregar('Catamarca', 'Valle Viejo', 1, 70);

  // Chaco
  agregar('Chaco', 'Resistencia', 1, 110);
  agregar('Chaco', 'Presidencia Roque Saenz Peña', 1, 95);

  // Chubut
  agregar('Chubut', 'Rawson', 1, 40);
  agregar('Chubut', 'Puerto Madryn', 1, 55);

  // Córdoba
  agregar('Cordoba', 'Cordoba Capital', 1, 150);
  agregar('Cordoba', 'Villa Maria', 1, 85);

  // Corrientes
  agregar('Corrientes', 'Corrientes Capital', 1, 70);
  agregar('Corrientes', 'Goya', 1, 45);

  // Entre Ríos
  agregar('Entre Rios', 'Parana', 1, 100);
  agregar('Entre Rios', 'Concordia', 1, 60);

  // Formosa
  agregar('Formosa', 'Formosa Capital', 1, 90);

  // Jujuy
  agregar('Jujuy', 'San Salvador', 1, 110);

  // La Pampa
  agregar('La Pampa', 'Santa Rosa', 1, 80);

  // La Rioja
  agregar('La Rioja', 'La Rioja Capital', 1, 75);

  // Mendoza
  agregar('Mendoza', 'Mendoza Capital', 1, 130);
  agregar('Mendoza', 'San Rafael', 1, 100);

  // Misiones
  agregar('Misiones', 'Posadas', 1, 85);

  // Neuquén
  agregar('Neuquen', 'Neuquen Capital', 1, 70);

  // Río Negro
  agregar('Rio Negro', 'Viedma', 1, 60);

  // Salta
  agregar('Salta', 'Salta Capital', 1, 95);

  // San Juan
  agregar('San Juan', 'San Juan Capital', 1, 110);

  // San Luis
  agregar('San Luis', 'San Luis Capital', 1, 90);

  // Santa Cruz
  agregar('Santa Cruz', 'Rio Gallegos', 1, 50);

  // Santa Fe
  agregar('Santa Fe', 'Santa Fe Capital', 1, 100);
  agregar('Santa Fe', 'Rosario', 1, 150);

  // Santiago del Estero
  agregar('Santiago del Estero', 'Santiago Capital', 1, 70);

  // Tierra del Fuego
  agregar('Tierra del Fuego', 'Ushuaia', 1, 60);

  // Tucumán
  agregar('Tucuman', 'San Miguel de Tucuman', 1, 120);

  close(a);
  writeln('Archivo "votos" creado con exito.');
end.
