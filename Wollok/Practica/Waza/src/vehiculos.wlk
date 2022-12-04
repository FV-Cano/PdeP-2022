class Vehiculo {
	var combustible
	const capacidadMaxima
	const velocidadPromedio
	
	method velocidadPromedio() = velocidadPromedio
	
	method recorrer(distancia) {
		combustible -= 2
	}
	
	method cantidadARecargar(cantidadCombustible) {return capacidadMaxima.min(cantidadCombustible)}
	
	method recargarCombustible(cantidadCombustible) {
		if(self.superaLaCapacidadMaxima(cantidadCombustible)){
			self.error("Supera la capacidad maxima del tanque")
		}
		
		combustible += cantidadCombustible
	}
	
	method superaLaCapacidadMaxima(cantidadCombustible) {return (combustible + cantidadCombustible) > capacidadMaxima}
	
	method superaVelocidadMaxima(velocidadMaximaPermitida) {return velocidadPromedio > velocidadMaximaPermitida}
	
	method esEcologico()
}

class Camioneta inherits Vehiculo {
	override method esEcologico() {return false}
	override method recorrer(distancia) {
		combustible -= 4 + 5*distancia
	}
}

class Deportivo inherits Vehiculo {
	override method esEcologico() {return velocidadPromedio < 120}
	override method recorrer(distancia) {
		super(distancia)
		combustible -= 2 * velocidadPromedio
	}
}

class Familiar inherits Vehiculo {
	override method esEcologico() {return true}
}