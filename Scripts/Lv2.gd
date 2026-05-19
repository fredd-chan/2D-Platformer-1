extends Node

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
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
		
	
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
