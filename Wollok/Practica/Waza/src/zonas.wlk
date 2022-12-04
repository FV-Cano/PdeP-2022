import multas.*
import usuarios.*

class Zona {
	const velocidadMaximaPermitida
	const usuarios = #{}
	const controles = #{}
	
	method controles() = controles
	
	method cantidadDeUsuarios() = usuarios.size()
	
	method activarControles() = controles.forEach({control => control.controlarUsuarios(usuarios, self)})
	
	method superaVelocidadPermitida(usuario) {
		return usuario.vehiculoAsociado().superaVelocidadMaxima(velocidadMaximaPermitida)
	}
}