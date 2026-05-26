extends Node2D

@onready var dialogue_box = $DialogueUI/DialogueBox
@onready var dialogue_text = $DialogueUI/DialogueBox/DialogueText
@onready var speaker_label = $DialogueUI/DialogueBox/SpeakerLabel
@onready var continue_label = $DialogueUI/DialogueBox/ContinueLabel

@export var level_2_scene : PackedScene

var current_line : int = 0
var dialogue_active : bool = false
var waiting_for_sprig : bool = false
var player : Node2D
var dialogue_done : bool = false

var dialogue_lines = [
	{"speaker": "???", "text": "...You've made it.   "},
	{"speaker": "???", "text": "I have waited a very long time for someone like you...   "},
	{"speaker": "Pluh", "text": "Who are you?   "},
	{"speaker": "???", "text": "I used to be called Queen Verabee.   "},
	{"speaker": "Pluh", "text": "The Ancient Queen from over a century ago?   "},
	{"speaker": "Queen Verabee", "text": "Indeed.   "},
	{"speaker": "Pluh", "text": "Why were you waiting?   "},
	{"speaker": "Queen Verabee", "text": "I was waiting for someone capable.   "},
	{"speaker": "Queen Verabee", "text": "Our people are dying. I'm sure you know.   "},
	{"speaker": "Queen Verabee", "text": "This used to be a prosporus village...   "},
	{"speaker": "Queen Verabee", "text": "But all that is left is in ruins.   "},
	{"speaker": "Queen Verabee", "text": "I do naught seek revenge, but solace for the fallen.   "},
	{"speaker": "Queen Verabee", "text": "The Brave who fought for us, but did not make it.   "},
	{"speaker": "Queen Verabee", "text": "I shall bestow the last of my powers onto you.   "},
	{"speaker": "Queen Verabee", "text": "They shall allow you to fight for what you wish to protect.   "},
	{"speaker": "Pluh", "text": "What about you?   "},
	{"speaker": "Queen Verabee", "text": "I have long since been gone.   "},
	{"speaker": "Queen Verabee", "text": "Do not worry. This is the last thing I must do.   "},
	{"speaker": "Pluh", "text": "Thank you.   "},
	{"speaker": "Queen Verabee", "text": "Go forth. Your friend waits. Good Luck."},
]

func _ready():
	dialogue_box.visible = false
	await get_tree().process_frame
	player = get_node_or_null("Player")

func _process(_delta):
	if not dialogue_active and not waiting_for_sprig and not dialogue_done and player:
		if player.global_position.x > 325:
			_start_dialogue()

	if dialogue_active:
		if Input.is_action_just_pressed("interact_p2"):
			current_line += 1
			if current_line < dialogue_lines.size():
				_show_line()
			else:
				_finish_dialogue()

	if waiting_for_sprig and PlayerStats.has_guardian:
		waiting_for_sprig = false
		_transition_to_level_2()

func _start_dialogue():
	dialogue_active = true
	dialogue_box.visible = true
	if player:
		player.freeze()
	_show_line()

func _show_line():
	print("Showing line: ", current_line, " of ", dialogue_lines.size())
	speaker_label.text = dialogue_lines[current_line]["speaker"]
	dialogue_text.text = dialogue_lines[current_line]["text"]
	continue_label.visible = true

func _finish_dialogue():
	dialogue_active = false
	dialogue_done = true
	dialogue_box.visible = false
	if player:
		player.unfreeze()
	PlayerStats.has_to_protect = true
	dialogue_box.visible = true
	continue_label.visible = false
	speaker_label.text = ""
	dialogue_text.text = "Waiting for your companion..."
	waiting_for_sprig = true

func _transition_to_level_2():
	dialogue_box.visible = false
