import viajes.*

object hormiguero {
    const hormigas = #{}
    var deposito = 0
    const posicionHormiguero = new Posicion(x = 0, y = 0)
     
    method posicion() = posicionHormiguero 
     
    method agregarHormiga(hormiga){
        hormigas.add(hormiga)
    }
    
    // 1.1
    method cantidadDeHormigas(){
    	return hormigas.size()
    }
    
    // 1.2
    method cantidadAlimentoEnHormigas(){
        return hormigas.sum({hormiga => hormiga.alimento()})
    }
    
    // 1.3
    method hormigasAlLimite(){
        return hormigas.map({hormiga => hormiga.estaAlLimite()}).size()
    }
    
    // 1.4
    method reclamarAlimento(){
        deposito += self.cantidadAlimentoEnHormigas()
        hormigas.forEach({hormiga => hormiga.entregarAlimento()})
    }
    
    // 1.5
    method alimentoTotal(){
        return deposito + self.cantidadAlimentoEnHormigas()
    }
    
    // 2.4
    method distanciaRecorridaHormigas(){
    	return hormigas.sum({hormiga => hormiga.distanciaTotal(0)})
    }
    
    // Testing:
    
    method alimentoEnDeposito() {return deposito}
}