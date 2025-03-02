extends Node2D

@onready var audio_player = $AudioStreamPlayer2D

func configurar_controles():
	# Limpiar cualquier asignación previa
	for action in ["ui_left", "ui_right", "ui_up", "attack"]:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)

	if OS.get_name().to_lower() == "windows":
		configurar_controles_pc()

func configurar_controles_pc():
	# Asignar teclas a las acciones
	InputMap.action_add_event("ui_left", crear_input_tecla(KEY_A))
	InputMap.action_add_event("ui_right", crear_input_tecla(KEY_D))
	InputMap.action_add_event("ui_up", crear_input_tecla(KEY_SPACE))  # Salto con SPACE
	InputMap.action_add_event("attack", crear_input_mouse(MOUSE_BUTTON_LEFT))

func crear_input_tecla(tecla):
	var event = InputEventKey.new()
	event.keycode = tecla
	event.pressed = true
	return event 

func crear_input_mouse(boton):
	var event = InputEventMouseButton.new()
	event.button_index = boton  
	event.pressed = true
	return event

func _ready():
	configurar_controles()
	audio_player.play()
