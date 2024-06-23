
program untitled;
const valorAlto = 9999;
type
	alumno = record
	codigo : integer;
	apellido : string;
	nombre : string;
	materiasSinFinal : integer;
	materiasConFinal : integer;
	end;
	
	regdet = record
	codigo : integer;
	materiaAprobada : byte;
	end;
	
	archivoMae = file of alumno;
	archivoDet = file of regdet;
	
procedure leerDet (var det : archivoDet ; var regd : regdet);
begin
	if not eof(det) then
		read(det,regd)
	else
		regd.codigo := valorAlto
end;

procedure leerMae (var mae : archivoMae ; var regm : alumno);
begin
	if not eof(mae) then
		read(mae,regm)
	else
		regm.codigo := valorAlto
end;

procedure actualizarMae (var mae : archivoMae ; var det : archivoDet);
var
	regm : alumno;
	regd : regdet;
	cod : integer;
	conFinal : integer;
	sinFinal : integer;
begin
	reset(mae);
	reset(det);
	leerDet(det,regd);
	while (regd.codigo <> valorAlto) do begin
		cod := regd.codigo;
		conFinal := 0;
		sinFinal := 0;
		while (regd.codigo = cod) do begin
			if regd.materiaAprobada = 0 then 
				conFinal := conFinal + 1
			else
				sinFinal := sinFinal + 1;
			leerDet(det,regd);
		end;
		leerMae(mae,regm);
		while (regm.codigo <> valorAlto) and (regm.codigo <> cod) do
			leerMae(mae,regm);
		
		// suponiendo que existe el alumno
		regm.materiasSinFinal := regm.materiasSinFinal + sinFinal - conFinal;
		regm.materiasConFinal := regm.materiasConFinal + conFinal;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
	end;	
	close(mae);
	close(det);
end;

procedure detallar (var mae : archivoMae);
var
	regm : alumno;
	txt : text;
begin
	assign(txt,'masFinales.txt');
	rewrite(txt);
	reset(mae);
	leerMae(mae,regm);
	while (regm.codigo <> valorAlto) do begin
		if (regm.materiasConFinal > regm.materiasSinFinal) then
			with regm do 
				writeln(txt,'CODIGO ',codigo,', ',nombre,' ',apellido,' CURSADAS APROBADAS: ',materiasSinFinal,', MATERIAS APROBADAS: ',materiasConFinal);
		leerMae(mae,regm);
	end;
	
	close(mae);
	close(txt);
end;

var 
	mae : archivoMae;
	det : archivoDet;
BEGIN
	assign(mae,'maestro');
	assign(det,'detalle');
	actualizarMae(mae,det);
	detallar(mae);
	
END.

