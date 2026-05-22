extends Area2D

# Assign this in the Inspector to your portal/door node
@export var portal : Node2D
@export var mystic_tree_scene : PackedScene

var player_inside : bool = false
var collected : bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Hide portal until seed is collected
	if portal:
		portal.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false

func _process(_delta):
	if not collected and player_inside:
		if Input.is_action_just_pressed("interact"):
			collected = true
			_reveal_portal()

func _reveal_portal():
	if not portal:
		return
	portal.visible = true
	# Fade portal in
	portal.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(portal, "modulate:a", 1.0, 1.0)
	# Hide the seed itself
	await tween.finished
	var seed_tween = create_tween()
	seed_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await seed_tween.finished
	queue_free()
