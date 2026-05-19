extends Area2D

@onready var dialogue_box = $"../DialogueUI/DialogueBox"
@onready var dialogue_text = $"../DialogueUI/DialogueBox/DialogueText"
@onready var speaker_label = $"../DialogueUI/DialogueBox/SpeakerLabel"
@onready var continue_label = $"../DialogueUI/DialogueBox/ContinueLabel"
@onready var platform = $"../MovingPlatform"

var players_inside : Array = []
var dialogue_triggered : bool = false
var current_line : int = 0
var dialogue_finished : bool = false
var player_nearby : bool = false
var is_retry : bool = false
var retry_cooldown : float = 5.0
var cooldown_timer : float = 0.0
var can_retry : bool = false

var dialogue_lines = [
	{"speaker": "???", "text": "Ah, travelers..."},
	{"speaker": "???", "text": "I haven't seen any like you since..."},
	{"speaker": "???", "text": "...Nevermind."},
	{"speaker": "???", "text": "My name is Wyllis."},
	{"speaker": "Wyllis", "text": "Please save us, brave travelers."},
	{"speaker": "Wyllis", "text": "We need your help."},
	{"speaker": "Wyllis", "text": "If you don't, we will all die."},
	{"speaker": "Wyllis", "text": "Here.. I will show you the way."},
	{"speaker": "Wyllis", "text": "Go, and live on, even if you cannot save us."},
]

var retry_lines = [
	{"speaker": "NPC", "text": "Oh, did you fall?"},
	{"speaker": "NPC", "text": "That's alright. Be more careful this time."},
	{"speaker": "NPC", "text": "Safe travels, and farewell."},
]

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	dialogue_box.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player") and not body in players_inside:
		players_inside.append(body)
		player_nearby = true
		if players_inside.size() >= 2 and not dialogue_triggered:
			dialogue_triggered = true
			start_dialogue()

func _on_body_exited(body):
	if body in players_inside:
		players_inside.erase(body)
	if players_inside.is_empty():
		player_nearby = false

func start_dialogue():
	dialogue_box.visible = true
	show_line()
	for p in get_tree().get_nodes_in_group("Player"):
		p.freeze()

func show_line():
	speaker_label.text = dialogue_lines[current_line]["speaker"]
	dialogue_text.text = dialogue_lines[current_line]["text"]
	continue_label.visible = true

func _process(_delta):
	if cooldown_timer > 0:
		cooldown_timer -= _delta
		
	if dialogue_box.visible and Input.is_action_just_pressed("interact"):
		current_line += 1
		if current_line < dialogue_lines.size():
			show_line()
		else:
			if is_retry:
				finish_retry()
			else:
				finish_dialogue()
	
	if dialogue_finished and player_nearby and cooldown_timer <= 0 and can_retry:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact_p2"):
			dialogue_lines = retry_lines
			current_line = 0
			dialogue_finished = false
			dialogue_triggered = false
			is_retry = true
			start_dialogue()
			_respawn_platform(false)

func finish_dialogue():
	dialogue_box.visible = false
	continue_label.visible = false
	for p in get_tree().get_nodes_in_group("Player"):
		p.unfreeze()
	dialogue_finished = true
	_respawn_platform(true)
	cooldown_timer = retry_cooldown
	await get_tree().process_frame
	can_retry = true

func _respawn_platform(needs_both : bool):
	platform.global_position = platform.start_pos
	platform.modulate.a = 1.0
	platform.moving = false
	platform.has_reached_top = false
	platform.players_on_platform.clear()
	platform.visible = false
	platform.require_both_players = needs_both
	platform.get_node("CollisionShape").disabled = true
	await get_tree().create_timer(0.5).timeout
	platform.visible = true
	platform.get_node("CollisionShape").disabled = false
	
func finish_retry():
	dialogue_box.visible = false
	continue_label.visible = false
	for p in get_tree().get_nodes_in_group("Player"):
		p.unfreeze()
	dialogue_finished = true
	is_retry = false
	can_retry = false
	cooldown_timer = retry_cooldown
	await get_tree().process_frame
	can_retry = true
