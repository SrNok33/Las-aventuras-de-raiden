extends CanvasLayer

@onready var contador_monedas: Label = $ContadorMonedas

func _ready() -> void:
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		game_manager.puntuacion_actualizada.connect(_on_puntuacion_actualizada)
	else:
		print("No se encontró GameManager")

func _on_puntuacion_actualizada(puntuacion_actual: int) -> void:
	contador_monedas.text = str(puntuacion_actual)
