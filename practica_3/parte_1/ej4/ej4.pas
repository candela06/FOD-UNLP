program ej4;
const valorAlto = 9999;
type
	reg_flor = record
	nombre: String[45];
	codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;

procedure agregarFlor (var arch : archivo; nueva : reg_flor);
var
	reg : reg_flor;
begin
	reset(arch);
	read(arch,reg);
	if reg.codigo = 0 then begin
		seek(arch,filesize(arch));
		write(arch,reg);
	end
	else begin
		seek(arch,reg.codigo * 1);
		read(arch,reg);
		seek(arch,filepos(arch)-1);
		write(arch,nueva);
		seek(arch,0);
		write(arch,reg);
	end;
end;

procedure listar (var arch : archivo);
var
	reg : reg_flor;
begin
	reset(arch);
	read(arch,reg);
	while not eof(arch) do begin
		if (reg.codigo > 0) then
			writeln('Codigo #',reg.codigo,', nombre: ',reg.nombre);
		read(arch,reg);
	end;
	close(arch);
end;
	
procedure eliminarFlor (var arch : archivo; flor : reg_flor);
var
	reg : reg_flor;
	cabecera : reg_flor;
	encontre : boolean;
begin
	encontre := false;
	reset(arch);
	read(arch,cabecera);	
	while not eof(arch) and not encontre do begin
		read(arch,reg);
		if (reg.codigo = flor.codigo) and (reg.nombre = flor.nombre) then begin
			encontre := true;
			seek(arch,filepos(arch)-1);
			write(arch,cabecera);
			cabecera.codigo := (filepos(arch)-1) * -1;
			seek(arch,0);
			write(arch,cabecera);
		end;
	end;
var
	arch : tArchFlores;
	flor : reg_flor
BEGIN
	assign(arch,'flores');
	//pedir flor...
	agregarFlor(arch,flor);
	listar(arch);
	//pedir flor...
	eliminarFlor(arch,flor);
END.
