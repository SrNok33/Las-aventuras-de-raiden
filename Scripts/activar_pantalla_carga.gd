extends Area2D

func _on_body_entered(body):
	print("🔍 Algo tocó la zona de carga:", body.name)  # ✅ Ver si detecta algún cuerpo

	if body.is_in_group("jugador"):  # ✅ Verificar si es el jugador
		print("🚪 El jugador ha entrado en la zona de carga")
		activar_pantalla_carga()

func activar_pantalla_carga():
	print("🕐 Activando pantalla de carga...")
	get_tree().change_scene_to_file("res://Escenas/Pantallas/pantallaCarga.tscn")  # ✅ Cambiar a la pantalla de carga
