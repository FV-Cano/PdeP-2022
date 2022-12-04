class Disfraz {
	const nombreDeDisfraz
	const property fechaDeConfeccion
	const caracteristicas = []
	
	method puntuacion(duenio, fiesta) {
		return caracteristicas.sum({caracteristica => caracteristica.puntaje(duenio, fiesta)})
	}
	
	method tieneNombrePar() {return nombreDeDisfraz.size().even()}
}

class Gracioso {
	var nivelDeGracia
	
	method puntaje(duenio, fiesta) {
		return nivelDeGracia * self.multiplicador(duenio)
	}
	
	method multiplicador(duenio) {
		if (duenio.edad() > 50) {
			return 3
		} else {
			return 1
		}
	}
	
	method nivelValido(nivelGracia) {return nivelGracia > 0 && nivelGracia <= 10}
	
	method nivelDeGracia(nuevoNivel) {
		if(self.nivelValido(nuevoNivel)) {
			nivelDeGracia = nuevoNivel
		} else {
			self.error("El nivel de gracia no está entre 1 y 10")
		}
	}
}
class Tobara {
	const fechaDeCompra
	
	method puntaje(duenio, fiesta) {
		return self.puntajeSegunFecha(fiesta)
	}
	
	method puntajeSegunFecha(fiesta) {
		if((fiesta.fecha() - fechaDeCompra) >= 2) {
			return 5
		} else {
			return 3
		}
	}
}
class Caretas {
	const caretaDePersonaje
	
	method puntaje(duenio, fiesta) {
		return caretaDePersonaje.puntajePorPersonaje()
	}
}
class Sexies {
	method puntaje(duenio, fiesta) {
		if(duenio.esSexy()) {
			return 15
		} else {
			return 2
		}
	}
}

object mickeyMouse {
	method puntoPorPersonaje() {return 8}
}
object osoCarolina {
	method puntoPorPersonaje() {return 6}
}