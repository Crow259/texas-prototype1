extends Node2D
@onready var spawnpoints = [$Spawners/Marker2D, $Spawners/Marker2D2, $Spawners/Marker2D3, $Spawners/Marker2D4]
const CIRCLE = preload("uid://b662wb4m8erbd")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OnWaveStart()
	pass # Replace with function body.

func OnWaveStart():
	Global.emit_signal("WaveStart")
	var LocalDifficulty = Global.Difficulty
	for i in range(LocalDifficulty):
		var enemy = CIRCLE.instantiate()
		get_tree().current_scene.call_deferred("add_child", enemy)
		enemy.global_position = spawnpoints.pick_random().global_position
		enemy.global_position += Vector2(randf_range(-5, 5), randf_range(-5, 5))
	pass

func NextWave():
	Global.TotalEnemies = 0
	Global.TotalEnemiesKilled = 0
	Global.Difficulty += 1
	OnWaveStart()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.TotalEnemies == Global.TotalEnemiesKilled:
		NextWave()
	pass
