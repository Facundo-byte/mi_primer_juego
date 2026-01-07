extends Control

@export var continuar: Button
@export var salir: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continuar.pressed.connect(_despausar)
	salir.pressed.connect(_salir)
	
func _despausar():
	get_tree().paused = false
	print("clickeado")
	visible = false 

func _salir():
	get_tree().quit()
