extends AnimatableBody2D


const VELOCIDAD = 180

var direccion = 1

@onready var ray_cast_derecha: RayCast2D = $RayCastDerecha
@onready var ray_cast_izquierda: RayCast2D = $RayCastIzquierda

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_derecha.is_colliding():
		direccion = -1
	if ray_cast_izquierda.is_colliding():
		direccion = 1
	position.x += direccion * VELOCIDAD * delta
	
