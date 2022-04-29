{
    
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
    información de asistentes a un congreso a partir de la información obtenida por
    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
    asistente inferior a 1000.
    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
    String a su elección.  Ejemplo:  ‘@Saldaño’.

}

program FODP3E2;
//-----------------------------------------------------
Const
    deletion_char = '@';
//-----------------------------------------------------
Type
    assistant = record
        num: integer;
        nme: String;
        sme: String;
        mail: String;
        phone: String;
        DNI: integer;
        end;
//
    assistants_file = file of assistant;

//-----------------------------------------------------
procedure logic_deletion(var a: assistants_file);
    {
        Must receive the file in the specified position.
        Returns file with changes made, in the same position it received it.
    }
    var
        aAux: assistant;
    begin
        read(a,aAux);
        aAux.nme := deletion_char + aAux.nme;
        seek(a,filePos(a) - 1);
        write(a,aAux);
        seek(a,filePos(a) - 1);
    end;
//
procedure delete_under_num(var a: assistants_file; num: integer);
    {
        
    }
    var
        aAux: assistant;
    begin
        reset(a);
        
        // No se especifica ningun orden en el archivo, no se supondrá uno
        while(not eof(a))begin
            read(a, aAux);
            if(num > aAux.num)then begin
                seek(a,filePos(a) - 1);
                logic_deletion(a);
                seek(a,filePos(a) + 1);
            end;   
        end;

        close(a);
    end;
//-----------------------------------------------------
var
    archivo_asistentes: assistants_file;
    numero_de_empleado_minimo: integer;
begin
    assign(archivo_asistentes,'C:\ArchivosFOD\AsistentesFODP3E2.dat');
    //
    write('Ingrese el minimo numero de empleado aceptado: '); readln(numero_de_empleado_minimo);
    delete_under_num(archivo_asistentes,numero_de_empleado_minimo);
    write('Empleados borrados de forma exitosa. Au revoir!');
end.