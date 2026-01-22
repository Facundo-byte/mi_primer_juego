extends Area2D

@export var speed := 400
@export var sonido : AudioStreamPlayer2D
var direction := Vector2.RIGHT

func _ready():
	sonido.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body):
	print("bola")
	var controlador = get_tree().get_first_node_in_group("controlador")
	var jugador = get_tree().get_first_node_in_group("jugador")
	var enemigo = get_tree().get_first_node_in_group("enemigo")
	
	controlador.actualizar_vidas(jugador, enemigo)
	queue_free()
