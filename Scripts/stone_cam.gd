extends Camera2D

@export var zoom_entry : Vector2 = Vector2(4, 4)
@export var zoom_walk : Vector2 = Vector2(2, 2)
@export var zoom_tree : Vector2 = Vector2(1, 1)
@export var zoom_speed : float = 2.0
@export var entry_x : float = -650.0
@export var tree_x : float = 450.0
@export var cam_limit_left : int = -640
@export var cam_limit_right : int = 650
@export var cam_limit_top : int = -300
@export var cam_limit_bottom : int = 250

var player : Node2D

func _ready():
	make_current()
	zoom = zoom_entry
	limit_left = cam_limit_left
	limit_right = cam_limit_right
	limit_top = cam_limit_top
	limit_bottom = cam_limit_bottom
	await get_tree().process_frame
	player = get_node_or_null("../Player")

func _process(delta):
	if not player or not is_instance_valid(player):
		return
	global_position = lerp(global_position, player.global_position, 5.0 * delta)
	zoom = lerp(zoom, _get_target_zoom(), zoom_speed * delta)

func _get_target_zoom() -> Vector2:
	if not player:
		return zoom_entry
	var px = player.global_position.x
	if px < entry_x + 50:
		return zoom_entry
	if px > tree_x - 100:
		return zoom_tree
	var t = inverse_lerp(entry_x + 50, tree_x - 100, px)
	t = clamp(t, 0.0, 1.0)
	return lerp(zoom_entry, zoom_walk, t)
