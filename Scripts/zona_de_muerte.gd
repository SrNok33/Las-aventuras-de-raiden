extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("Has perdido...")
	timer.start()
	

func _on_timer_timeout() -> void:
	cambiar_a_pantalla_de_muerte()

func cambiar_a_pantalla_de_muerte():
	get_tree().change_scene_to_file("res://Escenas/Pantallas/Muerte.tscn")
