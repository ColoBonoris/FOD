program FodP1E5y6;

// "celulares.txt" has to be already created and loaded
Uses sysutils;

Type
	
	phone = record
		code: integer;
		minStock: integer;
		stock: integer;
		price: real;
		name: String;
		desc: String;
		brand: String;
		end;
	
	binaryPhonesFile = file of phone;	
	
	
//----------------------------------------------------------------------
procedure importPhones(var phonesBinary: binaryPhonesFile);
	var
		phonesText: Text;
		pAux: phone;
	begin
		Assign(phonesText,'C:\ArchivosFOD\celulares.txt');
		reset(phonesText);
		Rewrite(phonesBinary);
		while(not eof(phonesText))do begin
			readln(phonesText,pAux.code,pAux.price,pAux.brand);
			readln(phonesText,pAux.stock,pAux.minStock,pAux.desc);
			readln(phonesText,pAux.name);
			write(phonesBinary,pAux);
		end;
		close(phonesBinary);
		close(phonesText);
	end;
//
procedure phoneToString(p: phone; var pStr: String);
	var
		auxStr: String;
	begin
		str(p.code,auxStr);
		pStr := ('Code: '+auxStr
			+'; Model: '+p.name
			+'; Brand: '+p.brand+
			'; Description: '+p.desc);
		str(p.minStock,auxStr);
		pStr := (pStr +'; Minimum Stock: '
			+auxStr);
		str(p.stock,auxStr);
		pStr := (pStr +'; Actual Stock: '
			+auxStr);
		str(p.price,auxStr);
		pStr := (pStr +'; Price: '
			+auxStr);
	end;
//
procedure exportNoStock(var phonesBinary: binaryPhonesFile);
	var
		pAux: phone;
		phonesText: Text;
		auxStr: String;
	begin
		Assign(phonesText,'C:\ArchivosFOD\celularesSinStock.txt');
		rewrite(phonesText);
		Seek(phonesBinary,0);
		while(not eof(phonesBinary))do begin
			read(phonesBinary,pAux);
			if(pAux.stock = 0)then begin
				phoneToString(pAux,auxStr);
				write(phonesText,auxStr);
			end;
		end;
	end;
//
procedure exportPhones(var phonesBinary: binaryPhonesFile);
	var
		phonesText: Text;
		auxStr: String;
		pAux: phone;
	begin
		Assign(phonesText,'C:\ArchivosFOD\celulares.txt');
		Seek(phonesBinary,0);
		WRITELN('LLEGA');
		rewrite(phonesText);
		WRITELN('LLEGA');
		while(not eof(phonesBinary))do begin
			WRITELN('LLEGA');
			read(phonesBinary,pAux);
			WRITELN('LLEGA');
			phoneToString(pAux,auxStr);
			WRITELN('LLEGA');
			write(phonesText,auxStr);
			WRITELN('LLEGA');
		end;
		close(phonesText);
		WRITELN('LLEGA');
	end;
//---------
procedure printPhone(p: phone; num: integer);
	begin
		writeln('');
		writeln('## ',num,'° Phone ##');
		writeln('');
		write('		Code: ', p.code);
		writeln('		Model: ', p.name);
		write('		Brand: ', p.brand);
		writeln('		Description: ', p.desc);
		write('		Minimum Stock: ', p.minStock);
		writeln('		Actual Stock: ', p.stock);
		writeln('		Price: ', p.price);
		writeln('');
	end;
//
procedure showWholeListing(var phonesBinary: binaryPhonesFile);
	var
		pAux: phone;
	begin
		seek(phonesBinary,0);
		writeln('');
		writeln('================ WHOLE PHONES LISTING ================');
		while(not eof(phonesBinary))do begin
			Read(phonesBinary,pAux);
			printPhone(pAux, filePos(phonesBinary));
		end;
	end;
//
procedure seekDescriptionString(var phonesBinary: binaryPhonesFile);
	var
		pAux: phone;
		auxStr: String;
		counter: integer;
	begin
		counter := 0;
		seek(phonesBinary,0);
		writeln('');
		write('## String to search among descriptions: ');readln(auxStr);
		writeln('');
		writeln('================ PHONES CONTAINING "',auxStr,'" ================');
		while(not eof(phonesBinary))do begin
			Read(phonesBinary,pAux);
			if(pos(auxStr,pAux.desc)<>0)then begin
				counter := counter + 1;
				printPhone(pAux,counter);
			end;
		end;
	end;
