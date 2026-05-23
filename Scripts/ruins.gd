extends Area2D

@export var scene_to_load : PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player2":
		return
	PlayerStats.pluh_ready = true
	if PlayerStats.sprig_ready and PlayerStats.pluh_ready:
		PlayerStats.sprig_ready = false
		PlayerStats.pluh_ready = false
		get_tree().change_scene_to_packed(scene_to_load)
