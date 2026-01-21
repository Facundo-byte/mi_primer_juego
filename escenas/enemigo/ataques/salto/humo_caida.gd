extends Node2D

signal tocado

@export var area: Area2D
@export var anim_humo: AnimatedSprite2D

var ya_golpeo := false

func _ready() -> void:
	add_to_group("humo")
	area.body_entered.connect(_impacto)

func _impacto(body): 
	if ya_golpeo: 
		return
		
	ya_golpeo = true
	tocado.emit()
