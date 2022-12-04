class Producto {
	var 	nombre
	var 	precioBase
	const 	IVA = 0.21
	
	method precio() {return (precioBase * IVA) + precioBase + self.recargo()}
	method recargo()
	method nombre() = nombre	
	
	method nombreDeOferta() {
		return 'SUPER OFERTA' + self.nombre()
	}
}

class Mueble inherits Producto {
	override method recargo() = 1000
}

class Indumentaria inherits Producto {
	override method recargo() = 0
}

class Ganga inherits Producto {
	override method precio() {return  0}
	override method recargo() = 0
	override method nombreDeOferta() {return super() + 'COMPRAME POR FAVOR'}	
}
