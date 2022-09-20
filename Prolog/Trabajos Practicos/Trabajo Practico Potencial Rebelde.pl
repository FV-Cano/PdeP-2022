% PUNTO 1 - PERSONAS

persona(bakunin).
persona(ravachol).
persona(rosaDubovsky).
persona(judithButler).
persona(elisaBachofen).
persona(juanSuriano).
persona(emmaGoldman).
persona(sebastienFaure).

trabajo(bakunin, aviacionMilitar).
trabajo(ravachol, inteligenciaMilitar).
trabajo(judithButler, profesoraJudo).
trabajo(judithButler, inteligenciaMilitar).
trabajo(elisaBachofen, ingenieraMecanica).
trabajo(emmaGoldman, profesoraJudo).
trabajo(emmaGoldman, cineasta).

gustos(ravachol, juegosAzar).
gustos(ravachol, ajedrez).
gustos(ravachol, tiroAlBlanco).
gustos(rosaDubovsky, construirPuentes).
gustos(rosaDubovsky, mirarPeppaPig).
gustos(rosaDubovsky, fisicaCuantica).
gustos(judithButler, judo).
gustos(judithButler, carrerasAutomovilismo).
gustos(elisaBachofen, fuego).
gustos(elisaBachofen, destruccion).
gustos(juanSuriano, judo).
gustos(juanSuriano, armarBombas).
gustos(juanSuriano, ringRaje).
gustos(emmaGoldman, Gustos):-
    gustos(judithButler, Gustos).

buenoEn(bakunin, conduciendoAutos).
buenoEn(ravachol, tiroAlBlanco).
buenoEn(rosaDubovsky, construirPuentes).
buenoEn(rosaDubovsky, mirarPeppaPig).
buenoEn(judithButler, judo).
buenoEn(elisaBachofen, armarBombas).
buenoEn(elisaBachofen, judo).
buenoEn(juanSuriano, judo).
buenoEn(juanSuriano, armarBombas).
buenoEn(juanSuriano, ringRaje).
buenoEn(emmaGoldman, Habilidad):-
    buenoEn(judithButler, Habilidad).
buenoEn(emmaGoldman, Habilidad):-
    buenoEn(elisaBachofen, Habilidad).

historialCriminal(bakunin, roboAeronaves).
historialCriminal(bakunin, fraude).
historialCriminal(bakunin, tenenciaCafeina).
historialCriminal(ravachol, falsificacionVacunas).
historialCriminal(ravachol, fraude).
historialCriminal(judithButler, falsificacionCheques).
historialCriminal(judithButler, fraude).
historialCriminal(juanSuriano, falsificacionDinero).
historialCriminal(juanSuriano, fraude).

% PUNTO 2 - VIVIENDAS

ocupante(laSeverino, bakunin).
ocupante(laSeverino, elisaBachofen).
ocupante(laSeverino, rosaDuvobsky).
ocupante(comisaria48, ravachol).
ocupante(casaDePapel, emmaGoldman).
ocupante(casaDePapel, juanSuriano).
ocupante(casaDePapel, judithButler).

%pasadizos(Cantidad).
%cuartosSecretos(Largo, Ancho).
%tunelesSecretos(Metros).
%tunelesEnConstruccion(Metros).

tiene(laSeverino, cuartosSecretos(4, 3)).
tiene(laSeverino, tunelesSecretos(8)).
tiene(laSeverino, tunelesSecretos(5)).
tiene(laSeverino, tunelesEnConstruccion(1)).
tiene(laSeverino, pasadizos(1)).
tiene(casaDePapel, cuartosSecretos(5, 3)).
tiene(casaDePapel, cuartosSecretos(4, 7)).
tiene(casaDePapel, tunelesSecretos(9)).
tiene(casaDePapel, tunelesSecretos(2)).
tiene(casaDePapel, pasadizos(2)).
tiene(casaDelSolNaciente, tunelesEnConstruccion(9)).
tiene(casaDelSolNaciente, pasadizos(1)).


%pasadizos(Cantidad).
%cuartosSecretos(Largo, Ancho).
%tunelesSecretos(Metros).
%tunelesEnConstruccion(Metros).

% PUNTO 3

guaridasRebeldes(Vivienda):-
    viveUnDisidente(Vivienda),
    superficieSospechosa(Vivienda).

viveUnDisidente(Vivienda):-
    ocupante(Vivienda, Ocupante),
    findall(Ocupante, (ocupante(Vivienda, Ocupante), esDisidente(Ocupante)), OcupantesDisidentes),
    length(OcupantesDisidentes, Longitud),
    Longitud > 0.

superficieSospechosa(Vivienda):-
    ocupante(Vivienda, _),
    findall(Area,areaSospechosa(Vivienda,Area), ListaAreas),
    sumlist(ListaAreas, AreaFinal),
    AreaFinal > 50.

areaSospechosa(Vivienda,Area):-
tiene(Vivienda, pasadizos(Area)).

areaSospechosa(Vivienda,Area):-
tiene(Vivienda, cuartosSecretos(Largo, Ancho)),
Area is (Largo * Ancho).

areaSospechosa(Vivienda,Area):-
tiene(Vivienda, tunelesSecretos(Cantidad)),
Area is Cantidad * 2.

% PUNTO 4

viviendaVacia(Vivienda):-
    not(ocupante(Vivienda, _)).

viviendaDeGustoEnComun(Vivienda, Gusto):-
    ocupante(Vivienda, _),
    gustos(_, Gusto),
    forall(ocupante(Vivienda, Persona), gustos(Persona, Gusto)). 

%PUNTO 5

esDisidente(Persona):-
    tenerHabilidadSospechosa(Persona),
    gustosCuestionables(Persona),
    historialAlarmante(Persona).

tenerHabilidadSospechosa(Persona):-
    buenoEn(Persona, armarBombas).
tenerHabilidadSospechosa(Persona):-
    buenoEn(Persona, tiroAlBlanco).
tenerHabilidadSospechosa(Persona):-
    buenoEn(Persona, mirarPeppaPig).

gustosCuestionables(Persona):-
    persona(Persona),
    not(gustos(Persona, _)).
gustosCuestionables(Persona):-
    persona(Persona),
    forall(gustos(Persona, Gusto), buenoEn(Persona, Gusto)).        

historialAlarmante(Persona):-
    historialInteresante(Persona).
historialAlarmante(Persona):-
    viveConDelincuentes(Persona).

historialInteresante(Persona):-
    historialCriminal(Persona, UnaCosa),
    historialCriminal(Persona, OtraCosa),
    UnaCosa \= OtraCosa.

viveConDelincuentes(Persona):-
    ocupante(Vivienda, Persona),
   	ocupante(Vivienda, Persona2),
    Persona \= Persona2,
    historialInteresante(Persona2).

% PUNTO 6

% En el punto 2, gracias a polimorfismo, solo habria que decir qué viviendas tienen bunkers.
% Y ademas, hay que modificar el punto 3 para agregar el calculo de los bunkers que nos da el enunciado (supericie interna + perimetro de acceso).

% PUNTO 7

batallonRebelde(RebeldesOrganizados):-
    findall(Persona, historialAlarmante(Persona), Rebeldes),
    list_to_set(Rebeldes, RebeldesOrganizados),
    tienenMuchasHabilidades(RebeldesOrganizados).

tienenMuchasHabilidades(ListaPersonas):-
    member(_, ListaPersonas),
    findall(Habilidad, buenoEn(_, Habilidad), Habilidades),
    length(Habilidades, Longitud),
    Longitud > 3.