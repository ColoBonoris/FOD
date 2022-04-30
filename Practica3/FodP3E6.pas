{
    
    Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
    con la información correspondiente a las prendas que se encuentran a la venta. De
    cada prenda se registra:
        cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario.

    Ante un eventual cambio de temporada, se deben actualizar las prendas
    a la venta. Para ello reciben un archivo conteniendo:
        cod_prenda
    de las prendas que quedarán obsoletas.
    
    Deberá implementar un procedimiento que reciba ambos archivos y realice la baja
    lógica de las prendas, para ello deberá modificar el stock de la prenda
    correspondiente a valor negativo.

    Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
    compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
    el archivo original al finalizar el proceso. Solo deben quedar en el archivo las prendas
    que no fueron borradas, una vez realizadas todas las bajas físicas.

}

program FODP3E6;
//-----------------------------------------------------
Const
    def_route = 'C:\ArchivosFOD\';
    obsoletes_file = 'cod_prenda';
//-----------------------------------------------------
Type
    clothe = record
        code: integer;
        description: String;
        colors: String;
        clothing_type: String;
        stock: integer;
        price: real;
    end;
    //
    catalogue = file of clothe;
    int_file = file of integer;
//-----------------------------------------------------
procedure search_clothe(var a:catalogue; n: integer; var pos: integer);
    var 
        aux_c: clothe;
    begin
        reset(a);
        pos := 0;
        aux_c.code := n + 1;
        while(not eof(a) and (aux_c.code <> n))do
            read(a,aux_c);
        if(aux_c.code = n)then
            pos := filepos(a) - 1;
        close(a);
    end;
//
procedure logic_delete_obsoletes(var a: catalogue; var d: int_file);
    var
        aux_c: clothe;
        aux_int,position: integer;
    begin
        reset(d);

        while(not eof(d))do begin
            read(d,aux_int);
            search_clothe(a,aux_int,position);
            if(position <> 0)then begin
                reset(a);
                seek(a,position);
                read(a,aux_c);
                aux_c.code := aux_c.code * -1;
                seek(a,position);
                write(a,aux_c);
                close(a);
            end;
        end;

        close(d);
    end;
//
procedure physic_delete_obsoletes(var a, new: catalogue);
    var
        nme_new: string;
        aux_c: clothe;
    begin
        reset(a);
        read(a,aux_c);

        nme_new := def_route + 'updated_catalogue.dat';
        Assign(new,nme_new);
        rewrite(new);
        aux_c.code := 0;
        write(new,aux_c);


        while(not(eof(a)))do begin
            read(a,aux_c);
            if(aux_c.code > 0)then
                write(new,aux_c);
        end;

        close(new);
        close(a);
    end;
//-----------------------------------------------------
var
    first_catalogue,new_catalogue: catalogue;
    deletion_file: int_file;
    nme_new: string;
begin
    nme_new := def_route + obsoletes_file + '.dat';
    Assign(deletion_file,nme_new);
    //
    nme_new := def_route + 'first_catalogue.dat';
    Assign(first_catalogue,nme_new);
    rewrite(first_catalogue);
    close(first_catalogue);
    //
    logic_delete_obsoletes(first_catalogue,deletion_file);
    //
    physic_delete_obsoletes(first_catalogue,new_catalogue);
    // Faltaría nada más cambiar el nombre físico de los archivos, pero no sé cómo podría lograrse eso
end.

