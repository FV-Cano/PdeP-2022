-- Estructura de procesador
data Microprocesador = UnMicro {
    memoria         :: [Int],
    acumuladorA     :: Int,
    acumuladorB     :: Int,
    pc              :: Int,
    etiquetaError   :: String
}deriving (Show)

xt8088 :: Microprocesador
xt8088 = UnMicro {
    memoria         = replicate 1024 0,      -- Instanciamos 1024 posiciones en 0
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = ""
}

fp20 :: Microprocesador
fp20 = UnMicro {
    memoria         = replicate 1024 0,      -- Instanciamos 1024 posiciones en 0
    acumuladorA     = 7,
    acumuladorB     = 24,
    pc              = 0,
    etiquetaError   = ""
}

at8086 :: Microprocesador
at8086 = UnMicro {
    memoria         = [1..20],      
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = ""
}

-- Función que aumenta el PC.
incrementarPC :: Instruccion
incrementarPC unMicroprocesador = unMicroprocesador {pc = pc unMicroprocesador + 1}

-- Type alias para más expresividad.
type Posicion = Int
type Valor = Int
type Instruccion = Microprocesador -> Microprocesador

-- Fución para hacer append en una posición específica de la memoria
appendEn :: Posicion -> Valor -> Microprocesador -> [Valor]
appendEn unaPosicion unValor unMicroprocesador  = (take (unaPosicion -1) . memoria $ unMicroprocesador) ++ [unValor] ++ (drop unaPosicion . memoria $ unMicroprocesador) 

-- nop
    -- 
nop :: Instruccion
nop = incrementarPC

add :: Instruccion
add unMicroprocesador = incrementarPC . resetearB . operarDeAaB (+) $ unMicroprocesador
-- str
    -- Guarda el valor unValor en una posicion de la memoria de datos (Recibe valor y posicion)
str :: Posicion -> Valor -> Instruccion
str  unaPosicion unValor unMicroprocesador = incrementarPC unMicroprocesador {memoria = appendEn unaPosicion unValor unMicroprocesador}

-- lod
    -- Carga el acumulador A con el contenido de la memoria de datos en la posición addr (Recibe posicion)
lod :: Posicion -> Instruccion
lod unaPosicion unMicroprocesador = incrementarPC unMicroprocesador {acumuladorA = memoria unMicroprocesador !! (unaPosicion - 1) }

-- lodv
    -- Carga el acumulador A con el valor recibido
lodv :: Valor -> Instruccion 
lodv unValor unMicroprocesador = incrementarPC unMicroprocesador {acumuladorA = unValor} 

-- swap
    -- Intercambia los valores de los acumuladores A y B
swap :: Instruccion
swap unMicroprocesador = incrementarPC unMicroprocesador {acumuladorA = acumuladorB unMicroprocesador, acumuladorB = acumuladorA unMicroprocesador}

-- divide
    -- Divide el acumulador A entre el acumulador B
divide :: Instruccion
divide unMicroprocesador  
    | acumuladorB unMicroprocesador == 0 = incrementarPC unMicroprocesador {etiquetaError = "DIVISION BY ZERO"}
    | otherwise = incrementarPC . resetearB. operarDeAaB div $ unMicroprocesador

resetearB :: Instruccion
resetearB unMicroprocesador = unMicroprocesador {acumuladorB = 0}


operarDeAaB :: (Int -> Int -> Int) -> Instruccion
operarDeAaB funcion unMicroprocesador = unMicroprocesador{acumuladorA = funcion (acumuladorA unMicroprocesador) (acumuladorB unMicroprocesador)}

-- Caso de prueba 4.1 nop . nop . nop $ xt8088
-- Caso de prueba 4.2
    {-                      lodv 5 xt8088
        Procesador fp20:    swap fp20
        Suma:               add . lodv 22 . swap . lodv 10 $ xt8088
    -}
-- Caso de prueba 4.3
    {-  Procesador at8086:  str 2 5 at8086
        lod 2 xt8088
        
        Div':               divide . lod 1 . swap . lod 2 . str 2 0 . str 1 2 $ xt8088
                            divide . lod 1 . swap . lod 2 . str 2 4 . str 1 12 $ xt8088
        
        Division con error: divide . nop . nop . nop . nop . lodv 2 $ xt8088 || divide . nop . nop . lodv 2 . swap . lodv 0 $ xt8088
        Division sin error: divide . nop . nop . lodv 12 . swap . lodv 4 $ xt8088 
    -}