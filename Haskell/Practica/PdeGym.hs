import Text.Show.Functions()

-- Parte A
-- Modelado personas

data Persona = Persona {
    nombre              :: String,
    cantidadCalorias    :: Int,
    indiceHidratacion   :: Int,
    tiempoParaEntrenar  :: Int,
    equipamientos       :: [String]
} deriving Show

type Ejercicio = Persona -> Persona

roca :: Persona
roca = Persona "The Rock" 150 60 120 ["Pesa"]

mapCalorias :: (Int -> Int) -> Persona -> Persona
mapCalorias unaFuncion unaPersona = unaPersona {cantidadCalorias = unaFuncion . cantidadCalorias $ unaPersona}

mapHidratacion :: (Int -> Int) -> Persona -> Persona
mapHidratacion unaFuncion unaPersona = unaPersona {indiceHidratacion = unaFuncion . indiceHidratacion $ unaPersona}

esfuerzo :: Int -> Int -> Int
esfuerzo indiceEsfuerzo repeticiones = indiceEsfuerzo * (div repeticiones 10)

-- Ejercicio

abdominales :: Int -> Ejercicio
abdominales repeticiones unaPersona = mapCalorias (subtract (8*repeticiones)) unaPersona

flexiones :: Int -> Ejercicio
flexiones repeticiones unaPersona =  mapHidratacion (subtract (esfuerzo 2 repeticiones)) . mapCalorias (subtract (16*repeticiones)) $ unaPersona

levantarPesas :: Int -> Int -> Ejercicio
levantarPesas repeticiones peso unaPersona
    |elem "Pesa" . equipamientos $ unaPersona = mapHidratacion (subtract . esfuerzo peso $ repeticiones) . mapCalorias (subtract (32*repeticiones)) $ unaPersona
    |otherwise = unaPersona

laGranHomeroSimpson :: Ejercicio
laGranHomeroSimpson = id

-- Acciones

renovarEquipo :: Persona -> Persona
renovarEquipo unaPersona = unaPersona {equipamientos = map ("Nuevo " ++) . equipamientos $ unaPersona}

volverseYoguista :: Persona -> Persona
volverseYoguista unaPersona = mapHidratacion (min 100 . (2*)) . mapCalorias (flip div 2) $ unaPersona

volverseBodyBuilder :: Persona -> Persona
volverseBodyBuilder unaPersona
    |all (=="Pesa") . equipamientos $ unaPersona = mapCalorias (*3) $ nombreBodyBuilder
    |otherwise = unaPersona
        where nombreBodyBuilder = unaPersona {nombre = nombre unaPersona ++ " BB"}

comerUnSandwich :: Persona -> Persona
comerUnSandwich unaPersona = mapCalorias (+500) . mapHidratacion (const 100) $ unaPersona

-- Parte B

type Rutina = (TiempoAproximadoDuracion, ListaEjercicios)
type TiempoAproximadoDuracion = Int
type ListaEjercicios = [Ejercicio]

hacerRutina :: Rutina -> Persona -> Persona
hacerRutina (tiempoAproximadoDuracion, listaEjercicios) unaPersona
    |tiempoAproximadoDuracion <= tiempoParaEntrenar unaPersona = foldl1 (.) listaEjercicios $ unaPersona
    |otherwise = unaPersona

esPeligrosa :: Rutina -> Persona -> Bool
esPeligrosa unaRutina unaPersona = personaAgotada . hacerRutina unaRutina $ unaPersona

personaAgotada :: Persona -> Bool
personaAgotada unaPersona = (cantidadCalorias unaPersona < 50) && (indiceHidratacion unaPersona < 10)

esBalanceada :: Rutina -> Persona -> Bool
esBalanceada unaRutina unaPersona = (personaBalanceada . cantidadCalorias $ unaPersona) . hacerRutina unaRutina $ unaPersona

personaBalanceada :: Int -> Persona -> Bool
personaBalanceada caloriasIniciales unaPersona = (cantidadCalorias unaPersona < (div caloriasIniciales 2)) && (indiceHidratacion unaPersona > 80)

elAbominableAbdominal :: Rutina
elAbominableAbdominal = (60, map abdominales [1..])
-- Duracion en minutos

-- Parte C

seleccionarGrupoDeEjercicio :: Persona -> [Persona] -> [Persona]
seleccionarGrupoDeEjercicio unaPersona listaPersonas = filter (mismoTiempoDeEntrenamiento unaPersona) $ listaPersonas

mismoTiempoDeEntrenamiento :: Persona -> Persona -> Bool
mismoTiempoDeEntrenamiento unaPersona otraPersona = tiempoParaEntrenar unaPersona == tiempoParaEntrenar otraPersona

promedioDeRutina :: Rutina -> [Persona] -> (Int, Int)
promedioDeRutina unaRutina listaPersonas = calcularPromedio . map (hacerRutina unaRutina) $ listaPersonas

calcularPromedioSegun :: (Persona -> Int) -> [Persona] -> Int
calcularPromedioSegun funcion listaPersonas = div (sum . map funcion $ listaPersonas) (length listaPersonas)

calcularPromedio :: [Persona] -> (Int , Int)
calcularPromedio listaPersonas = (calcularPromedioSegun cantidadCalorias listaPersonas, calcularPromedioSegun indiceHidratacion listaPersonas)