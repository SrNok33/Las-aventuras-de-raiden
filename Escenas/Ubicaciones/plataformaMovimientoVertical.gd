extends AnimatableBody2D

@export var punto_inicio: Vector2 = Vector2(-191, 436)
@export var punto_final: Vector2 = Vector2(-187, 226)
@export var velocidad: float = 55.0

var destino: Vector2

func _ready() -> void:
	position = punto_inicio
	destino = punto_final

func _process(delta: float) -> void:
	position = position.move_toward(destino, velocidad * delta)

	# Cambiar de dirección al llegar al destino
	if position == destino:
		if destino == punto_final:
			destino = punto_inicio
		else:
			destino = punto_final
