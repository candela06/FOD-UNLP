{
  Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. 
   
   
}


program ejercicio1;

uses crt;

type
	archivo = file of integer;

//procesos

procedure asignar(var enteros:archivo);
var ruta: string[12];
begin
	write('Ingrese nombre de la ruta: ');
	readln(ruta);
	assign(enteros,ruta);
end;

procedure cargar( var enteros:archivo);
var num: integer;
begin

	rewrite(enteros); //abro el nuevo archivo !
	write('Ingrese un numero entero (30000 para finalizar): ');
	readln(num);
	while num<>30000 do begin
		write(enteros,num);
		readln(num);
	end;
	close(enteros); //cierro el nuevo archivo !
end;

procedure leer (var enteros:archivo);
var num: integer;
begin
	writeln('los numeros guardados fueron: ');
	reset(enteros); //abro el archivi para lectura
	while not eof(enteros) do begin
		read(enteros,num);
		writeln(num);
	end;
end;


var
	enteros: archivo;

// programa princial
BEGIN
	asignar(enteros);
	cargar(enteros);
	leer(enteros);
	
END.

