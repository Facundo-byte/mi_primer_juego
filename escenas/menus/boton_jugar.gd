extends TextureButton

@export var escena_principal: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size / 2
	pressed.connect(jugar, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func jugar():
	await get_tree().create_timer(0.10).timeout
	get_tree().change_scene_to_packed(escena_principal)
