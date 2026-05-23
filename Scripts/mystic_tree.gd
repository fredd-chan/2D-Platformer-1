extends Node2D

@onready var dialogue_box = $DialogueUI/DialogueBox
@onready var dialogue_text = $DialogueUI/DialogueBox/DialogueText
@onready var speaker_label = $DialogueUI/DialogueBox/SpeakerLabel
@onready var continue_label = $DialogueUI/DialogueBox/ContinueLabel

@export var level_2_scene : PackedScene

var current_line : int = 0
var dialogue_active : bool = false
var waiting_for_pluh : bool = false
var player : Node2D

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
	await get_tree().process_frame
	player = get_node_or_null("Player")

func _process(_delta):
	if not dialogue_active and not waiting_for_pluh and player:
		if player.global_position.x < -325: 
			_start_dialogue()

	if dialogue_active:
		if Input.is_action_just_pressed("interact"):
			current_line += 1
			if current_line < dialogue_lines.size():
				_show_line()
			else:
				_finish_dialogue()

	if waiting_for_pluh and PlayerStats.has_to_protect:
		waiting_for_pluh = false
		_transition_to_level_2()

func _start_dialogue():
	dialogue_active = true
	dialogue_box.visible = true
	if player:
		player.freeze()
	_show_line()

func _show_line():
	speaker_label.text = dialogue_lines[current_line]["speaker"]
	dialogue_text.text = dialogue_lines[current_line]["text"]
	continue_label.visible = true

func _finish_dialogue():
	dialogue_active = false
	dialogue_box.visible = false
	if player:
		player.unfreeze()
	PlayerStats.has_guardian = true
	dialogue_box.visible = true
	continue_label.visible = false
	speaker_label.text = ""
	dialogue_text.text = "Waiting for your companion..."
	waiting_for_pluh = true

func _transition_to_level_2():
	dialogue_box.visible = false
	var split_level = get_tree().root.get_node_or_null("SplitLevel")
	if split_level:
		split_level.load_scene_in_viewport1(level_2_scene)
