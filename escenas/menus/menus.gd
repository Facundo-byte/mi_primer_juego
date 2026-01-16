extends Control

@export var texto: Label
@export var titulo: Label
@export var jugar: TextureButton 
@export var vajugar: TextureButton 
@export var salir: TextureButton
@export var fondo: TextureRect

var escala_hover := Vector2(1.1, 1.1)
var escala_normal := Vector2(1, 1)
var duracion := 0.10
var cduracion := 0.05


func _ready()-> void: 
	var tween : Tween = null
	#hovers de los botones
	jugar.mouse_entered.connect(_hover.bind(tween, 1))
	vajugar.mouse_entered.connect(_hover.bind(tween, 2))
	salir.mouse_entered.connect(_hover.bind(tween, 3)) 
	
	jugar.mouse_exited.connect(_exit.bind(tween, 1))
	vajugar.mouse_exited.connect(_exit.bind(tween, 2))
	salir.mouse_exited.connect(_exit.bind(tween, 3))
	
	#clicks de los botones 
	jugar.pressed.connect(_click.bind(tween, 1))
	vajugar.pressed.connect(_click.bind(tween, 2))
	salir.pressed.connect(_click.bind(tween, 3))
	
	#si se murio el enemigo
	if ControladorGlobal.estado == 1: 
		titulo.visible = false
		texto.visible = true
		texto.text = "Victoria!"
		fondo.visible = false
		texto.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
		jugar.visible = false
		vajugar.visible = true
	elif ControladorGlobal.estado == 2: #si se murio el jugador
		titulo.visible = false
		texto.visible = true
		fondo.visible = false
		texto.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0))
		texto.remove_theme_color_override("font_color")
		texto.text = "Perdiste"
		jugar.visible = false
		vajugar.visible = true
		
func _hover(tween: Tween, nodoaf: int):
	if tween: 
		tween.kill()
		
	tween = create_tween()
	match nodoaf: 
		1: tween.tween_property(jugar, "scale", escala_hover, duracion)
		2: tween.tween_property(vajugar, "scale", escala_hover, duracion)
		3: tween.tween_property(salir, "scale", escala_hover, duracion)
		
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
func _exit(tween: Tween, nodoaf: int):
	if tween:
		tween.kill()

	tween = create_tween()
	match nodoaf: 
		1: tween.tween_property(jugar, "scale", escala_normal, duracion)
		2: tween.tween_property(vajugar, "scale", escala_normal, duracion)
		3: tween.tween_property(salir, "scale", escala_normal, duracion)
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

func _click(tween: Tween, nodoaf: int):
	if tween: 
		tween.kill()
	
	tween = create_tween()
	match nodoaf: 
		1: 
			tween.tween_property(jugar, "scale", Vector2(0.9, 0.9), cduracion)
			tween.tween_property(jugar, "scale", Vector2(1, 1), cduracion)
		2: 
			tween.tween_property(vajugar, "scale", Vector2(0.9, 0.9), cduracion)
			tween.tween_property(vajugar, "scale", Vector2(1, 1), cduracion)
		3: 
			tween.tween_property(salir, "scale", Vector2(0.9, 0.9), cduracion)
			tween.tween_property(salir, "scale", Vector2(1, 1), cduracion)
			
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
