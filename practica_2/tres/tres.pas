
program untitled;
const valoralto = 9999;
type
	producto = record
		codigo : integer;
		pu : integer;
		stockAct : integer;
		stockMin : integer;
		nombre :string[20];
		end;
	
	venta = record
		codigo : integer;
		cantU : integer;
		end;
	
	maestro = file of producto;
	detalle = file of venta;

procedure importarMae (var mae : maestro);
var txt : text;
		p : producto;
begin
	assign(txt,'maestro.txt');
	assign(mae,'maestro.dat');
	reset(txt);
	rewrite(mae);
	while not eof(txt) do begin
		with p do begin
			readln(txt,codigo,pu,stockAct,stockMin);
		end;
		write(mae,p);
	end;
	close(txt);
	close(mae);
end;

procedure importarDet (var det : detalle);
var txt : text;
		v : venta;
begin
	assign(txt,'detalle.txt');
	assign(det,'detalle.dat');
	reset(txt);
	rewrite(det);
	while not eof(txt) do begin
		with v do begin
			readln(txt,codigo,cantU);
		end;
		write(det,v);
	end;
	close(txt);
	close(det);
end;

procedure leer ( var det : detalle; var regd : venta );
begin
	if (not(eof(det))) then read(det,regd)
	else regd.codigo := valoralto;
end;

procedure actualizarMaestro (var mae : maestro; var det : detalle);
var	regd : venta;
		regm : producto;
begin
	reset(mae);
	reset(det);
	// leo la venta
	leer(det,regd);
	// mientras no sea fin de archivo (no hay más ventas)...
	while regd.codigo <> valoralto do begin
		// leo el producto
		read(mae,regm);
		// busco el producto
		while (regm.codigo <> regd.codigo) do 
			read(mae,regm);
		// mientras sea la venta del mismo producto
		while (regm.codigo = regd.codigo) do begin
			// modifico el stock
			regm.stockAct := regm.stockAct - regd.cantU;
			// leo la siguiente venta
			leer(det,regd);
		end;
		
	end;
	close(mae);
	close(det);
end;

procedure listar (var mae : maestro; var txt : text);
var regm : producto;
begin
	assign(txt,'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	while not eof(mae) do begin
		read(mae,regm);
		if (regm.stockAct < regm.stockMin) then begin
			with regm do begin
				writeln(txt,codigo,' ',pu,' ',stockAct,' ',stockMin,' ',nombre);
			end;
		end;
	end;
	close(mae);
	close(txt);
	
end;
var mae : maestro;
		det : detalle;
		txt : text;
BEGIN
	importarMae(mae);
	importarDet(det);
	listar(mae,txt);
END.

