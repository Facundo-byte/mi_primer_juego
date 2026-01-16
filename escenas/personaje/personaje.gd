extends CharacterBody2D

signal danio_recibido

@export var animacion : AnimatedSprite2D
@export var colision: Area2D
var _velocidad: float = 200.0 #defino la velocidad a la q se mueve el pj
var mouse_pos 

#ataque
@export var distancia_espadazo := 90
@onready var espadazo := $Espadazo

#dash
@export var velocidad_dash := 600.0
@export var duracion_dash := 0.15
var direccion_mov := Vector2.ZERO
var dashing := false
var puede_dash := true
var puede_ataque := true

#knockback
var en_knockback := false

#camara
var cam
var cam_rect

func _ready():
	add_to_group("jugador")
	cam = get_tree().get_first_node_in_group("camara")
	cam_rect = cam.obtener_tam_camara()	
	colision.body_entered.connect(_choque)
	
func _process(delta: float):
	# limitar en base a la camara
	global_position = global_position.clamp(
		cam_rect.position + Vector2(32,32),
		cam_rect.position + cam_rect.size - Vector2(32,32)
	)
	
	if velocity.length() > 0: 
		direccion_mov = velocity.normalized()
	if dashing or en_knockback: 
		move_and_slide()
		return
			
	#movimiento
	if Input.is_action_pressed("izquierda"): 
		velocity.x = -_velocidad
		animacion.play("idle_left_right_up")
	if Input.is_action_pressed("derecha"): 
		velocity.x = _velocidad
		animacion.play("idle_left_right_up")
	if Input.is_action_pressed("arriba"): 
		velocity.y = -_velocidad
		animacion.play("idle_left_right_up")
	if Input.is_action_pressed("abajo"): 
		velocity.y = _velocidad
		animacion.play("idle_down")
		
	#movimientos diagonales
	if Input.is_action_pressed("abajo") and Input.is_action_pressed("izquierda"):
		animacion.flip_h = true
		animacion.play("idle_downandright")
	
	if Input.is_action_pressed("abajo") and Input.is_action_pressed("derecha"):
		animacion.flip_h = false
		animacion.play("idle_downandright")
		
	if Input.is_action_pressed("arriba") and Input.is_action_pressed("izquierda"):
		animacion.play("idle_upandright")
		
	if Input.is_action_pressed("arriba") and Input.is_action_pressed("derecha"):
		animacion.play("idle_upandright")
	
	#parar animaciones
	if !Input.is_action_pressed("abajo") and !Input.is_action_pressed("arriba"): 
		velocity.y = 0
		
	if !Input.is_action_pressed("derecha") and !Input.is_action_pressed("izquierda"): 
		velocity.x = 0
	move_and_slide()
	
	#ataque 
	if Input.is_action_just_pressed("ataque") and puede_ataque:
		atacar()
		mostrar_espadazo()
	
	if Input.is_action_just_pressed("dash") and puede_dash and direccion_mov != Vector2.ZERO: 
		_dash()
	
# colision con enemigo 
func _choque(body: Node) -> void:
	danio_recibido.emit()
	print("hola")

#funcion dash
func _dash():
	dashing = true
	collision_layer = 0
	puede_dash = false 
	
	var dir = direccion_mov
	velocity = dir * velocidad_dash 
	
	await get_tree().create_timer(duracion_dash).timeout
	
	collision_layer = 4
	dashing = false 
	velocity = Vector2.ZERO 
	
	await get_tree().create_timer(0.3).timeout
	puede_dash = true
	

#espadazo
func mostrar_espadazo():
	mouse_pos = obtener_direccion_mouse()
	
	espadazo.global_position = global_position + mouse_pos * distancia_espadazo
	espadazo.area.monitoring = true
	espadazo.visible = true 
	espadazo.anim_ataque.stop()
	espadazo.anim_ataque.frame = 0
	espadazo.anim_ataque.play("ataque")
	await get_tree().create_timer(0.25).timeout
	espadazo.area.monitoring = false
	espadazo.visible = false
	await get_tree().create_timer(0.15).timeout
	puede_ataque = true
	

func obtener_direccion_mouse() -> Vector2: 
	return (get_global_mouse_position() - global_position).normalized()

func atacar():
	puede_ataque = false
	mouse_pos = obtener_direccion_mouse()
	$Espadazo.rotation = mouse_pos.angle() + deg_to_rad(30)
