
program untitled;
type
	celular = record
		stockMin, stockDis, precio, codigo: integer;
		marca, desc, nombre: string[20];
		end;
	archivo = file of celular;
	
// procesos
procedure asignar ( var celulares: archivo);
var ruta: string[12];
begin
	write('ruta: ');readln(ruta);
	assign(celulares,ruta);
end;

procedure cargar ( var txt: Text);
	procedure leer ( var c: celular);
	begin
		with c do begin
			write('codigo: ');readln(codigo);
			if codigo <> 999 then begin
				write('nombre: ');readln(nombre);
				write('marca: ');readln(marca);
				write('precio: ');readln(precio);
				write('stock disponible: ');readln(stockDis);
				write('stock minimo: ');readln(stockMin);
				write('descripcion: ');readln(desc);
			end;
		end;
	end;
var
	c: celular;
begin
	assign(txt,'celulares.txt');
	rewrite(txt);
	leer(c);
	while c.codigo <> 999 do begin
		with c do begin
			writeln(txt,codigo,' ',precio,' ',marca);
			writeln(txt,stockDis,' ',stockMin,' ',desc);
			writeln(txt,nombre);
		end;
		leer(c);
	end;
	
end;

procedure cargarBin ( var txt: Text; var celulares: archivo);
var
	c:celular;
begin
	writeln('importando...');
	assign(celulares,'celulares');
	rewrite(celulares);
	reset(txt);
	while not eof(txt) do begin
		with c do begin
			readln(txt,codigo,precio,marca);
			readln(txt,stockDis,stockMin,desc);
			readln(txt,nombre);
		end;
		write(celulares,c);
	end;
	writeln('importación exitosa!');
	
	close(txt);
	close(celulares);
end;

procedure imprimirCel ( var c: celular);
begin
	with c do begin
		writeln(marca,' ',nombre,', $',precio);
		writeln('--------------------');
	end;
end;

procedure stockMinimo ( var celulares: archivo);
var c: celular;
begin
	writeln('celulares con menor stock dispoble al minimo...');
	writeln();
	reset(celulares);
	while not eof(celulares) do begin
		read(celulares,c);
		if c.stockDis < c.stockMin then imprimirCel(c);
	end;
	close(celulares);
end;

procedure imprimirDescripcion ( var celulares: archivo);
var aux:string[20]; c: celular;
begin
	write('descripcion a buscar: '); readln(aux);
	writeln();
	writeln('buscando...');
	reset(celulares);
	while not eof(celulares) do begin
		read(celulares,c);
		if c.desc = aux then imprimirCel(c);
	end;
	close(celulares);
end;

procedure exportartxt ( var celulares: archivo);
var
	c:celular;
	texto: Text;
begin
	assign(texto,'celulares.txt');
	rewrite(texto);
	reset(celulares);
	while not eof(celulares) do begin
		read(celulares,c);
		with c do begin
			writeln(texto,codigo,' ',precio,' ',marca);
			writeln(texto,stockDis,' ',stockMin,' ',desc);
			writeln(texto,nombre);
		end;
	end;
	writeln('carga exitosa...');
	close(celulares);
	close(texto);
end;
  
var 
	op : byte;
	celulares: archivo;
	txt: Text;
BEGIN
	asignar(celulares);
	repeat
		writeln();
		writeln('--------- | MENU | ---------');
		writeln('| 1) crear un archivo de celulares.');
		writeln('| 2) celulares con stock menor al minimo.');
		writeln('| 3) imprimir por descripcion');
		writeln('| 4) exportar txt');
		writeln('| 5) salir.');
		writeln('| OPCION: '); readln(op);
		writeln('----------------------------');
		writeln();
		case op of
			1: begin
					cargar(txt);
					cargarBin(txt,celulares);
				end;
			2: stockMinimo(celulares);
			3: imprimirDescripcion(celulares);
			4: exportartxt(celulares);
		end;
	until op = 5;
	asignar(celulares);

	
END.

