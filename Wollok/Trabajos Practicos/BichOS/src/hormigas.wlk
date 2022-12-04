import hormiguero.*
import comida.*
import estados.*
import viajes.*

class Hormiga {
    var alimento = 0
    var posicionHormiga
    const distancias = []
    const destinos = []
    var estado = normal
    var ultimoRecorrido = 0
    
    method posicion() = posicionHormiga
    
    method aumentarAlimento(cantidad) {alimento += cantidad}
    
    method alimento() = alimento
    
    method entregarAlimento() {
        	self.mover(hormiguero.posicion().posicionX(),hormiguero.posicion().posicionY())
        	alimento = 0
    }
    
    method mover(valorX, valorY){estado.mover(self, valorX, valorY)}

    method viajar(valorX,valorY){
    	ultimoRecorrido = posicionHormiga.recorrido(valorX, valorY)
    	self.guardarRecorrido(ultimoRecorrido)
    	self.guardarDestino(valorX, valorY)
    	posicionHormiga.setPosicion(valorX, valorY)
    	self.cansancio()
    }
    
    method guardarRecorrido(ultimaDistancia){
        distancias.add(ultimaDistancia)
    }
    
    method guardarDestino(valorX,valorY){
        destinos.add([valorX,valorY])
    }
    
    method estaAlLimite(){
    	return self.alimento().between(9,10)
    }
    
    method distanciaTotal(cantidad){
    	return distancias.drop(cantidad).sum()
    }
    
    // 2.2
    method distanciaPromedio(cantidad){
        return self.distanciaTotal(cantidad)/(distancias.size() - cantidad)
    }
    
    // 2.3
    method destinos(){return destinos}
    
    // 3.0										
    method extraerComida(comida){
     	estado.extraerComida(self, comida)
    }
    
    // 4
    method cansancio(){
    	estado = estado.cansancioHormiga(ultimoRecorrido)
    }
    
    method descansar(){
    	estado = estado.descansar(self)
    }
    
    // Testings
    
    method distancias() {return distancias}
    
    method estado() {return estado}
    
}

