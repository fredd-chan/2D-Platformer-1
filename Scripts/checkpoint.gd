extends Area2D

var activated : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	if not body.is_in_group("Player"):
		return
	
	activated = true
	var spawn = get_tree().get_first_node_in_group("SpawnPoint")
	if spawn:
		spawn.global_position = global_position
