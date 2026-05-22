extends Node

@onready var pause_menu = $PauseMenu
@onready var players := {
	"1": {
		viewport = $"HBoxContainer/SubViewportContainer/SubViewport",
		camera = $"HBoxContainer/SubViewportContainer/SubViewport/Camera2D",
		player = $HBoxContainer/SubViewportContainer/SubViewport/Node2D/Player
	},
	"2": {
		viewport = $"HBoxContainer/SubViewportContainer2/SubViewport",
		camera = $"HBoxContainer/SubViewportContainer2/SubViewport/Camera2D",
		player = $HBoxContainer/SubViewportContainer/SubViewport/Node2D/Player2
	}
}
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for key in players:
		var node = players[key]
		var camera = Camera2D.new()
		camera.zoom = Vector2(3, 3)  
		node.viewport.add_child(camera)
		camera.make_current()
		var remote = RemoteTransform2D.new()
		remote.remote_path = camera.get_path()
		node.player.add_child(remote)
	
	players["1"].viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	players["2"].viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	
	await get_tree().process_frame
	_update_viewport_sizes()
	get_tree().root.size_changed.connect(_update_viewport_sizes)
	
	
func _update_viewport_sizes():
	var screen_size = get_viewport().get_visible_rect().size
	$HBoxContainer.size = screen_size
	$HBoxContainer/SubViewportContainer.size.x = screen_size.x / 2
	$HBoxContainer/SubViewportContainer2.size.x = screen_size.x / 2
	players["1"].viewport.size = Vector2(screen_size.x / 2, screen_size.y)
	players["2"].viewport.size = Vector2(screen_size.x / 2, screen_size.y)
	
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()
