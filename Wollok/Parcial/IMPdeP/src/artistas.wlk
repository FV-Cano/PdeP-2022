import experiencias.*
 
class Artista {
	var experiencia
	var cantidadDePeliculas
	var ahorros = 0 // Le asigno un valor inicial porque sino Wollok detecta error de tipos con actuar()
	
	method cantidadDePeliculas() = cantidadDePeliculas
	
	method sueldo() = experiencia.sueldo(self)
	method recategorizar() = experiencia.recategorizar(self)
	
	method nivelDeFama() = (cantidadDePeliculas / 2).truncate(0)
	method actuoMasDeDiezPeliculas() {return cantidadDePeliculas > 10}
	method tieneFamaDeUnaEstrella() {return self.nivelDeFama() > 10}
	method cambiarExperiencia(experienciaRecategorizada) {experiencia = experienciaRecategorizada}
	
	method actuar() {
		self.aumentarPeliculasActuadas()
		ahorros += self.sueldo()
	}
	
	method aumentarPeliculasActuadas() {cantidadDePeliculas += 1}
}