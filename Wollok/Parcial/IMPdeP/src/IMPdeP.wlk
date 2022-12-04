import peliculas.*
import artistas.*

object impdep {
	const artistas = #{}
	const peliculas = #{}
	
	method artistaMejorPago() {return artistas.max({artista => artista.sueldo()})}
	method nombreDePeliculasEconomicas() {return self.peliculasEconomicas().map({pelicula => pelicula.nombre()})}
	method recategorizarArtistas() {artistas.forEach({artista => artista.recategorizar()})}
	
	method peliculasEconomicas() {return peliculas.filter({pelicula => pelicula.esEconomica()})}
	
	method gananciaDePeliculasEconomicas() {return self.ganancias(self.peliculasEconomicas())}
	
	method ganancias(listaPeliculas) {return listaPeliculas.sum({pelicula => pelicula.ganancias()})}
	
}