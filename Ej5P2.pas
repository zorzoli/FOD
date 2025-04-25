{5. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program ej5;
const
	valorAlto = 9999;
	cant = 5;
type
	sesion = record
		cod,dia: integer;
		tiempo: real;
	end;
	archivo = file of sesion;
	vArchivos = array [1..cant] of archivo;
	vSesiones = array [1..cant] of sesion;
	
procedure cargarUsuarios (var u: archivo);
var
	s: sesion;
begin
	s.cod:= random(cant) +1;
	s.dia:= random(31) + 1;
	s.tiempo:= (random(23) + 1);
	write (u,s);
end;
	
procedure crearUsuarios (var vu: vArchivos);
type
	listaNombres = ^nodo;
	nodo = record
		dato: string;
		sig: listaNombres;
	end;
var
	i: integer;
	l: listaNombres;
begin
	crearListaNombres (l);
	for i:= 1 to cant do begin
		if (l <> nil) then begin
			assign (vu[i],l);
			rewrite (vu[i]);
			cargarUsuarios (vu[i])
			close (vu[i]);
			l:= l^.sig;
		end
		else
			assign (vu[i],'ArchSinNombre');
	end;

end;
procedure leer (var arch: archivo; var s: sesion);
begin
	if (EOF(arch)) then
		s.cod:= valorAlto;
	else
		read (arch,s);

end;

procedure abrirArchivos (var vu: vArchivos; var vs: vSesiones);
var
	i: integer;
begin
	for i:= 1 to cant do begin
		reset (vu[i]);
		leer (vu[i],vs[i])
	end;
end;

procedure minimo (var vu: vArchivos; var vs: vsesiones; var min: sesion);
var
	i,pos: integer;
begin
	min.cod:= valorAlto;
	for i:= 1 to cant do begin
		if (vs[i].cod < min.cod) or (vs[i].cod <> valorAlto) and (vs[i].cod = min.cod) and (vs[i].dia < min.dia) then
			min:= vs[i];
			pos:= i;
	end;
	if (min.cod <> valorAlto) then begin
		leer (vu[pos],vs[pos])
	end;
end;

procedure cerrarArchivos (var vu: vArchivos);
var
	i: integer;
begin
	for i:= 1 to cant do 
		close (vu[i]);
end;

procedure crearMaestro (var mae: maestro; vArchivos: vectorArchivos)
var
	nombre: string;
	min,regMae: sesion;
	vSesiones: vectorSesiones;
begin
	writeln ('Ingrese un nombre para su archivo maestro'); readln (nombre);
	assign (mae,nombre);
	rewrite (mae);
	abrirArchivos (vArchivos,vSesiones);
	minimo (vArchivos,vSesiones,min);
	while (min.cod <> valorAlto) do begin
		regMae.cod:= min.cod;
		regMae.tiempo:= 0;	
		while (regMae.cod = min.cod) do begin
			regMae.dia:= min.dia;
			regMae.tiempo:= regMae.tiempo + min.tiempo;
			minimo (vu,vs,min);
		end;
		write (mae,regMae);
	end;
	end;
	cerrarArchivos (vArchivos);
	close (mae);
end;

var
	mae: archivo;
	vu: vArchivos;
begin
	Randomize();
	crearUsusarios(vu);
	crearMaestro (mae,vu);
end.
