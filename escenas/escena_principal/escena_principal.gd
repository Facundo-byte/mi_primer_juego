extends Node2D

@export var niveles: Array[PackedScene]
var _nivel_actual: int = 1
var _nivel_instanciado: Node 

#sonidos muerte
@export var sonido_mjugador: AudioStreamPlayer2D
@export var sonido_menemigo: AudioStreamPlayer2D

func _ready() -> void:
	_crear_nivel(_nivel_actual)
	var jugador = get_tree().get_first_node_in_group("jugador")
	var enemigo = get_tree().get_first_node_in_group("enemigo")
	#si el jugador muere cargo derrota
	ControladorGlobal.jugador_muerto.connect(_cargar_fin.bind(1, jugador, enemigo))
	#si el enemigo muere cargo victoria
	ControladorGlobal.enemigo_muerto.connect(_cargar_fin.bind(2, jugador, enemigo))
	
	
func _crear_nivel(numero_nivel: int):
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	add_child(_nivel_instanciado)
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()

func _reiniciar_nivel():
	_eliminar_nivel()
	_crear_nivel.call_deferred(_nivel_actual)

func _cargar_fin(bandera: int, jugador: Node2D, enemigo: Node2D):
	jugador.muriendo = true 
	enemigo.muriendo = true 
	
	if bandera == 1:
		sonido_mjugador.play()
		jugador.animacion.play("death")
		print("perdiste")
	else:
		sonido_menemigo.play()
		enemigo.sprite.play("death")
		print("ganaste")
	
	await get_tree().create_timer(2).timeout
	call_deferred("_ir_al_menu")
	#_nivel_actual += 1
	#_eliminar_nivel()
	#_crear_nivel.call_deferred(_nivel_actual)

func _ir_al_menu():
	ControladorGlobal.vidas_jugador = 3
	ControladorGlobal.vida_enemigo = 100
	get_tree().change_scene_to_file("res://escenas/menus/menus.tscn")
