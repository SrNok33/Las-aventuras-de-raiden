extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var vidas = 3
@export var attack_damage: int = 10
@onready var corazones = [
	$"../HUB/Corazon1",
	$"../HUB/Corazon2",
	$"../HUB/Corazon3"
]

var is_attacking = false
var is_shielding = false
var attack_queue = 0
var is_dead = false
var recibiendo_dano = false

@onready var anim = $AnimatedSprite2D

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if is_dead:
		return  # No hacer nada si el jugador está muerto

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejar defensa
	if Input.is_action_pressed("shield"):
		if not is_shielding:
			is_shielding = true
			cancel_attacks()
			anim.play("hurt")
			velocity.x = 0
	else:
		is_shielding = false

	# Manejar ataque
	if Input.is_action_just_pressed("attack") and not is_shielding:
		attack_queue += 1
		if not is_attacking:
			_start_attack()

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_shielding and not is_attacking:
		velocity.y = JUMP_VELOCITY

	# Movimiento
	if not is_attacking and not is_shielding:
		var direction = Input.get_axis("ui_left", "ui_right")

		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.scale.x = 1 if direction > 0 else -1
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_actualizar_animacion()

# 🔥 Manejo de Animaciones
func _actualizar_animacion():
	if is_dead:
		return

	if is_attacking:
		anim.play("attack")
	elif recibiendo_dano:
		anim.play("hurt")
		await anim.animation_finished  # Espera a que la animación termine
		recibiendo_dano = false  # Resetear la variable después de la animación
		anim.play("idle")  # Volver a idle
	elif not is_on_floor():
		anim.play("jump")
		await anim.animation_finished
	elif velocity.x != 0:
		anim.play("run")
	else:
		anim.play("idle")

# 🔥 Iniciar ataque
func _start_attack():
	if attack_queue > 0:
		is_attacking = true
		attack_queue -= 1
		velocity.x = 0
		anim.play("attack")
		$AttackArea.monitoring = true
		anim.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

# 🔥 Finalizar ataque
func _on_attack_finished():
	$AttackArea.monitoring = false
	if attack_queue > 0:
		_start_attack()
	else:
		is_attacking = false
	_actualizar_animacion()

# 🔴 Cancelar ataques
func cancel_attacks():
	attack_queue = 0
	is_attacking = false
	_actualizar_animacion()

# ✅ Detección de daño
func _on_attack_area_area_entered(area: Area2D) -> void:
	if is_attacking and area.is_in_group("enemigos"):
		var enemigo = area.get_parent()
		if enemigo.has_method("recibir_dano"):
			enemigo.recibir_dano(attack_damage)

func recibir_dano(cantidad: int):
	if vidas > 0:
		vidas -= cantidad
		recibiendo_dano = true
		print("¡Jugador recibió daño! Vidas restantes:", vidas)
		actualizar_vida()
		if vidas <= 0:
			morir()
		else:
			await anim.animation_finished
			recibiendo_dano = false
			_actualizar_animacion()

func actualizar_vida():
	for i in range(len(corazones)):
		corazones[i].visible = i < vidas

func _on_hitbox_area_entered(area: Area2D) -> void:
	if not is_attacking and area.is_in_group("enemigos"):
		recibir_dano(1)

func _on_Area2D_body_entered(body):
	if body.is_in_group("ZonaMuerte"):
		recibir_dano(1)

# 🟥 Muerte del jugador
func morir():
	if is_dead:
		return

	is_dead = true
	anim.play("dead")
	print("¡Jugador ha muerto!")

	await anim.animation_finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Escenas/Pantallas/Muerte.tscn")
