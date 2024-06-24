program ej2;
const valorAlto = 9999;
type
	tmae = record
	numero : integer;
	nombre : string;
	email : string;
	telefono : string;
	dni : string;
	end;
	
	maestro = file of tmae;
	
procedure leerAsistente (var reg : tmae);
begin
	with reg do begin
		write('numero: ');readln(numero);
		if numero <> valorAlto then begin
			write('nombre: '); readln(nombre);
			write('email: ');readln(email);
			write('telefono: ');readln(telefono);
			write('dni: ');readln(dni);
		end;
	end;
end;

procedure crear (var mae : maestro);
var
	reg : tmae;
begin
	reset(mae);
	leerAsistente(reg);
	seek(mae,filesize(mae));
	while reg.numero <> valorAlto do begin
		write(mae,reg);
		leerAsistente(reg);
	end;
	close(mae);
end;

procedure leer (var mae : maestro; var regm : tmae);
begin
	if not eof(mae) then 
		read(mae,regm)
	else
		read.numero := valorAlto;
end;
procedure bajaLogica (var mae :maestro; num : integer);
var
	reg : tmae;
begin
	reset(mae);
	leer(mae,reg);
	while (reg.numero <> valorAlto)
		if reg.numero < 1000 then begin
			reg.nombre := '@' + reg.nombre;
			seek(mae,filepos(mae)-1);
			write(mae,reg);
		end;
		leer(mae,reg);
	end;
	close(mae);
end;
var
	mae : maestro;
	num : integer;
BEGIN
	assign(mae,'asistentes');
	//crear(mae);
	write('numero para baja logica: ');readln(num);
END.
