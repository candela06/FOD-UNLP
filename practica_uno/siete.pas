

program untitled;
type
	novela = record
		codigo: integer;
		nombre: string[20];
		genero: string[20];
		precio: real;
		end;
	archivo = file of novela;
		
procedure menu ( var op : char);
begin
	writeln(' ---------- | M E N U | ----------');
	writeln('| a) crear un archivo de texto    |');
	writeln('| b) otro                         |');
	writeln('| c) exit                         |');
	write('| :'); readln(op);
	if op = 'b' then begin
		writeln(' --------------------------------');
		writeln('| d) crear un archivo binario     |');
		writeln('| e) actualizar archivo           |');
		write('| :'); readln(op);
		if op = 'e' then begin
			writeln(' --------------------------------');
			writeln('| f) agregar una novela nueva     |');
			writeln('| g) modificar una novela         |');
			write('| :'); readln(op);
			writeln(' --------------------------------');
		end;
	end; 
	writeln();
end;

procedure imprimirNovela ( n : novela );
begin
	writeln(n.nombre,', ',n.genero);
	writeln('$',n.precio);
	writeln('----------------------------');
end;
procedure imprimir ( var novelas : archivo );
var n : novela;
begin
	reset(novelas);
	while not eof(novelas) do begin
		read(novelas,n);
		imprimirNovela(n);
	end;
	writeln();
	close(novelas);
end;

procedure leer ( var n : novela);
begin
	with n do begin
		write('codigo: '); readln(codigo);
		if codigo <> -1 then begin
			write('nombre: ');readln(nombre);
			write('genero: ');readln(genero);
			write('precio: ');readln(precio);
		end;
	end;
	writeln();
end;

procedure cargar ( var txt : Text);
var n: novela;
begin
	writeln('Iniciando carga...');
	writeln();
	
	rewrite(txt);
	leer(n);
	while n.codigo <> -1 do begin
		with n do begin
			writeln(txt,codigo,' ',precio,' ',genero);
			writeln(txt,nombre);
		end;
		leer(n);
	end;
	writeln();
	close(txt);
end;

procedure exportarBin ( var txt : Text; var novelas : archivo);
var ruta : string[12];
		n : novela;
begin
	write('| ruta: '); read(ruta); writeln(' creando...');
	assign(novelas,ruta);
	rewrite(novelas);
	reset(txt);
	while not eof(txt) do begin 
		with n do begin
			readln(txt,codigo,precio,genero);
			readln(txt,nombre);
		end;
		write(novelas,n);
	end;
	writeln('archivo creado !');
	writeln();
	close(txt);
	close(novelas);
	
end;

procedure agregar ( var novelas : archivo );
var	n : novela;
begin
	leer(n);
	reset(novelas);
	seek(novelas,filesize(novelas)); // final del archivo
	write(novelas,n);
	writeln('novela agregada con exito !');
	writeln();
	close(novelas);
end;

procedure modificar ( var novelas : archivo );
var n : novela;
		aux : integer; 
		newCost : real;
		encontre : boolean;
begin
	encontre := false;
	write('| codigo: ');readln(aux);
	write('| nuevo precio: ');read(newCost);
	reset(novelas);
	while (not eof(novelas)) and (not encontre) do begin
		read(novelas,n);
		if n.codigo = aux then begin
			encontre := true;
			n.precio := newCost;
			seek(novelas,filepos(novelas)-1);
			write(novelas,n);
		end;
	end;
	if not encontre then writeln('no se encontraron coincidencias')
	else writeln('precio modificado exitosamente !');
	writeln();	
	close(novelas);
end;



var i : char;
		novelas : archivo;
		txt : Text;

BEGIN
	repeat
		menu(i);
		case i of
		'a':begin
					assign(txt,'novelas.txt');
					cargar(txt);
			end;
		'd':exportarBin(txt,novelas);
		'f':agregar(novelas);
		'g':modificar(novelas);
		end;
	until i = 'c';
	
	imprimir(novelas);
END.

