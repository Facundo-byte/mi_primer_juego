extends Button

@export var escena_principal: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(jugar, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func jugar():
	get_tree().change_scene_to_packed(escena_principal)
