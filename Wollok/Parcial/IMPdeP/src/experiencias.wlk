class Experiencia {
 	method recategorizar(artista) {
 		if (self.puedeRecategorizarse(artista)) {
 			self.cambiarCategoria(artista)
 		} else {
 			self.error("El actor no cumple con los requisitos para recategorizarse")
 		}
 	}
 	
 	method puedeRecategorizarse(artista)
 	method cambiarCategoria(artista)
 	method sueldo(artista)
}
 
object amateur inherits Experiencia {
 	override method sueldo(artista) = 10000
 	override method puedeRecategorizarse(artista) {return artista.actuoMasDeDiezPeliculas()}
 	override method cambiarCategoria(artista) = artista.cambiarExperiencia(establecido) 
}
 
object establecido inherits Experiencia {
 	override method sueldo(artista) {return self.sueldoSegunFama(artista)}
	method sueldoSegunFama(artista) {
		if (artista.nivelDeFama() < 15) {
			return 15000
		} else {
			return 5000 * artista.nivelDeFama()
		}
	}
	override method puedeRecategorizarse(artista) {return artista.tieneFamaDeUnaEstrella()}
	override method cambiarCategoria(artista) = artista.cambiarExperiencia(estrella)
}
 
object estrella inherits Experiencia {
 	override method sueldo(artista) = 30000 * artista.cantidadDePeliculas()
 	override method recategorizar(artista)  {throw new Exception (message = "Las estrellas no pueden recategorizarse")}
 	override method puedeRecategorizarse(artista) {return false} //Nunca llega acá, hablado con ayudantes
 	override method cambiarCategoria(artista) {}
}