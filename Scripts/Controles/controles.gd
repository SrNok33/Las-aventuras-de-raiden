extends CanvasLayer

# Referencia al personaje (ajusta la ruta según tu escena)
@onready var player = $"../Jugador"  # Asegúrate de que esta ruta sea correcta

# Referencias a los nodos en este CanvasLayer
@onready var jump_button = $Jump
@onready var attack_button = $Attack
@onready var joystick= $"VirtualJoystick"

func _ready():
	if OS.get_name() == "Windows":
		ocultar_controles_moviles()
	else:
		configurar_controles_moviles()

	if player:
		print("CanvasLayer ready, player found: ", player.name)  # Depuración
	else:
		print("Player not found, check the path in CanvasLayer")  # Depuración

# 🔹 Oculta los controles en PC
func ocultar_controles_moviles():
	jump_button.visible = false
	attack_button.visible = false
	joystick.visible = false  # Ocultar el joystick en PC
	print("Controles móviles ocultos en Windows")  # Depuración

# 🔹 Configura los controles en móviles
func configurar_controles_moviles():
	if jump_button is TouchScreenButton:
		jump_button.connect("pressed", _on_jump_button_pressed)
		jump_button.connect("released", _on_jump_button_released)
		print("Jump button connected")  # Depuración
	if attack_button is TouchScreenButton:
		attack_button.connect("pressed", _on_attack_button_pressed)
		attack_button.connect("released", _on_attack_button_released)
		print("Attack button connected")  # Depuración

# 🔥 Función para manejar el movimiento del joystick
func _on_joystick_direction_changed(direction: Vector2):
	if player and player.has_method("update_movement"):
		player.update_movement(direction * 300.0)  # Ajusta la velocidad según necesites
		print("Joystick direction sent to player: ", direction)  # Depuración

# ✅ Funciones para manejar los botones
func _on_jump_button_pressed():
	if player and player.has_method("jump"):
		player.jump()
		print("Jump button pressed")  # Depuración
	Input.action_press("jump")

func _on_jump_button_released():
	Input.action_release("jump")
	print("Jump button released")  # Depuración

func _on_attack_button_pressed():
	if player and player.has_method("attack"):
		player.attack()
		print("Attack button pressed")  # Depuración
	Input.action_press("attack")

func _on_attack_button_released():
	Input.action_release("attack")
	print("Attack button released")  # Depuración
