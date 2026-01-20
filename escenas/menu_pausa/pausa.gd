extends Control

@export var continuar: TextureButton
@export var salir: TextureButton

var escala_hover := Vector2(1.1, 1.1)
var escala_normal := Vector2(1, 1)
var duracion := 0.10
var cduracion := 0.05

#sonidos
@export var hover: AudioStreamPlayer2D
@export var click: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween : Tween = null
	
	#hover
	continuar.mouse_entered.connect(_hover.bind(tween, 1))
	salir.mouse_entered.connect(_hover.bind(tween, 2)) 
	
	continuar.mouse_exited.connect(_exit.bind(tween, 1))
	salir.mouse_exited.connect(_exit.bind(tween, 2))
	
	#presionado
	continuar.pressed.connect(_click.bind(tween, 1))
	salir.pressed.connect(_click.bind(tween, 2))
	
func _despausar():
	get_tree().paused = false
	print("clickeado")
	visible = false 

func _salir():
	get_tree().quit()

func _hover(tween: Tween, nodoaf: int):
	if tween: 
		tween.kill()
		
	tween = create_tween()
	match nodoaf: 
		1: tween.tween_property(continuar, "scale", escala_hover, duracion)
		2: tween.tween_property(salir, "scale", escala_hover, duracion)
		
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	#sonido
	hover.play()
	
func _exit(tween: Tween, nodoaf: int):
	if tween:
		tween.kill()

	tween = create_tween()
	match nodoaf: 
		1: tween.tween_property(continuar, "scale", escala_normal, duracion)
		2: tween.tween_property(salir, "scale", escala_normal, duracion)
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

func _click(tween: Tween, nodoaf: int):
	if tween: 
		tween.kill()
	
	tween = create_tween()
	match nodoaf: 
		1: 
			tween.tween_property(continuar, "scale", Vector2(0.9, 0.9), cduracion)
			tween.tween_property(continuar, "scale", Vector2(1, 1), cduracion)
			_despausar()
		2: 
			tween.tween_property(salir, "scale", Vector2(0.9, 0.9), cduracion)
			tween.tween_property(salir, "scale", Vector2(1, 1), cduracion)
			_salir()
			
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	#sonido
	click.play()
