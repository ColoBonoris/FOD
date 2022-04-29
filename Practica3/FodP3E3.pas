{
    
    3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
    año. De cada novela se registra: código, género, nombre, duración, director y precio.
    El programa debe presentar un menú con las siguientes opciones:

        NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
        proporcionado por el usuario

}

program FODP3E3;
//-----------------------------------------------------
Const
    def_route = 'C:\ArchivosFOD\';
//-----------------------------------------------------
Type
    novel = record
        code: integer;
        gen: String;
        nme: String;
        length: String;
        director: String;
        price: real;
        end;
    //
    novels_file = file of novel;
    
//-----------------------------------------------------
function display_menu(): integer;
    var
        aux_choice: integer;
    begin
        writeln('---------- \n ##### \n \n
        Ingrese la siguiente operación a llevarse a cabo: \n
            1. Create new data file.\n
            2. Modify current file.\n
            3. Create new text file.\n
            0. Exit.
            \n ### \n ---------- \n
        ');
        read(aux_choice);
        while((aux_choice > 3)or(aux_choice < 0))do begin
            writeln('\n Unknown election, please enter a valid option! \n');
            writeln('---------- \n ##### \n \n
            Ingrese la siguiente operación a llevarse a cabo: \n
                1. Create new data file.\n
                2. Modify current file.\n
                3. Create new text file.\n
                0. Exit.
            \n ### \n ---------- \n
            ');
            read(aux_choice);
        end;
        display_menu := aux_choice;
    end;
//-----------------------------------------------------
procedure create_novel_file(var new_file: novels_file; dir: String);
    {
    a.  Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
        utiliza la técnica de lista invertida para recuperar espacio libre en el
        archivo. Para ello, durante la creación del archivo, en el primer registro del
        mismo se debe almacenar la cabecera de la lista. Es decir un registro
        ficticio, inicializando con el valor cero (0) el campo correspondiente al
        código de novela, el cual indica que no hay espacio libre dentro del
        archivo.
    }
    var
        header: novel;
    begin
        Assign(new_file,dir);
        rewrite(new_file);
        header.code := 0;
        write(new_file,header);
        // Debería aá cargar unno por uno por teclado, cosa que no voy a hacer
        close(new_file);
    end;
//-----------------------------------------------------
{
    b.  Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
        inciso a., se utiliza lista invertida para recuperación de espacio. En
        particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
        números de registro referenciados con signo negativo, (utilice el código de
        novela como enlace).Una vez abierto el archivo, brindar operaciones para:
}
procedure add_novel(var a: novels_file; new_novel: novel);
    {
        i.  Dar de alta una novela leyendo la información desde teclado. Para
            esta operación, en caso de ser posible, deberá recuperarse el
            espacio libre. Es decir, si en el campo correspondiente al código de
            novela del registro cabecera hay un valor negativo, por ejemplo -5,
            se debe leer el registro en la posición 5, copiarlo en la posición 0
            (actualizar la lista de espacio libre) y grabar el nuevo registro en la
            posición 5. Con el valor 0 (cero) en el registro cabecera se indica
            que no hay espacio libre.
    }
    var
        aux_n: novel;
    begin
        reset(a);

        read(a,aux_n);
        if(cabecera.code < 0)then begin
            seek(a,cabecera.code * -1);
            read(a,aux_n);
            seek(a,filepos(a)-1);
            write(new_novel);
            seek(a,0);
            write(aux_n);
        end;
        else begin
            seek(a,filesize(a));
            write(new_novel);
        end;
            
        close(a);
    end;
//
procedure modify_novel(var a: novels_file; new_reg: novel);
    {
        ii. Modificar los datos de una novela leyendo la información desde
            teclado. El  código de novela no puede ser modificado.
    }
    var
        auxN: novel;
    begin
        reset(a);

        auxN.code := new_reg.code + 1;
        while(not eof(a))and(auxN.code <> new_reg.code)do
            read(a,auxN);
        if(auxN.code = new_reg.code)then begin
            seek(a,filepos(a)-1);
            write(a,new_reg);
        end;
        else
            writeln('Specified code could not be found.');

        close(a);
    end;
//
procedure delete_novel(var a: novels_file; deletion_code: integer);
    {
        iii. Eliminar una novela cuyo código es ingresado por teclado. Por
            ejemplo, si se da de baja un registro en la posición 8, en el campo
            código de novela del registro cabecera deberá figurar -8, y en el
            registro en la posición 8 debe copiarse el antiguo registro cabecera.
    }
    var
        aux_code: integer;
        aux_n, header: novel;
    begin
        if(deletion_code > 0)then begin
            reset(a);
            if(not eof(a))then
                read(a,header);
            aux_n.code := deletion_code + 1;
            while(not eof(a))and(aux_n.code <> deletion_code)do
                read(a,aux_n);
            if(aux_n.code = deletion_code)then begin
                seek(a, filepos(a)-1);
                read(a,aux_n);
                aux_n.code = aux_n.code * (-1);
                seek(a, filepos(a)-1);
                write(a,header);
                seek(a,0);
                write(a,aux_n);
            end;
            else
                writeln('Specified code could not be found.');      

            close(a);
        end;
        else
            writeln('Deletion code not valid!');
    end;
//-----------------------------------------------------
{
    c.  Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
        representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
}
procedure create_text_file(params);
    var
        
    begin
        
    end;
//-----------------------------------------------------
procedure MyProcedure(params);
    begin
        
    end;
//-----------------------------------------------------
var
    name_received, file_route: String;
    novels: novels_file;
begin
    write('Ingrese el nombre para el nuevo archivo: '); 
    read(name_received);
    file_route := def_route + name_received + '.dat';
    create_novel_file(novels,file_route);
    // falta un poco para implementación pero con esto basta
end.

