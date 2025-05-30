{

A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos 
de toda la provincia de buenos aires de los últimos diez años. 

En pos de recuperar dicha información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas en la provincia, 
un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro reuniendo dicha información.

Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida nacimiento, 
                                                                            nombre, 
                                                                            apellido, 
                                                                            dirección detallada (calle, nro, piso, depto, ciudad), 
                                                                            matrícula del médico, 
                                                                            nombre y apellido de la madre, 
                                                                            DNI madre, 
                                                                            nombre y apellido del padre, 
                                                                            DNI del padre.

En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, 
                                                      DNI, 
                                                      nombre y apellido del fallecido, 
                                                      matrícula del médico que firma el deceso, 
                                                      fecha y hora del deceso y 
                                                      lugar.

Realizar un programa que cree el archivo maestro a partir de toda la información de los archivos detalles. 
Se debe almacenar en el maestro: nro partida nacimiento, 
                                 nombre, 
                                 apellido, 
                                 dirección detallada (calle, nro, piso, depto, ciudad), 
                                 matrícula del médico, 
                                 nombre y apellido de la madre, 
                                 DNI madre, 
                                 nombre y apellido del padre, 
                                 DNI del padre y 
                                 si falleció,
                                    además matrícula del médico que firma el deceso, 
                                    fecha y hora del deceso y 
                                    lugar. 

Se deberá, además, listar en un archivo de texto la información recolectada de cada persona.

Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única. 
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y además puede no haber fallecido.

}

program ej19;

const

    VALORALTO = 9999;
    CANTDELEGACIONES = 3;

type

    //Nombres
    str = string[50];

    //Rangos
    rango_dias = 1..31;
    rango_meses = 1..12;
    rango_anios = 2014..2025;
    rango_horas = 0..23;
    rango_minutos = 0..59;
    rango_segundos = 0..59;
    rango_delegaciones = 1..CANTDELEGACIONES;


    //Fechas
    dma = record
        dia: rango_dias;
        mes: rango_meses;
        anio: rango_anios;
    end;

    //Horas
    hms = record
        hora: rango_horas;
        minuto: rango_minutos;
        segundo: rango_segundos;
    end;

    //Direcciones
    dir = record
        calle: str;
        numero: str;
        piso: str;
        depto: str;
        ciudad: str;
    end;

    //Madre y Padre
    datos_pariente = record
        nombre: str;
        apellido: str;
        dni: integer;
    end;

    //Nacimiento
    reg_nacimiento = record
        numero: integer;
        nombre: str;
        apellido: str;
        direccion: dir;
        matricula: str;
        madre: datos_pariente;
        padre: datos_pariente;
    end;

    //Archivo detalle de Nacimientos
    archivo_nacimientos = file of reg_nacimiento;

    //Fallecimiento 
    reg_fallecimiento = record
        numero: integer;
        dni: integer;
        nombre: str;
        apellido: str;
        matricula: str;
        fecha: dma;
        hora: hms;
        direccion: dir;
    end;

    //Archivo detalle de Fallecimientos
    archivo_fallecimientos = file of reg_fallecimiento;

    //Delegacion
    delegacion = record
        det_nacimientos: archivo_nacimientos;
        det_fallecimientos: archivo_fallecimientos;
    end;

    //Vector de Delegaciones (vector de archivos detalle)
    vector_delegaciones = array [rango_delegaciones] of delegacion;

    //Vector de Nacimientos
    vector_nacimientos = array [rango_delegaciones] of reg_nacimiento;

    //Vector de Fallecimientos
    vector_fallecimientos = array [rango_delegaciones] of reg_fallecimiento;


    //Informacion del Maestro
        //Datos si fallecio
        info_fallecido = record
            matricula: str;
            fecha: dma;
            hora: hms;
            direccion: dir;
        end;

    
    reg_maestro = record
        numero: integer;
        nombre: str;
        apellido: str;
        direccion: dir;
        matricula: str;
        madre: datos_pariente;
        padre: datos_pariente;
        fallecido: boolean;
        si_fallecio: info_fallecido;
    end;

    //Archivo maestro
    archivo_maestro = file of reg_maestro;

//Para leer sobre el archivo de nacimientos
procedure leer_nacimiento(var a: archivo_nacimientos; var n: reg_nacimiento);
begin
    if (not eof(a)) then read(a, n)
    else n.numero:= VALORALTO;
end;

//Para leer sobre el archivo de falleciminetos
procedure leer_fallecimiento(var a: archivo_fallecimientos; var f: reg_fallecimiento);
begin
    if (not eof(a)) then read(a, f)
    else f.numero:= VALORALTO;
end;

