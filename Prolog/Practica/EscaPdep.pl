% * Base de conocimientos:
%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).

% * Punto 1:

/*
    nivelDeDificultadDeLaSala/2: para cada sala nos dice su dificultad. Para las salas de experiencia terrorífica 
    el nivel de dificultad es la cantidad de sustos menos la edad mínima para ingresar. Para las de experiencia familiar 
    es 15 si es de una temática futurista y para cualquier otra temática es la cantidad de habitaciones. El de las enigmáticas 
    es la cantidad de candados que tenga.
*/

nivelDeDificultadDeLaSala(Nombre, NivelDificultad) :-
    sala(Nombre, Experiencia),
    dificultadPorExperiencia(Experiencia, NivelDificultad).

dificultadPorExperiencia(terrorifica(CantidadDeSustos, EdadMinima), NivelDificultad) :-
    NivelDificultad is CantidadDeSustos - EdadMinima.
dificultadPorExperiencia(enigmatica(CantidadDeCandados), CantidadDeCandados).
dificultadPorExperiencia(familiar(futurista, _), 15).
dificultadPorExperiencia(familiar(_, CantidadDeHabitaciones), CantidadDeHabitaciones).

% * Punto 2:

/*
    puedeSalir/2: una persona puede salir de una sala si la dificultad de la sala es 1 o si tiene más de 13 años y la dificultad
    es menor a 5. En ambos casos la persona no debe ser claustrofóbica.
*/

puedeSalir(NombrePersona, Sala) :-
    sala(Sala, _).
    persona(NombrePersona, _, Peculiaridades),
    nivelDeDificultadDeLaSala(Sala, NivelDificultad).
    NivelDificultad = 1,
    not(member(claustrofobia, Peculiaridades)).
    
puedeSalir(NombrePersona, Sala) :-
    sala(Sala, _).
    persona(NombrePersona, Edad, Peculiaridades),
    nivelDeDificultadDeLaSala(Sala, NivelDificultad),
    NivelDificultad < 5,
    Edad > 13,
    not(member(claustrofobia, Peculiaridades)).

% * Punto 3:

/*
    tieneSuerte/2: una persona tiene suerte en una sala si puede salir de ella aún sin tener ninguna peculiaridad.
*/

tieneSuerte(NombrePersona, Sala) :-
    persona(NombrePersona, _ ,Peculiaridades),
    length(Peculiaridades, CantidadDePeculiaridades),
    CantidadDePeculiaridades = 0,
    puedeSalir(NombrePersona, Sala).

% * Punto 4:

/*
    esMacabra/1: una empresa es macabra si todas sus salas son de experiencia terrorífica.
*/

esMacabra(Empresa) :-
    esSalaDe(Sala, Empresa),
    sala(Sala, Experiencia),
    forall(Sala, Experiencia = terrorifica()).

%  * Punto 5

/*
    empresaCopada/1: una empresa es copada si no es macabra y el promedio de dificultad de sus salas es menor a 4.
*/

empresaCopada(Empresa) :-
    promedioDificultad(Empresa, Promedio),
    Promedio < 4,
    not(esMacabra(Empresa)).

promedioDificultad(Empresa, Promedio) :-
    esSalaDe(_, Empresa),
    findall(Nivel, (esSalaDe(Sala, Empresa), nivelDeDificultadDeLaSala(Sala, Nivel)), Niveles),
    average(Niveles, Promedio).

average(Lista, Promedio) :-
    sumlist(Lista, Sumatoria),
    length(Lista, Largo),
    Promedio is Sumatoria / Largo.

% * Punto 6:

esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).
esSalaDe(miseriaDeLaNoche, skpista).

sala(estrellasDePelea, familiar(videojuegos, 7)).
sala(miseriaDeLaNoche, terrorifica(150, 21)).