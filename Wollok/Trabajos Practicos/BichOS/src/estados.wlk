object cansada {
	
	method capacidadMaxima() = 0
	method mover(hormiga,valorX,valorY){}
	method extraerComida(hormiga, comida){}
	method cansancioHormiga(valor){return self}
	method descansar(hormiga) { return normal }
}

class Estado {
	
	method capacidadMaxima()
	method mover(hormiga,valorX,valorY){hormiga.viajar(valorX,valorY)}
	method extraerComida(hormiga, comida) {
		const auxiliar = hormiga.alimento()
		hormiga.mover(comida.posicion().posicionX(), comida.posicion().posicionY())
		hormiga.aumentarAlimento(comida.peso().min(hormiga.estado().capacidadMaxima() - hormiga.alimento()))
		comida.perderPeso(hormiga.alimento() - auxiliar)
	}
	method cansancioHormiga(valor)
	method descansar(hormiga)
}

object normal inherits Estado {
	
	override method capacidadMaxima() = 10
	override method cansancioHormiga(valor){
		if (valor > 10){return cansada}
			else {return self}
	}
	override method descansar(hormiga) {return exaltada}
}

object exaltada inherits Estado {
	
	override method capacidadMaxima() = 20
	override method cansancioHormiga(valor){
		if (valor > 5){return normal}
			else {return self}
	}
	override method descansar(hormiga) {return self}
}