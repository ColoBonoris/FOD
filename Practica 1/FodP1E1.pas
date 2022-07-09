program FodP1E1;

Type

	archivo = file of integer;

procedure loadIntegers(var arch: archivo);
	var
		auxInt: integer;
	begin
		write('Ingrese un entero: ');
		readln(auxInt);
		while(auxInt <> 30000)do begin
			Write(arch,auxInt);
			write('Ingrese un entero: ');
			readln(auxInt);
		end;
		write('Carga finalizada.');
	end;
	
var
	intArch: archivo;
	nombreFisico: String;
Begin
	write('Ingrese el nombre del nuevo archivo: ');
	readln(nombreFisico);
	nombreFisico := 'C:\ArchivosFOD\' + nombreFisico + '.dat';
	Assign(intArch,nombreFisico);
	Rewrite(intArch);
	loadIntegers(intArch);
	writeln(' La cantidad total de enteros cargados fue de ',fileSize(intArch),'.');
	Close(intArch);
End.
