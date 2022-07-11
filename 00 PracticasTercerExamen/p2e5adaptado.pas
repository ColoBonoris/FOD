{
    
5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.

}

program fodP2E5Adaptado;

Const
    DETALLES = 50;
    M_DIR = 'C:\ArchivosFOD\actas.dat';
    D_DIR = 'C:\ArchivosFOD\fallecimientos';
    B_DIR = 'C:\ArchivosFOD\nacimientos';
    VALOR_ALTO = 32000;

Type
    birth = record
        n_part: integer;
        nombre: string;
        apellido: string;
        direccion: string;
        matricula: integer;
        nombreMadre: string;
        dniMadre: integer;
        nombrePadre: string;
        dniPadre: integer;
    end;
    death = record
        n_part: integer;
        dni: integer;
        nombre: string;
        apellido: string;
        matricula: integer;
        fecha: string;
        hora: string;
        lugar: string;
    end;
    acta = record
        n_part: integer;
        nombre: string;
        apellido: string;
        direccion: string;
        matricula: integer;
        nombreMadre: string;
        dniMadre: integer;
        nombrePadre: string;
        dniPadre: integer;
        died: boolean;
        matriculaFirma: integer;
        fecha: string;
        hora: string;
        lugar: string;
    end;

    mFile = file of acta;
    dFile = file of death;
    bFile = file of birth;

    dfArray = Array [1..DETALLES] of dFile;
    bfArray = Array [1..DETALLES] of bFile;

    dArray = Array [1..DETALLES] of death;
    bArray = Array [1..DETALLES] of birth;

procedure asignarNacimiento(var aux_m: acta; aux_b: birth);
begin
    aux_m.n_part := aux_b.n_part;
    aux_m.nombre := aux_b.nombre;
    aux_m.apellido := aux_b.apellido;
    aux_m.direccion := aux_b.direccion;
    aux_m.matricula := aux_b.matricula;
    aux_m.nombreMadre := aux_b.nombreMadre;
    aux_m.dniMadre := aux_b.dniMadre;
    aux_m.nombrePadre := aux_b.nombrePadre;
    aux_m.dniPadre := aux_b.dniPadre;
end;

procedure asignarFallecimiento(var aux_m: acta; aux_d: death);
begin 
    aux_m.matricula := aux_d.matricula;
    aux_m.fecha := aux_d.fecha;
    aux_m.hora := aux_d.hora;
    aux_m.lugar := aux_d.lugar;
    aux_m.died := true;
end;

procedure leerD(var d: dFile; var dato: death);
begin
    if(eof(d))then read(d,dato)
    else dato.n_part := VALOR_ALTO;
end;

procedure leerB(var b: dFile; var dato: death);
begin
    if(eof(b))then read(b,dato)
    else dato.n_part := VALOR_ALTO;
end;

procedure minDCond(var df: dfArray; var d: dArray; var min: death; partida: integer);
var
    i: integer;
    pos_min: integer;
begin
    min.n_part := VALOR_ALTO;
    for i:=1 to DETALLES do begin
        if(d[i].n_part < min.n_part)&(d[i].n_part = partida)then begin
            min := d[i];
            pos_min := i;
        end;
    end;
    if(min.n_part <> VALOR_ALTO)then leer(df[pos_min],d[pos_min]);
end;

procedure minB(var bf: bfArray; var b: bArray; var min: birth);
var
    i: integer;
    pos_min: integer;
begin
    min.n_part := VALOR_ALTO;
    for i:=1 to DETALLES do begin
        if(b[i].n_part < min.n_part)then begin
            min := b[i];
            pos_min := i;
        end;
    end;
    if(min.n_part <> VALOR_ALTO)then leer(bf[pos_min],b[pos_min]);
end;

procedure mergeDB(var m: mFile; var df: dArray; var bf: bArray);
var
    d: dArray;
    b: bArray;
    i: integer;
    aux_b: birth;
    aux_d: death;
    aux_m: acta;
begin
    rewrite(m);
    for i:=1 to DETALLES do begin
        reset(df[i]);
        reset(bf[i]);
        leerD(df[i],d[i]);
        leerB(bf[i],b[i]);
    end;

    minB(bf,b,aux_b);
    while(aux_b <> VALOR_ALTO) do begin
        minDCond(df,d,aux_d,aux_b.n_part);
        asignarNacimiento(aux_m, aux_b);
        if(aux_d.n_part < aux_b.n_part)then asignarFallecimiento(aux_m, aux_d)
        else begin
            aux_m.matricula := 'X';
            aux_m.fecha := 'X';
            aux_m.hora := 'X';
            aux_m.lugar := 'X';
            aux_m.died := False;
        end;
        write(m,aux_m);
        minB(bf,b,aux_b);
    end;
    
    close(m);
    for i:=1 to DETALLES do begin
        close(df[i]);
        close(bf[i]);
    end;
end;

var
    m: mFile;
    df: dfArray;
    bf: bfArray;
    i: integer;
begin
    Assign(m, M_DIR);
    for i:=1 to DETALLES do begin
        Assign(df[i], D_DIR + i + '.dat');
        Assign(bf[i], B_DIR + i + '.dat');
    end;
    mergeDB(m,df,bf);
end.
