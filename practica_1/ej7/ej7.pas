{
* 7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}
program ej7;
const valorAlto = 9999;
type
	novela = record
		codigo : integer;
		nombre : string;
		genero : string;
		precio : real;
	end;
	
	archivo = file of novela;

procedure menu (var op : byte);
begin
	writeln('-------------------------------');
	writeln('|1 Crear archivo binario.');
	writeln('|2 Modificar una novela.');
	writeln('|3 Agregar una novela.');
	writeln('|4 salir.');
	write('| opción: '); readln(op);
	writeln('-------------------------------');
end;

// Crear archivo binario
procedure crear (var arch : archivo ; var txt : text);
var
	reg : novela;
begin
	reset(txt);
	rewrite(arch);
	while not eof(txt) do begin
		with reg do begin
			readln(txt,codigo,precio,genero);
			readln(txt,nombre);
		end;
		write(arch,reg);
	end;
	close(arch);
	close(txt);
end;

// Modificar una novela
procedure leer(var arch : archivo ; var reg : novela);
begin
	if not eof(arch) then
		read(arch,reg)
	else
		reg.codigo := valorAlto;
end;

procedure menu2 (var opc : byte);
begin
	writeln('-------------------------------');
	writeln('|1 Modificar precio.');
	writeln('|2 Modificar nombre.');
	writeln('|3 Modificar genero.');
	writeln('|4 salir.');
	write('| opción: '); readln(opc);
	writeln('-------------------------------');
end;


procedure modificarNovela (var arch : archivo);
var
	reg : novela;
	opc : byte;
	cod : integer;
begin
	write('CODIGO DE LA NOVELA: '); readln(cod);
	reset(arch);
	leer(arch,reg);
	while (reg.codigo <> valorAlto) and (reg.codigo <> cod) do 
		leer(arch,reg);
	
	if (reg.codigo <> valorAlto) then begin
		if (reg.codigo = cod) then begin
			repeat
				menu2(opc);
				case opc of
					1: begin
							write('NUEVO PRECIO: $'); readln(reg.precio);
						end;
					2: begin
							write('NUEVO NOMBRE: '); readln(reg.nombre);
						end;
					3: begin
							write('NUEVO GENERO: '); readln(reg.genero);
						end;
				end;
				seek(arch,filepos(arch)-1);
				write(arch,reg);
			until opc = 4;
		end;
	end
	else
		writeln('No existe la novela con ese codigo.');
	close(arch);
end;

// Agregar novela
procedure leerNovela (var reg : novela);
begin
	with reg do begin
		write('codigo: '); readln(codigo);
		if codigo <> valorAlto then begin
			write('nombre: '); readln(nombre);
			write('genero: '); readln(genero);
			write('precio: $'); readln(precio);
		end;
	end;
end;

procedure agregarNovela (var arch : archivo);
	function existe (var arch : archivo; cod : integer): boolean;
	var
		reg : novela;
		ok : boolean;
	begin
		ok := false;
		leer(arch,reg);
		while (reg.codigo <> valorAlto) and (not ok) do begin
			if reg.codigo = cod then 
				ok := true
			else
				leer(arch,reg);
		end;
		existe := ok;
	end;
var
	reg : novela;
begin
	reset(arch);
	leerNovela(reg);
	if not existe(arch,reg.codigo) then begin
		seek(arch,filesize(arch));
		write(arch,reg);
	end;
	close(arch);
end;

var 
	arch : archivo;
	txt : Text;
	op : byte;

BEGIN
	assign(txt,'novelas.txt');
	assign(arch,'novelas.dot');
	repeat
		menu(op);
		case op of
			1: crear(arch,txt);
			2: modificarNovela(arch);
			3: agregarNovela(arch);
		end;
	until op = 4;
	
END.

