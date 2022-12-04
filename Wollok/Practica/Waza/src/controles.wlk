import zonas.*
import multas.*
import usuarios.*

class Control {
	method controlarUsuarios(usuarios, zona) {
		usuarios.forEach({usuario => self.controlarUsuario(usuario, zona)})
	}
	
	method controlarUsuario(usuario, zona) {
		if(self.esMultable(usuario, zona)) {
			usuario.recibirMulta(new Multa(costo = self.valorMulta()))
		}
	}
	
	method valorMulta()
	method esMultable(usuario, zona)
	
}

class ControlVelocidad inherits Control {
	const valorMultaVelocidad = 3000
	
	override method esMultable(usuario, zona) {
		return zona.superaVelocidadMaxima(usuario)
	}
	
	override method valorMulta() {return valorMultaVelocidad}
}

class ControlEcologico inherits Control {
	const valorMultaEcologica = 1500
	
	override method esMultable(usuario, zona) {
		return !usuario.vehiculoAsociado().esEcologico()
	}
	
	override method valorMulta() {return valorMultaEcologica}
}

class ControlRegulatorio inherits Control {
	const valorMultaRegulatoria = 2000
	
	override method esMultable(usuario, zona) {
		return !usuario.tieneDNIHabilitadoParaRecorrer()
	}
	
	override method valorMulta() {return valorMultaRegulatoria}
}