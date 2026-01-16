extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size / 2
	pressed.connect(_salir)

func _salir():
	await get_tree().create_timer(0.10).timeout
	get_tree().quit()
