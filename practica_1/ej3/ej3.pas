{3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.

ii. Listar en pantalla los empleados de a uno por línea.

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program ej3;
const valorAlto ='fin';
type
	empleado = record
		numero : integer;
		apellido : string[20];
		nombre : string[20];
		edad : integer;
		dni : string[8];
	end;
	
	archivo = file of empleado;

procedure menu (var op : byte);
begin
	writeln('-----------------------------------------------------------------------------------------');
	writeln('|1 Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('|2 Listar en pantalla los empleados de a uno por línea.');
	writeln('|3  Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.');
	writeln('|4 salir.');
	write('| opción: '); readln(op);
	writeln('-----------------------------------------------------------------------------------------');
end;

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

procedure cargar (var arch : archivo);
var
	regEm : empleado;
begin
	rewrite(arch);
	leerEmpleado(regEm);
	while regEm.apellido <> 'fin' do begin
		write(arch,regEm);
		leerEmpleado(regEm);
	end;
	close(arch);
end;

{i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.}
procedure leer (var arch : archivo; var reg : empleado);
begin
	if (not (eof(arch))) then 
		read(arch,reg)
	else
		reg.apellido := 'fin';
end;

procedure imprimir (reg : empleado);
begin
	writeln('----------------------------------------------------');
	writeln('Empleado ',reg.numero);
	writeln(reg.nombre,' ',reg.apellido,', ',reg.edad,' de edad');
	writeln('DNI: ',reg.dni);
end;

procedure listarEmpleado (var arch : archivo);
var
	reg : empleado;
	aux : string[20];
begin
	reset(arch);
	write('nombre o apellido: '); readln(aux);
	leer(arch,reg);
	while (reg.apellido <> 'fin') do begin
		if ((reg.nombre = aux) or (reg.apellido = aux)) then
			imprimir(reg);
		leer(arch,reg);
	end;
	close(arch);
end;

procedure listar (var arch : archivo);
var
	reg : empleado;
begin
	reset(arch);
	leer(arch,reg);
	while (reg.apellido <> 'fin') do begin
		imprimir(reg);
		leer(arch,reg);
	end;
	writeln();
	close(arch);
end;

procedure listarProximosAJubilarse(var arch : archivo);
var
	reg : empleado;
begin
	writeln('Empleados proximos a jubilarse...');
	writeln();
	reset(arch);
	leer(arch,reg);
	while(reg.apellido <> 'fin') do begin
		if (reg.edad > 70) then
			imprimir(reg);
		leer(arch,reg);
	end;
	close(arch);
end;
var
	arch : archivo;
	op : byte;
BEGIN
	assign(arch,'empleados.dat');
	//cargar(arch);
	writeln();
	repeat
		menu(op);
		case op of
			1: listarEmpleado(arch);
			2: listar(arch);
			3: listarProximosAJubilarse(arch);
		end;
	until (op = 4);
END.
