extends Node2D

signal tocado2

@export var anim_ataque: AnimatedSprite2D
@export var area: Area2D

var ya_golpeo := false 

func _ready() -> void:
	add_to_group("espadazo")
	area.body_entered.connect(_impactado)

func _impactado(body):
	if ya_golpeo:
		print("lol")
		return 
	
	print("entraste")
	tocado2.emit()
	
