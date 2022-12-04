import disfraces.*

class Invitado {
	var property disfraz
	var edad
	var personalidad
	
	method edad() = edad
	method puntuacionDelDisfraz(fiesta) {return disfraz.puntuacion(self, fiesta)}
	
	method esSexy() {
		return personalidad.esSexy(self)
	}
	
	method estaSatisfecho(fiesta) {
		return (self.puntuacionDelDisfraz(fiesta) > 10) && self.requisitoSegunTipo(fiesta)
	}
	
	method requisitoSegunTipo(fiesta)
	
}

class Caprichoso inherits Invitado {
	override method requisitoSegunTipo(fiesta) {
		return disfraz.tieneNombrePar()
	}
}
class Pretencioso inherits Invitado {
	const diaDeHoy = new Date().day()
	
	override method requisitoSegunTipo(fiesta) {
		return (diaDeHoy - disfraz.fechaDeConfeccion()) < 30
	}
}
class Numerologo inherits Invitado {
	var numeroEspecifico
	
	method seleccionarNumeroEspecifico(numero) {
		if (numero < 10) {
			self.error("El puntaje tiene que ser mayor a diez, por lo tanto lo mismo debe suceder con el numero")
		} else {
			numeroEspecifico = numero
		}
	}
	
	override method requisitoSegunTipo(fiesta) {
		return self.puntuacionDelDisfraz(fiesta) == numeroEspecifico
	}
}
 
 object alegre {
 	method esSexy(persona) = true
 }
 object taciturna {
 	method esSexy(persona) {return persona.edad() < 30}
 }
 object cambiante {
 	method esSexy(persona) {
 		const tiposDePersonalidad = [alegre, taciturna]
 		return tiposDePersonalidad.anyOne().esSexy(persona)
 	}
 }