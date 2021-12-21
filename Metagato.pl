%===================================================================
% García Tello Axel
% Proyecto. Metagato
% Construya un agente Prolog para jugar Metagato contra un oponente
% humano...
% Las reglas son exactamente las mismas que el Metagato tradicional.
% Existe una regla diferente al juego tradicional...
% Cada jugador, en su turno, DEBE tirar, forzosamente, en el tablero
% dentro de la casilla mayor, correspondiente a la casilla menor
% donde su oponente acaba de tirar.
%
% Predicados relevantes:
%   valor_tablero(<Tablero>,<TableroGrande>,<Valor>).
%   siguiente_analisis(<Analisis>,<AnalisisValido>).
%   max(<Tablero>,<TableroGrande>,<Lugar>,<Analisis>,<Profundidad>,
%       <AEntrada>,<BEntrada>,<TableroResultado>,
%       <TableroGrandeResultado>,<JugadaResultado>,<ASalida>,
%       <BSalida>).
%   min(<Tablero>,<TableroGrande>,<Lugar>,<Analisis>,<Profundidad>,
%       <AEntrada>,<BEntrada>,<TableroResultado>,
%       <TableroGrandeResultado>,<JugadaResultado>,<ASalida>,
%       <BSalida>).
% iniciar_juego().
%===================================================================

%===================================================================
% Base de conocimiento.
% profundidad/1.
% Establece la profundidad de las jugadas a evaluar.
%===================================================================

profundidad(5).
:- dynamic(profundidad/1).

%===================================================================
% bloqueo/3.
% Indica los casos donde la linea de juego a sido bloqueada.
%===================================================================

bloqueo("x","o",_):-!.
bloqueo("x",_,"o"):-!.
bloqueo("o","x",_):-!.
bloqueo(_,"x","o"):-!.
bloqueo("o",_,"x"):-!.
bloqueo(_,"o","x"):-!.
bloqueo("x","x","."):-!.
bloqueo("x",".","x"):-!.
bloqueo(".","x","x"):-!.
bloqueo("o","o","."):-!.
bloqueo("o",".","o"):-!.
bloqueo(".","o","o"):-!.
bloqueo("x",".","."):-!.
bloqueo(".","x","."):-!.
bloqueo(".",".","x"):-!.
bloqueo("o",".","."):-!.
bloqueo(".","o","."):-!.
bloqueo(".",".","o"):-!.

%===================================================================
% igual/2.
% Indica si 2 elementos son iguales.
%===================================================================

igual(X,X).

%===================================================================
% imprimir_tablero/1.
% Imprime el tablero ingresado.
%===================================================================

imprimir_tablero([[J11,J12,J13,J14,J15,J16,J17,J18,J19],
                  [J21,J22,J23,J24,J25,J26,J27,J28,J29],
                  [J31,J32,J33,J34,J35,J36,J37,J38,J39],
                  [J41,J42,J43,J44,J45,J46,J47,J48,J49],
                  [J51,J52,J53,J54,J55,J56,J57,J58,J59],
                  [J61,J62,J63,J64,J65,J66,J67,J68,J69],
                  [J71,J72,J73,J74,J75,J76,J77,J78,J79],
                  [J81,J82,J83,J84,J85,J86,J87,J88,J89],
                  [J91,J92,J93,J94,J95,J96,J97,J98,J99]]):-
    write(J11),write(J12),write(J13),write("|"),write(J21),write(J22),write(J23),write("|"),write(J31),write(J32),write(J33),write("\n"),
    write(J14),write(J15),write(J16),write("|"),write(J24),write(J25),write(J26),write("|"),write(J34),write(J35),write(J36),write("\n"),
    write(J17),write(J18),write(J19),write("|"),write(J27),write(J28),write(J29),write("|"),write(J37),write(J38),write(J39),write("\n"),
    write("---+---+---\n"),
    write(J41),write(J42),write(J43),write("|"),write(J51),write(J52),write(J53),write("|"),write(J61),write(J62),write(J63),write("\n"),
    write(J44),write(J45),write(J46),write("|"),write(J54),write(J55),write(J56),write("|"),write(J64),write(J65),write(J66),write("\n"),
    write(J47),write(J48),write(J49),write("|"),write(J57),write(J58),write(J59),write("|"),write(J67),write(J68),write(J69),write("\n"),
    write("---+---+---\n"),
    write(J71),write(J72),write(J73),write("|"),write(J81),write(J82),write(J83),write("|"),write(J91),write(J92),write(J93),write("\n"),
    write(J74),write(J75),write(J76),write("|"),write(J84),write(J85),write(J86),write("|"),write(J94),write(J95),write(J96),write("\n"),
    write(J77),write(J78),write(J79),write("|"),write(J87),write(J88),write(J89),write("|"),write(J97),write(J98),write(J99),write("\n").

