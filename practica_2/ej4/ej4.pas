
program ej4;
const valorAlto = 'zzzz';
type
	provincia = record
	nombre : string;
	alfabetizados : integer;
	encuestados : integer;
	end;
	
	regdet = record
	nombre : string;
	localidad : integer;
	alfabetizados : integer;
	encuestados : integer;
	end;
	
	maestro = file of provincia;
	detalle = file of regdet;
	
procedure leer (var det : detalle ; var regd : regdet);
begin
	if not eof(det) then
		read(det,regd)
	else
		regd.nombre := valorAlto;
end;

procedure minimo (var det1, det2 : detalle; var r1, r2, min : regdet);
begin
	if r1.nombre < r2.nombre then begin
		min := r1;
		leer(det1,r1);
	end
	else begin
		min := r2;
		leer(det2,r2);
	end;
end;

procedure actualizarMae (var mae : maestro ; var det1, det2 : detalle);
var
	regd1, regd2, min : regdet;
	regm : provincia;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1,regd1);
	leer(det2,regd2);
	minimo(det1,det2,regd1,regd2,min);
	while min.nombre <> valorAlto do begin
		read(mae,regm);
		while regm.nombre <> min.nombre do 
			read(mae,regm);
		while regm.nombre = min.nombre do begin
			regm.alfabetizados := regm.alfabetizados + min.alfabetizados;
			regm.encuestados := regm.encuestados + min.encuestados;
			minimo(det1,det2,regd1,regd2,min);
		end;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
		
	end;
	
	close(mae);
	close(det1);
	close(det2);
end;

var 
	mae : maestro;
	det1, det2 : detalle;

BEGIN
	assign(mae,'maestro');
	assign(det1,'detalle1');
	assign(det2,'detalle2');
	actualizarMae(mae,det1,det2);
	
END.

