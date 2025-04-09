{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
 <>
 b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos
 cuyo stock actual esté por debajo del stock mínimo permitido.}
 
program nachoinsoportable;
const
	valorAlto= 9999;
type
	producto = record
		cod:integer;
		nom: string;
		precio:real;
		stockAct:integer;
		stockMin:integer;
	end;
	
	
	venta = record
		cod:integer;
		cantVendidos:integer;
	end;
	
	detalle = file of venta;
	maestro = file of producto;
	
	// CARGAR ARCHIVOS
	
	procedure cargarMaestro (var mae: maestro, lprod: Text);
	var
		newProd: producto;
	begin
		reset (lprod);
		while not(EOF(lprod)) do begin
			readln (lprod,newProd.cod,newProd.stockAct,newProd.stockMin,newProd.precio,newProd.nombre);
			write (mae,newProd);
		end;
		close (lprod);
	end;
	
	procedure cargarProducto (var mae: maestro; lprod: listaProductos);
	var
		nombre: String;
	begin
		readln (nombre);
		assign (mae,nombre);
		rewrite (mae);
		cargarMaestro (mae,lprod)
		close (mae);
	end;
	
	procedure cargarVentas (var det: detalle; lvent: Text);
	var
		newVent: venta;
	begin
		reset (lvent);
		while not(EOF(lvent)) do begin
			readln (lvent, newVent.cod,newVent.cantVendidos);
			write (det,newVent);
		end;
		close (lvent);
	end;
	
	// PROCEDIMIENTO LEER
	
	procedure leer (var det:detalle; venta: venta );
	begin
		if (not (EOF(det)) then
			read(det, venta);
		else
			venta.cod := valorAlto;
	end;
	
	// PROCESAR DETALLE
	
	procedure actualizarMaestro (var mae: maestro; codAct,total: integer);
	var
		prod: producto; 
	begin
		read(mae, prod);
		while not(EOF(mae)) and (prod.cod <> codAct ) do begin
			read(mae, prod);
		end;
		if (prod.cod = codAct) then begin
			prod.stockAct:= prod.stockAct - total;
			seek (mae,filePos(mae) -1);
			write (mae,prod);
		end;
	end;
	
	procedure procesarDetalle (var det: detalle; var mae: maestro);
	var
		codAct,total: integer;
		venta: venta;
	begin
		reset(mae);
		reset (det);
		leer (det,venta);
		while (venta.cod  <> valorAlto) do begin
			codAct:= venta.cod;
			total:= 0;
			while (codAct = venta.cod) do begin
				total:= total + venta.cantVendidos;
				leer (det,venta);
			end;
			actualizarMaestro (mae,codAct,total);
		end;
		close (det);
		close(mae);
	end;
	
	// LISTAR STOCK MINIMO
	procedure leerStock (var mae: maestro; var newProd: producto);
	begin
		read (mae,newProd);
	end;
	
	procedure listarStockMin(var mae:maestro; var lmin:Text);
	var
		prod: producto;
		nombre: String;
	begin
		readln (nombre);
		assign (lmin, nombre);
		rewrite (lmin);
		reset (mae);
		while not(EOF(mae)) do begin
			leerStock (mae,prod);
			if (prod.stockMin > prod.stockAct ) then
				writeln (lmin,prod.cod,prod.stockAct,prod.stockMin,prod.precio,prod.nombre);
		end;
		close (mae);
		close (lmin);
	end;
	
	
var
	mae:maestro;
	det:detalle;
	lprod,lvent,lmin: Text;
	
begin
	cargarProductos(mae,lprod);
	cargarVentas (det,lvent);
	procesarDetalle(det, mae);
	listarStockMin(mae, lmin);
end.
