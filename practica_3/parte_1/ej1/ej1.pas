program ej1;
const valorAlto = 9999;
type
	empleado = record
	numero : integer;
	apellido : string[20];
	nombre : string[20];
	edad : integer;
	dni : string[8];
	end;
	
	archivo = file of empleado;

procedure leer (var mae : archivo; var reg : empleado);
begin
	if not eof(mae) then
		read(mae,reg)
	else
		reg.numero := valorAlto;
end;
procedure truncar (var mae : archivo; num : integer);
var
	ultimo : empleado;
	reg : empleado; 
begin
	reset(mae);
	seek(mae,filesize(mae)-1);
	leer(mae,ultimo); // tengo el ultimo para reemplazar
	seek(mae,0); // comienzo de la busqueda del empleado a eliminar
	leer(mae,reg);
	while (reg.numero <> valorAlto) and (reg.numero <> num) do
		leer(mae,reg);
	
	if reg.numero = num then begin
		seek(mae,filepos(mae)-1);
		write(mae,ultimo);
		seek(mae,filesize(mae)-1);
		truncate(mae);
		writeln('baja realizada');
	end
	else
		writeln('El empleado no existe');
	close(mae);
end;
procedure exportarTxt (var arch : archivo);
var
	reg : empleado;
	txt : Text;
begin
	assign(txt,'empleados.txt');
	rewrite(txt);
	reset(arch);
	leer(arch,reg);
	while (reg.numero <> valorAlto) do begin
		with reg do begin
			writeln(txt,numero,' ',edad,' ',dni);
			writeln(txt,apellido);
			writeln(txt,nombre);
		end;
		leer(arch,reg);
	end;
	close(arch);
	close(txt);
end;

var
	mae : archivo;
	num : integer;
BEGIN
	assign(mae,'empleados.dat');
	write('numero de empleado para eliminar: '); readln(num);
	truncar(mae,num);
	exportarTxt(mae);
END.
