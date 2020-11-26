class Documento
	attr_accessor :codigo, :tipo, :fecha ,:usuario
	def initialize(codigo, tipo, fecha ,usuario)
		@codigo = codigo
		@tipo = tipo
		@fecha = fecha
		@usuario = usuario
	end
end

class Ingreso < Documento
	attr_accessor :proveedor
	def initialize(codigo, tipo, fecha,usuario , proveedor)
		super(codigo, tipo, fecha,usuario)
		@proveedor = proveedor
	end
end

class Salida < Documento
	attr_accessor :cliente,:codigo_venta
	def initialize(codigo, tipo, fecha,usuario,cliente,codigo_venta)
		super(codigo, tipo, fecha,usuario)
		@cliente = cliente
		@codigo_venta = codigo_venta
	end
end
