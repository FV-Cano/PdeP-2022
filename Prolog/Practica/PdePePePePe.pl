% * Base de conocimientos:
%quedaEn(Boliche, Localidad)
quedaEn(pachuli, generalLasHeras).
quedaEn(why, generalLasHeras).
quedaEn(chaplin, generalLasHeras).
quedaEn(masDe40, sanLuis).
quedaEn(qma, caba).

%entran(Boliche, CapacidadDePersonas)
entran(pachuli, 500).
entran(why, 1000).
entran(chaplin, 700).
entran(masDe40, 1200).
entran(qma, 800).

%sirveComida(Boliche)
sirveComida(chaplin).
sirveComida(qma).

% * Tipos de Boliches
%tematico(tematica)
%cachengue(listaDeCancionesHabituales)
%electronico(djDeLaCasa, horaQueEmpieza, horaQueTermina)

%esDeTipo(Boliche, Tipo)
esDeTipo(why, cachengue([elYYo, prrrram, biodiesel, buenComportamiento])).
esDeTipo(masDe40, tematico(ochentoso)).
esDeTipo(qma, electronico(djFenich, 2, 5)).

% * Punto 1:

/*
    esPiola/1: sabemos que un boliche es piola cuando queda en General Las Heras o cuando es grande,
    es decir, entran más de 700 personas. En ambos casos es necesario que sirvan comida.
*/

esPiola(Boliche) :-
    sirveComida(Boliche),
    esPiola_(Boliche).

esPiola_(Boliche) :-
    quedaEn(Boliche, generalLasHeras).

esPiola_(Boliche) :-                            
    entran(Boliche, CapacidadDePersonas),
    CapacidadDePersonas >= 700.

% * Punto 2:

/*
    soloParaBailar/1: un boliche es solo para bailar cuando no sirve comida.
*/

soloParaBailar(Boliche) :-
    quedaEn(Boliche, _),                        
    not(sirveComida(Boliche)).

% * Punto 3:

/*
    podemosIrConEsa/1: cuando decimos que podemos ir con una localidad es porque sabemos que todos sus boliches son piolas.
*/

podemosIrConEsa(Localidad) :-
    quedaEn(_, Localidad),
    forall(quedaEn(Boliche, Localidad), esPiola(Boliche)).

% * Punto 4:

/*
    puntaje/2: nos permite relacionar un boliche con su puntaje. Los boliches de temática ochentosa tienen un puntaje de 9
    mientras que los otros temáticos tienen un puntaje de 7. El puntaje de boliches electrónicos está dado por la suma de
    la hora en que empieza y deja de tocar el DJ. Por último, los de cachengue son un 10 si suelen pasar biodiesel y 
    buenComportamiento pero no sabemos el puntaje de los que no pasan estos temaikenes.
*/

puntaje(Boliche, PuntajeBoliche) :-
    esDeTipo(Boliche, TipoDeBoliche),
    puntajeSegunTipo(TipoDeBoliche, PuntajeBoliche).

puntajeSegunTipo(tematico(ochentoso), 9).
puntajeSegunTipo(tematico(_), 7).
puntajeSegunTipo(electronico(_, HoraInicio, HoraFin), PuntajeBoliche) :-
    PuntajeBoliche is HoraInicio + HoraFin.
puntajeSegunTipo(cachengue(Temaikenes), 10) :-
    member(biodiesel, Temaikenes),
    member(buenComportamiento, Temaikenes).

% * Punto 5:

/*
    elMasGrande/2: el boliche más grande de una localidad es aquel que tiene la mayor capacidad.
*/

elMasGrande(Boliche, Localidad) :-
    quedaEn(Boliche, Localidad),
    forall(quedaEn(OtroBoliche, Localidad), esMasGrande(Boliche, OtroBoliche)).    

esMasGrande(Boliche, OtroBoliche) :-
    entran(Boliche, Capacidad1),
    entran(OtroBoliche, Capacidad2),
    Capacidad1 >= Capacidad2.

% * Punto 6:

/*
    puedeAbastecer/2: una localidad puede abastecer a una determinada cantidad de personas si la 
    suma de capacidades de los boliches que quedan en ella es mayor o igual a esa cantidad. Tener 
    en cuenta que este punto no puede ser totalmente inversible.
*/

puedeAbastecer(Localidad, CantidadPersonas) :-
    quedaEn(_, Localidad),
    capacidadDeLocalidad(Localidad, CapacidadTotal),
    CapacidadTotal >= CantidadPersonas.

capacidadDeLocalidad(Localidad, CapacidadTotal) :-
    findall(Capacidad, (quedaEn(Boliche, Localidad), entran(Boliche, Capacidad)), Capacidades),
    sumlist(Capacidades, CapacidadTotal).

% * Punto 7:

/*
    Parame la música! ¡No pare, sigue sigue! 🎶 Se van a abrir más boliches y nos pidieron que 
    reflejemos esta información en nuestra base de conocimientos:

        "Trabajamos y nos divertimos" será un boliche de temática oficina en el que entran 500 personas. 
        Se va a poder cenar en esta interesante propuesta de Concordia.
        
        "El fin del mundo" será el boliche más austral de la Argentina, con capacidad para 1500 personas. 
        No se va a poder comer pero esto no interesa porque tendrá las vistas más lindas de Ushuaia y al 
        DJ Luis tocando toda la noche: de 00 a 6 de la mañana.
    
        "Misterio" será el boliche más grande de Argentina, con capacidad para 1.000.000 de personas. 
        La verdad es que no sabemos dónde se hará un boliche tan grande pero sí sabemos que se va a poder comer ahí mismo.
*/

quedaEn(trabajamosYNosDivertimos, concordia).
entran(trabajamosYNosDivertimos, 500).
esDeTipo(trabajamosYNosDivertimos, oficina).    
sirveComida(trabajamosYNosDivertimos).          

quedaEn(elFinDelMundo, ushuaia).
entran(elFinDelMundo, 1500).
esDeTipo(elFinDelMundo, electronico(djLuis, 0, 6)).

entran(misterio, 1000000).
sirveComida(misterio).