{
    
9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: 
    código de provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.

Presentar en pantalla un listado como se muestra a continuación:



Código de Provincia
    Código de Localidad                                Total de Votos
................................                  ......................
................................                  ......................
Total de Votos Provincia: ____
Código de Provincia
    Código de Localidad                                 Total de Votos
................................                  ......................
Total de Votos Provincia: ___
....................................................................
Total General de Votos: ___



NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.

}

program FODP2E9;
//-----------------------------------------------------
Const
    VALOR_ALTO = 32000;
    M_FOD = 'C:\ArchivosFOD\mesas.txt';
//-----------------------------------------------------
Type
    mesa = record
        code_prov: integer;
        code_loc: integer;
        num: integer;
        amount: integer;
        end;
    
    detail_mesa = file of mesa;
//-----------------------------------------------------
procedure leer(var f: detail_mesa; var m: mesa);
begin
    if not eof(f) then
        read(f, m)
    else
        m.code_loc := VALOR_ALTO;
end;
//-----------------------------------------------------
procedure imprimir_mesas(var mesas: detail_mesa);
    var
        aux_m: mesa;
        act_prov,act_loc,total,total_prov,total_loc: integer;
    begin
        reset(mesas);
        //
        leer(mesas,aux_m);
        total := 0;
        while(aux_m <> VALOR_ALTO)do begin
            total_prov := 0;
            act_prov := aux_m.code_prov;
            print(act_prov);
            while(act_prov = aux_m.code_prov)do begin
                total_loc := 0
                act_loc := aux_m.code_loc;
                while((act_loc = aux_m.code_loc) and (act_prov = aux_m.code_prov))do begin
                    total_loc := total_loc + aux_m.amount;
                    leer(mesas,aux_m);
                end;
                print(act_loc,'         ',total_loc);
                total_prov := total_prov + total_loc;
            end;
            total := total + total_prov
            print('Total de Votos Provincia:            ',total_prov);
        end;
        print('Total de Votos Provincia:            ',total);
        //
        close(mesas);
    end;
//-----------------------------------------------------
var
    mesas: mesa;
begin
    Assign(mesas, M_FOD);
    imprimir_mesas (mesas);
end.