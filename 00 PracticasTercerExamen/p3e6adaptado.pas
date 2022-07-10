Program FODP3E6Adaptado;

Const

    dirNew = 'C:\FOD\PrendasActualizadas.dat';
    dirOld = 'C:\FOD\PrendasViejas.dat';
    dirFirst = 'C:\FOD\Prendas.dat';
    dirDet = 'C:\FOD\PrendasAEliminar.dat';

Type

    prenda = record
        cod: integer;
        desc: String;
        colors: String;
        tipo: String;
        stock: integer;
        price: real;
        end;

    mFile = file of prenda;
    dFile = file of integer:

procedure buscarPrenda(var m: mFile; var aux_m: prenda; cod: integer);
begin
    // Se supone que el archivo viene abierto, lo devuelve en la posicion del codigo que se busca, si no se encontró, devuelve en eof y el stock de aux_m será negativo
    seek(m, 0);
    while((not eof(m)) & (aux_m.cod <> cod))do read(m, aux_m);
    if (aux_m.cod <> cod) then aux_m.stock := -1
    else seek(m, filepos(m) - 1)
end;

porocedure bajasLógicas(var m: mFile);
var
    aux_m: prenda;
    aux_d: integer;
    det: dFile;
begin
    Assign(det, dirDet); reset(det);
    reset(m);

    while(noteof(m)) do begin
        read(det, aux_d);
        buscarPrenda(m, aux_m, aux_d);
        if(aux_m.stock >= 0)then begin
            aux_m.stock := -1;
            write(m, aux_m);
        end;
    end;

    close(m);
    close(det);
end;

procedure compactarYRenombrar(var m: mFile);
var
    aux_m: prenda;
    new_m: mFile;
begin
    Assign(new_m, dirNew); rewrite(new_m);
    reset(m);

    while(not eof(m)) do begin
        read(m, aux_m);
        if(aux_m.stock >= 0)then write(new_m, aux_m);
    end;

    close(m);
    close(new_m);
    rename(m, dirOld);
    rename(new_m, dirFirst);
end;

var
    master_prendas: mFile;
begin
    Assign(master_prendas, dirFirst);
    bajasLógicas(master_prendas);
    compactarYRenombrar(master_prendas);
end.
