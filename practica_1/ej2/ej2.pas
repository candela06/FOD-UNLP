{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program ej2;
type
	archivo = file of integer;
var
	arch : archivo;
	num : integer;
BEGIN
	assign(arch,'numeros.dat');
	reset(arch);
	writeln('numeros menores a 1500');
	while not eof(arch) do begin
		read(arch,num);
		if num < 1500 then
			writeln(num);
	end;
END.
