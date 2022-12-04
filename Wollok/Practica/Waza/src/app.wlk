object waza {
	const usuarios = #{}
	const zonas = #{}
	
	method pagarMultas() {
		usuarios.forEach({usuario => usuario.pagarMultas()})
	}
	
	method registrarPago(multa){
		multa.cambiarEstadoPagada()
	}
	
	method zonaMasTransitada(){
		zonas.max({zona => zona.cantidadDeUsuarios()})
	}
	
	method usuariosComplicados(){
		usuarios.filter({usuario => usuario.esUsuarioComplicado()})
	}
}