//Devuelve el nacimiento con el menor numero (el proximo a procesar)
procedure minimo_nacimiento(var vec_delegaciones: vector_delegaciones; var vec_nacimientos: vector_nacimientos; var min: reg_nacimiento);
var
    i, indicemin: rango_delegaciones;
    valmin: integer;
begin
    valmin:= VALORALTO;  //Valores de inicializacion

    for i:= 1 to CANTDELEGACIONES do begin //Recorrer vector nacimientos
        if (vec_nacimientos[i].numero <= valmin) then begin  //Si es menor al minimo
            valmin:= vec_nacimientos[i].numero;  //Remplazo el valor minimo
            indicemin:= i;  //Guardo su ubicacion
        end;
    end;
    min:= vec_nacimientos[indicemin];  //Devuelvo el minimo
    leer_nacimiento(vec_delegaciones[indicemin].det_nacimientos, vec_nacimientos[indicemin]);  //Actualizo el archivo donde estaba el minimo
end;


//Devuelve el fallecimiento con el menor numero (el proximo a procesar)
procedure minimo_fallecimiento(var vec_delegaciones: vector_delegaciones; var vec_fallecimientos: vector_fallecimientos; var min: reg_fallecimiento);
var
    i, indicemin: rango_delegaciones;
    valmin: integer;
begin
    valmin:= VALORALTO;  //Valores de inicializacion

    for i:= 1 to CANTDELEGACIONES do begin //Recorrer vector fallecimientos
        if (vec_fallecimientos[i].numero <= valmin) then begin  //Si es menor al minimo
            valmin:= vec_fallecimientos[i].numero;  //Remplazo el valor minimo
            indicemin:= i;  //Guardo su ubicacion
        end;
    end;
    min:= vec_fallecimientos[indicemin];  //Devuelvo el minimo
    leer_fallecimiento(vec_delegaciones[indicemin].det_fallecimientos, vec_fallecimientos[indicemin]);  //Actualizo el archivo donde estaba el minimo
end;

procedure abrir_archivos(var vec_delegaciones: vector_delegaciones; var vec_nacimientos: vector_nacimientos; var vec_fallecimientos: vector_fallecimientos);
var
    i: rango_delegaciones;
begin
    for i:= 1 to CANTDELEGACIONES do begin
        reset(vec_delegaciones[i].det_nacimientos);
        reset(vec_delegaciones[i].det_fallecimientos);
        leer_nacimiento(vec_delegaciones[i].det_nacimientos, vec_nacimientos[i]);
        leer_fallecimiento(vec_delegaciones[i].det_fallecimientos, vec_fallecimientos[i]);
    end;
end;

procedure cerrar_archivos(var vec_delegaciones: vector_delegaciones);
var
    i: rango_delegaciones;
begin
    for i:= 1 to CANTDELEGACIONES do begin
        close(vec_delegaciones[i].det_nacimientos);
        close(vec_delegaciones[i].det_fallecimientos);
    end;
end;

procedure merge_nacimientos(var vec_delegaciones: vector_delegaciones; var vec_nacimientos: vector_nacimientos; var merge: archivo_nacimientos);
var  //Mergea todos los archivos de nacimiento en uno solo ordenado de menor a mayor
    min: reg_nacimiento;

begin
    rewrite(merge);  //Sobreescribe y abre el archivo a mergear
    minimo_nacimiento(vec_delegaciones, vec_nacimientos, min);  //Obtiene el nacimiento con menor numero

    while (min.numero <> VALORALTO) do begin  //Mientras no se terminen los nacimientos
        write(merge, min);  //Guarda el nacimiento (con menor numero) en el archivo
        minimo_nacimiento(vec_delegaciones, vec_nacimientos, min);  //Obtiene el siguiente nacimiento con menor numero
    end;

    close(merge);  //CIERRA EL ARCHIVO!!!

end;

procedure merge_fallecimientos(var vec_delegaciones: vector_delegaciones; var vec_fallecimientos: vector_fallecimientos; var merge: archivo_fallecimientos);
var  //Mergea todos los archivos de fallecimiento en uno solo ordenado de menor a mayor
    min: reg_fallecimiento;

begin
    rewrite(merge);  //Sobreescribe y abre el archivo a mergear
    minimo_fallecimiento(vec_delegaciones, vec_fallecimientos, min);  //Obtiene el fallecimiento con menor numero

    while (min.numero <> VALORALTO) do begin  //Mientras no se terminen los fallecimientos
        write(merge, min);  //Guarda el fallecimiento (con menor numero) en el archivo
        minimo_fallecimiento(vec_delegaciones, vec_fallecimientos, min);  //Obtiene el siguiente fallecimiento con menor numero
    end;

    close(merge);  //CIERRA EL ARCHIVO!!!

