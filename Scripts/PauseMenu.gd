extends CanvasLayer

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.call_deferred("add_child", self)

func show_menu():
	show()
	get_tree().paused = true

func hide_menu():
	hide()
	get_tree().paused = false

func _on_resume_pressed():
	hide_menu()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
