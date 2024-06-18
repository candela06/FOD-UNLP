
program untitled;
const valorAlto = 9999;
type 
	alumno = record
		codigo : integer;
		cantCursadas : integer;
		cantFinales : integer;
		nombre : string[20];
		end;
	
	materia = record
		codigo : integer;
		estado : integer; // 1 si aprobo final, 0 si aprobo cursada
		end;
	
	maestro = file of alumno;
	detalle = file of materia;
	
procedure importarMaestro (var mae : maestro);
var a : alumno;
		txt : Text;
begin
	assign(mae,'maestro.dat');
	assign(txt,'maestro.txt');
	reset(txt);
	rewrite(mae);
	while not eof(txt) do begin
		with a do begin
			readln(txt,codigo,cantCursadas,cantFinales,nombre);
		end;
		write(mae,a);
	end;
	writeln('archivo maestro importado');
	close(txt);
	close(mae);
end;

procedure importarDetalle (var det : detalle);
var m : materia;
		txt : text;
begin
	assign(txt,'detalle.txt');
	assign(det,'detalle.dat');
	reset(txt);
	rewrite(det);
	while not eof(txt) do begin
		readln(txt,m.codigo,m.estado);
		write(det,m);
	end;
	writeln('archivo detalle importado');
	close(txt);
	close(det);
end;

procedure leer ( var det : detalle; var regd : materia);
begin
	if (not (eof(det))) then
		read(det,regd)
	else regd.codigo := valorAlto;
end;

procedure actualizarMae (var mae : maestro; var det : detalle);
var regd : materia;
		regm : alumno;
		finales : integer;
		cursadas : integer;
begin
	reset(mae);
	reset(det);

	// leo una materia
	leer(det,regd);
	
	// mientras no sea el fin de archivo detalle (materias)...
	while (regd.codigo <> valorAlto) do begin
		// leo un alumno
		read(mae,regm);
		finales := 0;
		cursadas := 0;
		
		// busco al alumno
		while ( regm.codigo <> regd.codigo ) do 
			read(mae,regm);
		// mientras se trate de materias del mismo alumno
		while (regm.codigo = regd.codigo) do begin
			if (regd.estado = 1) then
				finales := finales + 1;
			if (regd.estado = 0) then
				cursadas := cursadas + 1;
			// leo otra materia
			leer(det,regd);		
		end;
		
		// actualizo registro maestro (alumno)
		regm.cantFinales := regm.cantFinales + finales;
		regm.cantCursadas := regm.cantCursadas + cursadas - finales;
		
		writeln('se actualizo un alumno !');
		seek(mae,filepos(mae)-1);
		write(mae,regm);		
	end;
	
	close(mae);
	close(det);
end;

procedure listar ( var mae : maestro; var txt : text);
var	alu : alumno;
begin
	assign(txt,'masFinalesQueCursadas.txt');
	rewrite(txt);
	reset(mae);
	while not eof(mae) do begin
		read(mae,alu);
		with alu do begin
			if (cantFinales > cantCursadas) then
				writeln(txt,codigo,' ',cantCursadas,' ',cantFinales,' ',nombre);
		end;
	end;
	close(mae);
	close(txt);
end;

var mae : maestro;
		det : detalle;
		txt : text;

BEGIN
	importarMaestro(mae);
	importarDetalle(det);
	actualizarMae(mae,det);
	listar(mae,txt);
	
	
END.

