

program untitled;
const valorAlto = 9999;
type
	asistente = record
		numero : integer;
		nombre : string[20];
		end;
	archivo = file of asistente;

procedure leerReg (var a : asistente);
begin
	write('numero: ');readln(a.numero);
	if a.numero <> -1 then begin
		write('nombre: '); readln(a.nombre);
	end;
	writeln();

end;

procedure cargar (var arch : archivo);
var asis : asistente;
begin
	assign(arch,'asistentes');
	rewrite(arch);
	leerReg(asis);
	while (asis.numero <> -1) do begin
		write(arch,asis);
		leerReg(asis);
	end;
	close(arch);
end;

procedure leer (var arch : archivo; var reg : asistente);
begin
	if (not (eof(arch))) then read(arch,reg)
	else reg.numero := valorAlto;
end;

procedure bajaLogica (var arch : archivo);
var	reg : asistente;
begin
		writeln('comienza baja logica...');
	reset(arch);
	leer(arch,reg);
	while (reg.numero <> valorAlto) do begin
		if (reg.numero < 1000) then begin
			reg.nombre := '@' + reg.nombre;
			seek(arch,filepos(arch)-1);
			write(arch,reg);
		end;
		leer(arch,reg);
	end;
	close(arch);
end;

procedure imprimir (var arch : archivo);
var reg : asistente;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,reg);
		writeln(reg.nombre,', numero: ',reg.numero);
		writeln('--------------------');
	end;
	close(arch);
end;
var arch : archivo;

BEGIN
	cargar(arch);
	bajaLogica(arch);
	imprimir(arch);
	
END.

