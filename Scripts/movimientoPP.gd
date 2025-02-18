extends CharacterBody2D

@export var speed: float = 200.0 # Velocidad del personaje

func _process(delta: float) -> void:
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized() # Normalizar para movimiento diagonal consistente
	velocity = direction * speed
	move_and_slide()
