extends Control

@onready var audio = $Audio
var click_sfx : AudioStream = preload("res://Audio/Button Sound.wav")
var hover_sfx : AudioStream = preload("res://Audio/Hover.ogg")


func _on_play_button_pressed():
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/Lv1_Camera.tscn")


func _on_quit_button_pressed():
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	get_tree().quit()


func _on_button_pressed() -> void:
	audio.stream = click_sfx
	audio.play()
	await audio.finished
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


func _on_play_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()


func _on_quit_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()


func _on_button_mouse_entered() -> void:
	audio.stream = hover_sfx
	audio.play()
