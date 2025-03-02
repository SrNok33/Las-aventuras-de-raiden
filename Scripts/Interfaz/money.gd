extends Area2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var game_manager: Node = %GameManager



var autodestruir : bool = true
signal reproducir_animacion_destruccion

func _ready() -> void:
	anim_sprite.play("money")
	
func _on_body_entered(_body: Node2D) -> void:
	game_manager.incrementa_un_punto()
	collision_shape.call_deferred("set", "disabled", true)
	if autodestruir:
		anim_sprite.visible = false
	else:
		reproducir_animacion_destruccion.emit()

func _on_finished() -> void:
	queue_free()
