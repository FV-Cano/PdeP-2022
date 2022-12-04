import viajes.*

class Comida {
	var property peso = 0
	var posicionComida
    
    method posicion() = posicionComida
    
    method perderPeso(cantidad){
    	peso = 0.max(self.peso() - cantidad - 1)
    }
}