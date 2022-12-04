import comida.*
import estados.*
import hormigas.*
import hormiguero.*
import viajes.*
import enemigos.*
import colonias.*
import expediciones.*



const camelot = new HormigueroCercano (posicionHormiguero = new Posicion(x=3,y=3), hormigas = [merlin,arturo])
const coloniaHormigueros = new Colonia(hormigueros = #{hormigueroCasaDeGranHermano})
const coloniaDeColonias = new ColoniaDeColonias(hormigueros = #{camelot},colonias = #{coloniaHormigueros})


const merlin  = new Obrera(posicionHormiga = new Posicion(x=3,y=3), hormiguero = camelot, alimento = 5)
const arturo  = new Obrera(posicionHormiga = new Posicion(x=3,y=3), hormiguero = camelot, alimento = 5)



 
const hormigueroCasaDeGranHermano = new HormigueroCercano (posicionHormiguero = new Posicion(x=1,y=1), hormigas = #{thiago,holder})

const thiago  = new Obrera(posicionHormiga = new Posicion(x=0,y=0), hormiguero = hormigueroCasaDeGranHermano)
const holder  = new Soldado(posicionHormiga = new Posicion(x=0,y=0), hormiguero = hormigueroCasaDeGranHermano)
const juan  = new Zangano(posicionHormiga = hormigueroCasaDeGranHermano.posicion(), hormiguero = hormigueroCasaDeGranHermano)
const julieta  = new Reina(posicionHormiga = hormigueroCasaDeGranHermano.posicion(), hormiguero = hormigueroCasaDeGranHermano)

const huevos = new Comida(peso = 20, posicionComida = new Posicion(x = 6, y = 3))

const expedicionPrueba = new Expedicion(objetivo = huevos, hormigueroInicial = hormigueroCasaDeGranHermano)

object mundo {
	
	const criaturas = #{thiago, holder, juan, julieta}		

	method agregarCriatura(criatura) {criaturas.add(criatura)}
	method todasLasCriaturas() = criaturas
}