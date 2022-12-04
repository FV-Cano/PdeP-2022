import fiestas.*

object cambiadorDeTrajes {
	
	method puedenCambiarTraje(unaPersona, otraPersona, unaFiesta) {
		return 	self.ambasEstanEnLaFiesta(unaPersona, otraPersona, unaFiesta) &&
				self.algunaEstaDisconforme(unaPersona, otraPersona, unaFiesta) &&
				self.estanConformesLuegoDeCambiar(unaPersona, otraPersona, unaFiesta)
	}
	
	method ambasEstanEnLaFiesta(unaPersona, otraPersona, unaFiesta) {
		return unaFiesta.tieneInvitadoA(unaPersona) && unaFiesta.tieneInvitadoA(otraPersona)
	}
	
	method algunaEstaDisconforme(unaPersona, otraPersona, fiesta) {
		return !unaPersona.estaSatisfecho(fiesta) || !unaPersona.estaSatisfecho(fiesta)
	}
	
	method estanConformesLuegoDeCambiar(unaPersona, otraPersona, fiesta) {
		self.cambioDeTrajes(unaPersona, otraPersona)
		return unaPersona.estaSatisfecho(fiesta) && otraPersona.estaSatisfecho(fiesta)
	}
	
	method cambioDeTrajes(unaPersona, otraPersona) {
		const disfrazDeUnaPersona = unaPersona.disfraz()
		const disfrazDeOtraPersona = otraPersona.disfraz()
		unaPersona.disfraz(disfrazDeOtraPersona)
		otraPersona.disfraz(disfrazDeUnaPersona)
	}
}
