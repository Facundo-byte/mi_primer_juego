extends Control

@export var vidas: Array[Control]
@export var barra: TextureProgressBar

#knockback 
@export var fuerza_knockback := 300
@export var duracion_knockback := 0.15
var dir_knockback := Vector2.ZERO

#sonidos
@export var danio_jugador: AudioStreamPlayer2D
@export var danio_enemigo: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("controlador")
	
	var jugador = get_tree().get_first_node_in_group("jugador") #jugador
	var enemigo = get_tree().get_first_node_in_group("enemigo")
	#ataques
	var humo = get_tree().get_first_node_in_group("humo") #humo que lo impacto
	var espadazo = get_tree().get_first_node_in_group("espadazo")
	
	if !jugador.invulnerable and !jugador.muriendo:
		jugador.danio_recibido.connect(actualizar_vidas.bind(jugador, enemigo))
		humo.tocado.connect(actualizar_vidas.bind(jugador, enemigo))
		espadazo.tocado2.connect(actualizar_vidas.bind(jugador, enemigo))
		
	ControladorGlobal.vida_enemigo_act.connect(_actualizar_vida_enemigo.bind(jugador, enemigo))
	
	
func actualizar_vidas(jugador: Node2D, enemigo: Node2D):
	#aplicar knockback
	var dir = (jugador.global_position - enemigo.global_position).normalized()
	jugador.modulate = Color(1.0, 0.0, 0.0)
	jugador.scale = Vector2(0.800, 0.800)
	_aplicar_knockback(jugador, dir)
	
	#sonido
	danio_jugador.play()
	
	#restar vida
	ControladorGlobal.restarvidajugador()
	var ultimo = vidas.pop_back()
	if ultimo:
		ultimo.queue_free()

func _aplicar_knockback(personaje: Node2D, dir: Vector2):
	personaje.en_knockback = true
	dir_knockback = dir 
	personaje.velocity = dir * fuerza_knockback
	
	await get_tree().create_timer(duracion_knockback).timeout
	personaje.modulate = Color(1.0, 1.0, 1.0)
	personaje.scale = Vector2(1, 1)
	personaje.en_knockback = false 
	personaje.velocity = Vector2.ZERO
	
func _actualizar_vida_enemigo(nuevavida, jugador: Node2D, enemigo: Node2D):
	#aplicar knockback 
	var dir = (enemigo.global_position - jugador.global_position).normalized()
		#cambiar tamanio y color al ser golpeado
	enemigo.modulate = Color(18.892, 18.892, 18.892)
	enemigo.scale = Vector2(0.800, 0.800)
	_aplicar_knockback(enemigo, dir)
	
	#sonido
	danio_enemigo.play()
	
	print("act")
	barra.value = nuevavida
	
