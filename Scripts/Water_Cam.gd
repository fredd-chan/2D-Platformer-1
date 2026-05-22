extends Camera2D

var players : Array = []

func _ready():
	make_current()
	zoom = Vector2(2,2)
	await get_tree().process_frame
	var player = get_node_or_null("../Player")
	if player:
		players.append(player)
	make_current()
	limit_top = -250
	limit_bottom = 250
	limit_left = -670
	limit_right = 600
	

func _process(delta):
	if players.is_empty():
		return
	
	var mid = Vector2.ZERO
	for p in players:
		if p and is_instance_valid(p):
			mid += p.global_position
	mid /= players.size()
	
	global_position = lerp(global_position, mid, 5.0 * delta)