%===================================================================
% elemento/3.
% Dada una lista, nos devuelve el n elemento seleccionado.
%===================================================================

elemento([X|_],1,X):- !.
elemento([_|R],N,S):- N2 is N-1,
                      elemento(R,N2,S).

%===================================================================
% sustituir/4.
% Dada una lista, sustituye su n elemento por otro elemento
% ingresado.
%===================================================================

sustituir([_|R],1,Y,[Y|R]):- !.
sustituir([X|R],N,Y,[X|S]):- N2 is N-1,
                             sustituir(R,N2,Y,S).

%===================================================================
% empate/1.
% Verifica si el juego de gato normal termina en un empate.
%===================================================================

empate([J1,J2,J3,J4,J5,J6,J7,J8,J9]):-
    bloqueo(J1,J2,J3),
    bloqueo(J4,J5,J6),
    bloqueo(J7,J8,J9),
    bloqueo(J1,J4,J7),
    bloqueo(J2,J5,J8),
    bloqueo(J3,J6,J9),
    bloqueo(J1,J5,J9),
    bloqueo(J3,J5,J7).

%===================================================================
% gana_mini/2.
% Indica si el jugador seleccionado a ganado.
%===================================================================

gana_mini([J1,J2,J3,J4,J5,J6,J7,J8,J9],Jugador):-
    (igual(Jugador,J1),igual(Jugador,J2),igual(Jugador,J3)),!;
    (igual(Jugador,J4),igual(Jugador,J5),igual(Jugador,J6)),!;
    (igual(Jugador,J7),igual(Jugador,J8),igual(Jugador,J9)),!;
    (igual(Jugador,J1),igual(Jugador,J4),igual(Jugador,J7)),!;
    (igual(Jugador,J2),igual(Jugador,J5),igual(Jugador,J8)),!;
    (igual(Jugador,J3),igual(Jugador,J6),igual(Jugador,J9)),!;
    (igual(Jugador,J1),igual(Jugador,J5),igual(Jugador,J9)),!;
    (igual(Jugador,J3),igual(Jugador,J5),igual(Jugador,J7)),!.

%===================================================================
% jugada/7.
% Realiza la jugada indicada. En caso de no ser una jugada posible
% devuelve false.
% Los parámetros indican el jugador que realizo la jugada, el lugar
% donde se esta jugando, la posición donde se coloca el simbolo,
% el tablero de juego, el tablero de juego grande y el número
% tablero de juego y tablero de juego grande que se genero con esta
% jugada.
%===================================================================

