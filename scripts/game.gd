extends Node2D

@onready var player = $Player
@onready var HUD = $UI/HUD
@onready var UI = $UI
@onready var meteor_spawner = $MeteorSpawner
@onready var game_over_sound = $Sounds/GameOver
@onready var spawn_area = $SpawnArea

# @onready var hit_enemy_sfx :AudioStream = preload("res://sounds/enemy_hit.wav")
@onready var player_died_sfx :AudioStream = preload("res://sounds/player_died.wav")

@onready var meteor_scene = preload("res://scenes/meteor.tscn")
@onready var game_over_scene = preload("res://scenes/game_over.tscn")

var player_hidden = false

var score = 0

func _ready() -> void:
	meteor_spawner.connect("meteor_spawned", spawn_meteors)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_game"):
		get_tree().reload_current_scene()
		
	if player_hidden:
		player.paused($SpawnArea.position)
		
		await get_tree().create_timer(1).timeout
		if !spawn_area.has_overlapping_areas():
			player.respawn() 
			player_hidden = false

func _on_player_took_damage() -> void:
	# player_died_sound.play()
	AudioPlayer.play_sfx(player_died_sfx)
	player.lives -= 1
	# HUD.lost_life(player.lives)
	
	if player.lives <= 0:
		game_over()
	else:
		player_hidden = true

func game_over():
	player.die()
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.set_score(score)
	UI.add_child(game_over_instance)
	# enemy_spawner.stop_timer()
	HUD.visible = false

# adding score, updating hud and playing sound when enemy is dead
func _on_killed_enemy():
	score += 100
	HUD.update_score(score)
	# AudioPlayer.play_sfx(hit_enemy_sfx)

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
	meteor_spawner.add_child(meteor_instance)
