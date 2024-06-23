

program untitled;
const
	valorAlto = 9999;
type
	
	producto = record
	codigo : integer;
	nombre : string;
	precio : real;
	stockact : integer;
	stockmin : integer;
	end; 
	
	venta = record
	codigo : integer;
	cantuni : integer; // cantidad de unidades vendidas
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	
procedure leerDet (var det : detalle ; var regd : venta);
begin
	if not eof(det) then
		read(det,regd)
	else
		regd.codigo := valorAlto;
end;

procedure leerMae (var mae : maestro ; var regm : producto);
begin
	if not eof(mae) then
		read(mae,regm)
	else
		regm.codigo := valorAlto;
end;
	
procedure actualizarMae (var mae : maestro; var det : detalle);
var
	regm : producto;
	regd : venta;
	cod : integer;
	cant : integer;
begin
	reset(mae);
	reset(det);
	leerDet(det,regd);
	while (regd.codigo <> valorAlto) do begin
		cod := regd.codigo;
		cant := 0;
		while (regd.codigo = cod) do begin
			cant := cant + regd.cantuni;
			leerDet(det,regd);
		end;
		leerMae(mae,regm);
		while (regm.codigo <> cod) do  //asumimos que existe el producto
			leerMae(mae,regm);
		regm.stockact := regm.stockact - cant;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
	end;
	
	close(mae);
	close(det);
end;

procedure detallar (var mae : maestro);
var
	regm : producto;
	txt : text;
begin
	assign(txt,'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	leerMae(mae,regm);
	while (regm.codigo <> valorAlto) do begin
		with regm do 
			if stockact < stockmin then
				writeln(txt,codigo,' ',nombre,' ',nombre,' ',precio:10:2,' ',stockact,' ',stockmin);
		leerMae(mae,regm);
	end;
end;

var 
	mae : maestro;
	det : detalle;

BEGIN
	assign(mae,'maestro');
	assign(det,'detalle');
	actualizarMae(mae,det);
	detallar(mae);
END.

