


program untitled;
const
	valorAlto = 9999;
	n = 5;
type
	tdet = record
	codigo : integer;
	fecha : string;
	tiempo_sesion : real;
	end;
	
	tmae = record
	codigo : integer;
	fecha : string;
	tiempo_total : real;
	end;
	
	maestro = file of tmae;
	detalle = file of tdet;
	ar_detalles = array [1..n] of detelle;
	ar_registros = array [1..n] of tdet;

procedure leer (var det : detalle ; var regd : tdet);
begin
	if not eof(det) then
		read(det,regd)
	else
		regd.codigo := valorAlto;
end;

procedure minimo (var vdet : ar_detalles; var vreg : ar_registros; var min : tdet);
var
	i, j : integer;
begin
	min.codigo := valorAlto;
	min.fecha := 'zzzz';
	j := 0;
	for i:=1 to n do 
		if (vreg[i].codigo < min.codigo) or ((vreg[i].codigo = min.codigo) and (vreg[i].fecha < min.fecha)) then begin
			min = vreg[i];
			j:=i;
		end;
	
	if min.codigo <> valorAlto then 
		leer(vdet[j],vreg[j]);
end;

procedure crearMae(var mae : maestro ; var vdet : ar_detalles);
var
	min : tdet;
	regm : tmae;
	t, cod : integer;
	f : string;
begin
	for i:=1 to n do begin
		assign(vdet[i],'det'+i);
		reset(vdet[i]);
		leer(vdet[i],vreg[i]);
	end;
	minimo(vdet,vreg,min);
	while min.codigo <> valorAlto do begin
		cod := min.cod;
		while min.codigo = cod do begin
			f := min.fecha;
			t := 0;
			while (min.codigo = cod) and (min.fecha = f) do begin
				t := t + min.tiempo_sesion;
				minimo(vdet,vreg,min);
			end;
			regm.codigo := cod;
			regm.fecha := f;
			regm.tiempo_total := t;
			write(mae,regm);
		end;
		
	end;
	for i:=1 to n do
		close(vdet[i]);
	close(mae);
	
end;

var 
	mae : maestro;
	vdet : ar_detalles;

BEGIN
	assign(mae,'/var/log');
	crearMae(mae,vdet);
END.

