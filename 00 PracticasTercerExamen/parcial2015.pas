program parcial2015FOD;

Const

    DirFOD = 'C:\FOD\';
    vA = 32000;
    details = 3;

Type

    producto = record
        cod: integer; 
        nom: string;
        desc: string;
        bar_code: string;
        cat: string;
        stock: integer;
        min: integer;
        end;
    pedido = record
        cod: integer;
        cant: integer;
        desc: string;
        end;
    
    mFile = file of producto;
    dFile = file of pedido;
    dArray = array [1..details] of dFile;
    pedidos = array [1..details] of pedido;

procedure leerD(var a: dFile; var dato: pedido);
begin
    if(not eof(a)) then
        read(a, dato)
    else
        dato.cod := vA;
end;

procedure minimo(var v: dArray; var vd: pedidos; var min: pedido);
var
    pos, i: integer;
    auxp: pedido;
begin
    min.cod = vA;
    for i := 1 to details do begin
        if(vd[i].cod < min.cod)then begin
            min := vd[i];
            pos := i;
        end;
    end;
    if (min.cod < vA) then leerD(v[pos], vd[pos]);
end;

procedure updateMaster(var m: mFile; var vd: dArray);
var
    i: inetger; 
    bajo_stock: text;
    p: pedidos;
    min: pedido;
    aux_m: producto;
begin
    Assign(bajo_stock, DirFOD + 'bajo_stock.txt');
    Rewrite(bajo_stock);
    reset(m);

    for i:= 1 to details do begin
        reset(v[i]);
        leerD(v[i],p[i]);
    end;

    minimo(vd,p,min);

    while(min.cod <> vA)do begin
        repeat
            read(m,aux_m);
        until(aux_m.cod = min.cod);
        while(aux_m.cod = min.cod)do begin
            if (aux_m.stock = 0) then writeln('Al pedido de ', min.cant, ' unidades de ', min.cod, ' no se le asignó ninguna unidad.')
            else begin
                if(aux_m.cant < min.cant)then begin
                    writeln('Al pedido de ', min.cant, ' unidades de ', min.cod, ' se le asignaron ', aux_m.stock , ' unidades. Faltaron ', min.cant - aux_m.stock, ' unidades.');
                    aux_m.stock := 0;
                end
                else aux_m.stock := aux_stock - min.cant;
            end;
            minimo(vd,p,min);
        end;
        if(aux_m.stock < aux_m.min)then begin
            aux_str = 'Producto: ' + aux_m.cod + ', Categoría: ' + aux_m.cant;
            writeln(bajo_stock, aux_str);
        end;
    end;

    close(m);
    for i:= 1 to details do close(v[i]);
    close(bajo_stock);

end;

var
    m: mFile;
    vd: dArray;
    i: integer;
begin
    Assign(m, DirFOD + 'master.dat');
    for i:=1 to detail do Assign(vd[i], DirFOD + 'detalle' + i + '.dat');
    updateMaster(m, vd);
end.
