extends Control

@onready var audio = $Audio
var click_sfx : AudioStream = preload("res://Audio/Button Sound.wav")
var hover_sfx : AudioStream = preload("res://Audio/Hover.ogg")

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	

func _on_back_button_pressed():
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_level_1_button_pressed() -> void:
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/Lv1_Camera.tscn")
	

func _on_level_2_button_pressed() -> void:
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/transition.tscn")
	

func _on_level_3_button_pressed() -> void:
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_level_1_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()
	
func _on_level_2_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()

func _on_level_3_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()

func _on_back_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()
