extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("camara")
	
#limitar movimiento en camara
func obtener_tam_camara() -> Rect2:
	var viewport_size = get_viewport_rect().size

	var size = viewport_size * zoom
	var top_left = global_position - size / 2

	return Rect2(top_left, size)
