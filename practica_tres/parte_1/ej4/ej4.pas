
program untitled;
const valorAlto = 9999;
type
	reg_flor = record
		nombre : string[45];
		codigo : integer;
	end;
	
	tArchFlores = file of reg_flor;


procedure leer (var arch : tArchFlores; var regf : reg_flor);
begin
	if (not (eof(arch))) then read(arch,regf)
	else
		regf.codigo := valorAlto;
end;

procedure leerFlor (var regf : reg_flor);
begin
	write('codigo: ');readln(regf.codigo);
	if regf.codigo <> -1 then begin
		write('nombre: ');readln(regf.nombre);
	end;
	writeln('____________________');
end;

procedure cargarListaInvertida ( var arch : tArchFlores);
var
	regf : reg_flor;
begin
	assign(arch,'flores.dat');
	rewrite(arch);
	regf.codigo := 0;
	write(arch,regf);
	
	leerFlor(regf);
	while (regf.codigo <> -1) do begin
			write(arch,regf);
			leerFlor(regf);
	end;
	close(arch);
end;

procedure agregarFlor (var a : tArchFlores; nombre : string; codigo : integer);
var
	indice, regf : reg_flor;
begin
	reset(a);
	leer(a,regf);
	if (regf.codigo < 0) then begin
		// busco el espacio libre y me llevo el indice
		seek(a,abs(regf.codigo));
		read(a,indice);
		
		// cargo la nueva flor en el espacio disponible
		regf.codigo := codigo;
		regf.nombre := nombre;
		seek(a,filepos(a)-1);
		write(a,regf);
		
		// escribo el indice al principio
		seek(a,0);
		write(a,indice);
	end
	else begin
		seek(a,filesize(a));
		regf.codigo := codigo;
		regf.nombre := nombre;
		write(a,regf);
	end;
		
	close(a);
end;

procedure listar ( var arch : tArchFlores; var txt : text);
var
	regf : reg_flor;
begin
	assign(txt,'flores.txt');
	rewrite(txt);
	reset(arch);
	while (not eof(arch)) do begin
		read(arch,regf);
		if (regf.codigo > 0) then 
			writeln(txt,regf.codigo,' ',regf.nombre);
	end;
	close(txt);
	close(arch);
end;

procedure eliminarFlor (var arch : tArchFlores; flor : reg_flor);
var
	aux : reg_flor;
	regf : reg_flor;
	encontre : boolean;
begin
	encontre := false;
	reset(arch);
	read(arch,aux);
	while (not eof(arch)) and (not encontre) do begin
		read(arch,regf);
		if (regf.codigo = flor.codigo) then begin
			encontre := true;
			seek(arch,filepos(arch)-1);
			write(arch,aux);
			aux.codigo := (filepos(arch)-1) * -1;
			seek(arch,0);
			write(arch,aux);
		end;
	end;
	if (not encontre) then writeln('flor no encontrada')
	else
		writeln('flor borrada');
	close(arch);
end;

var 
	arch : tArchFlores;
	flor : reg_flor;
	txt : text;
	op : byte;
BEGIN
	repeat 
		writeln('________________MENU________________');
		writeln('| 1: crear un archivo.');
		writeln('| 2: agregar una flor');
		writeln('| 3: eliminar una flor');
		writeln('| 4: exportar texto');
		writeln('| 5: salir');
		write('| :'); readln(op);
		writeln('____________________________________');
		case op of
			1:cargarListaInvertida(arch);
			2:begin
					leerFlor(flor);
					agregarFlor(arch,flor.nombre,flor.codigo);
				end;
			3:begin
					writeln('a continuación escriba los datos de la flor que desea eliminar...');
					writeln();
					leerFlor(flor);
					eliminarFlor(arch,flor);
				end;
			4:listar(arch,txt);
		end;
	until op = 5;
END.

