extends Control

@onready var audio_player = $AudioStreamPlayer2D
func _on_bto_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Ubicaciones/Escena Mapa/MapaPrincipal.tscn")


func _on_bto_salir_pressed() -> void:
	get_tree().quit()

func _ready():
	audio_player.play()
