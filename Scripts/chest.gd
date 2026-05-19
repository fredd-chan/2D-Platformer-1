extends Area2D

@onready var dialogue_box = $"../DialogueUI/DialogueBox"
@onready var dialogue_text = $"../DialogueUI/DialogueBox/DialogueText"
@onready var speaker_label = $"../DialogueUI/DialogueBox/SpeakerLabel"
@onready var continue_label = $"../DialogueUI/DialogueBox/ContinueLabel"

@onready var platforms = [
	$"../Platform1",
	$"../Platform2",
	$"../Platform3",
]

var players_inside : Array = []
var chest_opened : bool = false
var current_line : int = 0
var dialogue_lines = [
	{"speaker": "Sprig", "text": "What's this?"},
	{"speaker": "Sprig", "text": "What's this?"},
	{"speaker": "Pluh", "text": "Maybe treasure!"},
	{"speaker": "Sprig", "text": "...A seed?"},
	{"speaker": "Pluh", "text": "What does it do?"},
	{"speaker": "Sprig", "text": "Where did those platforms come from?"},
	{"speaker": "Pluh", "text": "I don't know, but let's go!"},
]

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	dialogue_box.visible = false
	# Hide all platforms at start
	for p in platforms:
		p.visible = false
		p.get_node("CollisionShape2D").disabled = true

func _on_body_entered(body):
	if body.is_in_group("Player") and not body in players_inside:
		players_inside.append(body)

func _on_body_exited(body):
	if body in players_inside:
		players_inside.erase(body)

func _process(_delta):
	if not chest_opened and players_inside.size() >= 2:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact_p2"):
			chest_opened = true
			start_dialogue()
	
	if dialogue_box.visible:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact_p2"):
			current_line += 1
			if current_line < dialogue_lines.size():
				show_line()
			else:
				finish_dialogue()

func start_dialogue():
	dialogue_box.visible = true
	show_line()
	for p in get_tree().get_nodes_in_group("Player"):
		p.freeze()

func show_line():
	speaker_label.text = dialogue_lines[current_line]["speaker"]
	dialogue_text.text = dialogue_lines[current_line]["text"]
	continue_label.visible = true

func finish_dialogue():
	dialogue_box.visible = false
	continue_label.visible = false
	for p in get_tree().get_nodes_in_group("Player"):
		p.unfreeze()
	_spawn_platforms()

func _spawn_platforms():
	for p in platforms:
		p.visible = true
		p.get_node("CollisionShape2D").disabled = false
		var tween = create_tween()
		tween.tween_property(p, "modulate:a", 1.0, 0.5)
		await get_tree().create_timer(0.8).timeout
