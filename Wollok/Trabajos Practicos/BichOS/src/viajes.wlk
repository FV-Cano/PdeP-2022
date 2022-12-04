class Posicion {
	var x = 0
	var y = 0
	
    method posicionX() = x
    method posicionY() = y
    
    method setPosicion(valorX, valorY) {
    	x = valorX
    	y = valorY
    }
    
    method recorrido(nuevaPosX, nuevaPosY) {
        return  ((nuevaPosX - self.posicionX()) ** 2 +
        		 (nuevaPosY - self.posicionY()) ** 2).squareRoot().truncate(0)
    }
}