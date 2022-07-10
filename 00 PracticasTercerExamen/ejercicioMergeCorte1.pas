Program ejercicioMergeCorte1;

Const
    dirFOD = 'C:\FOD\';
    vA = 32000;

Type
    prod = record
        cod: integer;
        stock: integer;
        min_stock: integer;
        precio: real;
        end;
    
    pedido = record
        cod: integer;
        cant: integer;
        fecha: String;
        end;
    
    mFile = file of prod;
    dFile = file of pedido;

procedure leerD(var a: dFile; var dato: pedido);
begin
    if (not eof(a)) then read(a, dato);
    else dato.cod := vA;
end;

procedure minimo(var d1, d2: dFile; var aux_d1, aux_d2, min: pedido; var suc: integer);
begin
    if(aux_d1.cod <= aux_d2.cod)then begin
        min := aux_d1;
        suc := 1;
        leerD(d1, aux_d1);
    end;
    else begin
        min := aux_d2;
        suc := 2;
        leerD(d2, aux_d2);
    end;
end;

procedure actualizarEInformar(var m: mFile; var d1, d2: dFile);
var
    min, aux_d1, aux_d2: pedido;
    aux_m: prod;
    min_suc: integer;

begin

    reset(m);
    reset(d1);
    reset(d2);
    leerD(d1, aux_d1);
    leerD(d2, aux_d2);
    minimo(d1,d2,aux_d1,aux_d2,min,min_suc);

    while(min.cod <> vA)do begin
        repeat
            read(m,aux_m);
        until (aux_m.cod = min.cod);
        repeat
            if(aux_m.stock >= min.stock)then
                aux_m.stock := aux_m.stock - min.stock
            else begin
                writeln('No hay stock suficiente para el pedido de ', min.cant,' unidades de ', min.cod,', faltaron ', min.stock - aux_m.stock, ' unidades.');
                aux_m.stock := 0;
            end;
            minimo(d1,d2,aux_d1,aux_d2,min,min_suc);
        until(min.cod <> aux_m.cod);
        if (aux_m.stock < aux_m.min_stock) then writeln('El producto ', aux_m.cod, ' tiene un stock de ', aux_m.stock, ' unidades, pero se necesitan ', aux_m.min_stock, ' unidades.');
        seek(m, filepos(m) - 1);
        write(m, aux_m);
    end;

    close(m);
    close(d1);
    close(d2);

end;

var
    maestro: mFile;
    detail1: dFile;
    detail2: dFile;
begin
    Assign(maestro, dirFOD + 'maestro.dat');
    Assign(detail1, dirFOD + 'detail1.dat');
    Assign(detail2, dirFOD + 'detail2.dat');
    actualizarEInformar(maestro, detail1, detail2);
end.
