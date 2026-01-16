extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size / 2
	pressed.connect(funcion)

func funcion():
	print("hola")
