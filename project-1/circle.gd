extends CharacterBody2D

var vel = Vector2.ZERO
var health = 50.0
var damage := 15.0
var isinsideplayer = false
var candamage = false
@onready var maxhealth = health
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	Global.TotalEnemies += 1
	await get_tree().create_timer(1).timeout
	candamage = true
	pass

func _physics_process(delta: float) -> void:
	if not Global.Player:
		return
	if health <= 0:
		Global.TotalEnemiesKilled += 1
		queue_free()
	look_at(Global.Player.global_position)
	vel.x += cos(rotation) * 1400 * delta
	vel.y += sin(rotation) * 1400 * delta
	rotation = 0 
	progress_bar.value = health / maxhealth
	
	if isinsideplayer and candamage:
		Global.Player.damage(damage)
	
	velocity = vel
	move_and_slide()
	
	if is_on_ceiling() or is_on_floor():
		vel.y *= -1
	if is_on_wall():
		vel.x *= -1
	
	vel = lerp(vel, Vector2(0, 0), 0.7 * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player and Global.Dashing == false:
		isinsideplayer = true
	pass # Replace with function body.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is player and Global.Dashing == false:
		isinsideplayer = false
	pass # Replace with function body.

# wave 1 1
# wave 2 1.5
# wave 3 2
# modifier 
