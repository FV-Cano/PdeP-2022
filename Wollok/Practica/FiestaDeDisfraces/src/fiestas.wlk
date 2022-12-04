import disfraces.*
import invitados.*

 class Fiesta {
 	const lugar
 	const fecha
 	const invitados = #{}
 	
 	method fecha() = fecha
 	
 	method tieneInvitadoA(unaPersona) {return invitados.contains(unaPersona)}
 	
 	method esUnBodrio() {return invitados.all({invitado => !invitado.estaSatisfecho(self)})}
 	method mejorDisfraz() {return invitados.max({invitado => invitado.puntuacionDelDisfraz(self)})}
 
 	
 
 	method fiestaInolvidable() {return self.todosSonSexies() && self.todosEstanConformes()}

	method todosSonSexies() {return invitados.all({invitado => invitado.esSexy()})}
	method todosEstanConformes() {return invitados.all({invitado => invitado.estaSatisfecho(self)})}
 }