jugada(Jugador,Lugar,Numero,Tablero,BTablero,NTablero,NBTablero):-
    elemento(Tablero,Lugar,MiniTablero),
    elemento(MiniTablero,Numero,Jugada),
    Jugada =:= " ",
    sustituir(MiniTablero,Numero,Jugador,NMiniTablero),
    (empate(NMiniTablero)->
        (
            sustituir(Tablero,Lugar,[".",".",".",".",".",".",".",".","."],NTablero),
            sustituir(BTablero,Lugar,".",NBTablero)
        );
        (
            gana_mini(NMiniTablero,Jugador)->
            (
                sustituir(Tablero,Lugar,[Jugador,Jugador,Jugador,Jugador,Jugador,Jugador,Jugador,Jugador,Jugador],NTablero),
                sustituir(BTablero,Lugar,Jugador,NBTablero)
            );
            (
                sustituir(Tablero,Lugar,NMiniTablero,NTablero),
                igual(BTablero,NBTablero)
            )
        )
    ).

%===================================================================
% validar_lugar/3.
% Verifica si el tablero en donde el contrincante debe realizar su
% jugada, sea un tablero jugable; es decir, que no se haya ganado o
% empatado.
% En caso de ser un tablero no jugable, lo envía al siguiente
% tablero.
%===================================================================

validar_lugar(BTablero,Numero,NNumero):-
    elemento(BTablero,Numero,Casilla),
    (igual(Casilla," ")->
        NNumero is Numero;
        (
            igual(Numero,9)->
                validar_lugar(BTablero,1,NNumero);
                (
                    N2 is Numero+1,
                    validar_lugar(BTablero,N2,NNumero)
                )
        )
    ).

%===================================================================
% mi_valor/2.
% Establece cuantas rutas libres tiene nuestro agente jugador para
% ganar.
%===================================================================

mi_valor([J1,J2,J3,J4,J5,J6,J7,J8,J9],Valor):-
    V1 is 0,
    (
        (igual(J1,"x");igual(J2,"x");igual(J3,"x");igual(J1,".");igual(J2,".");igual(J3,"."))->
            V2 is V1+0;
            V2 is V1+1
    ),
    (
        (igual(J4,"x");igual(J5,"x");igual(J6,"x");igual(J4,".");igual(J5,".");igual(J6,"."))->
            V3 is V2+0;
            V3 is V2+1
    ),
    (
        (igual(J7,"x");igual(J8,"x");igual(J9,"x");igual(J7,".");igual(J8,".");igual(J9,"."))->
            V4 is V3+0;
            V4 is V3+1
    ),
    (
        (igual(J1,"x");igual(J4,"x");igual(J7,"x");igual(J1,".");igual(J4,".");igual(J7,"."))->
            V5 is V4+0;
            V5 is V4+1
    ),
    (
        (igual(J2,"x");igual(J5,"x");igual(J8,"x");igual(J2,".");igual(J5,".");igual(J8,"."))->
            V6 is V5+0;
            V6 is V5+1
    ),
    (
        (igual(J3,"x");igual(J6,"x");igual(J9,"x");igual(J3,".");igual(J6,".");igual(J9,"."))->
            V7 is V6+0;
            V7 is V6+1
    ),
    (
        (igual(J1,"x");igual(J5,"x");igual(J9,"x");igual(J1,".");igual(J5,".");igual(J9,"."))->
            V8 is V7+0;
            V8 is V7+1
    ),
    (
        (igual(J3,"x");igual(J5,"x");igual(J7,"x");igual(J3,".");igual(J5,".");igual(J7,"."))->
            V9 is V8+0;
            V9 is V8+1
    ),
    Valor is V9.

%===================================================================
% valor_contrincante/2.
% Establece cuantas rutas libres tiene nuestro contrincante para
% ganar.
%===================================================================

