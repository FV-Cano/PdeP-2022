object pdepLibre {
	const usuarios = #{}
	const productos = []
	
	method reducirPuntos() {
		const usuariosMorosos = usuarios.filter({usuario => usuario.esUsuarioMoroso()})
		usuariosMorosos.forEach({usuario => usuario.disminuirPuntos(1000)})
	}
	
	method eliminarCuponesUsados() {
		usuarios.forEach({usuario => usuario.eliminarCuponesUsados()})
	}
	
	method obtenerNombreDeOferta() {
		productos.forEach({producto => producto.nombreDeOferta()})
	}
	
	method actualizarNiveles() {
		usuarios.forEach({usuario => usuario.actualizarNivel()})
	}
}
