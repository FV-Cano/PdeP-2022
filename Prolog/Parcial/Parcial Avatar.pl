% * Base de conocimientos:
% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).
esPersonaje(cabbageGuy).        % * Solo para pruebas

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).
controla(cabbageGuy, tierra).

% visito/2 relaciona un personaje con un lugar que visitó. 
% Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).

/*  Punto 1:

    saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.
*/

esElAvatar(Personaje) :-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).

/*  Punto 2:

    clasificar a los personajes en 3 grupos:
    un personaje noEsMaestro si no controla ningún  elemento, ni básico ni avanzado;
    un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado;
    un personaje esMaestroAvanzado si controla algún elemento avanzado. Es importante destacar que el avatar 
    también es un maestro avanzado.
*/

noEsMaestro(Personaje) :-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).                % * Más sencillo de realizar sin reutilizar predicados

esMaestroPrincipiante(Personaje) :-
    esPersonaje(Personaje),
    controlaElementoBasico(Personaje),
    not(controlaElementoAvanzado(Personaje)).

controlaElementoBasico(Personaje) :-
    controla(Personaje, Elemento),
    esElementoBasico(Elemento).
controlaElementoAvanzado(Personaje) :-
    controla(Personaje, Elemento),
    elementoAvanzadoDe(_, Elemento).

esMaestroAvanzado(Personaje) :-
    esElAvatar(Personaje).

esMaestroAvanzado(Personaje) :-
    controlaElementoAvanzado(Personaje).

/*  Punto 3:

    saber si un personaje sigueA otro. Diremos que esto sucede si el segundo visitó todos los lugares
    que visitó el primero. También sabemos que zuko sigue a aang.
*/
sigueA(aang, zuko).
sigueA(PersonajeSeguido, PersonajePerseguidor) :-
    esPersonaje(PersonajeSeguido),
    esPersonaje(PersonajePerseguidor),
    forall(visito(PersonajeSeguido, Lugar), visito(PersonajePerseguidor, Lugar)),
    PersonajeSeguido \= PersonajePerseguidor.

% * Suceden cosas extrañas con el predicado de arriba.

/*  Punto 4:

    conocer si un lugar esDignoDeConocer, para lo que sabemos que: todos los templos aire
    son dignos de conocer;
    la tribu agua del norte es digna de conocer;
    ningún lugar de la nación del fuego es digno de ser conocido;
    un lugar del reino tierra es digno de conocer si no tiene muros en su estructura. 
*/

esDignoDeConocer(temploAire(PuntoCardinalDondeSeUbica)) :-
    member(PuntoCardinalDondeSeUbica, [norte, sur, este, oeste]).
esDignoDeConocer(tribuAgua(norte)).
esDignoDeConocer(Lugar) :-
    visito(_, reinoTierra(Lugar, Construcciones)),
    not(member(muro, Construcciones)).

/*  Punto 5:

    definir si un lugar esPopular, lo cual sucede cuando fue visitado por más de 4 personajes. 
*/

esPopular(Lugar) :-
    visito(_, Lugar),                                               
    findall(Visitante, visito(Visitante, Lugar), Visitantes),
    length(Visitantes, CantidadDeVisitantes),
    CantidadDeVisitantes > 4.

/*  Punto 6:

    Por último nos pidieron modelar la siguiente información en nuestra base de conocimientos 
    sobre algunos personajes desbloqueables en el juego:
    bumi es un personaje que controla el elemento tierra y visitó Ba Sing Se en el reino Tierra;
    suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima 
    seguridad en la nación del fuego protegida por 200 soldados. 
*/

esPersonaje(bumi).
controla(bumi, tierra).
visito(bumi, reinoTierra(baSingSe)).                      

esPersonaje(suki).
visito(suki, nacionDelFuego(prisionDeMaximaSeguridad, 200)).

/* El predicado controla/2 no se utiliza con suki debido a que todo lo que no se encuentra en la base de conocimientos
es falso, por lo tanto, no controla ningún elemento. */