% *Punto 1: Base de conocimientos // Calentando motores

% dodain atiende lunes, miércoles y viernes de 9 a 15.
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

% lucas atiende los martes de 10 a 20
atiende(lucas, martes, 10, 20).

% juanC atiende los sábados y domingos de 18 a 22.
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).

% juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

% leoC atiende los lunes y los miércoles de 14 a 18.
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

% martu atiende los miércoles de 23 a 24.
atiende(martu, miercoles, 23, 24).

% Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:
% - Vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(dodain, Dia, HoraInicio, HoraFin).
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(juanC, Dia, HoraInicio, HoraFin).

% - Nadie está en el mismo horario que leoC.
/*
    Nadie está en el mismo horario que leoC por principio de universo cerrado.
*/

% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles.
/*
    Misma razón, por principio de universo cerrado, todo lo desconocido, se presume falso.
*/

% *Punto 2: Quién atiende el kioskito...

% Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko.
quienAtiende(Persona, Dia, HorarioPuntual):-
    atiende(Persona, Dia, HorarioInicio, HorarioFin),
    between(HorarioInicio, HorarioFin, HorarioPuntual).

% *Punto 3: Forever alone

/* Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. 
En este predicado debe utilizar not/1, y debe ser inversible para relacionar personas. */

atiendeSolo(Persona, Dia, HorarioPuntual):-
    quienAtiende(Persona, Dia, HorarioPuntual),
    not((quienAtiende(OtraPersona, Dia, HorarioPuntual), Persona \= OtraPersona).

% *Punto 4: Posibilidades de atención

% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día.

posibilidadesAtencion(Dia, Personas):-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):- combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):- combinar(PersonasPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento:
/*  - Findall -> Genera un conjunto de soluciones que satisfacen un predicado.
    - Prolog -> Por como funciona el programa, nos permite, mediante su backtracking, encontrar todas las soluciones posibles.
*/

% *Punto 5: Ventas / suertudas

venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebidas(true, 8), bebidas (false, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos(chesterfield, colorado, parisiennes)]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(false, 2), cigarrillos(derby)]).

/* Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. 
Una venta es importante:
    en el caso de las golosinas, si supera los $ 100.
    en el caso de los cigarrillos, si tiene más de dos marcas.
    en el caso de las bebidas, si son alcohólicas o son más de 5.
*/

personaSuertuda(Persona):-
    vendedor(Persona),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).

vendedor(Persona):- venta(Persona, _, _).

ventaImportante(golosinas(Precio)):- Precio > 100.
ventaImportante(cigarrillos(Marcas)):- length(Marcas, CantidadMarcas), CantidadMarcas > 2.
ventaImportante(bebidas(true,_)).
ventaImportante(bebidas(false, Cantidad)):- Cantidad > 5.