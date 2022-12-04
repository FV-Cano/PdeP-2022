import viajes.*

class Hormiguero {
    const property hormigas = #{}
    var deposito = 0
    var posicionHormiguero
     
    method posicion() = posicionHormiguero 
    method alimentoEnDeposito() = deposito
     
    method agregarHormiga(hormiga){
        hormigas.add(hormiga)
    }
    
    // 1.1
    method cantidadDeHormigas(){
    	return hormigas.size()
    }
    
    // 1.2
    method cantidadAlimentoEnHormigas(){
        return hormigas.sum({hormiga => hormiga.alimento()})
    }
    
    // 1.3
    method hormigasAlLimite(){
        return hormigas.map({hormiga => hormiga.estaAlLimite()}).size()
    }
    
    // 1.4
    method reclamarAlimento(){
        hormigas.forEach({hormiga => hormiga.entregarAlimento()})
    }
    
    // 1.5
    method alimentoTotal(){
        return deposito + self.cantidadAlimentoEnHormigas()
    }
    
    // 2.4
    method distanciaRecorridaHormigas(){
    	return hormigas.sum({hormiga => hormiga.distanciaTotal(0)})
    }
        
    method defender(enemigo){
    	if(self.esIntruso(enemigo)){
        self.criterioDeAtaque().forEach({hormiga => hormiga.atacar(enemigo)})
        }
    }
    
    method listaHormigasAlLimite(){
        return hormigas.filter({hormiga=>hormiga.estaAlLimite()})
    }
    
    method quitarHormiga(hormiga){hormigas.remove(hormiga)}
    
    method primeraHormiga(){return self.hormigas().asList().head()}
    
    method esIntruso(criatura) {
    	return self.estaCerca(criatura) && self.esEnemigo(criatura)
    }
    
    method estaCerca(criatura) { 
    	return 	self.posicion().recorrido(criatura.posicion().posicionX(), criatura.posicion().posicionY()) < 2
    }
    
    method esEnemigo(criatura) {return !hormigas.contains(criatura)}
    
    method criterioDeAtaque()
    
    method recibirAlimento(valor){ deposito += valor}
}

class HormigueroCercano inherits Hormiguero {
	
	override method criterioDeAtaque() = self.estanCerca()
	
	method estanCerca() {
		return hormigas.filter({hormiga => hormiga.estaCerca()})
	}
}

class HormigueroCualquiera inherits Hormiguero {
	
	override method criterioDeAtaque() = self.diezCualesquiera()
	
	method diezCualesquiera() {
		return hormigas.asList().take(10)
	}
}

class HormigueroViolento inherits Hormiguero {
	
	override method criterioDeAtaque() = self.hormigasViolentas()
	
	method hormigasViolentas() {
		return hormigas.filter({hormiga => hormiga.esViolenta()})
	}
}