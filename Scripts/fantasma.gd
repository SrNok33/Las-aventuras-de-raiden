extends Node2D

@export var velocidad: float = 50 
var vida = 30
var direccion = 1
var jugador = null  

@onready var ray_cast_derecha: RayCast2D = $RayCastDerecha
@onready var ray_cast_izquierda: RayCast2D = $RayCastIzquierda
@onready var numero_dano: Label = $Control/NumeroDano 
@onready var barra_vida: ProgressBar = $Control/BarraVida
 
func _ready():
	add_to_group("enemigos")
 

func _physics_process(delta: float) -> void:
	if ray_cast_derecha.is_colliding():
		direccion = -1
	if ray_cast_izquierda.is_colliding():
		direccion = 1
	position.x += direccion * velocidad * delta

func recibir_dano(cantidad: int):
	vida -= cantidad
	print("¡Enemigo recibió daño!", cantidad, " Vida restante:", vida)


	mostrar_numero_dano(cantidad)  

	if vida <= 0:
		morir()

func mostrar_numero_dano(cantidad: int):
	numero_dano.text = "-" + str(cantidad)  
	numero_dano.visible = true  

	var tween = get_tree().create_tween()
	tween.tween_property(numero_dano, "position:y", numero_dano.position.y - 20, 0.5)
	tween.tween_property(numero_dano, "modulate:a", 0, 0.5)
	await tween.finished

	numero_dano.visible = false  
	numero_dano.modulate.a = 1  

func morir():
	print("¡Enemigo eliminado!")
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("hit"):
		recibir_dano(10)

func _on_AreaDeteccion_body_entered(body):
	if body.is_in_group("jugador"):
		jugador = body

func _on_AreaDeteccion_body_exited(body):
	if body == jugador:
		jugador = null
		
