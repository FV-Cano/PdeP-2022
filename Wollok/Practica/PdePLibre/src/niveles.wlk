class Nivel {
	method agregarProducto(producto, usuario) {
		if(self.puedeAgregarProductos(usuario)) {
			usuario.obtenerProducto(producto)
		} else {
			self.error("Supera el limite maximo de productos segun su nivel")
		}
	}
	
	method puedeAgregarProductos(usuario)
	method puedeSubirDeNivel(puntos)
	method subirDeNivel()
}

object bronce inherits Nivel {
	override method puedeAgregarProductos(usuario) {return usuario.tieneCarritoVacio()}
	override method puedeSubirDeNivel(puntos) {return puntos > 5000}
	override method subirDeNivel() {return plata}
}

object plata inherits Nivel {
	override method puedeAgregarProductos(usuario) {return usuario.cantidadDeProductosEnCarrito() < 5}
	override method puedeSubirDeNivel(puntos) {return puntos > 15000}
	override method subirDeNivel() {return oro}
}

object oro inherits Nivel {
	override method puedeAgregarProductos(usuario) {return true}
	override method puedeSubirDeNivel(puntos) {return true}
	override method subirDeNivel() {return self}
}