class Usuario
	attr_accessor :dni, :nombre,:user, :pass, :perfil
	def initialize(dni, nombre,user, pass, perfil)
		@dni = dni
		@nombre = nombre
		@user=user
		@pass= pass
		@perfil=perfil
	end
end

