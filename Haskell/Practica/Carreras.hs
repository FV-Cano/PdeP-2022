import Text.Show.Functions()

data Auto = Auto {
    color     :: String,
    velocidad :: Int,
    distancia :: Int
} deriving (Eq, Show)

type Carrera = [Auto]

-- Parte 1

estaCerca :: Auto -> Auto -> Bool
estaCerca unAuto otroAuto = (unAuto /= otroAuto) && abs (distancia unAuto - distancia otroAuto) < 10

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo _ [] = True
vaTranquilo unAuto (x:xs) = not (estaCerca unAuto x) && vaGanando unAuto x && vaTranquilo unAuto xs

{-
    vaTranquilo 2.0

    vaTranquilo :: Auto -> Carrera -> Bool
    vaTranquilo unAuto carrera = (not . any (estaCerca unAuto)) carrera $$ lesVaGanandoATodos unAuto carrera
        where   lesVaGanandoATodos = all (leVaGanando unAuto) . filter (/= unAuto)
                leVaGanando otroAuto = distancia unAuto > distancia otroAuto
-}

vaGanando :: Auto -> Auto -> Bool
vaGanando unAuto otroAuto = distancia unAuto > distancia otroAuto

puesto :: Auto -> Carrera -> Int
puesto _ [] = 1
puesto unAuto (x:xs)
    | vaGanando unAuto x = puesto unAuto xs
    | otherwise = 1 + puesto unAuto xs

{-
    Puesto  2.0

    puesto :: Auto -> Carrera -> Int
    puesto unAuto carrera = (+1) . length . filter (flip leVaGanando unAuto) carrera
-}

-- Parte 2

mapDistancia :: (Int -> Int) -> Auto -> Auto
mapDistancia unaFuncion unAuto = unAuto {distancia = unaFuncion . distancia $ unAuto} 

mapVelocidad :: (Int -> Int) -> Auto -> Auto
mapVelocidad unaFuncion unAuto = unAuto {velocidad = unaFuncion . velocidad $ unAuto}

correPorX :: Int -> Auto -> Auto
correPorX unTiempo unAuto = mapDistancia (+ (unTiempo * velocidad unAuto)) unAuto

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad reduccionVelocidad unAuto 
    |reduccionVelocidad < (velocidad unAuto) = mapVelocidad (abs .(reduccionVelocidad -)) unAuto 
    |otherwise = mapVelocidad (*0) unAuto

-- Parte 3

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not . criterio) lista

type Powerup = Auto -> Carrera -> Carrera

terremoto :: Powerup
terremoto unAuto carrera = afectarALosQueCumplen (estaCerca unAuto) (bajarVelocidad 50) carrera

miguelitos :: Int -> Powerup
miguelitos reduccionVelocidad unAuto carrera = afectarALosQueCumplen (vaGanando unAuto) (bajarVelocidad reduccionVelocidad) carrera


jetPack :: Int -> Powerup
jetPack unTiempo unAuto carrera = afectarALosQueCumplen (== unAuto) (mapVelocidad (flip div 2) . correPorX unTiempo . mapVelocidad (*2)) carrera

-- Parte 4

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, String)]
simularCarrera carrera eventos = (tablaDePosiciones . foldl (flip ($)) carrera) eventos

tablaDePosiciones :: Carrera -> [(Int, String)]
tablaDePosiciones carrera = map (\unAuto -> (puesto unAuto carrera, color unAuto)) carrera

correnTodos :: Int -> Carrera -> Carrera
correnTodos unTiempo carrera = map (correPorX unTiempo) carrera

usaPowerUp :: String -> Powerup -> Carrera -> Carrera
usaPowerUp unColor unPowerUp carrera = unPowerUp (buscarAuto unColor carrera) carrera

buscarAuto :: String -> [Auto] -> Auto
buscarAuto unColor carrera = head . filter ((== unColor).color) $ carrera

-- Simulacion

rojo :: Auto
rojo = Auto {color = "Rojo", velocidad = 120, distancia = 0}

blanco :: Auto
blanco = Auto {color = "Blanco", velocidad = 120, distancia = 0}

azul :: Auto
azul = Auto {color = "Azul", velocidad = 120, distancia = 0}

negro :: Auto
negro = Auto {color = "Negro", velocidad = 120, distancia = 0}

--simularCarrera [rojo, blanco, azul, negro] . reverse $ [correnTodos 30, usaPowerUp "Azul" (jetPack 3), usaPowerUp "Blanco" terremoto, correnTodos 40, usaPowerUp "Blanco" (miguelitos 20), usaPowerUp "Negro" (jetPack 6), correnTodos 40]

-- Parte 5
{-
    5a - Si, la solución actual lo permite, se podría filtrar el color del auto al que se quiere impactar y luego aplicar el efecto en el auto en cuestion.
    5b - La función vaTranquilo no se podría utilizar. La función no podría terminar de evaluar si no tiene autos cerca o si les va ganando a todos porque es una lista infinita.
         Sin embargo, si se podría llamar a la función en consola, y el programa no rompería gracias a lazy evaluation de Haskell.
         De la misma manera, tampoco se podría utilizar la función puesto debido a que se necesitaría saber la cantidad de autos a las que el auto en cuestión le está ganando,
         cantidad que no podría saberse debido a que la lista de autos es infinita.

    5a2.0 - Si el auto no va tranquilo podría terminar la evaluación gracias a any
-}