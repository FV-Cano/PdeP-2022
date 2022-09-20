import Text.Show.Functions()

-- Estructura de procesador
data Microprocesador = UnMicro {
    memoria         :: [Int],
    acumuladorA     :: Int,
    acumuladorB     :: Int,
    pc              :: Int,
    etiquetaError   :: String,
    instrucciones   :: [Instruccion]
}deriving (Show)

xt8088 :: Microprocesador
xt8088 = UnMicro {
    memoria         = replicate 1024 0,      -- Instanciamos 1024 posiciones en 0
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = "",
    instrucciones   = []
}

fp20 :: Microprocesador
fp20 = UnMicro {
    memoria         = replicate 1024 0,      -- Instanciamos 1024 posiciones en 0
    acumuladorA     = 7,
    acumuladorB     = 24,
    pc              = 0,
    etiquetaError   = "",
    instrucciones   = []
}

at8086 :: Microprocesador
at8086 = UnMicro {
    memoria         = [1..20],      
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = "",
    instrucciones   = []
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
operarDeAaB funcion unMicroprocesador = unMicroprocesador {acumuladorA = funcion (acumuladorA unMicroprocesador) (acumuladorB unMicroprocesador)}

-- TP02

-- Carga una lista de instrucciones a un micro
cargarPrograma :: [Instruccion] -> Instruccion
cargarPrograma listaInstrucciones unMicroprocesador = unMicroprocesador {instrucciones = listaInstrucciones}

-- EjecutarPrograma
ejecutarPrograma :: Instruccion
ejecutarPrograma unMicroprocesador = (crearEjecutable (instrucciones unMicroprocesador) unMicroprocesador) unMicroprocesador

-- Crea el ejecutable para correr el programa 
crearEjecutable :: [Instruccion] -> Microprocesador -> Instruccion
crearEjecutable [] _ = id 
crearEjecutable (cabeza:cola) unMicroprocesador | etiquetaError (cabeza unMicroprocesador) == "" = (crearEjecutable cola unMicroprocesador).cabeza
                                                | otherwise = cabeza

-- Verifica si una lista está ordenada
listaOrdenada :: [Int] -> Bool
listaOrdenada []          = True
listaOrdenada ([_])       = True
listaOrdenada (x:y:xs)    = x <= y && listaOrdenada (y:xs) 

-- Le pasa la memoria del microprocesador a la función listaOrdenada
memoriaOrdenada :: Microprocesador -> Bool
memoriaOrdenada unMicroprocesador = listaOrdenada . memoria $ unMicroprocesador 

ifnz :: [Instruccion] -> Instruccion
ifnz unasInstrucciones unMicroprocesador
    | acumuladorA unMicroprocesador /= 0 = crearEjecutable unasInstrucciones unMicroprocesador unMicroprocesador
    | otherwise = unMicroprocesador

depurarMicroprocesador :: Instruccion
depurarMicroprocesador unMicroprocesador =  depurar (instrucciones unMicroprocesador) (vaciarInstrucciones unMicroprocesador) 

--Funciones Auxiliares para la creacion de depurarMicroprocesador

depurar ::  [Instruccion] -> Instruccion
depurar [] unMicroprocesador  = unMicroprocesador
depurar (cabeza:cola) unMicroprocesador 
    | microprocesadorVacio.ejecutarPrograma.agregarInstruccion cabeza $ unMicroprocesador = depurar cola unMicroprocesador
    | otherwise = depurar cola (agregarInstruccion cabeza unMicroprocesador)

vaciarInstrucciones :: Instruccion
vaciarInstrucciones unMicroprocesador = unMicroprocesador {instrucciones = []}

agregarInstruccion :: Instruccion -> Instruccion
agregarInstruccion instruccion unMicroprocesador = mapInstrucciones (++ [instruccion]) unMicroprocesador

mapInstrucciones :: ([Instruccion] -> [Instruccion]) -> Instruccion
mapInstrucciones funcion unMicroprocesador = unMicroprocesador {instrucciones = funcion.instrucciones $ unMicroprocesador}

microprocesadorVacio :: Microprocesador -> Bool
microprocesadorVacio unMicroprocesador = (acumuladorA unMicroprocesador == 0) && (acumuladorB unMicroprocesador == 0) && (all (==0) (memoria unMicroprocesador))

-- 3.6

pInf :: Microprocesador
pInf = UnMicro {
    memoria         = repeat 0,
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = "",
    instrucciones   = []
}

microDesorden :: Microprocesador
microDesorden = UnMicro {
    memoria         = [2,5,1,0,6,9],
    acumuladorA     = 0,
    acumuladorB     = 0,
    pc              = 0,
    etiquetaError   = "",
    instrucciones   = []
}

{-
    1) No debería haber problema realizando una suma debido a que no utilizamos la memoria en ningún momento en la operación.
    Sin embargo, al momento de mostrar el procesador por pantalla, comenzaría a mostrar las infinitas posiciones de memoria.

    2) El programa no rompería, pero nunca terminaría de evaluar la condición.
        
    3) 
        3.1) Debido a que Haskell utiliza lazy evaluation, en el primer caso, la función se encarga primero de realizar la suma
        de los valores de los 2 acumuladores en lugar de precargar la lista de elementos infinitos.

        Prueba de ejemplo: acumuladorA . ejecutarPrograma . cargarPrograma [lodv 22, swap, lodv 10, add] $ pInf

        3.2) Dado que memoriaOrdenada compara la primera posicion de una lista con la siguiente hasta terminarla para verificar el orden,
        y como la lista es infinita, nunca terminaría de ejecutar la instrucción, pero el programa no genera un error gracias a Lazy Evaluation. 
-}

{-
    Casos de prueba:

    4.2) 
        Suma 10 + 22:           ejecutarPrograma . cargarPrograma [lodv 22, swap, lodv 10, add] $ xt8088
        Dividir 2 entre 0:      ejecutarPrograma . cargarPrograma [divide . lod 1 . swap . lod 2 . str 2 0 . str 1 2] $ xt8088

    4.3)
        IFNZ LODV 3 SWAP:       ifnz [lodv 3, swap] fp20 
        IFNZ LODV 3 SWAP:       ifnz [lodv 3, swap] xt8088

    4.4)
                                depurarMicroprocesador . cargarPrograma [swap, nop, lodv 133, lodv 0, str 1 3, str 2 0] $ xt8088

                                Discrepancias con lo pedido
    
    4.5)                        
                                memoriaOrdenada at8086
                                memoriaOrdenada microDesorden
-}