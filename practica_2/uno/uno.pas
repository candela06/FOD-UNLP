

program untitled;
const valorAlto = 9999;
type
	ingreso = record
		codigo: integer;
		monto: real;
		nombre: string[20];
	end;
	archivo = file of ingreso;

procedure asignar ( var compactFile : archivo );
var ruta : string[12];
begin
	write('ruta: '); readln(ruta);
	assign(compactFile,ruta);
end;

procedure importar ( var comisiones : archivo );
var txt : text;
		c : ingreso;
begin
	assign(txt,'comisiones.txt');
	assign(comisiones,'comisiones.dat');
	reset(txt);
	writeln('importando...');
	rewrite(comisiones);
	while not eof(txt) do begin
		readln(txt,c.codigo,c.monto,c.nombre);
		write(comisiones,c);
	end;
	writeln('importación exitosa ! ');
	writeln();
	close(comisiones);
	close(txt);
end;

procedure leer ( var comisiones : archivo; var c : ingreso );
begin
	if (not eof(comisiones)) then 
		read(comisiones,c)
	else 
		c.codigo := valorAlto;
end;

procedure compactar ( var comisiones, compactFile : archivo );

	
var c : ingreso;
		codigo : integer;
		montoTotal : real;
begin
	writeln('compactando...');
	reset(comisiones);
	rewrite(compactFile);
	leer(comisiones,c);
	// si no es el fin del archivo...
	while (c.codigo <> valorAlto) do begin
		codigo := c.codigo;
		montoTotal := 0;
		// mientras no sea el fin de archivo y sea el mismo empleado...
		while (c.codigo <> valorAlto) and (c.codigo = codigo ) do begin
			montoTotal := montoTotal + c.monto;
			leer(comisiones,c);
		end;
		c.monto := montoTotal;
		write(compactFile,c)
	end;
	writeln();
	close(compactFile);
	close(comisiones);
end;

procedure informar ( var compactFile : archivo );
	procedure informarEmpleado ( c : ingreso );
	begin
		writeln(c.nombre,', cod: ',c.codigo);
		writeln('monto total: $',c.monto);
	end;
var c : ingreso;
begin
	writeln('Empleados: ');
	reset(compactFile);
	while not eof(compactFile) do begin
		read(compactFile,c);
		informarEmpleado(c);
	end;
	close(compactFile);
end;
var comisiones : archivo;
		compactFile : archivo;

BEGIN
	asignar(compactFile);
	importar(comisiones);
	compactar(compactFile,comisiones);
	informar(compactFile);
	
END.