end;

procedure armar_regm(var m: reg_maestro; n: reg_nacimiento);
begin
    m.numero:= n.numero;

    m.nombre:= n.nombre; m.apellido:= n.apellido;

    m.direccion.calle:= n.direccion.calle; 
    m.direccion.numero:= n.direccion.numero; 
    m.direccion.piso:= n.direccion.piso;
    m.direccion.depto:= n.direccion.depto;
    m.direccion.ciudad:= n.direccion.ciudad;

    m.matricula:= n.matricula;

    m.madre.nombre:= n.madre.nombre; m.madre.apellido:= n.madre.apellido; m.madre.dni:= n.madre.dni;

    m.padre.nombre:= n.padre.nombre; m.padre.apellido:= n.padre.apellido; m.padre.dni:= n.padre.dni;

    m.fallecido:= false;
end;

procedure completar_regm(var m: reg_maestro; f: reg_fallecimiento);
begin
    m.fallecido:= true;

    m.si_fallecio.matricula:= f.matricula;

    m.si_fallecio.fecha.dia:= f.fecha.dia; m.si_fallecio.fecha.mes:= f.fecha.mes; m.si_fallecio.fecha.anio:= f.fecha.anio;

    m.si_fallecio.hora.hora:= f.hora.hora; m.si_fallecio.hora.minuto:= f.hora.minuto; m.si_fallecio.hora.segundo:= f.hora.segundo;

    m.si_fallecio.direccion.calle:= f.direccion.calle; 
    m.si_fallecio.direccion.numero:= f.direccion.numero;
    m.si_fallecio.direccion.piso:= f.direccion.piso;
    m.si_fallecio.direccion.depto:= f.direccion.depto;
    m.si_fallecio.direccion.ciudad:= f.direccion.ciudad;
    
end;

procedure listar_persona(p: reg_maestro; var texto: text);
var
    fallecido: boolean;
begin
    fallecido:= p.fallecido;
    writeln(texto, '');
    writeln(texto,'-----------------------');
    writeln(texto, '');
    
    write(texto, 'Acta de nacimiento #', p.numero, '(Matricula: ', p.matricula,'): ', p.apellido, ' ', p.nombre, ' | Vive: ');
    if fallecido then writeln(texto,'No.')
    else writeln(texto, 'Si.');
    
    writeln(texto, 'Direccion: ', p.direccion.ciudad, ' ', p.direccion.calle, ' ', p.direccion.numero, ' ', p.direccion.piso, ' ', p.direccion.depto, ' ');
    
    writeln(texto, 'Datos de la madre: ', p.madre.apellido, ' ', p.madre.nombre, ' (DNI: ',p.madre.dni, ').');
    
    writeln(texto, 'Datos del padre: ', p.padre.apellido, ' ', p.padre.nombre, ' (DNI: ',p.padre.dni, ').');
    
    if fallecido then begin
        writeln(texto, 'Datos fallecimiento: ');
        writeln(texto, 'Fecha: ', p.si_fallecio.fecha.dia, '/', p.si_fallecio.fecha.mes, '/', p.si_fallecio.fecha.anio, 
                ' a las ', p.si_fallecio.hora.hora, ' horas y ', p.si_fallecio.hora.minuto, ' minutos, en ', 
                p.si_fallecio.direccion.ciudad, ', ', p.si_fallecio.direccion.calle, ' ', p.si_fallecio.direccion.numero);
    end;
end;
procedure merge_maestro(var vec_delegaciones: vector_delegaciones; var mae: archivo_maestro); //Mergea todos los archivos en uno solo (maestro)
var
    //Para los nacimientos
    vec_nacimientos: vector_nacimientos;  //Para guardar el primer nacimiento de cada archivo
    todos_nacimientos: archivo_nacimientos;  //Archivo donde se mergean todos los nacimientos
    regn: reg_nacimiento;  //Para leer el archivo mergeado de nacimientos

    //Para los fallecimientos
    vec_fallecimientos: vector_fallecimientos;  //Para guardar el primer fallecimiento de cada archivo
    todos_fallecimientos: archivo_fallecimientos;  //Archivo donde se mergean todos los fallecimientos
    regf: reg_fallecimiento;  //Para leer el archivo mergeado de fallecimientos
    
    //Para el maestro
    regm: reg_maestro; //Para cargar el archivo maestro

    //Para el listado de personas
    texto: text;  //Archivo de texto

