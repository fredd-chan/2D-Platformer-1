extends Node2D

@onready var dialogue_box = $DialogueUI/DialogueBox
@onready var dialogue_text = $DialogueUI/DialogueBox/DialogueText
@onready var speaker_label = $DialogueUI/DialogueBox/SpeakerLabel
@onready var continue_label = $DialogueUI/DialogueBox/ContinueLabel
@onready var fade_overlay = $FadeOverlay

@export var level_2_scene : PackedScene

var current_line : int = 0
var dialogue_done : bool = false
var waiting_for_pluh : bool = false

var dialogue_lines = [
	{"speaker": "???", "text": "...You made it."},
	{"speaker": "???", "text": "I have waited a long time for someone like you."},
	{"speaker": "Sprig", "text": "Who are you?"},
	{"speaker": "???", "text": "I am what remains of this world's heart."},
	{"speaker": "???", "text": "You may call me the Guardian."},
	{"speaker": "Sprig", "text": "The world... it's dying, isn't it?"},
	{"speaker": "Guardian", "text": "It is. But it is not too late."},
	{"speaker": "Guardian", "text": "You and your companion carry something rare."},
	{"speaker": "Guardian", "text": "The will to protect."},
	{"speaker": "Guardian", "text": "Take this with you."},
	{"speaker": "Guardian", "text": "It will shield you when the darkness closes in."},
	{"speaker": "Sprig", "text": "We won't let you down."},
	{"speaker": "Guardian", "text": "I know you won't."},
	{"speaker": "Guardian", "text": "But Sprig... the road ahead is not kind."},
	{"speaker": "Guardian", "text": "There will be moments you want to give up."},
	{"speaker": "Guardian", "text": "Do not."},
	{"speaker": "Guardian", "text": "The ones you fight for are counting on you."},
	{"speaker": "Guardian", "text": "Now go. Your friend needs you."},
]

func _ready():
	dialogue_box.visible = false
DADA	fade_overlay.modulate.a = 1.0
	# Fade in from black
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 1.5)
	await tween.finished
	# Start dialogue
	dialogue_box.visible = true
	show_line()

func _process(_delta):
	if dialogue_box.visible and not waiting_for_pluh:
		if Input.is_action_just_pressed("interact"):
			current_line += 1
			if current_line < dialogue_lines.size():
				show_line()
			else:
				finish_dialogue()

	# Once dialogue is done, wait for Pluh to find his seed
	if waiting_for_pluh and PlayerStats.has_to_protect:
		waiting_for_pluh = false
		_transition_to_level_2()

func show_line():
	speaker_label.text = dialogue_lines[current_line]["speaker"]
	dialogue_text.text = dialogue_lines[current_line]["text"]
	continue_label.visible = true

func finish_dialogue():
	dialogue_box.visible = false
	# Grant the guardian power to both players
	PlayerStats.has_guardian = true
	# Show waiting message
	speaker_label.text = ""
	dialogue_text.text = "Waiting for your companion..."
	dialogue_box.visible = true
	continue_label.visible = false
	waiting_for_pluh = true

func _transition_to_level_2():
	dialogue_box.visible = false
	# Fade to black then load level 2
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.5)
	await tween.finished
	get_tree().change_scene_to_packed(level_2_scene)
