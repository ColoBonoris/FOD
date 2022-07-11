{

Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000

}

program e7p3FOD;

Const
    DIR_FILE = 'C:\FOD\maestroEspecies.dat';
    FIN = 500000;

Type

    esp = record
        cod: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;

    bFile = file of esp;

procedure buscarEspecie(var m:bFile; var aux_m: esp; codigo: integer);
// Devuelve aux_m.cod = 0 si no encontró la especie, sino lo devuelve en -1 (en caso de encontrar, preparado para el write)
// La eliminación lógica será poniendo el código en -1
// Se supone que el archivo llega abierto
// Se supone que el código siempre va a ser neutro/positivo
begin
    seek(m, 0);
    aux_m.cod := -1;

    while((not eof(m)) and (aux_m.cod <> codigo)) do
        read(m, aux_m);

    if(aux_m.cod = codigo)then begin
        seek(m, filePos(m) - 1);
        aux_m.cod := -1;
    end
    else aux_m.cod := 0;
end;

procedure eliminacionLogica(var m: bFile);
var
    aux_m: esp;
    aux_del: integer;

begin
    reset(m);

    write('Ingrese el código de la especie a eliminar: '); readln(aux_del);
    while(aux_del <> FIN)do begin
        buscarEspecie(m,aux_m,aux_del);
        if(aux_m.cod = -1)then write(m, aux_m)
        else writeln('No se encontró la especie');
        write('Ingrese el código de la especie a eliminar: '); readln(aux_del);
    end;
    close(m);
end;

procedure compactar(var m: bFile);
var
    aux_pos: integer;
    aux_m: esp;
begin
    reset(m);
    while(not eof(m))do begin
        read(m, aux_m);
        if(aux_m.cod = -1)then begin
            pos := filePos(m) - 1;
            seek(m, filesize(m)-1);
            read(m, aux_m);
            seek(m, pos);
            write(m, aux_m);
            seek(m, filesize(m) - 1);
            truncate(m);
            seek(m, pos);
        end;
    end;
    close(m);
end;

procedure compactar2(var m: bFile);
var
    aux_pos, aux_fin: integer;
    aux_m: esp;
    terminado: boolean;
begin
    terminado := false;
    reset(m);
    aux_fin := filesize(m) - 1;
    while(not terminado)do begin
        pos := filePos(m);
        read(m, aux_m);

        if(aux_m.cod = -1)and(pos <> aux_fin)then begin
            seek(m, aux_fin);
            read(m, aux_m);
            aux_fin := filepos(m) - 2;
            seek(m, pos);
            write(m, aux_m);
            seek(m, filepos(m)-1);
        end;
        else begin
            if(aux_fin = pos)then begin
                terminado := true;
                if(aux_m.cod = -1)then aux_fin := aux_fin - 1;
            end;
        end;
    end;
    seek(m,aux_fin + 1);
    truncate(m);
    close(m);
end;

procedure compactar3(var f: bFile);
var
    aux_fin, pos: integer;
    e: esp;
    recorrido: boolean;
begin
    reset(f);
    aux_fin := fileSize(f) -1;
    recorrido := false;

    while (not recorrido) do begin
        read(f, e);
        if e.cod = -1 then begin
        // Prepara para borrar 
            pos := filePos(f) -1;
            seek(f,aux_fin);
            read(f,e);
        // Acumula los finales a borrar
            while(e.cod = -1)&(aux_fin > pos)do begin
                aux_fin := aux_fin -1;
                seek(f,aux_fin);
                read(f,e);
            end;
        // Evalúa en qué posición del ercorrido estamos
            if(aux_fin > pos)then
                aux_fin := aux_fin - 1;
            else
                recorrido := true;
        // Trunca y borra el archivo a borrar
            seek(f,filepos(m)-1);
            truncate(f);
            if(not recorrido)then begin
                seek(f, pos);
                write(f, e);
            end;
        end;
    end;
    close(f);
end;

procedure compactar4(var arch: mFile);
var
    ave:esp;
    act:esp;
    pos:integer;
begin
    reset (arch);
    while (not eof (arch)) do begin
        read (arch, ave);
        if (ave.cod = -1) then begin
            pos:= filePos(arch) -1;
            seek (arch, fileSize(arch) -1);
            read(arch, act);
            seek (arch, pos);
            write (arch, act);
            seek (arch, fileSize (arch) -1);
            truncate(arch);
            seek (arch, pos);
        end
    end
    close (arch);
end;

var
    m: bFile;
begin
    Assign(m, DIR_FILE);
    eliminacionLogica(m);
    compactar(m);
end;


