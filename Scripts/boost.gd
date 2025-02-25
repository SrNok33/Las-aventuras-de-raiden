extends CharacterBody2D

@onready var player = owner.find_child("personajePrincipal")  # Busca al jugador
@onready var sprite = $Sprite2D
@onready var laser_detection = $LaserDetection  # Referencia al Area2D
@onready var animation_player = $AnimationPlayer  # Referencia al AnimationPlayer
@onready var state_machine = $FiniteStateMachine  # Referencia a la máquina de estados

var direction : Vector2 = Vector2.ZERO
var health : float = 100.0  # Vida del boss (opcional, para futuro)

func _ready():
	if player == null:
		print("❌ Error: No se encontró el nodo 'personajePrincipal'. Verifica el nombre o la jerarquía.")
	if sprite == null:
		print("❌ Error: No se encontró el nodo 'Sprite2D'. Verifica el nombre o la jerarquía.")
	if laser_detection == null:
		print("❌ Error: No se encontró el nodo 'LaserDetection'. Verifica el nombre o la jerarquía.")
	if animation_player == null:
		print("❌ Error: No se encontró el nodo 'AnimationPlayer'. Verifica el nombre o la jerarquía.")
	if state_machine == null:
		print("❌ Error: No se encontró la máquina de estados 'FiniteStateMachine'. Verifica el nombre o la jerarquía.")
	set_physics_process(false)

func enter():  # Si usas un sistema de estados
	set_physics_process(true)
	# Conectar la señal body_entered del Area2D si no está conectado
	if laser_detection != null and not laser_detection.is_connected("body_entered", _on_laser_detection_body_entered):
		laser_detection.connect("body_entered", _on_laser_detection_body_entered)

func exit():
	set_physics_process(false)

func _process(_delta):
	if player != null:
		direction = player.global_position - global_position
		
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		print("❌ Error: No se encontró el jugador 'personajePrincipal'")

func _physics_process(delta):
	if player != null:
		direction = player.global_position - global_position
		velocity = direction.normalized() * 100  # Ajusta la velocidad
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_laser_detection_body_entered(body):
	if body.is_in_group("jugador"):  # Asegúrate de que el jugador esté en el grupo "player"
		print("Jugador detectado en LaserDetection. Cambiando a estado LaserBeam")
		if state_machine != null:
			state_machine.change_state("laser")  # Cambia al estado LaserBeam
