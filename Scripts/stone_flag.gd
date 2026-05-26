extends Area2D

@export var scene_to_load : PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	var split_level = get_tree().root.get_node_or_null("SplitLevel")
	if split_level and split_level.has_method("load_scene_in_viewport2"):
		split_level.load_scene_in_viewport2(scene_to_load)
