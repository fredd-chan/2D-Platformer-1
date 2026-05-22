extends Node

# Assign these in the Inspector:
# scene_p1 = res://Scenes/waters.tscn  (or whichever scene Player 1 gets)
# scene_p2 = res://Scenes/your_other_level.tscn
@export var scene_p1 : PackedScene
@export var scene_p2 : PackedScene

@onready var viewport1 : SubViewport = $HBoxContainer/SubViewportContainer/SubViewport
@onready var viewport2 : SubViewport = $HBoxContainer/SubViewportContainer2/SubViewport
@onready var pause_menu = $PauseMenu

var player1 : CharacterBody2D
var player2 : CharacterBody2D
var p1_has_key : bool = false
var p2_has_key : bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	viewport1.world_2d = World2D.new()
	viewport2.world_2d = World2D.new()

	var level1 = scene_p1.instantiate()
	var level2 = scene_p2.instantiate()
	viewport1.add_child(level1)
	viewport2.add_child(level2)

	viewport1.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	viewport2.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

	await get_tree().process_frame
	_setup_camera(viewport1, level1, "Player")
	_setup_camera(viewport2, level2, "Player2")

	player1 = level1.get_node_or_null("Player")
	player2 = level2.get_node_or_null("Player2")

	_update_viewport_sizes()
	get_tree().root.size_changed.connect(_update_viewport_sizes)

func _setup_camera(viewport: SubViewport, level: Node, player_name: String):
	var player = level.get_node_or_null(player_name)
	if not player:
		return

	var existing_camera = _find_camera(level)
	if existing_camera:
		existing_camera.make_current()
		return
		
	var camera = Camera2D.new()
	camera.zoom = Vector2(3, 3)
	viewport.add_child(camera)
	camera.make_current()
	var remote = RemoteTransform2D.new()
	remote.remote_path = camera.get_path()
	player.add_child(remote)

func _find_camera(node: Node) -> Camera2D:
	if node is Camera2D:
		return node
	for child in node.get_children():
		var result = _find_camera(child)
		if result:
			return result
	return null

func _update_viewport_sizes():
	var screen_size = get_viewport().get_visible_rect().size
	$HBoxContainer.size = screen_size
	$HBoxContainer/SubViewportContainer.size.x = screen_size.x / 2
	$HBoxContainer/SubViewportContainer2.size.x = screen_size.x / 2
	viewport1.size = Vector2i(int(screen_size.x / 2), int(screen_size.y))
	viewport2.size = Vector2i(int(screen_size.x / 2), int(screen_size.y))

# -------------------------------------------------------
# POWER SYSTEM
# Call these from your key item scripts:
#   get_tree().get_first_node_in_group("SplitLevel").player_found_key(1)
#   get_tree().get_first_node_in_group("SplitLevel").player_found_key(2)
# -------------------------------------------------------
func player_found_key(player_num: int):
	if player_num == 1:
		p1_has_key = true
		print("Player 1 found their key!")
	elif player_num == 2:
		p2_has_key = true
		print("Player 2 found their key!")

	if p1_has_key and p2_has_key:
		_grant_powers_to_both()

func _grant_powers_to_both():
	print("Both keys found — granting powers!")
	if player1:
		_apply_power(player1)
	if player2:
		_apply_power(player2)

func _apply_power(player: CharacterBody2D):
	# Customize this however you want!
	# Examples already in your player.gd as exported vars:
	player.double_jump = true
	player.slow_fall = true
	# You could also do: player.move_speed *= 1.5
	# Or call a custom method: player.unlock_ability("dash")

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()
