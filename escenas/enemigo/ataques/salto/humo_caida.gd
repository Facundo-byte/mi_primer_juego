extends Node2D

signal tocado

@export var area: Area2D
@export var anim_humo: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("humo")
	area.body_entered.connect(_impacto)

func _impacto(body): 
	tocado.emit()
