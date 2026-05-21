
extends Area2D

var speed: float = 300.0
var damage: float = 1.0 
@onready var target = $"../Player"

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
		
	var direction = (target.global_position - self.global_position).normalized()
	
	self.global_position += direction * speed * delta


func _on_body_entered(body: Node) -> void:
	if body == target:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			
		queue_free()
