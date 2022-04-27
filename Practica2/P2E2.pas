{

2- Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final)
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
    a. Actualizar el archivo maestro de la siguiente manera:
        i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
        ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
        final
    b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
    con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos
}

// No estoy teniendo en cuenta posibles errores en el detalle, como que hayan alumnos que no estan en el maestro

program FODP2E2;
//-------------------------------------------------------------
Type
    alumno = record
        code: integer;
        ap: String;
        nom: String;
        cursadas: integer;
        finales: integer;
        end;

    materia = record
        code: integer;
        final: boolean;
        end;

    master = file of alumno;
    detail = file of materia;
//-------------------------------------------------------------
procedure actualizarMaestro(var maestro: master; var detalle: detail);
    var
        aux_alu: alumno;
        aux_mat: materia;
        actual: integer;
    begin
        reset(maestro);
        reset(detalle);
        //
        read(detalle,aux_mat);
        while(not eof(detalle))do begin
            read(maestro,aux_alu);
            actual := aux_mat.code;
            // Nos posicionamos en el maestro necesario
            while(actual <> aux_alu.code)do
                read(maestro,aux_alu)
            seek(maestro,filePos(maestro) - 1);
            // Comenzamos la actualizacion
            while((aux_mat.code = actual) and (not eof(detalle)))do begin
                // Actualizamos el auxiliar
                if(aux_mat.final)then
                    aux_alu.finales := aux_alu.finales + 1
                else
                    aux_alu.cursadas := aux_alu.cursadas + 1;
                //Tratamos corte de control
                read(detalle,aux_mat);
            end;
            // Actualizamos maestro
            write(maestro,aux_alu);
        end;
        //
        close(maestro);
        close(detalle);
    end;
//
procedure crearTextoCuatroCursadas(var maestro: master; var texto:Text);
    var
        aux_alu: alumno;
        str_alu, str_aux: string;
    begin
        reset(texto);
        reset(maestro);
        while(not eof(maestro))do begin
            read(maestro,aux_alu);
            Str(aux_alu.code,str_aux);
            str_alu := ('Numero de alumno: ' + str_aux + '; Nombre y Apellido: ' + aux_alu.nom + ', ' + aux_alu.ap + '; ');
            Str(aux_alu.cursadas,str_aux);
            str_alu := (str_alu + 'Cursadas aprobadas: ' + str_aux + '; ');
            Str(aux_alu.finales,str_aux);
            str_alu := (str_alu + 'Finales aprobados: ' + str_aux);
            write(texto,str_alu);
        end;
        close(texto);
        close(maestro);
    end;
//-------------------------------------------------------------
var
    maestro: master;
    detalle: detail;
    cuatro_cursadas: Text;
begin
    Assign(maestro,'C:\ArchivosFOD\alumnos.dat');
    Assign(detalle,'C:\ArchivosFOD\materias.dat');
    Assign(cuatro_cursadas,'C:\ArchivosFOD\cursadas.txt');
    rewrite(maestro);
    rewrite(detalle);
    rewrite(cuatro_cursadas);
    close(maestro);
    close(detalle);
    close(cuatro_cursadas);
    actualizarMaestro(maestro,detalle);
    crearTextoCuatroCursadas(maestro,cuatro_cursadas);
end.