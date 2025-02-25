extends Control


func _on_bto_volver_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Ubicaciones/mapa.tscn")


func _on_bto_salir_pressed() -> void:
	get_tree().quit()
