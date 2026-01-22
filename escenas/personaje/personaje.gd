extends CharacterBody2D

signal danio_recibido

@export var animacion : AnimatedSprite2D
@export var colision: Area2D
var _velocidad: float = 200.0 #defino la velocidad a la q se mueve el pj
var mouse_pos 
var muriendo: bool = false
var invulnerable: bool = false

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

#sonidos
@export var caminata : AudioStreamPlayer2D
@export var dash_sonido: AudioStreamPlayer2D
@export var espadazo_sonido: AudioStreamPlayer2D

func _ready():
	add_to_group("jugador")
	cam = get_tree().get_first_node_in_group("camara")
	cam_rect = cam.obtener_tam_camara()	
	if !muriendo:
		colision.body_entered.connect(_choque)

func _process(delta):
	# limitar en base a la camara
	global_position = global_position.clamp(
		cam_rect.position + Vector2(32,32),
		cam_rect.position + cam_rect.size - Vector2(32,32)
	)

	if muriendo: 
		return
	if dashing or en_knockback:
		move_and_slide()
		return

	#inputs
	var dir := Vector2(
		Input.get_action_strength("derecha") - Input.get_action_strength("izquierda"), 
		Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	) #get_action_strenght devuelve 0 si la tecla no fue presionada y 1 si fue presionada.

	#| Teclas             | Vector     |
	#| ------------------ | ---------- |
	#| Derecha            | `(1, 0)`   |
	#| Izquierda          | `(-1, 0)`  |
	#| Arriba             | `(0, -1)`  |
	#| Abajo              | `(0, 1)`   |
	#| Abajo + Derecha    | `(1, 1)`   |
	#| Arriba + Izquierda | `(-1, -1)` |

	if dir != Vector2.ZERO: #si se esta moviendo hago que la velocidad se escale a la velocidad del pj
		velocity = dir.normalized() * _velocidad #normalized para que no vaya mas rapido en diagonal
	else: #sino no tiene velocidad
		velocity = Vector2.ZERO

	# sonido caminar
	if velocity.length() > 0:
		direccion_mov = velocity.normalized()
		if not caminata.playing:
			caminata.play()
	else:
		caminata.stop()

	# === ANIMACIONES ===
	if dir == Vector2.ZERO:
		if animacion.animation != "idle_down":
			animacion.play("idle_down")
	else:
		# DIAGONAL
		if dir.x != 0 and dir.y != 0:
			
			if dir.x < 0:
				animacion.flip_h = true
			else:
				animacion.flip_h = false

			if dir.y > 0:
				if animacion.animation != "idle_downandright":
					animacion.play("idle_downandright")
			else:
				if animacion.animation != "idle_upandright":
					animacion.play("idle_upandright")

		# HORIZONTAL
		elif dir.x != 0:
			animacion.flip_h = dir.x < 0
			if animacion.animation != "idle_left_right_up":
				animacion.play("idle_left_right_up")

		# VERTICAL
		elif dir.y != 0:
			if dir.y > 0:
				if animacion.animation != "idle_down":
					animacion.play("idle_down")
			else:
				if animacion.animation != "idle_left_right_up":
					animacion.play("idle_left_right_up")

	move_and_slide()

	# ataque
	if Input.is_action_just_pressed("ataque") and puede_ataque:
		atacar()
		mostrar_espadazo()

	if Input.is_action_just_pressed("dash") and puede_dash and direccion_mov != Vector2.ZERO:
		_dash()

# colision con enemigo 
func _choque(body: Node) -> void:
	if !muriendo:
		danio_recibido.emit()
	print("hola")

#funcion dash
func _dash():
	dash_sonido.play()
	dashing = true
	invulnerable = true
	puede_dash = false 
	
	var dir = direccion_mov
	velocity = dir * velocidad_dash 
	
	await get_tree().create_timer(duracion_dash).timeout
	
	dashing = false 
	velocity = Vector2.ZERO 
	
	await get_tree().create_timer(0.3).timeout
	puede_dash = true
	invulnerable = false
	

#espadazo
func mostrar_espadazo():
	mouse_pos = obtener_direccion_mouse()
	
	espadazo.global_position = global_position + mouse_pos * distancia_espadazo
	espadazo.area.monitoring = true
	espadazo.visible = true 
	espadazo.anim_ataque.stop()
	espadazo.anim_ataque.frame = 0
	espadazo.anim_ataque.play("ataque")
	await(espadazo.anim_ataque.animation_finished)
	espadazo.area.monitoring = false
	espadazo.visible = false
	await get_tree().create_timer(0.30).timeout
	puede_ataque = true
	

func obtener_direccion_mouse() -> Vector2: 
	return (get_global_mouse_position() - global_position).normalized()

func atacar():
	espadazo_sonido.play()
	puede_ataque = false
	mouse_pos = obtener_direccion_mouse()
	$Espadazo.rotation = mouse_pos.angle() + deg_to_rad(30)
