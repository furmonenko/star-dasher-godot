extends Node2D

@onready var enemy_scene = preload("res://scenes/enemy.tscn")
@onready var timer = $Timer
@onready var spawn_positions = $SpawnPositions

signal enemy_spawned(enemy_instance)

var enemy_instance = null

func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy():
	var spawns_array = spawn_positions.get_children()
	var random_spawn_point = spawns_array.pick_random()
	
	enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = random_spawn_point.global_position
	emit_signal("enemy_spawned", enemy_instance)

func stop_timer():
	timer.stop()
