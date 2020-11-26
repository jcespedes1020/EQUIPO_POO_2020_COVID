require '../controlador/controlador'
require 'singleton'
$lista_usuario = Array.new
$perfil = ""
$userName = ""
$lista_producto = Array.new
$lista_documento = Array.new
$lista_docDet = Array.new

$ct = Controlador.new()

def menuPrincipal
	begin  	
		begin
			system('cls')
			puts
			puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
			puts "1. Registrar Ingreso"
			puts "2. Registrar Salida"
			puts "3. Nuevo Producto"
			puts "4. Nuevo Usuario"
			puts "5. Reporte: Todos los productos"
			puts "6. Reporte: Productos que están por debajo del stock mínimo"
			puts "7. Reporte: Usuario"
			puts "8. Reporte: KARDEX"
			puts "9. Salir"
			puts
			puts "Seleccione una opción:"
			opcion = gets.chomp.to_i
		end until(opcion >= 1 and opcion <= 9)
		case opcion
			when 1
				nuevoIngreso()
			when 2
				nuevoSalida()
			when 3
				nuevoProducto()
			when 4
				if $perfil == 'Administrador'
					nuevoUsuario()
					menuPrincipal()
				else
					puts "No tienes privilegios para ejecutar este proceso. Presione una tecla para continuar..."
					gets
					menuPrincipal()
				end	

			when 5
				reporteProductoTodo()
				menuPrincipal()
			when 6
				
				if $perfil == 'Administrador'
					reporteProducto()
					menuPrincipal()
				else
					puts "No tienes privilegios para ejecutar este proceso. Presione una tecla para continuar..."
					gets
					menuPrincipal()
				end
			when 7
				if $perfil == 'Administrador'
					reporteUsuario()
				#else
					menuPrincipal()
				else
					puts "No tienes privilegios para ejecutar este proceso. Presione una tecla para continuar..."
					gets
					menuPrincipal()
				end	
			when 8
				reporteDocumento()
			when 9
				login()
		end
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def generarCodigoDocDet()
	begin

	codigo = "D"
	n = $lista_docDet.size + 1 
	if n < 10
		codigo = codigo+"00"+n.to_s
	elsif n < 100
		codigo = codigo+"0"+n.to_s
	else
		codigo = codigo+n.to_s
	end
	return codigo
	rescue StandardError => msg  
	  puts msg 	
	end  
end


def nuevoIngreso
begin

	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts "NUEVO INGRESO"
	puts
	puts "Ingrese codigo de documento:"
	codigo = gets.chomp
	puts "Ingrese fecha de documento:"
	fecha = gets.chomp
	puts "Ingrese nombre de proveedor:"
	proveedor = gets.chomp
    user = $userName
	obj = $ct.createDocumento(codigo,'I', fecha,user, proveedor)
	$lista_documento.push(obj)
	nuevoDocDetalle(codigo,'I')
	menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def nuevoSalida
	begin
	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts "NUEVO SALIDA"
	puts
	puts "Ingrese codigo de Documento:"
	codigo = gets.chomp	
	puts "Ingrese fecha de Documento:"
	fecha = gets.chomp
	puts "Ingrese nombre de cliente"
	cliente = gets.chomp
	puts "Ingrese codigo de venta"
	codigo_venta = gets.chomp
    user = $userName
	obj = $ct.createDocumento(codigo, 'S', fecha,$userName,cliente,codigo_venta)
	$lista_documento.push(obj)
	nuevoDocDetalle(codigo, 'S')
	menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def nuevoProducto
	begin
	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts "NUEVO PRODUCTO"
	puts
	usuario = ""
	puts "Ingrese codigo de producto:"
	codigo = gets.chomp
	puts "Ingrese Nombre de producto:"
	nombre = gets.chomp
	puts "Ingrese stock de producto:"
	stock = gets.chomp.to_i
	usuario = $userName
	obj = $ct.createProducto(codigo,nombre,stock,usuario)
	$lista_producto.push(obj)
	menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def nuevoDocDetalle(codigo_documento,tipo)
	begin
	system('cls')
	puts
	puts "1. PARA AGREGAR DETALLE"
	opcion = gets.chomp.to_i
	if(opcion != 1)
		return
	end
	puts "Ingrese cantidad:"
	cantidad = gets.chomp.to_i
	puts "Ingrese codigo producto:"
	codigo_producto = gets.chomp

	id_detalle = generarCodigoDocDet()
	obj = $ct.createDocumentoDet(id_detalle,codigo_documento,cantidad,codigo_producto)
	$lista_docDet.push(obj)

	if(tipo=='S')
		UpdateProductoSalida(codigo_producto,cantidad)
	end 
	if(tipo=='I')
		UpdateProductoIngreso(codigo_producto,cantidad)
	end 
	nuevoDocDetalle(codigo_documento,tipo)
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def nuevoUsuario
	begin
	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts "NUEVO USUARIO"
	puts
	puts "Ingrese DNI:"
	dni = gets.chomp
	puts "Ingrese Nombre:"
	nombre = gets.chomp
	puts "Ingrese usuario de autenticación :"
	user = gets.chomp
	puts "Ingrese Contraseña:"
	pass = gets.chomp
	puts "Ingrese Perfil:"
	perfil = gets.chomp

	obj = $ct.createUsuario(dni, nombre,user, pass, perfil)
	$lista_usuario.push(obj)
	menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def UpdateProductoSalida(codigo,cantidad)
	begin
		system('cls')
		cant=0
		$lista_producto.each do |prod|
				cant_aux =0
				if(prod.codigo == codigo)
					puts "cantidad:#{cantidad}"
					puts "prod.stock:#{prod.stock}"
					if(cantidad >= prod.stock)
						puts "No hay Stock disponible... Presione una tecla para continuar..."
						gets
					else
						cant_aux=prod.stock-cantidad
						prod.stock = cant_aux
					end	
					cant=1
					break
				end
		end
		if(cant!=1)
			puts "No existe producto selecionado"
			gets			
		end	
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def UpdateProductoIngreso(codigo,cantidad)
	begin
		system('cls')
		cant=0
		$lista_producto.each do |prod|
				cant_aux =0
				if(prod.codigo == codigo)
						cant_aux=prod.stock+cantidad
						prod.stock = cant_aux
					cant=1
					break
				end
		end
		if(cant!=1)
			puts "No existe producto selecionado"
			gets			
		end	
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def reporteProducto()
	begin
	system('cls')
	puts "************************* CENTRO DE SALUD SAN JOSÉ *************************"
	stock_nim = 5
	puts
	puts "REPORTE DE PRODUCTOS - STOCK MÍNIMO ES #{stock_nim}"
	print "codigo".ljust(15)
	print "nombre".ljust(15)
	print "stock".ljust(15)
	print "usuario".ljust(15)
	puts
	$lista_producto.each do |prod|
		if(stock_nim >=  prod.stock)
				print "#{prod.codigo}".ljust(15)
				print "#{prod.nombre}".ljust(15)
				print "#{prod.stock}".ljust(15)
				print "#{prod.usuario}".ljust(15)			
		end
		puts
	end
	puts "Presione una tecla para continuar..."
	gets
	#menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def reporteProductoTodo()
	begin
	system('cls')
	puts "************************* CENTRO DE SALUD SAN JOSÉ *************************"
	puts
	puts "REPORTE DE PRODUCTOS"
	puts
	print "codigo".ljust(15)
	print "nombre".ljust(15)
	print "stock".ljust(15)
	print "usuario".ljust(15)
	puts
	$lista_producto.each do |prod|
				print "#{prod.codigo}".ljust(15)
				print "#{prod.nombre}".ljust(15)
				print "#{prod.stock}".ljust(15)
				print "#{prod.usuario}".ljust(15)			
				puts
	end
	puts "Presione una tecla para continuar..."
	gets
	#menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def reporteUsuario()
	begin
	system('cls')
	puts "************************* CENTRO DE SALUD SAN JOSÉ *************************"
	puts
	puts "REPORTE DE USUARIOS "
	puts
	print "DNI".ljust(15)
	print "NOMBRE".ljust(15)
	print "USER".ljust(15)
	print "PASS".ljust(15)
	print "PERFIL".ljust(15)
	puts
	$lista_usuario.each do |item|
				print "#{item.dni}".ljust(15)
				print "#{item.nombre}".ljust(15)	
				print "#{item.user}".ljust(15)
				print "#{item.pass}".ljust(15)
				print "#{item.perfil}".ljust(15)
		puts
	end
	puts "Presione una tecla para continuar..."
	gets
	#menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def buscaProd(codigo)
	begin
		$lista_producto.each do |item|
			if(codigo ==item.codigo)												
					return "#{item.nombre}".ljust(15)
			end
		end
	rescue StandardError => msg  
	  puts msg 	
	end  
