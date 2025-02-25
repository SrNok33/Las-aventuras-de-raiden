extends Node2D

func configurar_controles():
	# Limpiar cualquier asignación previa
	for action in ["ui_left", "ui_right", "ui_up", "pause", "attack"]:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)

	if OS.get_name().to_lower() == "windows":
		configurar_controles_pc()
		esperar_y_reconfigurar()

func configurar_controles_pc():
	InputMap.action_add_event("ui_left", crear_input_tecla(KEY_A))
	InputMap.action_add_event("ui_right", crear_input_tecla(KEY_D))
	InputMap.action_add_event("ui_up", crear_input_tecla(KEY_SPACE))
	InputMap.action_add_event("ui_up", crear_input_tecla(KEY_W))
	InputMap.action_add_event("pause", crear_input_tecla(KEY_ESCAPE))
	InputMap.action_add_event("attack", crear_input_mouse(MOUSE_BUTTON_LEFT))

func crear_input_tecla(tecla):
	var event = InputEventKey.new()
	event.keycode = tecla
	return event 

func crear_input_mouse(boton):
	var event = InputEventMouseButton.new()
	event.button_index = boton  
	return event

# Nueva función para manejar la espera
func esperar_y_reconfigurar():
	await get_tree().create_timer(0.5).timeout
	configurar_controles()
