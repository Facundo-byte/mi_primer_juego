extends Control

@export var texto: Label
@export var jugar: Button 
@export var salir: Button 

func _ready()-> void: 
	#si se murio el enemigo
	if ControladorGlobal.estado == 1: 
		texto.text = "Victoria!"
		jugar.text = "Volver a jugar"
	elif ControladorGlobal.estado == 2: #si se murio el jugador
		texto.text = "Perdiste"
		jugar.text = "Reintentar"
