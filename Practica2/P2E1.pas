{

1- Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez

}


program FODP2E1;
//------------------------------------------
Type
    String20 = string[20];
    employee = record:
        code: integer;
        nom: String20;
        comission: real;
        end;
    emp_file = file of employee;

//------------------------------------------

//
procedure compactFile(var emp, c_emp: emp_file);
    var
        actual: integer;
        aux_emp: employee;
    begin
        reset(emp);
        Assign(c_emp,'C:\ArchivosFOD\compact_employees.dat');
        rewrite(c_emp);
        //
        while(not eof(emp))do begin
            read(emp,aux_emp);
            actual := aux_emp.code;
            while((aux_emp.code = actual) and (not eof(emp)))do begin
                write(c_emp,aux_emp);
                read(emp,aux_emp);
            end;
            write(c_emp,aux_emp);
            //Después se va actualizando el actual y manejando corte de control
        end;
        //
        close(emp);
        close(c_emp);
    end;
//------------------------------------------
var
    emp, c_emp: emp_file;
begin   
    Assign(emp_file,'C:\ArchivosFOD\employees.dat');
    rewrite(emp);
    close(emp);
    compactFile(employees,compact_employees)
end.