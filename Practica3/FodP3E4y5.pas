{
    
    Dada la siguiente estructura:
            type
                reg_flor = record
                    nombre: String[45];
                    code:integer;
                tArchFlores = file of reg_flor;

    Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y -N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

        a.  Implemente el siguiente módulo:
        
        *Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descripta anteriormente* 

        procedure agregarFlor (var a: tArchFlores ; nombre: string; code:integer);

        b.  Liste el contenido del archivo omitiendo las flores eliminadas.
            Modifique lo que considere necesario para obtener el listado.

}

program FODP3E4y5;
//-----------------------------------------------------
Const
    FLOWERS_DIR = 'C:\FOD\archivoFlores.dat';
    FLOWERS_TEXT_DIR = 'C:\FOD\archivoFlores.txt';
//-----------------------------------------------------
Type
    reg_flor = record
        nombre: String[45];
        code:integer;
    end;
    //
    tArchFlores = file of reg_flor;
//-----------------------------------------------------
procedure create_flower_file(var new_file: tArchFlores; dir: String);
    var
        header: reg_flor;
    begin
        rewrite(new_file);
        header.code := 0;
        write(new_file,header);
        // Debería acá cargar uno por uno por teclado, cosa que no voy a hacer
        close(new_file);
    end;
//-----------------------------------------------------
procedure agregarFlor(var a: tArchFlores; nombre: string; codigo:integer);
    {
        
    }
    var
        aux_f, cabecera, new_reg_flor: reg_flor;
    begin
        if(codigo > 0) then begin
            reset(a);

            new_reg_flor.nombre := nombre;
            new_reg_flor.code := code;
            read(a,cabecera);
            if(cabecera.code < 0)then begin
                seek(a,cabecera.code * -1);
                read(a,aux_f);
                seek(a,filepos(a)-1);
                write(a,new_reg_flor);
                seek(a,0);
                write(a,aux_f);
            end;
            else begin
                seek(a,filesize(a));
                write(a,new_reg_flor);
            end;
            
            close(a);
        end
        else writeln('El código debe ser mayor a 0');
    end;
//-----------------------------------------------------
procedure modify_reg_flor(var a: tArchFlores; new_reg: reg_flor);
    {
        
    }
    var
        aux_f: reg_flor;
    begin
        if(new_reg > 0) then begin
            if(new_reg.code > 0)then begin
                reset(a);
                aux_f.code := new_reg.code;

                while(not eof(a))and(aux_f.code <> new_reg.code)do read(a,aux_f);
                if(aux_f.code = new_reg.code)then begin
                    seek(a,filepos(a)-1);
                    write(a,new_reg);
                end
                else
                    writeln('Specified code could not be found.');
            end
            else writeln('Invalid code.');
            close(a);
        end
        else writeln('Invalid code.');
    end;
//-----------------------------------------------------
procedure delete_reg_flor(var a: tArchFlores; deletion_code: integer);
    {
        Se asume que llega una estructura apropiada de lista invertida.
    }
    var
        aux_code: integer;
        aux_f, header: reg_flor;
    begin
        if(deletion_code > 0)then begin
            reset(a);
            read(a,header);

            while(not eof(a))and(aux_f.code <> deletion_code)do read(a,aux_f);
            if(aux_f.code = deletion_code)then begin
                aux_f.code = aux_f.code * (-1);
                seek(a, filepos(a)-1);
                write(a,header);
                seek(a,0);
                write(a,aux_f);
            end;
            else writeln('Specified code could not be found.');      

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
            if(aux_f.code > 0)then
                print(aux_f.nombre,': ',aux_f.code);
        end;
        
        close(a);
    end;
//-----------------------------------------------------
procedure flowers_to_txt(var m: tArchFlores; var t: text);
    var
        aux_f: reg_flor;
    begin
        rewrite(t);
        reset(m);
        while(not eof(m))do begin
            read(m, aux_f);
            if(aux_f.code > 0)then writeln(t,aux_f.code,aux_f.nombre);
        end;
    end;
//-----------------------------------------------------
var
    m_file: tArchFlores;
    t_file: text;
begin
    Assign(m_file,FOD_DIR);
    Assign(t_file,FOD_TEXT_DIR);
    // hay que crear el archivo y hacer el testing para probar las funciones en orden, cosa que no pasará
end.

