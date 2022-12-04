import hormiguero.*

class Colonia {
	const property coloniasYHormigueros = #{}
	
	method reclamarAlimento() {
		coloniasYHormigueros.forEach ({coloniaUhormiguero => coloniaUhormiguero.reclamarAlimento()})
	}
	
	method reclamarAlimentoDeHormigasAlLimite(){
		coloniasYHormigueros.forEach({ coloniaUhormiguero => coloniaUhormiguero.reclamarAlimentoDeHormigasAlLimite() })
	}
	
	method cantidadDeHormigas(){
		return coloniasYHormigueros.sum({coloniaUhormiguero => coloniaUhormiguero.cantidadDeHormigas()})
	}
	
	method defender(enemigo){
		coloniasYHormigueros.forEach({coloniaUhormiguero => coloniaUhormiguero.defender(enemigo)})
	}
	
	method alimentoTotal(){
		return coloniasYHormigueros.sum({coloniaUhormiguero => coloniaUhormiguero.alimentoTotal()})
	}
}