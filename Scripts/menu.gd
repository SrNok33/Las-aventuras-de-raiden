extends Control



func _on_bto_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Pantallas/pantallaCarga.tscn")


func _on_bto_salir_pressed() -> void:
	get_tree().quit()
