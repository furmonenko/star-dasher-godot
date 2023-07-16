extends Node2D

@onready var player = $Player
@onready var HUD = $UI/HUD
@onready var UI = $UI
@onready var hit_enemy_sound = $Sounds/HitEnemy
@onready var player_died_sound = $Sounds/PlayerDied
@onready var meteors = $Meteors
@onready var game_over_sound = $Sounds/GameOver
@onready var level_passed_sound = $Sounds/LevelPassed
@onready var spawn_area = $SpawnArea

@onready var level_passed_scene = preload("res://scenes/level_passed.tscn")
@onready var meteor_scene = preload("res://scenes/meteor.tscn")
@onready var game_over_scene = preload("res://scenes/game_over.tscn")

var can_respawn = true
var player_hidden = false
var if_level_passed = false

var score = 0

func _ready() -> void:
	for meteor in meteors.get_children():
		meteor.connect("exploded", _on_meteor_exploded)

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
		
	if meteors.get_child_count() == 0 && !if_level_passed:
		level_passed()
		print("level passed")
		
	if player_hidden:
		player.paused($SpawnArea.position)
		
		await get_tree().create_timer(1).timeout
		if !spawn_area.has_overlapping_areas():
			player.respawn() 
			player_hidden = false

func _on_player_took_damage() -> void:
	player_died_sound.play()
	player.lives -= 1
	HUD.lost_life(player.lives)
	
	if player.lives <= 0:
		game_over()
	else:
		player_hidden = true

func level_passed():
	if_level_passed = true
	
	if player != null:
		player.queue_free()
	
	level_passed_sound.play()
	var level_passed_instance = level_passed_scene.instantiate()
	level_passed_instance.set_score(score)
	UI.add_child(level_passed_instance)
	# enemy_spawner.stop_timer()
	HUD.visible = false

func game_over():
	game_over_sound.play()
	player.die()
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.set_score(score)
	UI.add_child(game_over_instance)
	# enemy_spawner.stop_timer()
	HUD.visible = false

func _on_enemy_spawned(enemy_instance) -> void:
	enemy_instance.connect("killed", _on_killed_enemy)
	add_child(enemy_instance)

func _on_killed_enemy():
	score += 100
	HUD.update_score(score)
	hit_enemy_sound.play()

func _on_item_picked_up() -> void:
	HUD.gained_life(player.lives)
	player.lives += 1
	$Sounds/GainedHP.play()

func _on_item_spawner_item_spawned(item_instance) -> void:
	item_instance.connect("picked_up", _on_item_picked_up)

func _on_meteor_exploded(size, pos):
	_on_killed_enemy()
	
	match size:
		Meteor.MeteorSize.LARGE:
			for i in range(2):
				spawn_meteors(Meteor.MeteorSize.SMALL, pos)
		Meteor.MeteorSize.SMALL:
			pass

func spawn_meteors(size, pos):
	var meteor_instance = meteor_scene.instantiate()
	meteor_instance.size = size
	meteor_instance.position = pos
	meteor_instance.connect("exploded", _on_meteor_exploded)
	meteors.add_child(meteor_instance)

func _on_spawn_area_area_entered(area: Area2D) -> void:
	if area is Meteor:
		can_respawn = false

func _on_spawn_area_area_exited(area: Area2D) -> void:
	if area is Meteor:
		can_respawn = true
