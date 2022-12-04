class Cupon {
	var 	estado = false
	const 	porcentajeDescuento
	
	method fueUsado() {return estado}
	method usar() {estado = true}
	
	method aplicarDescuento(importe) {
		return importe - self.descuentoCupon(importe)
	}
	method descuentoCupon(importe) {return (importe * porcentajeDescuento) / 100}
}