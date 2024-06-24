program ej7;
const
	valorAlto = 9999;
	n = 10;
type
	casosCovid = record
	activos : integer;
	nuevos : integer;
	recuperados : integer;
	fallecidos : integer;
	end;
	
	tdet = record
	localidad : integer;
	cepa : integer;
	casos : casosCovid;
	end;
	
	tmae = record
	codloc : integer;
	nomloc : string;
	codcepa : integer;
	nomcepa : string;
	casos : casosCovid;
	end;
	
	maestro = file of tmae;
	detalle = file of tdet;
	ar_det = array [1..n] of detalle;
	ar_reg = array[1..n]of tdet;

procedure actualizarMae (var mae : maestro; var vdet : ar_det; var vreg : ar_reg);
var
	min : tdet;
	regm : tmae;
	casosTotales, loc, i : integer;
	casos : casosCovid;

begin
	reset(mae);
	for i:=1 to n do begin
		assign(vdet[i],'det'+i);
		reset(vdet[i]);
		leer(vdet[i],vreg[i]);
	end;
	minimo(vdet,vreg,min);
	while min.localidad <> valorAlto do begin
		casosTotales := 0;
		min.localidad := loc;
		while min.localidad = loc do begin
			cepa := min.cepa;
			casos.fallecidos:=0;
			casos.recuperados:=0;
			casos.activos :=0;
			casos.nuevos := 0;	
			while (min.localidad = loc) and (min.cepa = cepa) do begin
				casos.fallecidos += min.casos.fallecidos;
				casos.recuperos += min.casos.recuperados;
				casos.activos += min.casos.activos;
				casos.nuevos += min.casos.nuevos; 
				minimo(vdet,vreg,min);
			end;
			read(mae,regm);
			while (regm.codloc <> loc) or (regm.codcepa <> cepa) do 
				read(mae,regm);
			
			regm.casos.fallecidos += casos.fallecidos;
			regm.casos.recuperados += casos.recuperados;
			regm.casos.activos := casos.activos;
			regm.casos.nuevos := casos.nuevos;
			casosTotales := casos.activos;
			seek(mae,filepos(mae)-1);
			write(mae,regm);
		end;
	end;
	
	
end;
	
var
	mae : maestro;
	vdet : ar_det;
	vreg : ar_reg;
BEGIN
	assign(mae,'maestro');
	actualizarMae(mae,tdet,vreg);
END.
