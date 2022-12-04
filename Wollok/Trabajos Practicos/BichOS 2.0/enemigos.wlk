import viajes.*


class Enemigo {
	var vida
	var posicionEnemigo
     
    method posicion() = posicionEnemigo
	
	method atacarHormiga(hormiga){
		hormiga.recibirDanio(1, self)
	}
	
	method recibirDanio(danio, atacante){
		vida = (vida - danio).max(0)
	}
	
	method vitalidad() = vida
}

class Langosta inherits Enemigo(vida = 50){
	override method recibirDanio(danio, atacante){
		super(danio, atacante)
		atacante.recibirDanio(10, self)
	}
}