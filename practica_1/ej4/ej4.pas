{4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}

program ej4;
const valorAlto = 'fin';
type
	empleado = record
		numero : integer;
		apellido : string[20];
		nombre : string[20];
		edad : integer;
		dni : string[8];
	end;
	
	archivo = file of empleado;

procedure leer (var arch : archivo; var reg : empleado);
begin
	if not eof(arch) then 
		read(arch,reg)
	else
		reg.apellido := valorAlto;
end;

procedure menu (var op : byte);
begin
	writeln('-------------------------------------------');
	writeln('|1 Agregar empleado nuevo.');
	writeln('|2 Modificar edad de un empleado');
	writeln('|3  Exportar todos los empleados.');
	writeln('|4 Exportar empleados con dni 00.');
	writeln('|5 salir.');
	write('| opción: '); readln(op);
	writeln('-------------------------------------------');
end;
	
procedure agregar (var arch : archivo);
	procedure leerEmpleado (var reg : empleado);
	begin
		write('apellido: '); readln(reg.apellido);
		if reg.apellido <> 'fin' then begin
			write('nombre: '); readln(reg.nombre);
			write('numero: '); readln(reg.numero);
			write('edad: '); readln(reg.edad);
			write('dni: '); readln(reg.dni);
		end;
	end;
	
	function repetido (var arch : archivo; num : integer):boolean;
	var
		reg : empleado;
		ok : boolean;
	begin
		ok := false;
		while (not eof(arch)) and (not ok) do begin
			read(arch,reg);
			if (reg.numero = num) then
				ok := true;
		end;
		repetido := ok;
	end;
var
	reg : empleado;
begin
	reset(arch);
	leerEmpleado(reg);
	if reg.apellido <> 'fin' then begin
		if not repetido(arch,reg.numero) then begin
			seek(arch,filesize(arch));
			write(arch,reg);
			writeln('Empleado agregado con exito.')
		end
		else
			writeln('El empleado ya existe');
	end;
	close(arch);
end;

procedure modificarEdad(var arch : archivo);
var
	reg : empleado;
	num : integer;
begin
	reset(arch);
	write('numero: ');readln(num);
	leer(arch,reg);
	while (reg.apellido <> valorAlto) and (reg.numero <> num) do 
		leer(arch,reg);
	
	if reg.numero = num then begin
		write('nueva edad:'); readln(num);
		seek(arch,filepos(arch)-1);
		reg.edad:= num;
		write(arch,reg);
	end
	else
		writeln('Empleado no encontrado.');
	
	close(arch);
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
	while (reg.apellido <> valorAlto) do begin
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

procedure faltaDNIEmpleado(var arch : archivo);
var
	reg : empleado;
	txt : Text;
begin
	assign(txt,'faltaDNIEmpleado.txt');
	rewrite(txt);
	reset(arch);
	leer(arch,reg);
	while(reg.apellido <> valorAlto) do begin
		if (reg.dni = '00') then begin
			with reg do begin
				writeln(txt,numero,' ',edad,' ',dni);
				writeln(txt,apellido);
				writeln(txt,nombre);
			end;
		end;
		leer(arch,reg);
	end;
	close(arch);
	close(txt);
end;
var 
	arch : archivo;
	//txt : Text;
	op : byte;
BEGIN
	assign(arch,'empleados.dat');
	repeat
		menu(op);
		case op of
			1: agregar(arch);
			2: modificarEdad(arch);
			3: exportarTxt(arch);
			4: faltaDNIEmpleado(arch);
		end;
	until	op = 5;
END.
