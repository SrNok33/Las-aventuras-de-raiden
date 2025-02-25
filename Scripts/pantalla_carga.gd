extends Control

@onready var barra_carga = $BarraProgreso
@export var duracion_carga: float = 3.0  # ⏳ Tiempo total de carga en segundos
var tiempo_actual = 0.0

func _process(delta):
	if tiempo_actual < duracion_carga:
		tiempo_actual += delta
		barra_carga.value = (tiempo_actual / duracion_carga) * 100  # ✅ Rellenar la barra de carga

	if tiempo_actual >= duracion_carga:
		iniciar_batalla_boss()

func iniciar_batalla_boss():
	print("⚔️ Carga completa. ¡Iniciando la batalla contra el Boss!")
	get_tree().change_scene_to_file("res://Escenas/Ubicaciones/mapa.tscn")  # ✅ Cambiar a la escena del Boss
