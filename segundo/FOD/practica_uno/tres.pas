{
 Realizar un programa que presente un menú con opciones para:
 
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido

b. Abrir el archivo anteriormente generado y
* 
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
* 
ii. Listar en pantalla los empleados de a uno por línea.
* 
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
* 
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
   
}


program untitled;
type
	empleado = record
		edad,nro: integer;
		dni,nombre,apellido: string[20];
		end;
	
	archivo = file of empleado;

// procesos
procedure asignar(var empleados: archivo);
var ruta:string[12];
begin
	write('ruta: ');
	readln(ruta);
	assign(empleados,ruta);
end;

procedure cargar (var empleados: archivo);
	procedure leerEmpleado(var e: empleado);
	begin
		writeln();
		write('apellido: ');readln(e.apellido);
		if e.apellido <> 'fin' then begin
			write('nombre: '); readln(e.nombre);
			write('numero: '); readln(e.nro);
			write('edad: '); readln(e.edad);
			write('dni: '); readln(e.dni);
		end;
	end;
	
var e: empleado;
begin
	writeln();
	writeln('Inicia la caga de empleados (apellido: "fin" para finalizar)...');
	rewrite(empleados);
	leerEmpleado(e);
	while e.apellido <> 'fin' do begin
		write(empleados,e);
		leerEmpleado(e);
	end;
	
	close(empleados);
end;

procedure leer( e: empleado);
begin
	writeln(e.apellido,' ',e.nombre,', ',e.nro);
	writeln(e.edad,' de edad. DNI: ',e.dni);
	writeln('--------------------');
end;

procedure imprimir ( var empleados: archivo);
var e: empleado;
begin
	writeln();
	writeln('--------- EMPLEADOS ----------');
	writeln();
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,e);
		leer(e);
	end;
		
	close(empleados);
end;

procedure buscar (var empleados: archivo);
var aux: string[20]; e: empleado;
begin
	write('apellido: ');read(aux);
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,e);
		if e.apellido = aux then leer(e);
	end;
	close(empleados);
end;

procedure proximosAJubilarse (var empleados: archivo);
var e: empleado;
begin
	writeln('----------- PROXIMOS A JUBILARSE -----------');
	reset(empleados);
	while not eof(empleados) do begin
		read(empleados,e);
		if e.edad > 70 then leer(e);
	end;
	close(empleados);
end;
var empleados: archivo;
		op: byte;

BEGIN
	asignar(empleados);
	cargar(empleados);
	


	repeat
		writeln('--------- | MENU | ---------');
		writeln('| 1) buscar por apellido.');
		writeln('| 2) imprimir empleados. ');
		writeln('| 3) imprimir proximos a jubilarse. ');
		writeln('| 4) salir');
		write('| OPCION: '); readln(op);
		writeln('----------------------------');
		writeln();
		case op of
			1: buscar(empleados);
			2: imprimir(empleados);
			3: proximosAJubilarse(empleados);
		end;
	until op = 4;
END.

