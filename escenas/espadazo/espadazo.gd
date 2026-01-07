extends Node2D

@export var anim_ataque: AnimatedSprite2D
@export var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(ControladorGlobal.restarvidaenemigo)

	