valor_contrincante([J1,J2,J3,J4,J5,J6,J7,J8,J9],Valor):-
    V1 is 0,
    (
        (igual(J1,"o");igual(J2,"o");igual(J3,"o");igual(J1,".");igual(J2,".");igual(J3,"."))->
            V2 is V1+0;
            V2 is V1+1
    ),
    (
        (igual(J4,"o");igual(J5,"o");igual(J6,"o");igual(J4,".");igual(J5,".");igual(J6,"."))->
            V3 is V2+0;
            V3 is V2+1
    ),
    (
        (igual(J7,"o");igual(J8,"o");igual(J9,"o");igual(J7,".");igual(J8,".");igual(J9,"."))->
            V4 is V3+0;
            V4 is V3+1
    ),
    (
        (igual(J1,"o");igual(J4,"o");igual(J7,"o");igual(J1,".");igual(J4,".");igual(J7,"."))->
            V5 is V4+0;
            V5 is V4+1
    ),
    (
        (igual(J2,"o");igual(J5,"o");igual(J8,"o");igual(J2,".");igual(J5,".");igual(J8,"."))->
            V6 is V5+0;
            V6 is V5+1
    ),
    (
        (igual(J3,"o");igual(J6,"o");igual(J9,"o");igual(J3,".");igual(J6,".");igual(J9,"."))->
            V7 is V6+0;
            V7 is V6+1
    ),
    (
        (igual(J1,"o");igual(J5,"o");igual(J9,"o");igual(J1,".");igual(J5,".");igual(J9,"."))->
            V8 is V7+0;
            V8 is V7+1
    ),
    (
        (igual(J3,"o");igual(J5,"o");igual(J7,"o");igual(J3,".");igual(J5,".");igual(J7,"."))->
            V9 is V8+0;
            V9 is V8+1
    ),
    Valor is V9.

%===================================================================
% valor/2.
% Calcula el valor de un juego de gato.
%===================================================================

valor(MiniTablero,Valor):-
    mi_valor(MiniTablero,V1),
    valor_contrincante(MiniTablero,V2),
    Valor is V1 - V2.

%===================================================================
% calcularValor/3.
% Calcula y suma los valores de los juegos de gato que componen al
% metagato (pero solo los que no han sido ganados o empetados).
%===================================================================

calcularValor([],[],0).
calcularValor([Mini|Resto],[Jugada|Resto2],Valor):-
    calcularValor(Resto,Resto2,V1),
    (igual(Jugada," ")->
        (
            valor(Mini,V2),
            Valor is V1 + V2
        );
        Valor is V1
    ).

%===================================================================
% valor_tablero/3.
% Evalua el tablero completo y el tablero grande para determinal su
% valor.
%===================================================================

valor_tablero(Tablero,BTablero,Valor):-
    calcularValor(Tablero,BTablero,V1),
    valor(BTablero,V2),
    V3 is 10*V2,
    Valor is V1+V3.

%===================================================================
% siguiente_analisis
% Establece cual es la siguiente jugada a analizar.
% Primero analizamos la jugada central, despues las de las esquinas
% y por ultimo las jugadas de las aristas.
%===================================================================

siguiente_analisis(E,S):-
    igual(5,E), S is 1,!;
    igual(1,E), S is 3,!;
    igual(3,E), S is 7,!;
    igual(7,E), S is 9,!;
    igual(9,E), S is 2,!;
    igual(2,E), S is 4,!;
    igual(4,E), S is 6,!;
    igual(6,E), S is 8,!.

%===================================================================
% max/12.
% Analiza las jugadas cuando el agente jugador tiene el turno.
% El primer parámetro tenemos el tablero de juego.
% El segundo parámetro es el tablero del juego grande.
% El tercer parámtero es el gato donde se esta llevando la jugada
% El cuarto parámetro es el lugar donde se realizara y analizara
% la jugada.
% El quinto parámetro es la profundidad de analisis.
% El sexto y septimo parámetro son las podas a y B de entrada.
% El octavo, noveno y decimo parámetro son el tablero completo, el
% tablero grande y la jugada realizada que resulto más optima.
% Los ultimos dos parámetros son las cotas a y B de salida.
%===================================================================

