import Text.Show.Functions()

-- Parte A

data Participante = UnParticipante {
    nombre          :: String,
    trucoCocina     :: [Truco],
    especialidad    :: Plato
} deriving Show

data Plato = UnPlato {
    gradoDificultad :: Int,
    ingredientes    :: [Componente]
} deriving Show

type Componente = (String, Int)
type Truco = Plato -> Plato

agregarIngrediente   :: String -> Int -> Plato -> Plato
agregarIngrediente nombreIngrediente cantidad unPlato = unPlato {ingredientes = ingredientes unPlato ++ [(nombreIngrediente, cantidad)]}
mapDificultad        :: (Int -> Int) -> Plato -> Plato
mapDificultad funcion unPlato = unPlato {gradoDificultad = funcion . gradoDificultad $ unPlato}

ingredienteReceta    :: Componente -> String
ingredienteReceta (ingrediente, _) = ingrediente
componenteReceta     :: Componente -> Int
componenteReceta (_, componente) = componente

modificarComponentes :: (Int -> Int) -> Componente -> Componente
modificarComponentes funcion (ingrediente, componentes) = (ingrediente, funcion componentes)  

endulzar :: Int -> Truco
endulzar gramosAzucar unPlato = agregarIngrediente "Azucar" gramosAzucar unPlato

salar :: Int -> Truco
salar gramosSal unPlato = agregarIngrediente "Sal" gramosSal unPlato

darSabor :: Int -> Int -> Truco
darSabor cantidadSal cantidadAzucar unPlato = salar cantidadSal . endulzar cantidadAzucar $ unPlato 

duplicarPorcion :: Truco
duplicarPorcion unPlato = unPlato {ingredientes = map (modificarComponentes (*2)) . ingredientes $ unPlato }

simplificar :: Truco
simplificar unPlato
    |esComplejo unPlato = mapDificultad (const 5) menosComponentes
    |otherwise = unPlato
        where menosComponentes = unPlato {ingredientes = filter ((>= 10) . componenteReceta) . ingredientes $ unPlato}


obtenerIngredientes :: Plato -> [String]
obtenerIngredientes unPlato = map (ingredienteReceta) . ingredientes $ unPlato

esVegano :: Plato -> Bool
esVegano unPlato = any ingredienteVegano . obtenerIngredientes $ unPlato
    where ingredienteVegano "Carne"  = False
          ingredienteVegano "Huevos" = False
          ingredienteVegano "Leche"  = False
          ingredienteVegano _        = True

esSinTacc  :: Plato -> Bool
esSinTacc unPlato = not . any (== "Harina") . obtenerIngredientes $ unPlato

esComplejo :: Plato -> Bool
esComplejo unPlato = ((length . ingredientes $ unPlato) > 5) && ((gradoDificultad unPlato) > 7)

noAptoHipertension :: Plato -> Bool
noAptoHipertension unPlato = any tieneMuchaSal . ingredientes $ unPlato
    where tieneMuchaSal (ingrediente, cantidad) = ingrediente == "Sal" && cantidad > 2

-- Parte B

pepeRonccino     :: Participante
pepeRonccino = UnParticipante "Pepe Ronccino" [darSabor 2 5, simplificar, duplicarPorcion] pizzadePepeRonni

pizzadePepeRonni :: Plato
pizzadePepeRonni = UnPlato 8 [("Harina", 150), ("Huevos", 3), ("Tomate", 30), ("Mozzarella", 60), ("Parmesano", 30), ("Pepperoni", 1500), ("Sal", 35)]

-- Parte C

cocinar :: Participante -> Plato
cocinar unParticipante = foldr ($) platoEspecial todosLosTrucos
    where todosLosTrucos = trucoCocina unParticipante
          platoEspecial = especialidad unParticipante

obtenerComponentes :: Plato -> [Int]
obtenerComponentes unPlato = map (componenteReceta) . ingredientes $ unPlato

esMejorQue :: Plato -> Plato -> Bool
esMejorQue plato1 plato2 = cumpleConDificultad && cumpleConPesos
    where cumpleConDificultad = gradoDificultad plato1 > gradoDificultad plato2
          cumpleConPesos = (sum . obtenerComponentes $ plato1) < (sum . obtenerComponentes $ plato2)

participanteEstrella :: [Participante] -> Participante
participanteEstrella [participante] = participante
participanteEstrella (participante1:participante2:otrosParticipantes)
    |esMejorQue plato1 plato2 = participanteEstrella (participante1:otrosParticipantes)
    |otherwise = participanteEstrella (participante2:otrosParticipantes)
        where plato1 = cocinar participante1
              plato2 = cocinar participante2

-- Parte D

platinum :: Plato
platinum = UnPlato 10 platosInfinitos

platosInfinitos :: [Componente]
platosInfinitos = map platosIncrementales [1..]
    where platosIncrementales componente = ("Ingrediente " ++ (show componente), componente)

{-
    Pregunta: ¿Qué sucede si aplicamos cada uno de los trucos modelados en la Parte A al platinum?
        endulzar: Agregaría sin problemas el ingrediente "Azucar" con la cantidad especificada (aunque este no se podría
        ver debido a que primero debería terminar de mostrar los ingredientes infinitos). El programa no rompe gracias a 
        lazy evaluation pero no termina de ejecutarse. Pasa exactamente lo mismo con "salar" y "darSabor".
        
        duplicarPorcion: Se ejecutaría sin problemas gracias a lazy evaluation pero no terminaría de mostrar los casos.

        simplificar: el programa no rompe pero tampoco devuelve nada. Si bien la condicion de dificultad la cumple, nunca
        termina de evaluar si la lista infinita tiene cantidades que cumplan con la condicion pedida
    
    Pregunta: ¿Cuáles de las preguntas de la Parte A (esVegano, esSinTacc, etc.) se pueden responder sobre el platinum? 
        Solo esVegano.

    Pregunta: ¿Se puede saber si el platinum es mejor que otro plato?
        No se puede, la condición de dificultad la cumple sin problema dado que el grado de dificultad de platinum es el máximo
        sin embargo nunca terminaría de sumar las cantidades de platinum, por lo que no podría devolver el resultado de esa condicion
-}