import productos.*
import niveles.*
import cupones.*

class Usuario {
	const 	nombre
	var 	dineroDisponible
	var 	puntos
	var 	nivel
	const 	productosDeCarrito = []
	const 	cupones = #{}
	
	method 	cantidadMaximaDeProductos() {return nivel.cantidadMaximaDeProductos()}
	method 	puedeAscender() {return nivel.puedeAscender()}
	method	cantidadDeProductosEnCarrito() {return productosDeCarrito.size()}
	method	tieneCarritoVacio() {return productosDeCarrito.isEmpty()}
	method	agregarCupon(cupon) = cupones.add(cupon)
	
	method 	agregarProducto(producto) {
		nivel.agregarProducto(producto, self)
	}
	
	method	obtenerProducto(producto) {
		productosDeCarrito.add(producto)
	}
	
	method 	precioTotalDeCarrito() {return productosDeCarrito.sum({producto => producto.precio()})}
	method 	cuponesNoUsados() = cupones.filter({cupon => !cupon.fueUsado()})
	method 	cuponAlAzar(listaCupones) = listaCupones.anyone()
	method 	aumentarPuntos(cantidad) {puntos += cantidad}
	method	disminuirPuntos(cantidad) {puntos -= cantidad}
	
	method	comprarCarrito() {
		const cupon = self.cuponAlAzar(self.cuponesNoUsados())
		const precioConDescuento = self.aplicarCupon(self.precioTotalDeCarrito(), cupon)
		cupon.usar()
		dineroDisponible -= precioConDescuento
		self.aumentarPuntos((precioConDescuento * 0.1))
	}
	
	method	aplicarCupon(importe, cupon) {
		return cupon.aplicarDescuento(importe)
	}
	
	method	esUsuarioMoroso() {return dineroDisponible < 0}
	
	method 	eliminarCuponesUsados() {
		cupones.removeAllSuchThat({cupon => cupon.fueUsado()})
	}
	
	method puedeSubirDeNivel(){
		nivel.puedeSubirDeNivel(puntos)
	}
	
	method actualizarNivel(){
		if(!self.puedeSubirDeNivel()){
			self.error("No tiene los puntos necesarios para subir de nivel")
		}
		nivel.subirDeNivel()
	}
}
