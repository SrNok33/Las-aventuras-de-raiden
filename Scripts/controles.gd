extends CanvasLayer

# Referencia al personaje (ajusta la ruta según tu escena)
@onready var player = $"../Jugador"  # Asegúrate de que esta ruta sea correcta

# Referencias a los nodos en este CanvasLayer
@onready var jump_button = $Jump
@onready var attack_button = $Attack

func _ready():
	if player:
		print("CanvasLayer ready, player found: ", player.name)  # Depuración
		# Conectar señales de los botones TouchScreenButton
		if jump_button is TouchScreenButton:
			jump_button.connect("pressed", _on_jump_button_pressed)
			jump_button.connect("released", _on_jump_button_released)
			print("Jump button connected")  # Depuración
		if attack_button is TouchScreenButton:
			attack_button.connect("pressed", _on_attack_button_pressed)
			attack_button.connect("released", _on_attack_button_released)
			print("Attack button connected")  # Depuración
		
		# Conectar la señal del joystick
	else:
		print("Player not found, check the path in CanvasLayer")  # Depuración

# Función para manejar el movimiento del joystick
func _on_joystick_direction_changed(direction: Vector2):
	if player and player.has_method("update_movement"):
		player.update_movement(direction * 300.0)  # Ajusta la velocidad según necesites
		print("Joystick direction sent to player: ", direction)  # Depuración

# Funciones para manejar los botones
func _on_jump_button_pressed():
	if player and player.has_method("jump"):
		player.jump()  # Llama al método jump en el personaje
		print("Jump button pressed")  # Depuración
	Input.action_press("jump")  # Simular la acción jump (opcional)

func _on_jump_button_released():
	Input.action_release("jump")  # Liberar la acción (opcional)
	print("Jump button released")  # Depuración

func _on_attack_button_pressed():
	if player and player.has_method("attack"):
		player.attack()  # Llama al método attack en el personaje
		print("Attack button pressed")  # Depuración
	Input.action_press("attack")  # Simular la acción attack (opcional)

func _on_attack_button_released():
	Input.action_release("attack")  # Liberar la acción (opcional)
	print("Attack button released")  # Depuración
