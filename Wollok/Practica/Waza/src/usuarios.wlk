import vehiculos.*
import multas.*
import app.*

class Usuario {
	var property nombre
	var property dineroEnCuenta
	var vehiculo
	const dni
	const property multas = #{}
	
	method recibirMulta(nuevaMulta) = multas.add(nuevaMulta)
	
	method vehiculoAsociado() = vehiculo
	
	method recorrer(distancia) {
		vehiculo.recorrer(distancia)
	}
	
	method recargarCombustible(cantidad) {
		const cantidadCombustible = vehiculo.cantidadARecargar(cantidad)
		if(self.puedePagarPorCombustible(cantidadCombustible)){
			vehiculo.recargarCombustible(cantidadCombustible)
			self.pagarPorCombustible(cantidadCombustible)
		}
	}
	
	method puedePagarPorCombustible(cantidadCombustible) {return dineroEnCuenta > (40 * cantidadCombustible)}
	
	method pagarPorCombustible(cantidadARecargar) {dineroEnCuenta -= (40 * cantidadARecargar)}
	
	method tieneDNIHabilitadoParaRecorrer() {
		const diaActual = new Date().day()
		
		return dni.even() && diaActual.even()
	}
	
	method pagarMultas() {
		multas.forEach({multa => self.pagarPorMulta(multa)})
	}
	
	method pagarPorMulta(multa) {
		if(!self.puedePagarPorMulta(multa)) {
			multa.aplicarRecargo()
			self.error("El usuario no tiene dinero suficiente para pagar por la multa")
		}
		dineroEnCuenta -= multa.costo()
		waza.registrarPago(multa)
	}
	
	method puedePagarPorMulta(multa) { return dineroEnCuenta > multa.costo() }
	
	method esUsuarioComplicado() {
		const multasNoPagadas = multas.filter({multa => !multa.estaPagada()})
		const valorDeMultas = multasNoPagadas.map({multa => multa.costo()})
		return self.montoTotalDeMultas(valorDeMultas) > 5000
	}
	
	method montoTotalDeMultas(valorDeMultas) {
		return valorDeMultas.sum()
	}
}