begin
    rewrite(mae);
    abrir_archivos(vec_delegaciones, vec_nacimientos, vec_fallecimientos);

    assign(texto, 'listado_personas.txt');
    rewrite(texto);

    assign(todos_nacimientos, 'merge_nacimientos');    assign(todos_fallecimientos, 'merge_fallecimientos');
    rewrite(todos_nacimientos);                        rewrite(todos_fallecimientos);

    merge_nacimientos(vec_delegaciones, vec_nacimientos, todos_nacimientos);
    merge_fallecimientos(vec_delegaciones, vec_fallecimientos, todos_fallecimientos);

    reset(todos_nacimientos);
    reset(todos_fallecimientos);

    leer_nacimiento(todos_nacimientos, regn);  leer_fallecimiento(todos_fallecimientos, regf);

    while (regn.numero <> VALORALTO) do begin
        armar_regm(regm, regn);
        if (regm.numero = regf.numero) then completar_regm(regm, regf);
        listar_persona(regm, texto);
        write(mae, regm);
        leer_nacimiento(todos_nacimientos, regn);
    end;

    close(todos_nacimientos);
    close(todos_fallecimientos);
    close(mae);
    cerrar_archivos(vec_delegaciones);
    close(texto);
end;

var
    mae: archivo_maestro;
    delegaciones: vector_delegaciones;
