require '../modelo/Documento'
require '../modelo/usuario'
require '../modelo/Producto'
require '../modelo/DocumentoDet'

class Controlador

	def createDocumento(*param)
		if param[1] == 'I'
			Ingreso.new(param[0],param[1],param[2],param[3],param[4])
		elsif param[1] == 'S'
			Salida.new(param[0],param[1],param[2],param[3],param[4],param[5])
		end
	end

	def createUsuario(dni, nombre,user, pass, perfil)
		Usuario.new(dni, nombre,user, pass, perfil)
	end

	def createProducto(codigo, nombre,stock,usuario)
		Producto.new(codigo, nombre,stock,usuario)
	end

	def createDocumentoDet(id_detalle,codigo_documento,cantidad,codigo_producto)
		DocumentoDet.new(id_detalle,codigo_documento,cantidad,codigo_producto)
	end

end