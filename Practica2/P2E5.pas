{
5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.

Los archivos detalles con nacimientos, contendrán la siguiente información:
    nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad),
    matrículadel médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre.
En cambio, los 50 archivos de fallecimientos tendrán:
    nro partida nacimiento, DNI, nombre y apellido del fallecido, matrícula del médico que firma el deceso,
    fecha y hora del deceso y lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro:
    nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
    del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
    además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar.

Se deberá, además, listar en un archivo de texto la información recolectada de cada persona.

Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.


}

program FODP2E5;
//-----------------------------------------------------
Const
    details_amount = 50;
//-----------------------------------------------------
Type
    details_range = 1..details_amount;
//
    address = record 
        calle: String;
        num: integer;
        floor: integer;
        apt: char;
        city: String;
        end;
    citizen = record
        nme: String;
        sme: String;
        DNI: integer;
        end;
     date = record
        min: integer;
        hour: integer;
        day: integer;
        month: integer;
        year: integer;
        end;
//
    birth = record
        num: integer;
        nme: String;
        sme: String;
        adr: address;
        mat: integer;
        mother: citizen;
        father: citizen;
        end;
    decease = record
        num: integer;
        self: citizen;
        mat: integer;
        time: date;
        place: address;
        end;
//
    master_citizen = record
        num: integer;
        nme: String;
        sme: String;
        father: citizen;
        mother: citizen;
        birth_mat: integer;
        died: boolean;
        death_mat: integer;
        place: address;
        time: date;
        end;
//
    birth_detail = file of birth;
    birth_details = array [1..details_amount] of birth_detail;
    death_detail = file of decease;
    death_details = array [1..details_amount] of death_detail;
    master = file of master_citizen;
//-----------------------------------------------------
procedure minimum_birth(var b: birth; var v: birth_details);
    // Sacamos un minimo de nacimiento
    var
        aux_b: birth;
        i: integer;
    begin
        aux_b.num := -1;
        b.num := 32000;
        for i:=1 to details_amount do begin
            if(not eof(v[i]))then begin
                read(v[i],aux_b);
                if(aux_b.num < b.num)then
                    b := aux_b
                else
                    seek(v[i],filepos(v[i])-1);
            end;
        end;
        if(aux_b.num = -1)then
            b.num := -1;
    end;
//
procedure minimum_decease(var d: decease; var v: death_details);
    // Sacamos un minimo de fallecimiento
    var
        aux_d: decease;
        i: integer;
    begin
        aux_d.num := -1;
        d.num := 32000;
        for i:=1 to details_amount do begin
            if(not eof(v[i]))then begin
                read(v[i],aux_d);
                if(aux_d.num < d.num)then
                    d := aux_d
                else
                    seek(v[i],filepos(v[i])-1);
            end;
        end;
        if(aux_d.num = -1)then
            d.num := -1;
    end;
//
procedure create_master(var mas: master; var v_bir: birth_details; var v_dec: death_details);
    // Creamos el maestro solicitado, con los datos pedidos
    var
        aux_b: birth;
        aux_d: decease;
        aux_c: master_citizen;
        i: integer;
    begin
        // Creamos y asignamos al maestro
        Assign(mas,'C:\ArchivosFOD\maestro_censo.dat');
        rewrite(mas);
        // Abrimos todos los detalles
        for i:=1 to details_amount do begin
            reset(v_bir[i]);
            reset(v_dec[i]);
        end;
        // Caso aparte
        minimum_birth(aux_b,v_bir);
        minimum_decease(aux_d,v_dec);
        while(aux_b.num <> -1)do begin
            // Se asignan datos de nacimiento
            aux_c.nme := aux_b.nme; aux_c.sme := aux_b.sme;
            aux_c.num := aux_b.num; aux_c.father := aux_b.father;
            aux_c.mother := aux_b.mother; aux_c.birth_mat := aux_b.mat;
            // Se asignan datos de fallecimiento
            if(aux_d.num = aux_c.num)then begin
                // Falleció, se asignan valores y actualiza minimo fallecimiento
                aux_c.died := true; aux_c.death_mat := aux_d.mat;
                aux_c.place := aux_d.place; aux_c.time := aux_d.time;
                minimum_decease(aux_d,v_dec);
            end
            else
                // No falleció, aclara
                aux_c.died := False;
            // Guarda la variable maestro en el maestro y actualiza para iterar
            write(mas,aux_c);
            minimum_birth(aux_b,v_bir);
        end;
        // cerramos todo
        close(mas);
        for i:=1 to details_amount do begin
            close(v_bir[i]);
            close(v_dec[i]);
        end;
    end;
//
procedure create_master_text(var mas: master; var t: Text);
    // Pasamos el maestro a un archivo de texto
    var
        aux_c: master_citizen;
        c_string: String;
    begin
        // Abrimos 
        Assign(t,'C:\ArchivosFOD\maestro_censo.txt');
        rewrite(t);
        reset(mas);
        // Se hace el pasaje
        while(not eof(mas))do begin
            read(mas,aux_c);
            c_string := 'Acá falta hacer el pasaje del registro a una linea de texto, lo omito.';
            write(t,c_string);
        end;
        // Cerramos ambos
        close(t);
        close(mas);
    end;
//-----------------------------------------------------
var
    datos_provincia: master;
    datos_provincia_texto: Text;
    nacimientos: birth_details;
    fallecimientos: death_details;
    i: integer;
    auxStr: String;
begin
    // Hacemos los assign de los detalles (podría modularizarse)
    for i:=1 to details_amount do begin
        str(i,auxStr);
        Assign(nacimientos[i],'C:\ArchivosFOD\detalle_nacimientos.dat' + auxStr);
        Assign(fallecimientos[i],'C:\ArchivosFOD\detalle_nacimientos.dat' + auxStr);
    end;
    // Cumplimos las consignas
    create_master(datos_provincia,nacimientos,fallecimientos);
    create_master_text(datos_provincia,datos_provincia_texto);
end.
