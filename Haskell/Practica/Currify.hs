import Text.Show.Functions()

-- Parte A --

-- Modelado de canciones

data Cancion = Cancion {
    titulo      :: String,
    genero      :: String,
    duracion    :: Int
} deriving Show


cafeParaDos :: Cancion
cafeParaDos = Cancion {titulo = "Café para dos", genero = "Rock melancólico", duracion = 146}

fuiHastaAhi :: Cancion
fuiHastaAhi = Cancion {titulo = "Fui Hasta Ahí", genero = "Rock", duracion = 279}

rocketRaccoon :: Cancion
rocketRaccoon = Cancion {titulo = "", genero = "", duracion = 0}

mientrasMiBateriaFesteja :: Cancion
mientrasMiBateriaFesteja = Cancion {titulo = "", genero = "", duracion = 0}

tomateDeMadera :: Cancion
tomateDeMadera = Cancion {titulo = "", genero = "", duracion = 0}

teAcordas :: Cancion
teAcordas = Cancion {titulo = "", genero = "", duracion = 0}

unPibeComoVos :: Cancion
unPibeComoVos = Cancion {titulo = "", genero = "", duracion = 0}

daleMechaALaLluvia :: Cancion
daleMechaALaLluvia = Cancion {titulo = "", genero = "", duracion = 0}

-- Modelado de artistas

data Artista = Artista {
    nombre      :: String,
    canciones   :: [Cancion],
    efectoPref  :: Efecto
}

losEscarabajos :: Artista
losEscarabajos = Artista {nombre = "Los Escarabajos", canciones = [rocketRaccoon, mientrasMiBateriaFesteja, tomateDeMadera], efectoPref = acortar}

adela :: Artista
adela = Artista {nombre = "Adela", canciones = [teAcordas, unPibeComoVos, daleMechaALaLluvia], efectoPref = remixar}

elTigreJoaco :: Artista
elTigreJoaco = Artista {nombre = "El tigre Joaco", canciones = [], efectoPref = (acustizar 360)}


type Efecto = Cancion -> Cancion
type Duracion = Int
type Genero = String

-- Modelado de efectos

mapDuracion :: (Int -> Int) -> Cancion -> Cancion
mapDuracion unaFuncion unaCancion = unaCancion {duracion = unaFuncion . duracion $ unaCancion}

mapGenero :: String -> Cancion -> Cancion
mapGenero nuevoGenero unaCancion = unaCancion {genero = nuevoGenero}

acortar :: Efecto
acortar unaCancion 
    | duracion unaCancion > 60 = mapDuracion (60 -) unaCancion
    | otherwise = mapDuracion (*0) unaCancion

remixar :: Efecto
remixar unaCancion = mapGenero "Remixado" . mapDuracion (*2) $ unaCancion {titulo = titulo unaCancion ++ " remix"}

acustizar :: Duracion -> Efecto
acustizar duracionAcustica unaCancion
    |genero unaCancion == "Acústico" = unaCancion
    |otherwise = mapGenero "Acústico" unaCancion {duracion = duracionAcustica}

metaEfecto :: [Efecto] -> Efecto
metaEfecto listaEfectos unaCancion = foldl1 (.) listaEfectos $ unaCancion

-- Parte B --

esCancionCorta :: Cancion -> Bool
esCancionCorta unaCancion = duracion unaCancion < 120

vistazo :: Artista -> [Cancion]
vistazo unArtista = take 3 . filter esCancionCorta . canciones $ unArtista

esCancionDe :: Genero -> Cancion -> Bool
esCancionDe unGenero unaCancion = unGenero == genero unaCancion

playlist :: Genero -> Artista -> [Cancion]
playlist unGenero unArtista = filter (esCancionDe unGenero) . canciones $ unArtista

-- Parte C --

hacerseDJ :: Artista -> Artista
hacerseDJ unArtista = unArtista {canciones = map (efectoPref unArtista) . canciones $ unArtista} 

sonTodosIguales :: Eq a => [a] -> Bool
sonTodosIguales unaLista = all (== head unaLista) unaLista

tieneGustoHomogeneo :: Artista -> Bool
tieneGustoHomogeneo unArtista = sonTodosIguales . map genero . canciones $ unArtista

-- map canciones unArtista

efectoSupremo :: [Efecto] -> Efecto
efectoSupremo unosEfectos unaCancion = foldr ($) unaCancion unosEfectos

formarBanda :: String -> [Artista] -> Artista
formarBanda nombreBanda artistas = Artista {
    nombre      = nombreBanda, 
    canciones   = concatMap canciones artistas, 
    efectoPref  = efectoSupremo . map efectoPref $ artistas
}

rankingDeGeneros :: Genero -> Genero -> Genero
rankingDeGeneros "Reggaeton" unGenero = unGenero
rankingDeGeneros unGenero "Reggaeton" = unGenero
rankingDeGeneros unGenero otroGenero
    |elem "Rock" [unGenero ++ otroGenero] = "Rock"
    |length unGenero > length otroGenero = unGenero
    |otherwise = otroGenero

generoSuperador :: [Genero] -> Genero
generoSuperador [] = ""
generoSuperador (x:[]) = x
generoSuperador (x:y:[]) = rankingDeGeneros x y
generoSuperador (x:y:xs) = rankingDeGeneros (rankingDeGeneros x y) (head xs)

obraMaestraProgresiva :: Artista -> Cancion
obraMaestraProgresiva unArtista = Cancion {
    titulo      = concatMap titulo . canciones $ unArtista,
    duracion    = sum . map duracion . canciones $ unArtista,
    genero      = generoSuperador . map genero . canciones $ unArtista 
}