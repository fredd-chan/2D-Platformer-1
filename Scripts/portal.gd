extends Area2D

@export var mystic_tree_scene : PackedScene

var player_inside : bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_inside = true
		_enter_portal()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false

func _enter_portal():
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.modulate.a = 0.0
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	get_tree().root.add_child(overlay)
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_packed(mystic_tree_scene)
