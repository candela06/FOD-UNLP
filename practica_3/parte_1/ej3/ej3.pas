program ej3;
const valorAlto = 9999;
type
	novela = record
	codigo : integer;
	genero, nombre, director : string;
	duracion, precio : real;
	end;
	
	archivo = file of novela;
	
procedure listaInvertida (var arch : archivo);
var
	reg : novela;
begin
	rewrite(arch);
	reg.codigo := 0;
	write(arch,reg);
	leerNovela(reg);
	while reg.codigo <> valorAlto do begin
		write(arch,reg);
		leerNovela(reg);
	end;
	close(arch);
end;

procedure leer (var arch : archivo; var reg : novela);
begin
	if	not eof(arch) then
		read(arch,reg)
	else
		reg.codigo := valorAlto;
end;

procedure alta (var arch : archivo; nuevo : novela);
var
	reg : novela;
begin
	reset(arch);
	leer(arch,reg);
	if reg.codigo = 0 then begin
		seek(arch,filesize(arch));
		write(arch,reg);
	else
	if reg.codigo < 0 then begin
		seek(arch,reg.codigo * -1);
		read(arch,reg);
		seek(arch,filepos(arch)-1);
		write(arch,nuevo);
		seek(arch,0);
		write(arch,reg);
	end;
	
	close(arch);
end;

procedure modificar (var arch : archivo; cod : integer);
var
	reg : novela;
begin
	reset(arch);
	leer(arch,reg);
	while (reg.codigo <> valorAlto) and (reg.codigo <> cod) do
		leer(arch,reg);
	
	if reg.codigo = cod then begin
		modificarNovela(reg);
		seek(arch,filepos(arch)-1);
		write(arch,reg);
	end;
	close(arch);
end;

procedure baja (var arch : archivo; cod : integer);
var
	reg : novela;
	encontre : boolean;
begin
	encontre := false;
	reset(arch);
	leer(arch,reg);
	while (reg.codigo <> valorAlto) and (not encontre) do begin
		if reg.codigo = cod then begin
			encontre := true;
			reg.codigo := reg.codigo * -1;
			seek(arch,filepos(arch)-1);
			write(arch,reg);
			seek(arch,0);
			write(arch,reg);
		end
		else
			leer(arch,reg);
	end;
	close(arch);
end;

procedure exportarTxt (var arch : archivo);
var
	reg : novela;
	txt : text;
begin	
	assign(txt,'novelas.txt');
	rewrite(txt);
	reset(arch);
	leer(arch,reg);
	while reg.codigo <> valorAlto do begin
		if (reg.codigo < 0) then
			writeln(txt,' ')
		else
			writeln(txt,reg.nombre);
		leer(arch,reg);
	end;
end;

var
	arch : archivo;
BEGIN
	assign(arch,'novelas');
	listaInvertida(arch);
END.
