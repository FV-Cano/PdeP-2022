import Text.Show.Functions()

data Turista = UnTurista {
    cansancio :: Int,
    estres    :: Int,
    viajaSolo :: Bool,
    idiomas   :: [String]
} deriving Show

jorge :: Turista
jorge = UnTurista 10 5 False ["Ingles", "Sueco"]

-- Modelado de excursiones:

type Excursion = Turista -> Turista

mapCansancio     :: (Int -> Int) -> Turista -> Turista
mapCansancio     unaFuncion unTurista = unTurista {cansancio = unaFuncion . cansancio $ unTurista}
mapEstres        :: (Int -> Int) -> Turista -> Turista
mapEstres        unaFuncion unTurista = unTurista {estres = unaFuncion . estres $ unTurista}
aprenderIdioma   :: String -> Turista -> Turista
aprenderIdioma   nuevoIdioma unTurista = unTurista {idiomas = idiomas unTurista ++ [nuevoIdioma]}

irALaPlaya :: Excursion
irALaPlaya unTurista
    |viajaSolo unTurista = mapCansancio (subtract 5) unTurista
    |otherwise = mapEstres (subtract 1) unTurista

apreciarElementoPaisaje :: String -> Excursion
apreciarElementoPaisaje elemento unTurista = mapEstres (subtract (length elemento)) unTurista

hablarIdioma :: String -> Excursion
hablarIdioma idioma unTurista = aprenderIdioma idioma unTurista {viajaSolo = False}

caminar :: Int -> Excursion
caminar minutos unTurista = mapEstres (subtract minutos) . mapCansancio (+ minutos) $ unTurista

paseoEnBarco :: String -> Excursion
paseoEnBarco "Fuerte" unTurista     = mapEstres (+6) . mapCansancio (+10) $ unTurista
paseoEnBarco "Moderada" unTurista   = id unTurista
paseoEnBarco "Tranquila" unTurista  = hablarIdioma "Aleman" . apreciarElementoPaisaje "mar" . caminar 10 $ unTurista
paseoEnBarco _ unTurista            = id unTurista

-- 1: Modelado de turistas

ana :: Turista
ana = UnTurista 0 21 False ["Español"]
beto :: Turista
beto = UnTurista 15 15 True ["Aleman"]
cathi :: Turista
cathi = UnTurista 15 15 True ["Aleman", "Catalan"]

-- 2a:

hacerExcursion :: Turista -> Excursion -> Turista
hacerExcursion unTurista unaExcursion = mapEstres (subtract(div porcentaje 100)) . unaExcursion $ unTurista
    where porcentaje = estres unTurista * 10

-- 2b:
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

-- deltaExcursionSegun índice turista excursion
deltaExcursionSegun :: (Turista -> Int) -> Turista -> Excursion -> Int
deltaExcursionSegun unIndice unTurista unaExcursion = deltaSegun unIndice unTurista (hacerExcursion unTurista unaExcursion)

-- 2c:
esExcursionEducativa :: Turista -> Excursion -> Bool
esExcursionEducativa unTurista unaExcursion = (>0) . deltaExcursionSegun (length . idiomas) unTurista $ unaExcursion

esSituacionEstresante :: Turista -> Excursion -> Bool
esSituacionEstresante unTurista unaExcursion = (>= 3) . deltaExcursionSegun estres unTurista $ unaExcursion

-- 3:

type Tour = [Excursion]

completo :: Tour
completo = [caminar 20, apreciarElementoPaisaje "Cascada", caminar 40, irALaPlaya, hablarIdioma "Melmacquiano"]
ladoB :: Excursion -> Tour
ladoB excursionElegida = [paseoEnBarco "Tranquila", excursionElegida, caminar 120] 
islaVecina :: String -> Tour
islaVecina "Fuerte" = [paseoEnBarco "Fuerte", apreciarElementoPaisaje "Lago", paseoEnBarco "Fuerte"]
islaVecina marea = [paseoEnBarco marea , irALaPlaya, paseoEnBarco marea]

hacerTour :: Turista -> Tour -> Turista
hacerTour unTurista unTour = realizarExcursiones . mapEstres (+(length unTour)) $ unTurista
    where realizarExcursiones = foldl1 (.) (reverse unTour)


tourConvincente :: [Tour] -> Turista -> Bool
tourConvincente tours unTurista = any (esConvincente unTurista) tours

esConvincente :: Turista -> Tour -> Bool
esConvincente unTurista unTour = any (dejaAcompaniado unTurista) . excursionesDesestresantes unTurista $ unTour

dejaAcompaniado :: Turista -> Excursion -> Bool
dejaAcompaniado unTurista unaExcursion = not . viajaSolo . hacerExcursion unTurista $ unaExcursion

excursionesDesestresantes :: Turista -> Tour -> Tour
excursionesDesestresantes unTurista unTour = filter (not . esSituacionEstresante unTurista) unTour

efectividadTour :: Tour -> [Turista] -> Int
efectividadTour unTour turistas = sum . map (espiritualidadRecibida unTour) $ turistasConvencidos
    where turistasConvencidos = filter (tourConvincente [unTour]) turistas

espiritualidadRecibida :: Tour -> Turista  -> Int
espiritualidadRecibida unTour unTurista  = espiritualidadSegun estres + espiritualidadSegun cansancio
    where espiritualidadSegun criterio = sum . map (deltaExcursionSegun criterio unTurista) $ unTour

-- 4:

playasInfinitas :: Tour
playasInfinitas = repeat irALaPlaya

{-
    4b: Sería imposible saber si el tour es convincente tanto para Ana como para Beto. Pese a que se puede llamar a la función, y esta no va a romper
    gracias a lazy evaluation, el programa nunca terminaría de filtrar qué excursiones son estresantes para un turista. Por tanto nunca podría verificar
    si el tour es convincente o not
    4c: No, sólo se podría conocer la efectividad del tour si la lista de turistas es vacía, que dará siempre 0. 
-}