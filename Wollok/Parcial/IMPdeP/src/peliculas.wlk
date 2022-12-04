import artistas.*

class Pelicula {
 	const nombre
 	const elenco = #{}
 	const RECAUDACION_BASE = 10000000
 	
 	method nombre() = nombre
 	
 	method presupuestoPelicula() {
 		return 	self.sumaDeSueldoDeElenco() + 
 				self.costosDeRodaje() + 
 				self.gastosAdicionales()
 	}
 	
 	method sumaDeSueldoDeElenco() {return elenco.sum({artista => artista.sueldo()})}
 	method costosDeRodaje() {return self.sumaDeSueldoDeElenco() * 0.7}
 	method gastosAdicionales() = 0
 	
 	method recaudacion() {return (RECAUDACION_BASE + self.recaudacionSegunTipo())}
 	
 	method ganancias() {return self.recaudacion() - self.presupuestoPelicula()}
 	
 	method recaudacionSegunTipo()
 	
 	method rodar() {elenco.forEach({artista => artista.actuar()})}
 	
 	method esEconomica() {return self.presupuestoPelicula() < 500000}
}
 
class PeliculaDrama inherits Pelicula {
 	override method recaudacionSegunTipo() = 100000 * self.cantidadDeLetras()
 	method cantidadDeLetras() = nombre.size()
}
 
class PeliculaAccion inherits Pelicula {
 	var CANTIDAD_VIDRIOS_ROTOS
 	
 	override method gastosAdicionales() = 1000 * CANTIDAD_VIDRIOS_ROTOS
 	override method recaudacionSegunTipo() = 50000 * self.tamanioDeElenco()
 	method tamanioDeElenco() = elenco.size()

}
 
class PeliculaTerror inherits Pelicula {
  	var CANTIDAD_CUCHOS
  	
 	override method recaudacionSegunTipo() = 20000 * CANTIDAD_CUCHOS
}
 
class PeliculaComedia inherits Pelicula {
 	override method recaudacionSegunTipo() = 0
}