extends Node

@export var pausa = Control

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pausa"):
		pausa.visible = !pausa.visible
		get_tree().paused = !get_tree().paused
