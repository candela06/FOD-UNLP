
program untitled;
const valoralto = 9999;
type
	prenda = record
		codigo : integer;
		precio : real;
		stock : integer;
		des : string[20];
		color : string[20];
		tipo : string[20];
	end;
	
	maestro = file of prenda;
	detalle = file of integer;


procedure importarMae (var mae : maestro);
var
		txt : text;
		regm : prenda;
begin
	assign(txt,'maestro.txt');
	assign(mae,'maestro.dat');
	reset(txt);
	rewrite(mae);
	while not eof(txt) do begin
		with regm do begin
			readln(txt,codigo,stock,precio,des);
			readln(txt,tipo);
			readln(txt,color);
		end;
		write(mae,regm);
	end;
	writeln('archivo maestro importado');
	close(mae);
	close(txt);
end;

procedure importarDet (var det : detalle);
var
	txt : text;
	codigo : integer;
begin
	assign(txt,'detalle.txt');
	reset(txt);
	assign(det,'detalle.dat');
	rewrite(det);
	while not eof(txt) do begin
		readln(txt,codigo);
		write(det,codigo);
	end;
	writeln('archivo detalle importado');
	close(txt);
	close(det);
end;

procedure leerMae (var mae : maestro; var regm : prenda);
begin
	if not eof(mae) then read(mae,regm)
	else
		regm.codigo := valoralto;
end;

procedure bajaLogica (var mae : maestro; var det : detalle);
var
	regm : prenda;
	codigo : integer;
begin
	codigo := 0;
	reset(mae);
	reset(det);
	while not eof(det) do begin
		read(det,codigo);
		seek(mae,0);
		leerMae(mae,regm);
		while (regm.codigo <> valoralto) and (regm.codigo <> codigo) do 
			leerMae(mae,regm);
		if (regm.codigo = codigo) then begin
			regm.stock := -2;
			seek(mae,filepos(mae)-1);
			write(mae,regm);
			writeln('registro dado de baja');
		end;
	end;
	
	close(det);
	close(mae);
end;

procedure maeActualizado (var newMae, mae : maestro);
var
	regm : prenda;
begin
	assign(newMae,'mae_actualizado.txt');
	rewrite(newMae);
	reset(mae);
	leerMae(mae,regm);
	while (regm.codigo <> valoralto) do begin
		if (regm.stock >= 0) then
			write(newMae,regm);
	end;
	close(newMae);
	close(mae);
end;

var 
	newMae, mae : maestro;
	det : detalle;
BEGIN

	importarMae(mae);
	importarDet(det);
	writeln();
	writeln('comienza baja logica');
	bajaLogica(mae,det);
	maeActualizado(newMae,mae);

END.
