extends Area2D

@export var scene_to_load : PackedScene
var players_inside : Array = []

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if not body in players_inside:
		players_inside.append(body)
	
	if players_inside.size() >= 1:
		get_tree().change_scene_to_packed(scene_to_load)

func _on_body_exited(body: Node2D) -> void:
	if body in players_inside:
		players_inside.erase(body)
