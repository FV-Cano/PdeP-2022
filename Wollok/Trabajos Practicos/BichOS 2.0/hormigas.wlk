import hormiguero.*
import comida.*
import estados.*
import viajes.*
import enemigos.*

class Hormiga {
    var alimento = 0
    var posicionHormiga
    var property hormiguero
    const distancias = []
    const destinos = []
    var estado = normal
    var ultimoRecorrido = 0
    var vida = 1
    
    method posicion() = posicionHormiga
    method distancias() {return distancias}
    method estado() {return estado} 
    method ultimoRecorrido() {return ultimoRecorrido}
    method alimento() = alimento
    
    method aumentarAlimento(cantidad) {alimento += cantidad}
    
    method entregarAlimento(){
    			self.mover(hormiguero.posicion().posicionX(),hormiguero.posicion().posicionY())
    			hormiguero.recibirAlimento(alimento)
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
    
    method estaAlLimite()
 
    method distanciaTotal(cantidad){
    	return distancias.drop(cantidad).sum()
    }
    
    method distanciaPromedio(cantidad){
        return self.distanciaTotal(cantidad)/(distancias.size() - cantidad)
    }
    
    method destinos(){return destinos}
    
    method extraerComida(comida){
     	estado.extraerComida(self, comida)
    }
    
    method cansancio(){
    	estado = estado.cansancioHormiga(ultimoRecorrido)
    }
    
    method descansar(){
    	estado = estado.descansar(self)
    }
    
    method salirDeHormiguero(){hormiguero.quitarHormiga(self)}
    
    method atacar(enemigo)
    
    method recibirDanio(danio, atacante){
    	self.morir()
    }
    
    method morir() {
    	estado = muerta
    	hormiguero.quitarHormiga(self)
    }
   
    method esViolenta() = false
    
    method vitalidad() = vida
    
    method cambiarDeHormiguero(nuevoHormiguero){hormiguero = nuevoHormiguero}
    
    method estaCerca() {
    	return (self.posicion().recorrido(hormiguero.posicion().posicionX(), hormiguero.posicion().posicionY())) < 5
    }
}


class Obrera inherits Hormiga {
	
	override method estaAlLimite() {return self.alimento().between(9,10)}
	override method atacar(enemigo) { 
		self.mover(enemigo.posicion().posicionX(), enemigo.posicion().posicionY())
		enemigo.recibirDanio(2, self)
	}
}

class Soldado inherits Hormiga(vida = 20){
	
	override method extraerComida(comida){}
	override method entregarAlimento(){
        	self.mover(hormiguero.posicion().posicionX(),hormiguero.posicion().posicionY())
    }
    override method estaAlLimite() = false
    override method atacar(enemigo) { 
    	self.mover(enemigo.posicion().posicionX(), enemigo.posicion().posicionY())
    	enemigo.recibirDanio(5, self)
    }
    override method recibirDanio(danio, atacante) {
    	vida = (vida - danio).max(0)
    	if(vida == 0){
    		super(danio, atacante)
    	}
    }
    override method descansar(){
    	vida = 20
    	super()
    }
    override method esViolenta() = true
}

class HormigaReal inherits Hormiga {
	override method extraerComida(comida){}
	override method mover(valorX,valorY){}
	override method entregarAlimento(){hormiguero.recibirAlimento(alimento)}
    override method estaAlLimite() = true
    override method atacar(enemigo){
    	enemigo.recibirDanio(0, self)
    }
}

class Zangano inherits HormigaReal(alimento = 1){}

class Reina inherits HormigaReal(alimento = 0){
    override method entregarAlimento(){}
    override method estaAlLimite() = false
}


