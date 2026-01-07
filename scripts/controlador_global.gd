extends Node

signal vidas_jugador_act
signal vida_enemigo_act
signal jugador_muerto
signal enemigo_muerto

var vidas_jugador: int = 3
var vida_enemigo: float = 100 
var dmg_jugador: float = 20
var estado: int

func restarvidajugador():
	vidas_jugador -= 1
	
	if vidas_jugador == 0: 
		print(vidas_jugador)
		estado = 2
		jugador_muerto.emit()
	else:
		print(vidas_jugador)

func restarvidaenemigo(body: Node):
	print("golpeado")
	vida_enemigo -= dmg_jugador
	if vida_enemigo == 0: 
		print(vida_enemigo)
		estado = 1
		enemigo_muerto.emit()
	else:
		print(vida_enemigo)
		vida_enemigo_act.emit(vida_enemigo)
		
