extends Node2D

signal tocado2

@export var anim_ataque: AnimatedSprite2D
@export var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("espadazo")
	area.body_entered.connect(_impactado)

func _impactado(body):
	tocado2.emit()
	
