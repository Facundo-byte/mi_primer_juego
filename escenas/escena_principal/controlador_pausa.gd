extends CanvasLayer

@export var pausa = Control

func _input(event: InputEvent) -> void: 
	var jugador = get_tree().get_first_node_in_group("jugador")
	var enemigo = get_tree().get_first_node_in_group("enemigo")
	
	if event.is_action_pressed("pausa") and !jugador.muriendo and !enemigo.muriendo:
		pausa.visible = !pausa.visible
		get_tree().paused = !get_tree().paused
