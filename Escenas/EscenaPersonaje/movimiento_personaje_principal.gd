extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking = false
var is_shielding = false
var attack_queue = 0  # Cola de ataques en espera

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0 and not is_attacking and not is_shielding:
			$AnimatedSprite2D.play("jump")

	# Manejar escudo (detiene ataque y movimiento)
	if Input.is_action_pressed("shield"):
		if not is_shielding:
			is_shielding = true
			cancel_attacks()  # 🔴 Cancela ataques si activa el escudo
			$AnimatedSprite2D.play("hurt")
			velocity.x = 0  # Detener movimiento mientras bloquea
	else:
		if is_shielding:
			is_shielding = false
			_set_idle_or_run_animation()  # Volver a la animación correcta

	# Registrar ataques en la cola sin bloquear el movimiento
	if Input.is_action_just_pressed("attack") and not is_shielding:
		attack_queue += 1  # Aumentamos la cola de ataques
		if not is_attacking:  # Si no está atacando, iniciar ataque
			_start_attack()

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_shielding and not is_attacking:
		velocity.y = JUMP_VELOCITY

	# Movimiento solo si no está atacando o bloqueando
	if not is_attacking and not is_shielding:
		var direction := Input.get_axis("ui_left", "ui_right")

		if direction > 0:
			$AnimatedSprite2D.scale.x = 1
		elif direction < 0:
			$AnimatedSprite2D.scale.x = -1

		if direction:
			velocity.x = direction * SPEED
			if is_on_floor():
				$AnimatedSprite2D.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				$AnimatedSprite2D.play("idle")

	move_and_slide()

# 🔥 **Función para iniciar ataque sin que se quede en bucle**
func _start_attack():
	if attack_queue > 0:
		is_attacking = true
		attack_queue -= 1  # Reducimos la cola de ataques
		velocity.x = 0  # Detenemos el movimiento mientras ataca
		$AnimatedSprite2D.play("attack")

		# Evitar múltiples conexiones de animation_finished
		$AnimatedSprite2D.animation_finished.disconnect(_on_attack_finished)
		$AnimatedSprite2D.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

# 🔥 **Finaliza el ataque y revisa si hay más ataques en la cola**
func _on_attack_finished():
	if attack_queue > 0:  # Si hay ataques pendientes, sigue atacando
		_start_attack()
	else:
		is_attacking = false
		_set_idle_or_run_animation()  # Restaurar animación correcta

# 📌 **Función auxiliar para restaurar la animación correcta**
func _set_idle_or_run_animation():
	if is_on_floor():
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

# 🔴 **Función para cancelar ataques si el enemigo muere**
func cancel_attacks():
	attack_queue = 0  # Elimina cualquier ataque en espera
	is_attacking = false  # Permite que el personaje vuelva a moverse
	_set_idle_or_run_animation()  # Restablecer animación
