class Producto
	attr_accessor :codigo, :nombre, :stock, :usuario
	def initialize(codigo, nombre,stock,usuario)
		@codigo = codigo
		@nombre = nombre
		@stock=stock
		@usuario=usuario
	end
end
