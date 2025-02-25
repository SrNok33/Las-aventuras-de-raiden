extends CharacterBody2D

class_name Boss

var speed = 190
var player = null

# Assuming you have an AnimationPlayer node named "AnimationPlayer"
@onready var animation_player = $AnimationPlayer

func _ready():
	# Get all nodes in the "jugador" group
	var players = get_tree().get_nodes_in_group("jugador")
	if players.size() > 0:
		player = players[0]  # Assign the first player if it exists
	else:
		print("Error: No node found in group 'jugador'. Please assign a node to this group.")
		player = null  # Set to null if no player is found

func _process(delta: float) -> void:
	follow()

func follow():
	if player != null:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
		if animation_player:
			animation_player.play("run")
	else:
		# Optional: Stop movement if no player is found
		velocity = Vector2.ZERO
		move_and_slide()
