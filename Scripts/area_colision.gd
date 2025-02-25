extends Area2D

var loading_scene = preload("res://Escenas/Pantallas/pantalla_win.tscn")

func _ready():
	print("Area2D cargado")
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Cuerpo detectado: ", body.name)
	if body.is_in_group("jugador"):
		print("¡Colisión con el jugador!")
		get_tree().change_scene_to_packed(loading_scene)
