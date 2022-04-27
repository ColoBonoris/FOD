{
    
    Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
    agregándole una opción para realizar bajas copiando el último registro del archivo en
    la posición del registro a borrar y luego truncando el archivo en la posición del último
    registro de forma tal de evitar duplicados.

}

program FODP3E1;
//-----------------------------------------------------
Const
	
	condfin = 'fin';
	fileName = 'empleadosP1E4';
//-----------------------------------------------------
Type
	
	string20 = String[20];
	string9 = string[9];
//	
	empleado = record
		num: integer;
		nom: string20;
		ap: string20;
		edad: integer;
		DNI: string9;
		end;
//		
	archivoEmpleados = file of empleado;
	archivoEmpleadosTxt = file of String;
//-----------------------------------------------------
procedure printEmployee(e: empleado);
	begin
		writeln(e.ap,', ',e.nom,' (',e.num,')');
		writeln('	DNI: ',e.dni );
		writeln('	Edad: ',e.edad );
		writeln('	Nombre: ',e.nom );
		writeln('-----');
	end;
//
procedure readEmployee(var e: empleado);
	begin
		writeln('-------------------| Cargando empleado... ');
		write('Ingrese el apellido: '); readln(e.ap);
		if(e.ap <> condfin)then begin
			write('Ingrese el nombre: '); readln(e.nom);
			write('Ingrese el DNI: '); readln(e.dni);
			write('Ingrese el numero de empleado: '); readln(e.num);
			write('Ingrese la edad: '); readln(e.edad);
		end;
	end;
//
procedure loadEmployees(var arch: archivoEmpleados);
	var
		auxemp: empleado;
	begin
		readEmployee(auxEmp);
		while(auxEmp.ap <> condFin)do begin
			Write(arch,auxEmp);
			readEmployee(auxEmp);
		end;
	end;
//
procedure searchBySurname(var arch: archivoEmpleados; apellido: string20);
	var
		counter, i: integer;
		auxEmp: empleado;
	begin
		reset(arch);
		seek(arch,0);
		counter := 0;
		for i:=1 to filesize(arch) do begin
			Read(arch,auxEmp);
			if(auxEmp.ap = apellido)then begin
				counter := counter + 1;
				writeln(counter,').');
				printEmployee(auxEmp);
			end;
		end;
		close(arch);
	end;
//
procedure printStaff(var arch: archivoEmpleados);
	var
		auxEmp: empleado;
		i: integer;
	begin
		reset(arch);
		for i:=1 to filesize(arch) do begin
			Read(arch,auxEmp);
			writeln(filePos(arch),').');
			printEmployee(auxEmp);
		end;
		close(arch);
	end;
//
procedure printAlmostRetired(var arch: archivoEmpleados; jubilacion: integer);
	var
		counter, i: integer;
		auxEmp: empleado;
	begin
		reset(arch);
		counter := 0;
		for i:=1 to filesize(arch) do begin
			Read(arch,auxEmp);
			if(auxEmp.edad > jubilacion)then begin
				counter := counter + 1;
				writeln(counter,').');
				printEmployee(auxEmp);
			end;
		end;
		close(arch);
	end;
//
procedure exportTxt(var arch: archivoEmpleados);
	var
		newArch: archivoEmpleadosTxt;
		auxStr: String;
		auxEmp: empleado;
	begin
		auxStr := 'C:\ArchivosFOD\'+fileName+'.txt';
		Assign(newArch,auxStr);
		rewrite(newArch);
		reset(arch);
		while(not eof(arch))do begin
			read(arch,auxEmp);
			auxStr := '- '+ filepos(arch) +
				'). Nombre: '+ auxEmp.nom +
				', Apellido: '+ auxEmp.ap +
				', Numero de Empleado: '+ auxEmp.num +
				', Edad: '+ auxEmp.edad +
				', DNI: '+ auxEmp.dni;
			write(newArch,auxStr)
		end;
		close(newArch);
		close(arch);
	end;
//
procedure exportTxtNoDni(var arch: archivoEmpleados);
	var
		newArch: archivoEmpleadosTxt;
		auxStr: String;
		auxEmp: empleado;
	begin
		auxStr := 'C:\ArchivosFOD\'+fileName+'SinDni.txt';
		Assign(newArch,auxStr);
		rewrite(newArch);
		reset(arch);
		while(not eof(arch))do begin
			read(arch,auxEmp);
			if(auxEmp.dni = '00')then begin
				auxStr := '- '+ filepos(arch) +
					'). Nombre: '+ auxEmp.nom +
					', Apellido: '+ auxEmp.ap +
					', Numero de Empleado: '+ auxEmp.num +
					', Edad: '+ auxEmp.edad;
				write(newArch,auxStr);
			end;
		end;
		close(newArch);
		close(arch);
	end;
