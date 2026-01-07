extends Control

@export var vidas: Array[Control]
@export var barra: TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var jugador = get_tree().get_first_node_in_group("jugador") #jugador
	var humo = get_tree().get_first_node_in_group("humo") #humo que lo impacto
	var espadazo = get_tree().get_first_node_in_group("espadazo")
	
	jugador.danio_recibido.connect(_actualizar_vidas)
	ControladorGlobal.vida_enemigo_act.connect(_actualizar_vida_enemigo)
	humo.tocado.connect(_actualizar_vidas)
	espadazo.tocado2.connect(_actualizar_vidas)
	
func _actualizar_vidas():
	ControladorGlobal.restarvidajugador()
	var ultimo = vidas.pop_back()
	ultimo.queue_free()
	
	
func _actualizar_vida_enemigo(nuevavida):
	barra.value = nuevavida
	