begin
    assign(mae, 'maestro');
    
    assign(delegaciones[1].det_nacimientos,   'nacimientos_1');
    assign(delegaciones[1].det_fallecimientos,'fallecimientos_1');
    assign(delegaciones[2].det_nacimientos,   'nacimientos_2');
    assign(delegaciones[2].det_fallecimientos,'fallecimientos_2');
    assign(delegaciones[3].det_nacimientos,   'nacimientos_3');
    assign(delegaciones[3].det_fallecimientos,'fallecimientos_3');
    {
    assign(delegaciones[4].det_nacimientos,   'nacimientos_4');
    assign(delegaciones[4].det_fallecimientos,'fallecimientos_4');
    assign(delegaciones[5].det_nacimientos,   'nacimientos_5');
    assign(delegaciones[5].det_fallecimientos,'fallecimientos_5');
    assign(delegaciones[6].det_nacimientos,   'nacimientos_6');
    assign(delegaciones[6].det_fallecimientos,'fallecimientos_6');
    assign(delegaciones[7].det_nacimientos,   'nacimientos_7');
    assign(delegaciones[7].det_fallecimientos,'fallecimientos_7');
    assign(delegaciones[8].det_nacimientos,   'nacimientos_8');
    assign(delegaciones[8].det_fallecimientos,'fallecimientos_8');
    assign(delegaciones[9].det_nacimientos,   'nacimientos_9');
    assign(delegaciones[9].det_fallecimientos,'fallecimientos_9');
    assign(delegaciones[10].det_nacimientos,  'nacimientos_10');
    assign(delegaciones[10].det_fallecimientos,'fallecimientos_10');
    assign(delegaciones[11].det_nacimientos,  'nacimientos_11');
    assign(delegaciones[11].det_fallecimientos,'fallecimientos_11');
    assign(delegaciones[12].det_nacimientos,  'nacimientos_12');
    assign(delegaciones[12].det_fallecimientos,'fallecimientos_12');
    assign(delegaciones[13].det_nacimientos,  'nacimientos_13');
    assign(delegaciones[13].det_fallecimientos,'fallecimientos_13');
    assign(delegaciones[14].det_nacimientos,  'nacimientos_14');
    assign(delegaciones[14].det_fallecimientos,'fallecimientos_14');
    assign(delegaciones[15].det_nacimientos,  'nacimientos_15');
    assign(delegaciones[15].det_fallecimientos,'fallecimientos_15');
    assign(delegaciones[16].det_nacimientos,  'nacimientos_16');
    assign(delegaciones[16].det_fallecimientos,'fallecimientos_16');
    assign(delegaciones[17].det_nacimientos,  'nacimientos_17');
    assign(delegaciones[17].det_fallecimientos,'fallecimientos_17');
    assign(delegaciones[18].det_nacimientos,  'nacimientos_18');
    assign(delegaciones[18].det_fallecimientos,'fallecimientos_18');
    assign(delegaciones[19].det_nacimientos,  'nacimientos_19');
    assign(delegaciones[19].det_fallecimientos,'fallecimientos_19');
    assign(delegaciones[20].det_nacimientos,  'nacimientos_20');
    assign(delegaciones[20].det_fallecimientos,'fallecimientos_20');
    assign(delegaciones[21].det_nacimientos,  'nacimientos_21');
    assign(delegaciones[21].det_fallecimientos,'fallecimientos_21');
    assign(delegaciones[22].det_nacimientos,  'nacimientos_22');
    assign(delegaciones[22].det_fallecimientos,'fallecimientos_22');
    assign(delegaciones[23].det_nacimientos,  'nacimientos_23');
    assign(delegaciones[23].det_fallecimientos,'fallecimientos_23');
    assign(delegaciones[24].det_nacimientos,  'nacimientos_24');
    assign(delegaciones[24].det_fallecimientos,'fallecimientos_24');
    assign(delegaciones[25].det_nacimientos,  'nacimientos_25');
    assign(delegaciones[25].det_fallecimientos,'fallecimientos_25');
    assign(delegaciones[26].det_nacimientos,  'nacimientos_26');
    assign(delegaciones[26].det_fallecimientos,'fallecimientos_26');
    assign(delegaciones[27].det_nacimientos,  'nacimientos_27');
    assign(delegaciones[27].det_fallecimientos,'fallecimientos_27');
    assign(delegaciones[28].det_nacimientos,  'nacimientos_28');
    assign(delegaciones[28].det_fallecimientos,'fallecimientos_28');
    assign(delegaciones[29].det_nacimientos,  'nacimientos_29');
    assign(delegaciones[29].det_fallecimientos,'fallecimientos_29');
    assign(delegaciones[30].det_nacimientos,  'nacimientos_30');
    assign(delegaciones[30].det_fallecimientos,'fallecimientos_30');
    assign(delegaciones[31].det_nacimientos,  'nacimientos_31');
    assign(delegaciones[31].det_fallecimientos,'fallecimientos_31');
    assign(delegaciones[32].det_nacimientos,  'nacimientos_32');
    assign(delegaciones[32].det_fallecimientos,'fallecimientos_32');
    assign(delegaciones[33].det_nacimientos,  'nacimientos_33');
    assign(delegaciones[33].det_fallecimientos,'fallecimientos_33');
    assign(delegaciones[34].det_nacimientos,  'nacimientos_34');
    assign(delegaciones[34].det_fallecimientos,'fallecimientos_34');
    assign(delegaciones[35].det_nacimientos,  'nacimientos_35');
    assign(delegaciones[35].det_fallecimientos,'fallecimientos_35');
    assign(delegaciones[36].det_nacimientos,  'nacimientos_36');
    assign(delegaciones[36].det_fallecimientos,'fallecimientos_36');
    assign(delegaciones[37].det_nacimientos,  'nacimientos_37');
    assign(delegaciones[37].det_fallecimientos,'fallecimientos_37');
    assign(delegaciones[38].det_nacimientos,  'nacimientos_38');
    assign(delegaciones[38].det_fallecimientos,'fallecimientos_38');
    assign(delegaciones[39].det_nacimientos,  'nacimientos_39');
    assign(delegaciones[39].det_fallecimientos,'fallecimientos_39');
    assign(delegaciones[40].det_nacimientos,   'nacimientos_40');
    assign(delegaciones[40].det_fallecimientos,'fallecimientos_40');
    assign(delegaciones[41].det_nacimientos,   'nacimientos_41');
    assign(delegaciones[41].det_fallecimientos,'fallecimientos_41');
    assign(delegaciones[42].det_nacimientos,   'nacimientos_42');
    assign(delegaciones[42].det_fallecimientos,'fallecimientos_42');
    assign(delegaciones[43].det_nacimientos,   'nacimientos_43');
    assign(delegaciones[43].det_fallecimientos,'fallecimientos_43');
    assign(delegaciones[44].det_nacimientos,   'nacimientos_44');
    assign(delegaciones[44].det_fallecimientos,'fallecimientos_44');
    assign(delegaciones[45].det_nacimientos,   'nacimientos_45');
    assign(delegaciones[45].det_fallecimientos,'fallecimientos_45');
    assign(delegaciones[46].det_nacimientos,   'nacimientos_46');
    assign(delegaciones[46].det_fallecimientos,'fallecimientos_46');
    assign(delegaciones[47].det_nacimientos,   'nacimientos_47');
    assign(delegaciones[47].det_fallecimientos,'fallecimientos_47');
    assign(delegaciones[48].det_nacimientos,   'nacimientos_48');
    assign(delegaciones[48].det_fallecimientos,'fallecimientos_48');
    assign(delegaciones[49].det_nacimientos,   'nacimientos_49');
    assign(delegaciones[49].det_fallecimientos,'fallecimientos_49');
    assign(delegaciones[50].det_nacimientos,   'nacimientos_50');
    assign(delegaciones[50].det_fallecimientos,'fallecimientos_50');
    }

    merge_maestro(delegaciones, mae);
end.