end	

def reporteDoc(codigo_aux)
	begin
		tipo_aux =""
		$lista_documento.each do |item|
			if(codigo_aux ==item.codigo)												
					if(item.tipo=='I')
						tipo_aux= "INGRESO"
					end	
					if(item.tipo=='S')
						tipo_aux= "SALIDA"
					end	
					return "#{tipo_aux}".ljust(15)+"#{item.fecha}".ljust(15)
			end
		end
	rescue StandardError => msg  
	  puts msg 	
	end  
end	

def reporteDocumento()
	begin
	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts
	puts "REPORTE DE DOCUMENTO "
	puts
	print "CODIGO_DOC".ljust(15)
	print "CANTIDAD".ljust(15)
	print "TIPO".ljust(15)
	print "FECHA".ljust(15)
	print "PRODUCTO".ljust(15)
	print "USUARIO".ljust(15)
	puts
	dato =""
	prod =""
	$lista_docDet.each do |x|
		dato = reporteDoc(x.codigo_documento)
		prod=buscaProd(x.codigo_producto)
		print "#{x.codigo_documento}".ljust(15)
		print "#{x.cantidad}".ljust(15)
		print "#{dato}"
		print "#{prod}"
		$lista_documento.each do |item|
        if(x.codigo_documento ==item.codigo)
	     print "#{item.usuario}".ljust(15) 
		 print "\n"
		 end
		end
		puts	
	end									
	puts
	puts "Presione una tecla para continuar..."
	gets
	menuPrincipal()
	rescue StandardError => msg  
	  puts msg 	
	end  
end

def login()
	begin
	system('cls')
	puts
	puts "******************************* CENTRO DE SALUD SAN JOSÉ *******************************"
	puts "LOGIN"
	puts
	puts "Ingrese usuario:"
	usuario = gets.chomp
	puts "Ingrese password:"
	pass = gets.chomp
	ingresa = false
	$lista_usuario.each do |item|
		if(item.user == usuario)
			if(item.pass == pass)
				$perfil = item.perfil
				$userName=item.user
				ingresa = true
				break
			end
		end
	end
	if ingresa == true
		menuPrincipal()
	else
		login()
	end
	rescue StandardError => msg  
	  puts msg 	
	end  
end



$obj = $ct.createUsuario('43998078','JAIME CHAVEZ','admin', '123456', 'Administrador')
$lista_usuario.push($obj)
$obj = $ct.createUsuario('78262078','MARIA PEREZ','almacenero', '123456', 'Almacenero')
$lista_usuario.push($obj)

login()