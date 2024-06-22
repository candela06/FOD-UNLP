{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.}

program ej5;
const valorAlto = 9999;
type
	celular = record
		cod : integer;
		nombre : string[10];
		des : string[20];
		marca : string[20];
		precio : real;
		stockMin : integer;
		stockDis : integer;
	end;
	
	archivo = file of celular;

procedure menu (var op : byte);
begin
	writeln('------------------------------------------------');
	writeln('|1 crear archivo bin.');
	writeln('|2 listar celulares con poco stock');
	writeln('|3 listar celulares con determianda descripcion.');
	writeln('|4 Exportar archivo de texto.');
	writeln('|5 salir.');
	write('| opción: '); readln(op);
	writeln('------------------------------------------------');
end;

{En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden.}
procedure crear (var arch : archivo; var txt : Text);
var
	reg : celular;
begin
	reset(txt);
	rewrite(arch);
	while not eof(txt) do begin
		with reg do begin
			readln(txt,cod,precio,marca);
			readln(txt,stockDis,stockMin,des);
			readln(txt,nombre);
		end;
		write(arch,reg);
	end;
	close(txt);
	close(arch);
end;

procedure leer (var arch : archivo ; var reg : celular);
begin
	if not eof(arch) then
		read(arch,reg)
	else
		reg.cod := valorAlto;
end;

procedure imprimir (reg : celular);
begin
	with reg do begin
		writeln('|CODIGO: ',cod,' |PRECIO: $',precio,' |MARCA: ',marca);
		writeln('STOCK DISPONIBLE: ',stockDis,' |STOCK MINIMO: ',stockMin,' |DESCRIPCION: ',des);
		writeln('|NOMBRE: ',nombre);
		writeln();
	end;
end;

{Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo}
procedure stockDisMenorAStockMin (var arch : archivo);
var
	reg : celular;
begin
	reset(arch);
	leer(arch,reg);
	while (reg.cod <> valorAlto) do begin
		if reg.stockDis < reg.stockMin then
			imprimir(reg);
		leer(arch,reg);
	end;
	close(arch);
end;


//Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
procedure buscarDes (var arch : archivo);
var
	reg : celular;
	aux : string[20];
begin
	write('descripcion: '); readln(aux);
	aux := '  ' + aux;
	reset(arch);
	leer(arch,reg);
	while (reg.cod <> valorAlto) do begin
		if reg.des = aux then 
			imprimir(reg);
		leer(arch,reg);
	end;
	close(arch);
end;


// Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.
procedure exportarTxt (var arch : archivo);
var
	reg : celular;
	txt : Text;
begin
	assign(txt,'celulares.txt');
	rewrite(txt);
	reset(arch);
	leer(arch,reg);
	while reg.cod <> valorAlto do begin
		with reg do begin
			writeln(txt,cod,' ',precio:10:2,' ',marca);
			writeln(txt,stockDis,' ',stockMin,' ',des);
			writeln(txt,nombre);
		end;
		leer(arch,reg);
	end;
	close(txt);
	close(arch);
end;

var
	txt : Text;
	arch : archivo;
	op : byte;
BEGIN
	assign(txt,'celulares.txt');
	assign(arch,'celulares.dat');
	repeat
		menu(op);
		case op of
			1: crear(arch,txt);
			2: stockDisMenorAStockMin(arch);
			3: buscarDes(arch);
			4: exportarTxt(arch);
		end;
	until op = 5;

END.
