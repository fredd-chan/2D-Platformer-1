extends CharacterBody2D

signal OnUpdateHealth (health : int)

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200
@export var health : int = 1
@export var fall_gravity_multiplier : float = 2.0
@export var input_left : String = "move_left"
@export var input_right : String = "move_right"
@export var input_jump : String = "jump"
@export var slow_fall : bool = false
@export var input_respawn : String = "respawn"
@export var double_jump : bool = false
@export var input_up : String = "climb_up"
@export var input_down : String = "climb_down"
@export var climb_speed : float = 100.0
@export var lock_x_on_ladder : bool = false
@export var death_y : float = 500

var move_input : float
var can_double_jump : bool = false
var on_ladder : bool = false
var frozen : bool = false

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var jump_sfx : AudioStream = preload("res://Audio/Jump_sound.wav")
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")


func _physics_process(delta):
	if on_ladder:
		velocity.y = 0
		if not lock_x_on_ladder:
			move_input = Input.get_axis(input_left, input_right)
			if move_input != 0:
				velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
			else:
				velocity.x = lerp(velocity.x, 0.0, braking * delta)
		else:
			velocity.x = 0
		if Input.is_action_pressed(input_up):
			velocity.y = -climb_speed
		elif Input.is_action_pressed(input_down):
			velocity.y = climb_speed
		move_and_slide()
		return
	
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * fall_gravity_multiplier * delta
		elif velocity.y < 0 and slow_fall and Input.is_action_pressed(input_jump):
			velocity.y += gravity * 0.5 * delta
		else:
			velocity.y += gravity * delta
	
	move_input = Input.get_axis(input_left, input_right)
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	if is_on_floor():
		can_double_jump = true
		
	if Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = -jump_force
		play_sound(jump_sfx)
	elif Input.is_action_just_pressed(input_jump) and double_jump and can_double_jump:
		velocity.y = -jump_force
		can_double_jump = false
		play_sound(jump_sfx)
	
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed(input_respawn):
		game_over()
	if frozen:
		return
	
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	
	if global_position.y > death_y:
		game_over()
	_manage_animation()

func _manage_animation():
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
	elif move_input != 0:
		anim.play("move")
	else:
		anim.play("Idle")

func take_damage(amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	if health <= 0:
		call_deferred("game_over")

func game_over():
	health = 1
	OnUpdateHealth.emit(health)
	velocity = Vector2.ZERO
	var spawn = get_tree().get_first_node_in_group("SpawnPoint")
	if spawn:
		global_position = spawn.global_position

func _damage_flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE

func play_sound(sound : AudioStream):
	audio.stream = sound
	audio.play()

func freeze():
	frozen = true
	set_physics_process(false)
	anim.play("Idle")

func unfreeze():
	frozen = false
	set_physics_process(true)
	
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
