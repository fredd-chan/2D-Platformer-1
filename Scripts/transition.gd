extends Node2D

var player1
var player2

func _ready() -> void:
	# Removed content_scale_mode lines — they caused progressive zoom on repeated visits
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	await get_tree().process_frame
	player1 = $Player
	player2 = $Player2
	player1.global_position = $SpawnPoint.global_position
	player2.global_position = $SpawnPoint.global_position + Vector2(30, 0)
	player1.on_ladder = true
	player2.on_ladder = true
	await get_tree().process_frame
	player1.velocity.y = player1.climb_speed
	player2.velocity.y = player2.climb_speed
