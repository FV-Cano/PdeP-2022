% * Base de conocimientos

% vocaloid(nombre)
vocaloid(megurineLuka).
vocaloid(hatsuneMiku).
vocaloid(gumi).
vocaloid(seeU).
vocaloid(kaito).

% cancion(nombre, minutos)
cancion(nightFever, 4).
cancion(foreverYoung, 5).
cancion(tellYourWorld, 4).
cancion(novemberRain, 6).

% canta(vocaloid, cancion).
canta(megurineLuka, nightFever).
canta(megurineLuka, foreverYoung).
canta(hatsuneMiku, tellYourWorld).
canta(gumi, foreverYoung).
canta(gumi, tellYourWorld).
canta(seeU, novemberRain).
canta(seeU, nightFever).

% * Punto 1:
/*
    un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo
    total que duran todas las canciones debería ser menor a 15.
*/

esNovedoso(Vocaloid) :-
    vocaloid(Vocaloid),
    sabe2Canciones(Vocaloid),
    duracionNovedosa(Vocaloid).

sabe2Canciones(Vocaloid) :-
    canta(Vocaloid, UnaCancion),
    canta(Vocaloid, OtraCancion),
    UnaCancion \= OtraCancion.
duracionNovedosa(Vocaloid) :-
    listaDeCanciones(Vocaloid, DuracionCanciones),
    duracionTotal(DuracionCanciones, DuracionTotal),
    DuracionTotal < 15.

% * Punto 2:
/*
    un cantante es acelerado, condición que se da cuando todas sus canciones duran 4
    minutos o menos. Resolver sin usar forall/2.
*/

esAcelerado(Vocaloid) :-
    canta(Vocaloid, _),
    not((tiempoDeCancion(Vocaloid, TiempoCancion), TiempoCancion > 4)).

tiempoDeCancion(Vocaloid, TiempoCancion) :-
    canta(Vocaloid, Cancion),
    cancion(Cancion, TiempoCancion).

/*  Tipos de concierto:

        gigante(cantidadMinimaCanciones, duracionTotalEspecífica).
        mediano(duracionTotalEspecifica).
        pequeño(duracionEspecifica).
*/

% * Conciertos:

% concierto(nombreConcierto, gigante(canciones, duracion), localizacion, fama)
concierto(mikuExpo, gigante(2,6), estadosUnidos, 2000).
concierto(magicalMirai, gigante(3, 10), japon, 3000).
concierto(vocalektVisions, mediano(9), estadosUnidos, 1000).
concierto(mikuFest, pequenio(4), argentina, 100).

listaDeCanciones(Vocaloid, CantidadDeCanciones) :-
    findall(Duracion, (canta(Vocaloid, Cancion), cancion(Cancion, Duracion)), CantidadDeCanciones).
duracionTotal(Canciones, DuracionTotal) :-
    sumlist(Canciones, DuracionTotal).

puedeParticiparEnConcierto(Vocaloid, NombreConcierto) :-
    vocaloid(Vocaloid),
    concierto(NombreConcierto, TipoConcierto, _, _),
    cumpleConRequisitos(Vocaloid, TipoConcierto).

cumpleConRequisitos(Vocaloid, gigante(CantidadCancionesRequerida, DuracionTotalRequerida)) :-
    listaDeCanciones(Vocaloid, Canciones),
    length(Canciones, CantidadDeCanciones),
    duracionTotal(Canciones, DuracionTotal),
    CantidadDeCanciones >= CantidadCancionesRequerida,
    DuracionTotal >= DuracionTotalRequerida.

cumpleConRequisitos(Vocaloid, mediano(DuracionTotalRequerida)) :-
    listaDeCanciones(Vocaloid, Canciones),
    duracionTotal(Canciones, DuracionTotal),
    DuracionTotal >= DuracionTotalRequerida.

cumpleConRequisitos(Vocaloid, pequenio(DuracionUnicaRequerida)) :-
    canta(Vocaloid, NombreCancion),
    cancion(NombreCancion, Duracion),
    Duracion > DuracionUnicaRequerida.

mikuPuedeConTodo() :-
    forall(concierto(NombreConcierto, _ ,_, _), puedeParticiparEnConcierto(hatsuneMiku, NombreConcierto)).

% * Fama:

famaTotal(Vocaloid, FamaTotal) :-
    famaDeConciertos(Vocaloid, FamaConciertos),
    listaDeCanciones(Vocaloid, ListaDeCanciones),
    length(ListaDeCanciones, CantidadDeCanciones),
    FamaTotal is FamaConciertos * CantidadDeCanciones.

famaDeConciertos(Vocaloid, FamaConciertos) :-
    vocaloid(Vocaloid),
    findall(FamaConcierto, (concierto(NombreConcierto, _, _, FamaConcierto), puedeParticiparEnConcierto(Vocaloid, NombreConcierto)), ListaFama),
    sumlist(ListaFama, FamaConciertos).

vocaloidMasFamoso(Vocaloid) :-
    vocaloid(Vocaloid),
    famaTotal(Vocaloid, FamaTotal1),
    forall(famaTotal(_, FamaTotal2), FamaTotal1 >= FamaTotal2).

% * Conocidos:

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipanteEnConcierto(Cantante, NombreConcierto):- 
    puedeParticiparEnConcierto(Cantante, NombreConcierto),
	not((conocido(Cantante, OtroCantante), puedeParticiparEnConcierto(OtroCantante, NombreConcierto))).

%Conocido directo
conocido(Cantante, OtroCantante) :- 
conoce(Cantante, OtroCantante).

%Conocido indirecto
conocido(Cantante, OtroCantante) :- 
conoce(Cantante, UnCantante), 
conocido(UnCantante, OtroCantante).

% * Punto 5:
/*
    Por supuesto habría que agregar ese concierto a la base de datos. Dejando eso de lado, habría que
    agregar un nuevo predicado de cumpleConRequisitos\2 para que pueda, mediante pattern matching,
    "encajar" con este nuevo tipo. Más allá del desarrollo de este nuevo "tipo", no habría que realizar
    nada más.
*/