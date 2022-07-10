Program FODP3E6Adaptado;

Const

    DIR_NEW = 'C:\FOD\PrendasTemp.dat';
    DIR_OLD = 'C:\FOD\PrendasViejas.dat';
    DIR_FIRST = 'C:\FOD\PrendasActualizadas.dat';
    DIR_DET = 'C:\FOD\PrendasAEliminar.dat';

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
    dFile = file of integer;

procedure buscarPrenda(var m: mFile; var aux_m: prenda; cod: integer);
begin
    // Se supone que el archivo viene abierto, lo devuelve en la posicion del codigo que se busca,
    // si no se encontró, devuelve en eof y el stock de aux_m será negativo
    seek(m, 0);
    while((not eof(m)) & (aux_m.cod <> cod))do read(m, aux_m);
    if (aux_m.cod <> cod) then aux_m.stock := -1
    else seek(m, filepos(m) - 1);
end;

procedure bajasLógicas(var m: mFile; var det: dFile);
var
    aux_m: prenda;
    aux_d: integer;
begin
    
    reset(det);
    reset(m);

    while(not eof(det)) do begin
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

procedure compactarYRenombrar(var m, new_m: mFile);
var
    aux_m: prenda;
begin
    
    rewrite(new_m);
    reset(m);

    while(not eof(m)) do begin
        read(m, aux_m);
        if(aux_m.stock >= 0)then write(new_m, aux_m);
    end;

    close(m);
    close(new_m);
    rename(m, DIR_OLD);
    rename(new_m, DIR_FIRST);
end;

var
    master_prendas, new_m: mFile;
    det: dFile;
begin
    Assign(det, DIR_DET);
    Assign(master_prendas, DIR_FIRST);
    Assign(new_m, DIR_NEW);
    bajasLógicas(master_prendas, det);
    compactarYRenombrar(master_prendas, new_m);
end.
