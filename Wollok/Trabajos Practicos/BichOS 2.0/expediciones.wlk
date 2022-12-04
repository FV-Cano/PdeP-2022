import hormiguero.*

class Expedicion {
	
	const property hormigueroInicial
	const property hormigas = #{}
	const property objetivo
	
	method cantidadNecesariaHormigas(){
		return (objetivo.peso() / 10)
	}
	
	method asignarHormigas(){
			self.cantidadNecesariaHormigas().times({unNumero => self.reclutarDeHormiguero(hormigueroInicial.primeraHormiga())})
			hormigas.forEach({hormiga=>hormiga.entregarAlimento()})
	}
	
	method realizarExpedicion(){
			if (hormigas.isEmpty()) {
				throw new ExcepcionExpedicion (message = "No se puede realizar una expedicion sin integrantes")
			}
			
			hormigas.forEach({hormiga=>hormiga.extraerComida(objetivo)})
			hormigas.forEach({hormiga=>hormiga.descansar()})
			self.entregarAlimentoDeLaExpedicion()
			return "Expedicion Realizada"
	}
	
	method desarmar(){
			if (hormigas.isEmpty()) {
				throw new ExcepcionExpedicion (message = "No se puede desarmar una expedición vacía")
			}
			
			hormigas.forEach({hormiga=>hormiga.hormiguero().agregarHormiga(hormiga)})
			hormigas.clear()
			return "Expedicion Desarmada"
	}
			
	method reclutarDeHormiguero(hormiga){
			hormigas.add(hormiga)
			hormiga.salirDeHormiguero()
	}	
	
	method entregarAlimentoDeLaExpedicion(){hormigas.forEach({hormiga=>hormiga.entregarAlimento()})}
		
}

class ExcepcionExpedicion inherits Exception {
}