max(Tablero,BTablero,Lugar,Analisis,Prof,AE,BE,RT,RBT,RJ,AS,BS):-
    (jugada("o",Lugar,Analisis,Tablero,BTablero,T1,BT1)->
        (
            (
                gana_mini(BT1,"o")->
                (
                    Valor1 is 250
                );
                (
                    empate(BT1)->
                    (
                        Valor1 is 0
                    );
                    (
                        elemento(T1,Lugar,MiniTablero),
                        (
                            gana_mini(MiniTablero,"o")->
                            (
                                Valor1 is 200
                            );
                            (
                                empate(MiniTablero)->
                                (
                                    Valor1 is 0
                                );
                                (
                                    profundidad(Prof)->
                                    (
                                        valor_tablero(T1,BT1,Valor1)
                                    );
                                    (
                                        Prof2 is Prof + 1,
                                        validar_lugar(BT1,Analisis,NNumero),
                                        min(T1,BT1,NNumero,5,Prof2,AE,BE,_,_,_,_,Valor1)
                                    )
                                )
                            )
                        )
                    )
                )
            ),
            (
                (
                    Valor1 > AE ->
                        A is Valor1;
                        A is AE
                ),
                (
                    A > BE ->
                    (
                        AS is A,
                        BS is BE,
                        igual(T1,RT),
                        igual(RBT,BT1),
                        RJ is Analisis
                    );
                    (
                        igual(Analisis,8)->
                        (
                            AS is A,
                            BS is BE,
                            igual(T1,RT),
                            igual(BT1,RBT),
                            RJ is Analisis
                        );
                        (
                            siguiente_analisis(Analisis,NAnalisis),
                            max(Tablero,BTablero,Lugar,NAnalisis,Prof,A,BE,T2,BT2,J2,Valor2,_),
                            (
                                Valor2 > A ->
                                (
                                    AS is Valor2,
                                    BS is BE,
                                    igual(T2,RT),
                                    igual(BT2,RBT),
                                    RJ is J2
                                );
                                (
                                    AS is A,
                                    BS is BE,
                                    igual(T1,RT),
                                    igual(BT1,RBT),
                                    RJ is Analisis
                                )
                            )
                        )
                    )
                )
            )
        );
        (
            igual(Analisis,8)->
            (
                AS is AE,
                BS is BE
            );
            (
                siguiente_analisis(Analisis,NAnalisis),
                max(Tablero,BTablero,Lugar,NAnalisis,Prof,AE,BE,RT,RBT,RJ,AS,BS)
            )
        )
    ).

%===================================================================
% min/11.
% Analiza las jugadas cuando el agente humano tiene el turno.
% El primer parámetro tenemos el tablero de juego.
% El segundo parámetro es el tablero del juego grande.
% El tercer parámtero es el gato donde se esta llevando la jugada
% El cuarto parámetro es el lugar donde se realizara y analizara
% la jugada.
% El quinto parámetro es la profundidad de analisis.
% El sexto y septimo parámetro son las podas a y B de entrada.
% El octavo, noveno y decimo parámetro son el tablero completo, el
% tablero grande y la jugada realizada que resulto más optima.
% Los ultimos dos parámetros son las cotas a y B de salida.
%===================================================================

