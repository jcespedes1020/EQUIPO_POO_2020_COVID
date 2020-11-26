class DocumentoDet
	attr_accessor :id_detalle, :codigo_documento,:cantidad,:codigo_producto
	def initialize(id_detalle,codigo_documento,cantidad,codigo_producto)
		@id_detalle=id_detalle
		@codigo_documento=codigo_documento
		@cantidad=cantidad
		@codigo_producto=codigo_producto
	end
end

