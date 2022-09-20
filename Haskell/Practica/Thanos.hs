import Text.Show.Functions()

----- Parte 1: -----
-- Punto 1:

data Guantelete = UnGuantelete {
    material    :: String,
    gemas       :: [GemaDelInfinito]
} deriving Show

data Personajes = UnPersonaje {
    nombre      :: String,
    edad        :: Int,
    energia     :: Int,
    habilidades :: [String],
    planeta     :: String
} deriving Show

data Universo = UnUniverso {
    habitantes  :: [Personajes]
} deriving Show

type Habilidad = String


ironMan    :: Personajes
ironMan    = UnPersonaje "Iron Man" 10 20 ["Blaster", "Disparo de pecho"] "Tierra"
drStrange  :: Personajes
drStrange  = UnPersonaje "Dr Stephen Strange" 20 30 ["Portal loco", "Vistazo de realidades", "Darkhold"] "Tierra"
groot      :: Personajes
groot      = UnPersonaje "He's Groot" 30 40 ["Arbol"] "TreeLand"
wolverine  :: Personajes
wolverine  = UnPersonaje "Wolverine" 40 50 ["Garras de adamantium"] "Tierra"
blackWidow :: Personajes
blackWidow = UnPersonaje "Black Widow" 40 50 ["Karate", "usar Mjolnir", "programacion en Haskell"] "Tierra"

universo7  :: Universo
universo7  = UnUniverso [ironMan, drStrange, groot, wolverine, blackWidow]

chasquidoDelUniverso :: Guantelete -> Universo -> Universo
chasquidoDelUniverso unGuantelete unUniverso
    |condicionDeChasquido unGuantelete = efectoDeChasquido unUniverso
    |otherwise = unUniverso

condicionDeChasquido :: Guantelete -> Bool
condicionDeChasquido unGuantelete = (material unGuantelete == "Uru") && ((== 6) . length . gemas $ unGuantelete)
efectoDeChasquido :: Universo -> Universo
efectoDeChasquido unUniverso = unUniverso {habitantes = take (div (length . habitantes $ unUniverso) 2) . habitantes $ unUniverso} 

-- Punto 2:

aptoParaPendex :: Universo -> Bool
aptoParaPendex unUniverso = any (<45) (map edad . habitantes $ unUniverso)

energiaTotal :: Universo -> Int
energiaTotal unUniverso = sum integrantesHabilidosos
    where integrantesHabilidosos = filter (>=2) (map energia . habitantes $ unUniverso)

----- Parte 2: -----
-- Punto 3:

type GemaDelInfinito = Personajes -> Personajes

mapEnergia :: (Int -> Int) -> Personajes -> Personajes
mapEnergia funcion unPersonaje   = unPersonaje {energia = funcion . energia $ unPersonaje}
mapPlaneta :: String -> Personajes -> Personajes
mapPlaneta unPlaneta unPersonaje = unPersonaje {planeta = unPlaneta}


mente   :: Int -> GemaDelInfinito
mente unValor unPersonaje = mapEnergia (subtract unValor) unPersonaje

alma    :: Habilidad -> GemaDelInfinito
alma unaHabilidad unPersonaje = mapEnergia (subtract 10) $ unPersonaje {habilidades = filter (/= unaHabilidad) $ habilidades unPersonaje}

espacio :: String -> GemaDelInfinito
espacio unPlaneta unPersonaje = mapPlaneta unPlaneta unPersonaje

poder   :: GemaDelInfinito
poder unPersonaje
    |(length (habilidades unPersonaje)) <= 2 = mapEnergia (*0) $ unPersonaje {habilidades = []}
    |otherwise = mapEnergia (*0) unPersonaje

tiempo  :: GemaDelInfinito
tiempo unPersonaje = mapEnergia (subtract 50) $ unPersonaje {edad = (max 18 . div (edad unPersonaje)) 2}

gemaLoca :: GemaDelInfinito -> GemaDelInfinito
gemaLoca unaGema unPersonaje = foldl1 (.) (replicate 2 unaGema) unPersonaje

-- Punto 4:

guanteleteDeGoma :: Guantelete
guanteleteDeGoma = UnGuantelete "Goma" [tiempo, alma "usar Mjolnir", gemaLoca (alma "programacion en Haskell")]

usoDeGuanteleteIncompleto :: Guantelete -> Personajes -> Personajes
usoDeGuanteleteIncompleto unGuantelete unPersonaje = foldl1 (.) (gemas unGuantelete) unPersonaje
    -- Ejemplo de uso de guantelete incompleto: usoDeGuanteleteIncompleto guanteleteDeGoma blackWidow

-- Punto 5:

utilizar :: [GemaDelInfinito] -> Personajes -> Personajes
utilizar listaGemas enemigo = foldr ($) enemigo listaGemas                                                          -- foldl1 (.) listagemas enemigo

-- Punto 6:

gemaMasPoderosa   :: Guantelete -> Personajes -> GemaDelInfinito
gemaMasPoderosa unGuantelete unPersonaje = gemaMasPoderosaDe unPersonaje . gemas $ unGuantelete

gemaMasPoderosaDe :: Personajes -> [GemaDelInfinito] -> GemaDelInfinito
gemaMasPoderosaDe _ [] = id
gemaMasPoderosaDe _ [gema] = gema
gemaMasPoderosaDe unPersonaje (gema1:gema2:gemasRestantes)
    |(energia . gema1) unPersonaje > (energia . gema2) unPersonaje = gemaMasPoderosaDe unPersonaje (gema1:gemasRestantes)
    |otherwise = gemaMasPoderosaDe unPersonaje (gema2:gemasRestantes)

-- Punto 7:

infinitasGemas :: GemaDelInfinito -> [GemaDelInfinito]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = UnGuantelete "vesconite" (infinitasGemas tiempo)

punisher :: Personajes
punisher = UnPersonaje "The Punisher" 38 350 ["Disparar con de todo","golpear"] "Tierra" 

usoLasTresPrimerasGemas :: Guantelete -> Personajes -> Personajes
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

{-
    Se podría utilizar gemaMasPoderosa guanteleteDeLocos punisher pero no daría ningún resultado.
    Gracias a lazy evaluation en haskell se puede ejecutar la función sin que el programa rompa, pero nunca devolvería el resultado dado que no podría
    terminar de comparar las infinitas gemas de tiempo.

    Por otro lado, usoLasTresPrimerasGemas guanteleteDeLocos punisher, no solo se ejecuta, sino que también devuelve un valor. También gracias a lazy evaluation,
    haskell es capaz de procesar la función aún cuando la lista de elementos no terminó de instanciarse. Por lo tanto, al ser necesarios los 3 primeros elementos de esa
    lista infinita, con solo tomar estos 3, la función puede dar un resultado.
-}