min(Tablero,BTablero,Lugar,Analisis,Prof,AE,BE,RT,RBT,RJ,AS,BS):-
    (jugada("x",Lugar,Analisis,Tablero,BTablero,T1,BT1)->
        (
            (
                gana_mini(BT1,"x")->
                (
                    Valor1 is -250
                );
                (
                    empate(BT1)->
                    (
                        Valor1 is 0
                    );
                    (
                        elemento(T1,Lugar,MiniTablero),
                        (
                            gana_mini(MiniTablero,"x")->
                            (
                                Valor1 is -200
                            );
                            (
                                empate(MiniTablero)->
                                (
                                    Valor1 is 0
                                );
                                (
                                    profundidad(Prof)->
                                    (
                                        valor_tablero(T1,BT1,Valor1)
                                    );
                                    (
                                        Prof2 is Prof + 1,
                                        validar_lugar(BT1,Analisis,NNumero),
                                        max(T1,BT1,NNumero,5,Prof2,AE,BE,_,_,_,Valor1,_)
                                    )
                                )
                            )
                        )
                    )
                )
            ),
            (
                (
                    Valor1 < BE ->
                        B is Valor1;
                        B is BE
                ),
                (
                    B < AE ->
                    (
                        AS is AE,
                        BS is B,
                        igual(T1,RT),
                        igual(RBT,BT1),
                        RJ is Analisis
                    );
                    (
                        igual(Analisis,8)->
                        (
                            AS is AE,
                            BS is B,
                            igual(T1,RT),
                            igual(RBT,BT1),
                            RJ is Analisis
                        );
                        (
                            siguiente_analisis(Analisis,NAnalisis),
                            min(Tablero,BTablero,Lugar,NAnalisis,Prof,AE,B,T2,BT2,J2,_,Valor2),
                            (
                                Valor2 < B ->
                                (
                                    AS is AE,
                                    BS is Valor2,
                                    igual(T2,RT),
                                    igual(BT2,RBT),
                                    RJ is J2
                                );
                                (
                                    AS is AE,
                                    BS is B,
                                    igual(T1,RT),
                                    igual(BT1,RBT),
                                    RJ is Analisis
                                )
                            )
                        )
                    )
                )
            )
        );
        (
            igual(Analisis,8)->
            (
                AS is AE,
                BS is BE
            );
            (
                siguiente_analisis(Analisis,NAnalisis),
                min(Tablero,BTablero,Lugar,NAnalisis,Prof,AE,BE,RT,RBT,RJ,AS,BS)
            )
        )
    ).

%===================================================================
% jugar/4. (Caso del jugador humano "x")
% Pide al jugador humano la jugada a realizar, analiza sí esta es
% posible y después sí es una jugada que finaliza el juego.
% El primer parámetro es el jugador.
% El segundo parámetro es el tablero competo.
% El tercer parámetro es la representación de tablero grande.
% El último parámetro es el lugar donde se tiene que realizar la
% jugada.
%===================================================================

jugar("x",Tablero,BTablero,Lugar):-
    write("Turno de x\n"),
    write("Cuadrante "),write(Lugar),write("\n"),
    write("Escribe el número de la casilla\n"),
    write("Las casillas estan enumeradas de izquierda a derecha de arriba a abajo\n"),
    read(Numero),
    (jugada("x",Lugar,Numero,Tablero,BTablero,NTablero,BNTablero)->
        (
            imprimir_tablero(NTablero),
            ((gana_mini(BNTablero,"x");empate(BNTablero))->
                write("Fin del juego\n");
                (
                    validar_lugar(BNTablero,Numero,NNumero),
                    jugar("o",NTablero,BNTablero,NNumero)
                )
            )
        );
        (
            write("Jugada incorrecta\n"),
            jugar("x",Tablero,BTablero,Lugar)
        )
    ).

%===================================================================
% jugar/4. (Caso del agente jugador "o")
% Manda a realizar un analisis de la mejor jugada a realizar, dada
% la jugada verifica si es una jugada terminal o si continua el
% juego.
%===================================================================

jugar("o",Tablero,BTablero,Lugar):-
    write("Turno de o\n"),
    max(Tablero,BTablero,Lugar,5,1,-1000,1000,NTablero,BNTablero,Numero,_,_),
    imprimir_tablero(NTablero),
    ((gana_mini(BNTablero,"o");empate(BNTablero))->
        write("Fin del juego\n");
        (
            validar_lugar(BNTablero,Numero,NNumero),
            jugar("x",NTablero,BNTablero,NNumero)
        )
    ).

%===================================================================
% iniciar_juego/0.
% Inicia el juego de metagato.
%===================================================================

iniciar_juego():-
    imprimir_tablero([[" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "],
                      [" "," "," "," "," "," "," "," "," "]]),
    jugar("x",[[" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "],
              [" "," "," "," "," "," "," "," "," "]],
              [" "," "," "," "," "," "," "," "," "],5),!.
