extends AnimatableBody2D


const VELOCIDAD = 80

var direccion = 1

@onready var ray_cast_derecha: RayCast2D = $RayCastDerecha
@onready var ray_cast_izquierda: RayCast2D = $RayCastIzquierda

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if ray_cast_derecha.is_colliding():
		direccion = -1
	if ray_cast_izquierda.is_colliding():
		direccion = 1
	position.x += direccion * VELOCIDAD * delta
	
