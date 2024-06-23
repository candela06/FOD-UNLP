

program ej5;
const
	valorAlto = 9999;
	n = 3;
type
	producto = record
	codigo : integer;
	nombre : string;
	des : string;
	stockdis : integer;
	stockmin : integer;
	precio : rea;
	end;
	
	tdet = record
	codigo : integer;
	cantVendidas : integer;
	end;
	
	maestro = file of producto;
	detalle = file of tdet;
	ar_detalles = array [1..n] of detalle;
	ar_registros = array [1..n] of tdet;

procedure leer (var det : detalle; var regd : tdet);
begin
	if not eof(det) then
		read(det,regd)
	else
		regd.codigo := valorAlto;
end;

procedure minimo (var vdet : ar_detalles, var vreg : ar_registros; var min : tdet);
var
	i, j : integer;
begin
	min.codigo = valorAlto;
	for i:=1 to n do 
		if vreg[i].codigo < min.codigo then begin
			min := vreg[i];
			j := i;
		end;
	if min.codigo <> valorAlto then 
		leer(vdet[j],vreg[j]);
end;

procedure actualizarMae (var mae : maestro ; var vdet : ar_detalles; var vreg : ar_registros);
var
	cant, i : integer;
	min : tdet;
	regm : producto;
begin
	reset(mae);
	for i:=1 to n do begin
		assign(vdet[i],'det'+i);
		reset(vdet[i]);
		leer(vdet[i],vreg[i]);
	end;
	minimo(vdet,vreg,min);
	while min.codigo <> valorAlto do begin
		cod := min.codigo;
		cant := 0;
		while min.codigo = cod do begin
			cant := cant + min.cantVendidas;
			minimo(vdet,vreg,min);
		end;
		read(mae,regm);
		while regm.codigo <> cod do 
			read(mae,regm);
		regm.stockdis := regm.stockdis - cant;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
	end;
	
	for i:= 1 to n do
		close(vdet[i]);
	close(mae);
	
end;

procedure detallar (var mar : maestro; var txt : text);
var
	regm : producto;
begin
	reset(mae);
	rewrite(txt);
	read(mae,regm);
	while not eof(mae) do begin
		with regm do begin
			if stockdis < stockmin then
				writeln(txt,nombre,' ',des,' ',stockdis,' ',precio);
		end;
		read(mae,regm);
	end;
	close(mae);
	close(txt);
end;

var 
	mae : maestro;
	vdet : ar_detalles;
	vreg : ar_registros;
	txt : text;
BEGIN
	assign(mae,'maestro');
	assign(txt,'maestro.txt');
	actualizarMae(mae,vdet,vreg);
	detallar(mae,txt);
	
END.

