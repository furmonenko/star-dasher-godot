extends Node2D

@onready var meteor_scene = preload("res://scenes/meteor.tscn")

@onready var spawn_points = $SpawnPoints
@onready var meteors = $Meteors
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer

signal meteor_spawned(size, pos)

func _on_timer_timeout() -> void:
	var meteor_spawn_pos = spawn_points.get_children().pick_random().position
	emit_signal("meteor_spawned", Meteor.MeteorSize.LARGE, meteor_spawn_pos)

func _on_difficulty_timer_timeout() -> void:
	# increase difficulty by spawning meteors more often
	if spawn_timer.wait_time >= 0.6:
		spawn_timer.wait_time -= 0.2
