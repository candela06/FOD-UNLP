
program ej1;
const valorAlto = 9999;
type
	ingreso = record
	codigo : integer;
	nombre : string;
	monto : real;
	end;
	
	archivo = file of ingreso;
procedure leer (var arch : archivo ; var reg : ingreso);
begin
	if not eof(arch) then
		read(arch,reg)
	else
		reg.codigo := valorAlto;
end;
procedure compactar (var detalle : archivo ; var maestro : archivo);
var
	regd : ingreso;
	regm : ingreso;
begin
	reset(detalle);
	assign(maestro,'CompactedFile.dot');
	rewrite(maestro);
	leer(detalle,regd);
	while (regd.codigo <> valorAlto) do begin
		regm.codigo := regd.codigo;
		regm.nombre := regd.nombre;
		regm.monto := 0;
		while (regd.codigo = regm.codigo) do begin
			regm.monto := regm.monto + regd.monto;
			leer(detalle,regd);
		end;
		write(maestro,regm);
	end;
	close(detalle);
	close(maestro);
end;

var 
	arch : archivo;
	compacted_file : archivo;
BEGIN
	assign(arch,'comisiones.dot');
	compactar(arch,compacted_file);
END.

