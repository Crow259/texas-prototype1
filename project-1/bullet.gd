extends Area2D

@export var BulletSpeed = 8000
var damage = 50
var bullethealth = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += cos(rotation) * BulletSpeed * delta
	global_position.y += sin(rotation) * BulletSpeed * delta
	pass


func _on_body_entered(body: Node2D) -> void:
	#if body is StaticBody2D:
		#queue_free()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	print("collided w/ area")
	if area.is_in_group("Enemy hurtbox"):
		area.get_parent().health -= damage
		bullethealth -= 1
	if bullethealth <= 0:
		queue_free()
	pass # Replace with function body.
