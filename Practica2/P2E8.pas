{
    
8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas *organizadas por
cliente.

Para ello, se deberá *informar por pantalla: 
    datos personales del cliente, el total mensual (mes por mes cuánto compró)
    y finalmente el monto total comprado en el año por el cliente.

Además, al finalizar el reporte, se debe informar el monto *total de ventas obtenido por la
empresa.

El formato del archivo maestro está dado por:
    cliente (cod cliente, nombre y apellido), año, mes, día y monto de la venta.
El orden del archivo está dado por:
    cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras.

}

program FODP2E8;
//-----------------------------------------------------
Const
//-----------------------------------------------------
Type
    client = record
        code: integer;
        nme: String;
        sme: String;
        end;
    date = record
        year: integer;
        month: integer;
        day: String;
        end;
    selling = record
        c: client;
        d: date;
        amount: real;
        end;
//
    sellings = file of venta;
//-----------------------------------------------------
procedure informar_corte_de_control(var s: sellings);
begin
    reset(s);
    //
    read(s,aux_s);
    total := 0;
    while(not eof(s))do begin
        print('\n---------------------------------------\n')
        actual_client := aux_s.code;
        client_total := 0;
        while((aux_s.code = actual_client) and not eof(s))do begin
            actual_year := aux_s.d.year;
            annual := 0;
            while((aux_s.code = actual_client) and (not eof(s)) and (actual_year = aux_s.d.year)) do begin
                actual_month := aux_s.d.month;
                monthly := 0;
                while((aux_s.code = actual_client) and (not eof(s)) and (actual_month = aux_s.d.month)) do begin
                    monthly := monthly + aux_s.amount;
                    read(s,aux_s);
                end;
                if((aux_s.code = actual_client) and (actual_month = aux_s.d.month))then
                    monthly := monthly + aux_s.amount;
                print(actual_month,': ',monthly);
                annual := annual + monthly;
            end; 
            print(actual_year,': ',annual);
            client_total := client_total + annual;
        end;
        print(actual_client,': ',client_total);
        total := total + annual;
        print('\n---------------------------------------\n')
    end;
    print('Total: ', total);
    //
    close(s);
end;
//-----------------------------------------------------
var
    ventas: sellings;
begin
    Assign(ventas,'C:\ArchivosFOD\ventas_empresa.dat');
    informar_corte_de_control(ventas);
end.