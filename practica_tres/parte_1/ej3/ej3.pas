
program untitled;
const valorAlto = 9999;
type
	novela = record
		codigo : integer;
		precio : real;
		duracion : real;
		gen : string[20];
		nombre : string[20];
		director : string[20];
	end;
	archivo = file of novela;

procedure leerNov (var nov : novela);
begin
	with nov do begin
		write('codigo : ');readln(codigo);
		if codigo <> -1 then begin
			write('precio: $');readln(precio);
			write('duracion: ');readln(duracion);
			write('genero: ');readln(gen);
			write('nombre: ');readln(nombre);
			write('director: ');readln(director);
		end;
		writeln();
	end;
end;
procedure crearListaInvertida (var arch : archivo);
var
	nov : novela;
begin
	assign(arch,'novelas');
	rewrite(arch);
	nov.codigo := 0;
	
	write(arch,nov);
	leerNov(nov);
	while nov.codigo <> -1 do begin
		write(arch,nov);
		leerNov(nov);
	end;
	close(arch);
end;

procedure leer (var arch : archivo; var nov : novela);
begin
	if (not (eof(arch))) then read(arch,nov)
	else nov.codigo := valorAlto;
end;

procedure darDeAlta (var arch : archivo);
var	
	indice, nov : novela;
begin
	reset(arch);
	leer(arch,nov);
	
	if (nov.codigo < 0) then begin // si es 0, no hay espacios libres
		// voy a la posición con el espacio libre
		seek(arch,abs(nov.codigo));
		// leo el próximo indice 
		read(arch,indice);
		
		// ubico la nueva novela en la posición libre
		leerNov(nov);
		seek(arch,filepos(arch)-1);
		write(arch,nov);
		
		// vuelvo a la cabecera y reescribo el indice
		seek(arch,0);
		write(arch,indice);
	end
	else begin
		// caso contrario agrego al final del archivo
		seek(arch,filesize(arch));
		leerNov(nov);
		write(arch,nov);
	end;
	
	close(arch);
end;



procedure modificar (var arch : archivo);
	procedure modificarNov (var nov : novela);
	var opc : byte;
	begin
		writeln('__________MENU DE OPCIONES A MODIFICAR__________');
		writeln('| 1: duracion.');
		writeln('| 2: precio.');
		writeln('| 3: genero.');
		writeln('| 4: nombre.');
		writeln('| 5: director.');
		write('| :'); readln(opc);
		writeln('________________________________________________');
		case opc of
			1:begin
					write('nueva duracion: ');readln(nov.duracion);
				end;
			2:begin
					write('nuevo precio: ');readln(nov.precio);
				end;
			3:begin
					write('nuevo genero: ');readln(nov.gen);
				end;
			4:begin
					write('nuevo nombre: ');readln(nov.nombre);
				end;
			5:begin
					write('nuevo director: ');readln(nov.director);
				end;
	end;
end;
var
	cod : integer;
	encontre : boolean;
	nov : novela;
begin
	encontre := false;
	write('codigo: ');readln(cod);
	reset(arch);
	leer(arch,nov);
	while (nov.codigo <> valorAlto) and (not encontre) do begin
		if (nov.codigo = cod) then begin
			encontre := true;
			modificarNov(nov);
			seek(arch,filepos(arch)-1);
			write(arch,nov);
		end;
		leer(arch,nov);
	end;
	writeln();
	
	if not encontre then 
		writeln('la novela no existe')
	else 
		writeln('registro modificado');
	close(arch);
end;

procedure eliminar (var arch : archivo);
var indice, nov : novela;
		cod : integer;
		encontre : boolean;
		
begin
	encontre := false;
	write('codigo: ');readln(cod);
	reset(arch);
	leer(arch,nov);
	indice.codigo := nov.codigo;
	while (nov.codigo <> valorAlto) and (not encontre) do begin
		if (nov.codigo = cod) then begin
			encontre := true;
			// copio el indice en el registro a eliminar
			nov.codigo := indice.codigo;
			seek(arch,filepos(arch)-1);
			// indice en negativo
			indice.codigo := filepos(arch) * -1;
			write(arch,nov);
			// reemplazo el nuevo indice
			seek(arch,0);
			write(arch,indice);
		end
		else leer(arch,nov);
	end;
	
	writeln();
	if not encontre then 
		writeln('la novela no existe')
	else
		writeln('la novela fue eliminada');
	close(arch);
end;

procedure listarTxt (var arch : archivo);
var nov : novela;
		txt : text;
begin
	assign(txt,'novelas.txt');
	rewrite(txt);
	reset(arch);
	while not eof(arch) do begin
		read(arch,nov);
		if (nov.codigo > 0) then begin
			with nov do begin
				writeln(txt,codigo,' ',precio:0:2,' ',nombre);
				writeln(txt,gen);
			end;
		end
		else
			writeln(txt,'espacio libre');
	end;

	close(arch);
	close(txt);
end;
var
	arch : archivo;
	op : byte;
 
BEGIN
	repeat 
		writeln('________________MENU________________');
		writeln('| 1: crear un archivo.');
		writeln('| 2: dar de alta una novela.');
		writeln('| 3: modificar datos.');
		writeln('| 4: eliminar una novela.');
		writeln('| 5: exportar txt.');
		writeln('| 6: salir.');
		write('| :'); readln(op);
		writeln('____________________________________');
		case op of
			1:crearListaInvertida(arch);
			2:darDeAlta(arch);
			3:modificar(arch);
			4:eliminar(arch);
			5:listarTxt(arch);
		end;
	until op = 6;
	
END.

