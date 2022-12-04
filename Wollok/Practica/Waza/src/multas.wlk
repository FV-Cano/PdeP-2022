class Multa {
	var costo
	var estado = false
	
	method costo() = costo
	
	method aplicarRecargo() {costo += costo*0.1}
	
	method cambiarEstadoPagada() {estado = true}
	
	method estaPagada() {return estado}
}