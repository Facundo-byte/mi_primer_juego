extends CharacterBody2D

@onready var ia = $NavigationAgent2D

@export var sprite : AnimatedSprite2D
@export var _velocidad: float 
@export var vida : float 
@export var area_atq: Area2D
@export var humo: Node2D
@export var espadazo: Node2D

var jugador
var puede_moverse: bool = true
var en_knockback: bool = false

func _ready():
	add_to_group("enemigo")
	jugador = get_tree().get_first_node_in_group("jugador")
	area_atq.body_entered.connect(_atacar_jugador)

func _process(delta: float):
	if !puede_moverse: 
		velocity = Vector2.ZERO 
		move_and_slide()
		return
	if en_knockback:
		move_and_slide()
		return
	
	var direccion = to_local(ia.get_next_path_position()).normalized()
	velocity = direccion * _velocidad
	move_and_slide()
	
	animar_direccion()

func _on_timer_timeout() -> void:
	ia.target_position = jugador.global_position

# animaciones de movimiento
func animar_direccion(): 
	var dir: String = obtener_direccion()
	
	match dir: 
		"idle": 
			sprite.play("idle_down")
		"up_right":
			sprite.flip_h = false 
			sprite.play("idle_upandright")
		"down_right":
			sprite.flip_h = false
			sprite.play("idle_downandright")
		"up_left": 
			sprite.flip_h = true
			sprite.play("idle_upandright")
		"down_left": 
			sprite.flip_h = true
			sprite.play("idle_downandright")
		"right": 
			sprite.play("idle_left_right_up")
		"left":
			sprite.play("idle_left_right_up")
		"up":
			sprite.play("idle_left_right_up")

func obtener_direccion() -> String: 
	const tol := 5
	
	if velocity == Vector2(0,0):
		return "idle"
	
	if velocity.x > tol and velocity.y < -tol: 
		return "up_right"
	if velocity.x > tol and velocity.y > tol:
		return "down_right"
	if velocity.x < -tol and velocity.y < -tol: 
		return "up_left"
	if velocity.x < -tol and velocity.y > tol: 
		return "down_left"
	
	if velocity.x > tol and velocity.y < tol: 
		return "right"
	if velocity.x < -tol and velocity.y < tol: 
		return "left"
	if velocity.x < tol and velocity.y > tol: 
		return "idle"
	if velocity.x < tol and velocity.y < -tol: 
		return "up"
		
	return "idle"

# ataque 
func _atacar_jugador(body):
	var ataques = [
		ataque_salto,
		ataque_slash, 
		null
	]
	
	var accion = ataques.pick_random()
	
	if accion: 
		#detengo su movimiento
		puede_moverse = false
		accion.call()
		
	
	
func ataque_slash(): 
	var distancia_espadazo: int = 100
	var dir_jugador = obtener_direccion_jugador()
	
	espadazo.global_position = global_position + dir_jugador * distancia_espadazo
	espadazo.rotation = dir_jugador.angle() + deg_to_rad(30)
	espadazo.area.monitoring = true
	espadazo.visible = true 
	espadazo.anim_ataque.stop()
	espadazo.anim_ataque.frame = 0
	espadazo.anim_ataque.play("ataque")
	
	await get_tree().create_timer(0.25).timeout
	espadazo.area.monitoring = false
	espadazo.visible = false
	
	puede_moverse = true

func obtener_direccion_jugador():
	return (ia.target_position - global_position).normalized()

func ataque_salto():
	var tween: Tween = create_tween()
	### ataque con salto
	velocity = Vector2(velocity.x + 5, velocity.y)
	
	#ejecuto la animacion
	sprite.play("jump_down")
	tween.tween_property(sprite, "position:y", sprite.position.y - 30, 0.25)
	tween.tween_property(sprite, "position:y", sprite.position.y, 0.25)
	

	#humo de caida
	await get_tree().create_timer(0.5).timeout
	humo.area.monitoring = true 
	humo.visible = true
	humo.anim_humo.stop()
	humo.anim_humo.frame = 0
	humo.anim_humo.play("onda_expansiva")
	
	await get_tree().create_timer(0.5).timeout
	#retomo el movimiento normal
	humo.visible = false 
	humo.area.monitoring = false
	
	puede_moverse = true
