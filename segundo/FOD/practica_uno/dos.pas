{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
   
}


program untitled;
const
	numMenor = 1500;
type
	archivo = file of integer;

// procesos...

procedure asignar ( var enteros: archivo);
var ruta: string[12];
begin
	write('ruta de archivo: ');
	readln(ruta);
	assign(enteros,ruta);
end;

procedure recorrer (var enteros: archivo; var menores: integer; var promedio: real);
var num,suma: integer; 
begin
	suma := 0;
	reset(enteros);
	while not eof(enteros) do begin
		read(enteros,num);
		if (num < numMenor) then menores := menores + 1;
		suma := suma + num;
	end;
	promedio := suma / fileSize(enteros);
	close(enteros);
end;

procedure leer( var enteros: archivo);
var num: integer;
begin
	writeln('---------- NUMEROS ----------');
	reset(enteros);
	while not eof(enteros) do begin
		read(enteros,num);
		writeln(num);
	end;
	close(enteros);
end;
var enteros: archivo;
		menores: integer;
		promedio: real;

BEGIN
	menores := 0;
	promedio := 0;
	
	asignar(enteros);
	recorrer(enteros,menores,promedio);
	leer(enteros);
	
	writeln();
	writeln(' -------------------------');
	writeln('|PROMEDIO: ',promedio:0:2,'        |');
	writeln('|NUMEROS MENORES A 1500: ',menores,'|');
	writeln(' -------------------------');

END.

