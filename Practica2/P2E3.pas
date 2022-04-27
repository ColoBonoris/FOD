{
    
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida.

Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.

}

// No se trata la posibilidad de productos inexistentes
program FODP2E3;
//-----------------------------------------------------
Const
    details_amount = 30;
//-----------------------------------------------------
Type
    product = record
        code: integer;
        stock: integer;
        min_stock: integer;
        price: real;
        nam: String;
        desc: String;
        end;
    sold = record
        code: integer;
        units: integer;
        end;
    
    master = file of product;
    detail = file of sold;
    detail_vector = array [1..details_amount] of detail;
//-----------------------------------------------------
procedure minimoDetalle(var det: detail_vector; var pos_min: integer);
    var 
        i, min: integer;
        aux_sold: sold;
    begin
        min := 32000;
        pos_min := 0;
        for i:=1 to details_amount do begin
            if(not eof(det[i]))then begin
                read(det[i],aux_sold);
                seek(det[i],filepos(det[i]) - 1);
                if(aux_sold.code < min)then begin
                    min := aux_sold.code;
                    pos_min := i;
                end;
            end;
        end;
    end;
//
procedure actualizarMaestro(var maestro: master; var detalle: detail_vector);
    var
        aux_pro: product;
        aux_sold: sold;
        actual, pos_min, i: integer;
    begin
        reset(maestro);
        for i:=1 to details_amount do
            reset(detalle[i]);
        minimoDetalle(detalle, pos_min);
        if(pos_min > 0)then
            read(detalle[pos_min],aux_sold);
        while(pos_min > 0)do begin
            actual := aux_sold.code;
            repeat
                read(maestro,aux_pro);
            until(actual = aux_pro.code);
            seek(maestro,filePos(maestro) - 1);
            while((pos_min > 0) and (aux_sold.code = actual))do begin
                aux_pro.stock := aux_pro.stock - aux_sold.units;
                minimoDetalle(detalle, pos_min);
                if(pos_min > 0)then
                    read(detalle[pos_min],aux_sold);
            end;
            write(maestro,aux_pro);
        end;
        close(maestro);
        for i:=1 to details_amount do
            close(detalle[i]);
    end;
//
procedure textoBajoStock(var a: master; var t: Text);
    var
        str_pro, aux_str: String;
        aux_pro: product;
    begin
        reset(a);
        Assign(t,'C:\ArchivosFOD\BajoStock.txt;');
        rewrite(t);
        while(not eof(a))do begin
            read(a,aux_pro);
            str_pro := 'Nombre: '+ aux_pro.nam +'; Descripción: '+ aux_pro.desc;
            Str(aux_pro.stock,aux_str);
            str_pro := str_pro +'; Stock: '+ aux_str;
            Str(aux_pro.price,aux_str);
            str_pro := str_pro +'; Precio: '+ aux_str + '.';
            write
        end;
        close(a);
        close(t);
    end;
//-----------------------------------------------------
var
    stock_master: master;
    sellings_detail: detail_vector;
    under_stock : Text;
    i: integer;
    aux_str: String;
begin
    Assign(stock_master,'C:\ArchivosFOD\StockProductos.dat');
    rewrite(stock_master);
    close(stock_master);
    for i:= 1 to details_amount do begin
        Str(i,aux_str);
        aux_str := 'C:\ArchivosFOD\StockProductos'+ aux_str +'.dat';
        Assign(sellings_detail[i],aux_str);
    end;
    actualizarMaestro(stock_master, sellings_detail);
    textoBajoStock(stock_master, under_stock);
end.