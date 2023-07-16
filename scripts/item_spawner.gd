extends Node2D

@onready var paths = $Paths
@onready var item_scene = preload("res://scenes/item.tscn")
@onready var timer = $Timer

signal item_spawned(item_instance)

var paths_amount = 0

var path_to_spawn :Path2D
var path_follow :PathFollow2D
var item_instance = null

var item_moving = false

func _ready() -> void:
	paths_amount = paths.get_child_count() - 1
	#timer.wait_time = randi_range(14, 30)
	
func _physics_process(delta: float) -> void:
	if item_moving:
		move_item(delta)
	print(timer.time_left)

func _on_timer_timeout() -> void:
	path_to_spawn = paths.get_children()[randi_range(0, paths_amount)]
		
	path_follow = path_to_spawn.get_child(0)
	item_instance = item_scene.instantiate()
		
	emit_signal("item_spawned", item_instance)
	path_follow.add_child(item_instance)
	timer.stop()
	item_moving = true
	
func move_item(delta):
	path_follow.progress_ratio += 0.05 * delta
	
	if path_follow.get_child_count() == 0:
		timer.start(randf_range(14.0, 30.0))
		item_moving = false
		return
	elif path_follow.progress_ratio >= 0.95 && path_follow.get_child(0):
		path_follow.get_child(0).queue_free()
		timer.start(randf_range(14.0, 30.0))
		item_moving = false