//
procedure searchEmployee(var arch: archivoEmpleados; num: integer; var pos: integer);
	var
		auxEmp: empleado;
	begin
		pos := -1;
		while((pos = -1)and(not eof(arch)))do begin
			read(arch,auxEmp);
			if(auxEmp.num = num)then
				pos := filePos(arch) - 1;
		end;
	end;
//
procedure changeAge(var arch: archivoEmpleados);
	var
		auxint, index: integer;
		auxEmp: empleado;
	begin
		reset(arch);
		write('Ingrese el numero de empleado: ');readln(auxInt);
		searchEmployee(arch,auxInt,index);
		if(index > -1)then begin
			write('Ingrese la nueva edad: ');readln(auxInt);
			seek(arch,index);
			read(arch,auxEmp);
			seek(arch,index);
			auxEmp.edad := auxInt;
			write(arch,auxEmp);
		end
		else
			writeln('Empleado no encontrado.');
		close(arch);
	end;
//
procedure addEmployee(var a: archivoEmpleados);
	var
		auxEmp: empleado;
	begin
        // E una lectura posterior, no se checkea que no se repita el número o el DNI, claves unívocas
		reset(a);
		readEmployee(auxEmp);
		seek(a,fileSize(a));
		write(a,auxEmp);
		close(a);
	end;
//
procedure deleteEmployee(var a: archivoEmpleados);
    var
        auxEmp: empleado;
        deleteNum, posDelete: integer;
        found: boolean;
    begin
        write('Ingrese el numero del empleado a eliminar: (num < 1 cancels the operation) ');
        readln(deleteNum);
        if(deletenum > 1) then begin
            reset(a);
            // seteamos el numero para que sea diferente a deletenum nada más
            auxEmp.num := deletenum + 1;
            // Buscamos el registro
            found := false;
            while(not (eof(a) or found))do begin
                read(a,auxEmp);
                if(auxEmp.num = deletenum)then
                    found := true;
            end;
            // Checkeamos que haya sido encontrado
            if(found)then begin
                // Reemplazamos el registro a eliminar por el último del archivo y truncamos en la última posición
                posDelete := filePos(a);
                seek(a,filesize(a)-1);
                read(a,auxEmp);
                seek(a,posDelete);
                write(a,auxEmp);
                seek(a,filesize(a)-1);
                truncate(a);
            end
            else begin
                // Informamos
                writeln('Empleado no existente!');
                close(a);
            end;
        end;
    end;
//-----------------------------------------------------
var
	arch: archivoEmpleados;
	apPrueba: string20;
	edadPrueba: integer;
	auxChar: char;
	auxName: String;
Begin
    {
    write('Ingrese el nombre del archivo: '); readln(fileName);
    while(filename = 'con')do begin
        writeln('Ingrese un nombre válido.');
        write('Ingrese el nombre del archivo: '); readln(fileName);
    end;
    }
    auxName := 'C:\ArchivosFOD\'+ fileName +'.dat';
	Assign(arch,auxName);
	// Se cargan los primeros empleados, al poder estar creado o no lo inicio afuera
	rewrite(arch);
	loadEmployees(arch);
	close(arch);
    // Se eliminan los empleados con los números pedidos
    write('Desea eliminar a algún empleado? (N if not)'); readln(auxChar);
	while(auxChar <> 'N')do begin
		deleteEmployee(arch);
		writeln('--');
		write('Desea eliminar otro empleado? (N if not)'); readln(auxChar);
	end;
	// Se imprimen todos los empleados
	printStaff(arch);
	// Se imprimen los proximos a jubilarse
	write('Ingrese la edad de jubilacion: '); readln(edadPrueba);
	writeln('Proximos a jubilarse: ');
	printAlmostRetired(arch,edadPrueba);
	// Se buscan los empleados con X apellido y se imprimen
	write('Ingrese un apellido a buscar: '); readln(apPrueba);
	writeln('Apariciones: ');
	searchBySurname(arch,apPrueba);
	// Se agregan empleados extra
	write('Desea agregar otro empleado? '); readln(auxChar);
	while(auxChar <> 'S')do begin
		addEmployee(arch);
		writeln('--');
		write('Desea agregar otro empleado? S/N'); readln(auxChar);
	end;
	// Se cambia la edad de algun empleado
	changeAge(arch);
	// Se exporta el archivo como .txt
	exportTxt(arch);
	exportTxtNoDni(arch);
End.























