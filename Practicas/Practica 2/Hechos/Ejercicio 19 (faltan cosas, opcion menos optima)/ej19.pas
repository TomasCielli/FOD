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
    CANTDELEGACIONES = 50;

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
procedure leer_fallecimiento(var a: archivo_nacimientos; var f: reg_fallecimiento);
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

procedure procesar_nacimiento(var mae: archivo_maestro; var n: reg_nacimiento);
begin
    if (not esta_el_nacimiento(mae, n)) then begin
        
    end;
end;

procedure procesar_fallecimiento(var mae: archivo_maestro; var f: reg_fallecimiento);
begin
    if (not esta_el_fallecimiento(mae, f)) then begin
        
    end;
end;

procedure crear_maestro(var mae: archivo_maestro; var vec_delegaciones: vector_delegaciones);
var
    i: rango_delegaciones;
    vec_nacimientos: vector_nacimientos;    vec_fallecimientos: vector_fallecimientos;
    min_nacimiento: reg_nacimiento;         min_fallecimiento: reg_fallecimiento;

begin
    rewrite(mae);  //Sobreescribe el maestro
    for i:= 1 to CANTDELEGACIONES do begin  //Abre archivos e inicializa vectores
        reset(vec_delegaciones[i].det_nacimientos);
        reset(vec_delegaciones[i].det_fallecimientos);
        leer_nacimiento(vec_delegaciones[i].det_nacimientos, vec_nacimientos[i]);
        leer_fallecimiento(vec_delegaciones[i].det_fallecimientos, vec_fallecimientos[i]);
    end;

    minimo_nacimiento(vec_delegaciones, vec_nacimientos, min_nacimiento);  //Calcula los minimos de cada uno
    minimo_fallecimiento(vec_delegaciones, vec_fallecimientos, min_fallecimiento);

    while (min_nacimiento.numero <> VALORALTO) or (min_fallecimiento.numero <> VALORALTO) do begin
        if (min_nacimiento.numero < min_fallecimiento.numero) then begin //Si el numero del nacimiento es menor que el de fallecimiento
            procesar_nacimiento(mae, min_nacimiento);  //Lo procesa
            minimo_nacimiento(vec_delegaciones, vec_nacimientos, min_nacimiento);  //Avanza al siguiente
        end
        else begin //Sino el numero del  fallecimiento es menor que el de nacimiento
            procesar_fallecimiento(mae, min_fallecimiento);  //Lo procesa
            minimo_fallecimiento(vec_delegaciones, vec_fallecimientos, min_fallecimiento);  //Avanza al siguiente
        end;
    end;

    close(mae);  //Cierra los archivos
    for i:= 1 to CANTDELEGACIONES do begin
        close(vec_delegaciones[i].det_nacimientos);
        close(vec_delegaciones[i].det_fallecimientos);
    end;
end;






begin
    
end.