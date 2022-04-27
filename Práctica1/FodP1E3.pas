program FodP1E1;

Const
	
	condfin = 'fin';

Type
	
	string20 = String[20];
	string9 = string[9];
	
	empleado = record
		num: integer;
		nom: string20;
		ap: string20;
		edad: integer;
		DNI: string9;
		end;
		
	archivoEmpleados = file of empleado;

procedure printEmployee(e: empleado);
	begin
		writeln(e.ap,', ',e.nom,' (',e.num,')');
		writeln('	DNI: ',e.dni );
		writeln('	Edad: ',e.edad );
		writeln('	Nombre: ',e.nom );
		writeln('-----');
	end;
	
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

procedure searchBySurname(var arch: archivoEmpleados; apellido: string20);
	var
		counter, i: integer;
		auxEmp: empleado;
	begin
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
	end;

procedure printStaff(var arch: archivoEmpleados);
	var
		auxEmp: empleado;
		i: integer;
	begin
		seek(arch,0);
		for i:=1 to filesize(arch) do begin
			Read(arch,auxEmp);
			writeln(filePos(arch),').');
			printEmployee(auxEmp);
		end;
	end;

procedure printAlmostRetired(var arch: archivoEmpleados; jubilacion: integer);
	var
		counter, i: integer;
		auxEmp: empleado;
	begin
		seek(arch,0);
		counter := 0;
		for i:=1 to filesize(arch) do begin
			Read(arch,auxEmp);
			if(auxEmp.edad > jubilacion)then begin
				counter := counter + 1;
				writeln(counter,').');
				printEmployee(auxEmp);
			end;
		end;
	end;
var
	arch: archivoEmpleados;
	apPrueba: string20;
	edadPrueba: integer;
Begin
	Assign(arch,'C:\ArchivosFOD\empleadosP1E3.dat');
	rewrite(arch);
	loadEmployees(arch);
	close(arch);
	reset(arch);
	printStaff(arch);
	write('Ingrese la edad de jubilacion: '); readln(edadPrueba);
	writeln('Proximos a jubilarse: ');
	printAlmostRetired(arch,edadPrueba);
	write('Ingrese un apellido a buscar: '); readln(apPrueba);
	writeln('Apariciones: ');
	searchBySurname(arch,apPrueba);
	close(arch);
End.























