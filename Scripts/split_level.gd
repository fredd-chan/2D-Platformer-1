extends Node

@export var scene_p1 : PackedScene
@export var scene_p2 : PackedScene
@export var scene_to_load : PackedScene


@onready var viewport1 : SubViewport = $HBoxContainer/SubViewportContainer/SubViewport
@onready var viewport2 : SubViewport = $HBoxContainer/SubViewportContainer2/SubViewport
@onready var pause_menu = $PauseMenu

var player1 : CharacterBody2D
var player2 : CharacterBody2D
var p1_has_key : bool = false
var p2_has_key : bool = false
var players_inside : Array = []

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
	player.double_jump = true
	player.slow_fall = true

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()


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

func load_scene_in_viewport1(new_scene: PackedScene):
	for child in viewport1.get_children():
		child.queue_free()
	# Load the new scene in its place
	await get_tree().process_frame
	var new_level = new_scene.instantiate()
	viewport1.add_child(new_level)
	_setup_camera(viewport1, new_level, "Player")
	player1 = new_level.get_node_or_null("Player")
