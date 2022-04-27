program FodP1E1;

Type

	archivo = file of integer;

procedure loadIntegers(var arch: archivo);
	var
		auxInt: integer;
	begin
		writeln('------------------|');
		write('Ingrese un entero: ');
		readln(auxInt);
		while(auxInt <> 30000)do begin
			Write(arch,auxInt);
			write('Ingrese un entero: ');
			readln(auxInt);
		end;
		writeln('Carga finalizada.');
	end;
	
procedure processFile(var arch: archivo; var promedio: real; var menoresA1500: integer);
	var
		intActual: integer;
	begin
		writeln('------------------|');
		promedio := 0;
		menoresA1500 := 0;
		if(fileSize(arch) > 0)then
			Seek(Arch,0);
		while(not eof(arch))do begin
			Read(arch, intActual);
			promedio := promedio + intActual;
			if(intActual < 1500)then
				menoresA1500 := menoresA1500 + 1;
			writeln('Pos ',filePos(arch) - 1,' = ', intActual);
		end;
		promedio := promedio / fileSize(arch);
	end;

var
	intArch: archivo;
	nombreFisico: String;
	menoresA1500: integer;
	promedioArchivo: real;
Begin
	write('Ingrese el nombre del nuevo archivo: ');
	readln(nombreFisico);
	nombreFisico := 'C:\ArchivosFOD\' + nombreFisico + '.dat';
	Assign(intArch,nombreFisico);
	Rewrite(intArch);
	loadIntegers(intArch);
	Close(intArch);
	Reset(intArch);
	processFile(intArch,promedioArchivo,menoresA1500);
	writeln('Hubieron ',menoresA1500,' numeros menores a 1500.');
	writeln('El promedio fue de ',promedioArchivo);
	Close(intArch);
	writeln('------------------|');
End.
