
program ej1;
type
	archivo = file of integer;

procedure asignar (var arch : archivo);
var
	ruta : string[10];
begin
	write('ruta: '); readln(ruta);
	assign(arch,ruta);
end;

procedure cargar (var arch : archivo);
var
	num : integer;
begin
	rewrite(arch);
	writeln('Inicia la carga, 30000 para finalizar\n');
	write('entero: '); readln(num);
	while num <> 30000 do begin
		write(arch,num);
		write('entero: '); readln(num);
	end;
	
	close(arch);
end;

procedure importarTxt (var arch : archivo; var txt: text);
var
	num : integer;
begin
	assign(txt,'numeros.txt');
	rewrite(txt);
	reset(arch);
	while not eof(arch) do begin
		read(arch,num);
		writeln(txt,num);
	end;
end;

var arch : archivo;
		txt : text;

BEGIN
	asignar(arch);
	cargar(arch);
	importarTxt(arch,txt);
END.

