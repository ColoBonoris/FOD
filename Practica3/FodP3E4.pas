{
    
    Dada la siguiente estructura:
            type
                reg_flor = record
                    nombre: String[45];
                    codigo:integer;
                tArchFlores = file of reg_flor;

    Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y -N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

        a.  Implemente el siguiente módulo:
        
        *Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descripta anteriormente* 

        procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

        b.  Liste el contenido del archivo omitiendo las flores eliminadas.
            Modifique lo que considere necesario para obtener el listado.

}

program FODP3E4;
//-----------------------------------------------------
Const
    def_route = 'C:\ArchivosFOD\';
//-----------------------------------------------------
Type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    //
    tArchFlores = file of reg_flor;
//-----------------------------------------------------
procedure create_flower_file(var new_file: tArchFlores; dir: String);
    {
        
    }
    var
        header: reg_flor;
    begin
        Assign(new_file,dir);
        rewrite(new_file);
        header.code := 0;
        write(new_file,header);
        // Debería aá cargar uno por uno por teclado, cosa que no voy a hacer
        close(new_file);
    end;
//-----------------------------------------------------
procedure agregarFlor(var a: tArchFlores; nombre: string; codigo:integer);
    {
        
    }
    var
        aux_f, new:reg_flor: reg_flor;
    begin
        reset(a);

        new_reg_flor.nombre := nombre;
        new_reg_flor.codigo := codigo;
        read(a,aux_f);
        if(cabecera.code < 0)then begin
            seek(a,cabecera.code * -1);
            read(a,aux_f);
            seek(a,filepos(a)-1);
            write(new_reg_flor);
            seek(a,0);
            write(aux_f);
        end;
        else begin
            seek(a,filesize(a));
            write(new_reg_flor);
        end;
            
        close(a);
    end;
//
procedure modify_reg_flor(var a: tArchFlores; new_reg: reg_flor);
    {
        
    }
    var
        aux_f: reg_flor;
    begin
        reset(a);

        aux_f.code := new_reg.code + 1;
        while(not eof(a))and(aux_f.code <> new_reg.code)do
            read(a,aux_f);
        if(aux_f.code = new_reg.code)then begin
            seek(a,filepos(a)-1);
            write(a,new_reg);
        end;
        else
            writeln('Specified code could not be found.');

        close(a);
    end;
//
procedure delete_reg_flor(var a: tArchFlores; deletion_code: integer);
    {

    }
    var
        aux_code: integer;
        aux_f, header: reg_flor;
    begin
        if(deletion_code > 0)then begin
            reset(a);
            if(not eof(a))then
                read(a,header);
            aux_f.code := deletion_code + 1;
            while(not eof(a))and(aux_f.code <> deletion_code)do
                read(a,aux_f);
            if(aux_f.code = deletion_code)then begin
                seek(a, filepos(a)-1);
                read(a,aux_f);
                aux_f.code = aux_f.code * (-1);
                seek(a, filepos(a)-1);
                write(a,header);
                seek(a,0);
                write(a,aux_f);
            end;
            else
                writeln('Specified code could not be found.');      

            close(a);
        end;
        else
            writeln('Deletion code not valid!');
    end;
//-----------------------------------------------------
procedure print_flower_file(var a: tArchFlores)
    var 
    begin
        reset(a);

        read(a, aux_f);
        while(not eof(a))do begin
            read(a, aux_f);
            if(aux_f.codigo > 0)then
                print(aux_f.nombre,': ',aux_f.codigo);
        end;
        
        close(a);
    end;
var
    
begin
    // hay que crear el archivo y hacer el testing, cosa que no pasará
end.