//
procedure showLowStock(var phonesBinary: binaryPhonesFile);
	var
		pAux: phone;
		counter: integer;
	begin
		counter := 0;
		seek(phonesBinary,0);
		writeln('');
		writeln('================ PHONES UNDER MINIMUM STOCK ================');
		while(not eof(phonesBinary))do begin
			Read(phonesBinary,pAux);
			if(pAux.minStock > pAux.stock)then begin
				counter := counter + 1;
				printPhone(pAux,counter);
			end;
		end;
	end;
//
procedure readNewPhone(var p: phone);
	begin
		writeln('');
		writeln('## LOADING NEW PHONE ##');
		writeln('');
		write('		Code: '); readln(p.code);
		write('		Model: '); readln(p.name);
		write('		Brand: '); readln(p.brand);
		write('		Description: '); readln(p.desc);
		write('		Minimum Stock: '); readln(p.minStock);
		write('		Actual Stock: '); readln(p.stock);
		write('		Price: '); readln(p.price);
		writeln('');
	end;
//
procedure addPhone(var phonesBinary: binaryPhonesFile);
	var
		pAux: phone;
	begin
		readNewPhone(pAux);
		seek(phonesBinary,fileSize(phonesBinary));
		write(phonesBinary,pAux);
	end;
//
procedure modifyStock(var phonesBinary: binaryPhonesFile);
	var
		code, newStock: integer;
		done: boolean;
		pAux: phone;
	begin
		write('Code: '); readln(code);
		write('New Stock: '); readln(newStock);
		done := False;
		while((not eof(phonesBinary)) and (not done)) do begin
			read(phonesBinary,pAux);
			if(pAux.code = code)then begin
				done := True;
				pAux.stock := newStock;
				seek(phonesBinary,filePos(phonesBinary) - 1);
				write(phonesBinary,pAux);
			end;
		end;
		if(not done)then
			writeln('Phone not found!');
	end;
//
procedure displayMenu(var phonesBinary: binaryPhonesFile);
	var
		election: integer;
	begin
		election := 0;
		while(election<>9)do begin
			writeln('-----------------------------------|');
			writeln('');
			writeln('# -- NEXT ACTION -- #');
			writeln('');
			writeln('	1 - Create new binary file.');
			writeln('	2 - Create text file.');
			writeln('	3 - Create "No Stock.txt".');
			writeln('	4 - Print under minimum stock.');
			writeln('	5 - Search for a string in descriptions.');
			writeln('	6 - Add new phone.');
			writeln('	7 - Modify stock.');
			writeln('	8 - Show listing.');
			writeln('	9 - Exit.');
			writeln('');
			write('* Choose an option 1-9: '); readln(election);
			
			while((election<1)or(election>9))do begin
				writeln('--');
				writeln('Election out of bounds!');
				write('Choose an option 1-9: '); readln(election);
			end;
			
			case election of
				1: 	begin
						importPhones(phonesBinary);
						reset(phonesBinary);
					end;
				2: exportPhones(phonesBinary);
				3: exportNoStock(phonesBinary);
				4: showLowStock(phonesBinary);
				5: seekDescriptionString(phonesBinary);
				6: addPhone(phonesBinary);
				7: modifyStock(phonesBinary);
				8: showWholeListing(phonesBinary);
			end;
		end;
		writeln('Goodbye world!');
	end;
	
//----------------------------------------------------------------------

VAR
	binaryName: String;
	phonesBinary: binaryPhonesFile;
BEGIN
	// First mandatory create/assign the first two files, only then display menu
	write('Insert new binary file''s name: '); readln(binaryName);
	binaryName := 'C:\ArchivosFOD\' + binaryName + '.dat';
	Assign(phonesBinary,binaryName);
	importPhones(phonesBinary);
	reset(phonesBinary);
	displayMenu(phonesBinary);
	Close(phonesBinary);
	// The only thing may not be right is the export, is not useful anymore to load a binary file
END.



















