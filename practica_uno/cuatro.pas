program untitled;
type
	empleado = record
		edad,numero: integer;
		dni,nombre,apellido: string[20];
		end;
	
	archivo = file of empleado;

// procesos
procedure asignar ( var empleados: archivo);
var ruta: string[12];
begin
	write('ruta: ');read(ruta);
	assign(empleados,ruta);
end;

function cumple ( var empleados: archivo; numero: integer): boolean;
var e: empleado;
		encontre: boolean;
begin
	encontre := false;
	while (not eof(empleados)) and (not encontre) do begin
		read(empleados,e);
		if e.numero = numero then encontre := true;
	end;
	cumple := encontre;
end;

procedure agregarEmpleado( var empleados: archivo);
	procedure leerEmpleado(var e: empleado);
	begin
		writeln();
		write('apellido: ');readln(e.apellido);
		if e.apellido <> 'fin' then begin
			write('nombre: '); readln(e.nombre);
			write('numero: '); readln(e.numero);
			write('edad: '); readln(e.edad);
			write('dni: '); readln(e.dni);
		end;
		end;
var e: empleado;
begin
	reset(empleados);
	leerEmpleado(e);
	if not cumple(empleados,e.numero) then begin
		seek(empleados,fileSize(empleados));
		write(empleados,e);
		writeln();
		writeln('¡Empleado agregado exitosamente!');
	end
	else writeln('el empleado ya exitse.');
	close(empleados);
end;

procedure modificarEdad ( var empleados: archivo);
var
	encontre: boolean;
	e: empleado;
	num, edad: integer;
begin
	encontre := false;
	reset(empleados);
	writeln('numero de empleado que sea modificar su edad: '); read(num);
	while (not eof(empleados)) and (not encontre) do begin
		read(empleados,e);
		if e.numero = num then begin
			encontre := true;
			writeln('nueva edad: '); read(edad);
			e.edad := edad;
			// me vuelvo a posicionar en el empleado encontrado
			Seek(empleados,filepos(empleados)-1);
			// reescribo el empleado modificado
			write(empleados,e);
		end;
	end;
	if not encontre then writeln('no existe el empleado');
	
	close(empleados);
end;

procedure exportartxt (var empleados: archivo);
var
	e: empleado;
	txt: Text;
begin
	assign(txt,'todos_empleados.txt');
	rewrite(txt);
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,e);
		with e do begin
			writeln(txt,numero,' ',edad,' ',dni,' ',nombre);
			writeln(txt,apellido);
		end;
	end;
	writeln('exportación exitosa...');
	close(empleados);
	close(txt);
end;
procedure exportartxtDni( var empleados: archivo);
var
	txt: Text;
	e: empleado;
begin
	assign(txt,'faltaDNIEmpleado.txt');
	rewrite(txt);
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,e);
		with e do begin
			if dni = '00' then begin
				writeln(txt,numero,' ',edad,' ',dni,' ',nombre);
				writeln(txt,apellido);
			end;
		end;
	end;
	close(txt);
	close(empleados);
end;

var op : byte;
		empleados : archivo;

BEGIN
	asignar(empleados);
	
	repeat
		writeln();
		writeln('--------- | MENU | ---------');
		writeln('| 1) agregar empleado.');
		writeln('| 2) modificar edad. ');
		writeln('| 3) exportar a txt. ');
		writeln('| 4) exportar empleados con dni 00.');
		writeln('| 5) salir.');
		writeln('| OPCION: '); readln(op);
		writeln('----------------------------');
		writeln();
		case op of
			1: agregarEmpleado(empleados);
			2: modificarEdad(empleados);
			3: exportartxt(empleados);
			4: exportartxtDni(empleados);
		end;
	until op = 5;
END.

