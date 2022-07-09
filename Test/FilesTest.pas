{
    
    Pruebo temas con archivos

}

program FODtest;
//-----------------------------------------------------
Const
    def_route = 'C:\ArchivosFOD\';
//-----------------------------------------------------
Type
    test_reg = record
        numero: integer;
        cadena: String;
        end;
    test_file = file of test_reg;
//-----------------------------------------------------
procedure testing_eof_empty_file(var a: test_file);
    var
        aux_reg: test_reg;
    begin
    {
        Con esto vemos que sí se rompe, ya que no podemos saber si el erchivo fue creado o no
    }
		rewrite(a);
        while(not eof(a))do begin
            read(a, aux_reg);
        end;
        close(a);
    end;
//-----------------------------------------------------
var
    arch_test: test_file;
    test_str: String;
begin
    test_str := def_route + 'testArch.dat';
    Assign(arch_test,test_str);
    if(eof(arch_test))then writeln('fin paaaa')
    else writeln('no es fin paaaa');
    //testing_eof_empty_file(arch_test);

end.

